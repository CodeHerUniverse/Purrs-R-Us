import requests
import pandas as pd
from datetime import timedelta, datetime
import sys
from dotenv import load_dotenv
import os
from pathlib import Path
from pprint import pprint as pp
import math

#Identifying the directory where this .py file is located
current_filepath = str(Path.cwd())
print(current_filepath)


#load API keys
load_dotenv()
OS_NAMES_API_KEY=os.getenv("OS_NAMES_API_KEY")
OPENAQ_API_KEY=os.getenv("OPENAQ_API_KEY")


##### Function for logging issues and messages #####
def log(instance_msg):
    with open(current_filepath+"/Log.txt", 'a') as text_file:
        finish_time = str(datetime.now())
        end_message = finish_time + instance_msg
        text_file.write(end_message + "\n")
    text_file.close()

#User Input 
input_postcode = input('Please input the desired postcode: ').lower()
#Remove any spaces
input_postcode = input_postcode.replace(" ", "")


#OS Names API Request - To obtain the name of the Postcode area (Postcodes.io is not consitent in the city/town fields)
res_os_names_api = requests.get("https://api.os.uk/search/names/v1/find?query="+input_postcode+"&maxresults=1&key="+OS_NAMES_API_KEY)
data_os_names_api = res_os_names_api.json() 
data_os_names_api = data_os_names_api['results']
osname_city = data_os_names_api[0]['GAZETTEER_ENTRY']['POPULATED_PLACE']
osname_postcode = data_os_names_api[0]['GAZETTEER_ENTRY']['ID']


#Log OS Names API response status
instance_msg = (f" - OS Names API request status: "+str(res_os_names_api.status_code))
log(instance_msg)


#Control to stop the program if OS Name Postcode doesn't match input
if osname_postcode != input_postcode.upper():
    #Log issue, inform user & close program.
    instance_msg = " - Unsuccessful run - Chosen postcode ("+input_postcode.upper()+") could not be located in the Ordnance Survey records. Contact Ordnance Survey team."
    log(instance_msg)
    sys.exit("Apologies but your postcode could not be located in the Ordnance Survey records. Please try again")


#Define County by COUNTY_UNITARY first and if field not present, define by DISTRICT_BOROUGH
try:
    county = data_os_names_api[0]['GAZETTEER_ENTRY']['COUNTY_UNITARY']
except:
    county = data_os_names_api[0]['GAZETTEER_ENTRY']['DISTRICT_BOROUGH']+" Borough"


try:
    #Poscodes.io API Request - to obtain the latitude and longitude of the Postcode 
    res_postcode = requests.get("https://api.postcodes.io/postcodes/"+input_postcode)
    data_postcode_api = res_postcode.json() 
    data_postcode_api = data_postcode_api['result']
    #Defining Latitude & Longitude variables
    lat = str(data_postcode_api['latitude'])
    lon = str(data_postcode_api['longitude'])

    #Log OS Names API response status
    instance_msg = (f" - Postcodes.io API request status: "+str(res_postcode.status_code))
    log(instance_msg)
except:
    #Log issue, inform user & close program.
    instance_msg = " - Unsuccessful run - Chosen postcode ("+input_postcode.upper()+") could not be located in Postcodes.io. Contact Postcodes.io team."
    log(instance_msg)
    sys.exit("Apologies but your postcode could not be located in the Postcodes.io records. Please try again")


#Defining Town/City name
town = osname_city


try:
    #OpenAq API Request - requesting information via lat & long coordinates and listing the data from closet to furthest.
    res_open_aq_locations = requests.get("https://api.openaq.org/v2/locations?coordinates="+lat+","+lon+"&radius=25000&nearest=1&limit=10&order_by=distance&sort=asc", headers={"X-API-Key": OPENAQ_API_KEY})
    data_open_aq_locations = res_open_aq_locations.json()
    locations_results = data_open_aq_locations['results']
    #pp(data_open_aq_locations)
    #Log OpenAq API Locations endpoint response status
    instance_msg = (f" - OpenAq API Locations endpoint request status: "+str(res_open_aq_locations.status_code))
    log(instance_msg)

    #create dataframe from the API results for easy manipulation
    dflocation = pd.DataFrame(locations_results)
    #Backfill any Nan Values under "City" with data from the "Name"
    dflocation['city'].replace("None", None)
    dflocation = dflocation.bfill(axis = 'columns')
    #isolate 'city' column
    town_openaq = dflocation['city']
    #isolate the first result as a variable - closest location at the top.
    town_openaq = town_openaq.iloc[0]
    coordinates = dflocation['coordinates'][0]
    lat = str(round(coordinates['latitude'],8))
    lon = str(round(coordinates['longitude'],8))
    #define location name as "City - County/Borough"
    final_town_name = town +" - "+county


    #if statment to test if the OS Name city is included in the OpenAQ city closest to the coordinates (sometimes OpenAQ naming conventions have further detail - for example Birmingham - Ladywood)
    if town in town_openaq:
        message1 = f"\nAQ Data requested for: {final_town_name}"
        print(message1)
    else:
        #if OS Name city doesn't match the OpenAQ city closest to the coordinates, then print message to user
        final_town_name = town_openaq + " - " + county
        message1 = f"Your exact location is not available in OpenAq, so we have provided results to the nearest location: {final_town_name}"
        print(message1)
except:
    #Log issue, inform user & close program.
    instance_msg = " - Unsuccessful run - Chosen location ("+town+") could not be located via latitude and longitude within OpenAQ (nearest results not available either). Contact OpenAQ team."
    log(instance_msg)
    sys.exit("Apologies but your location is not available in OpenAq, and there aren't any nearby locations with relevant results.")
    

#defining today variable as today
today = datetime.today().date()
#defining the start date of our date range - today minus 30 days as standard
start_date = today - timedelta(days = 30)
#convert the start and and end dates of the range (end date is today)
today_string = str(datetime.strftime(today, '%Y-%m-%d'))
start_string = str(datetime.strftime(start_date, '%Y-%m-%d'))


#res_open_aq_measurements = requests.get("https://api.openaq.org/v2/measurements?date_from="+start_string+"&date_to="+today_string+"&"+search+"="+town_openaq+"&limit=50000", headers={"X-API-Key": OPENAQ_API_KEY})
res_open_aq_measurements = requests.get("https://api.openaq.org/v2/measurements?date_from="+start_string+"&date_to="+today_string+"&limit=50000&coordinates="+lat+","+lon+"&radius=25000", headers={"X-API-Key": OPENAQ_API_KEY})    
data_open_aq_measurements = res_open_aq_measurements.json()
data_open_aq_measurements = data_open_aq_measurements['results']

df_measurements = pd.DataFrame(data_open_aq_measurements)
pollutant_summary = df_measurements[['parameter', 'value']]

#Log OpenAq API Locations endpoint response status
instance_msg = (f" - OpenAq API Measurements endpoint request status: "+str(res_open_aq_measurements.status_code))
log(instance_msg)


#Summarize the data - grouping by parameter and displaying the mean of each pollutant
pollutant_summary = pollutant_summary.groupby(['parameter']).mean()
pollutant_summary_grouped = pollutant_summary.reset_index(drop=False)
pollutant_summary_grouped = pollutant_summary_grouped[pollutant_summary_grouped["parameter"].str.contains("no2|o3|pm10|pm25|co|so2")] #European AQI only measures these values

#blank list for scores to be stored
numeric_score_list =[]


#####  Function to run each summarized pollutant through the scoring tables defined earlier and identify the correct table, row and 
#####  numeric scoring. ###########################################################################################################
def get_numeric_score_from_ranges(pollutant_summary_grouped):

    for pollutant in pollutant_summary_grouped['parameter']:
            
        aqi_joint_data = pd.read_excel(current_filepath+"/Europe AQI values.xlsx", sheet_name=pollutant)
        
        isolated_pollutant = pollutant_summary_grouped[pollutant_summary_grouped['parameter'] == pollutant]
        isolated_pollutant_measure = isolated_pollutant['value']
        merged_data = aqi_joint_data.merge(isolated_pollutant_measure, how='cross')

        correct_range_row = merged_data[(merged_data['value'] > merged_data['Range Start']) & (merged_data['value'] < merged_data['Range Finish'])]
        correct_range_row.reset_index()
        #Isolate result
        aqi_score = correct_range_row.iloc[0,0]
        #Append to list
        numeric_score_list.append(aqi_score)

    return aqi_score


#run Summarized table of averages through get_numeric_score_from_ranges Function
get_numeric_score_from_ranges(pollutant_summary_grouped)

#Determine the overall score for the area
overall_score = sum(numeric_score_list)/len(numeric_score_list)
#create reusable variable name of "score" for the overall score, as the scoring_description is going to be used twice for different scores (overall & max)
score = overall_score


def scoring_description(score):

    global score_message

    for i in range(6): #provides a range from 0 to 5
        score_list_definitions = ["Very Low Air Pollution", "Low Air Pollution", "Medium Air Pollution","High Air Pollution", "Very High Air Pollution"]
        if score == i:
            score_message = score_list_definitions[i-1] #-1 because the score is 1-5, but the list index is 0-4

        #accounts for overall scores with decimal places. If the score is smaller than a number but bigger than the prior number 
        #then take the highest number as it's a linear range of scoring.
        if score < i and score > i-1: 
            score_message = score_list_definitions[i-1] #-1 because the score is 1-5, but the list index is 0-4


#Run overall score (renamed to score) through the scoring description Function
scoring_description(score)


#User message to inform of overall score results
message2 = f"\nThe overall AQI Score for this location is {score_message}."
print(message2)


#If negative values are present, log message for the imaginary tech team to investigate the measuring devices used - User doesn't need to be informed
if (pollutant_summary_grouped['value'] < 0).values.any():
    instance_msg = ' - Message for Tech: Negative values present - measuring equipment to be checked. OpenAQ Location: '+town_openaq+' - '+county
    log(instance_msg)


#Reset numeric score list to house the score of the highest pollutant
numeric_score_list =[]


#Create Dataframe for easy data manipulation
pollutant_summary_grouped = pd.DataFrame(pollutant_summary_grouped)
#Find the pollutant with the highest value
pollutant_summary_grouped = pollutant_summary_grouped.iloc[pollutant_summary_grouped['value'].idxmax()]
#Create dataframe from results so we can transpose into a layout that can be used by the function
pollutant_summary_grouped = pd.DataFrame(pollutant_summary_grouped).transpose()
#isolate the 
max_pollutant = pollutant_summary_grouped.iloc[0,0]


#Run highest pollutant through the numeric score retrieval function
get_numeric_score_from_ranges(pollutant_summary_grouped)
#isolate the only value in the list as a variable.
score = numeric_score_list[0]
#Run highest pollutant through the numeric score retrieval function
scoring_description(score)
#Final User Message
#print(f"The highest pollutant found in the area is {max_pollutant.upper()}. The presence level of this pollutant is deemed as {str(score_message.split(" Air")[0])}.")
message3 = f"\nThe highest pollutant found in the area is {max_pollutant.upper()}. The presence level of this pollutant is deemed as {score_message[0:len(score_message)-13]}."
print(message3)


#Additional Information on the maximum pollutant - with further enhancement I would scrape this info from the web.

pollutant_dictionary = {0 : "no2", 1 : "o3", 2 : "so2", 3 : "co", 4 : "pm25", 5 : "pm10"}

info = ['''\nNO2 stands for  Nitrogen Dioxide. The main source of nitrogen dioxide resulting from human activities is the combustion of fossil fuels (coal, gas and oil) especially fuel used in cars. Longer exposures to elevated concentrations of NO2 may contribute to the development of asthma and potentially increase susceptibility to respiratory infections.''', 
        '''\nO3 stands for Ozone. Ground-level ozone comes from pollution emitted from cars, power plants, industrial boilers, refineries, and chemical plants. Long-term ozone exposure is associated with increased respiratory illnesses, metabolic disorders, nervous system issues, reproductive issues (including reduced male and female fertility and poor birth outcomes), cancer and also increased cardiovascular mortality, which is the main driver of total mortality.''',
        '''\nSO2 stands for Sulfur Dioxide. SO2 forms when sulfur-containing fuel such as coal, petroleum oil, or diesel is burned.Sulfur dioxide is severely irritating to the eyes, mucous membranes, skin, and respiratory tract. Inhalation exposure to very low concentrations of sulfur dioxide can aggravate chronic pulmonary diseases, such as asthma and emphysema.''',
        '''\nCO stands for Carbon Monoxide. CO pollution occurs primarily from emissions produced by fossil fuel–powered engines, including motor vehicles and non-road engines and vehicles (such as construction equipment and boats). The most common symptoms of chronic CO poisoning include persistent headaches, lightheadedness, fatigue, memory problems, nausea, hearing disorders, sleep disorders, abdominal pain, diarrhea, and vomiting. Each time a patient is exposed to CO, they will develop one or more of these symptoms.''',
        '''\nPM25 stands for fine particulate matter and is a type of air pollution that consists of particles that are 2.5 microns or less in diameter.PM2.5 can be caused by both natural and human-made sources, such as dust, ash, sea spray, and the combustion of solid and liquid fuels. Long-term (months to years) exposure has been linked to premature death, particularly in people who have chronic heart or lung diseases, and reduced lung function growth in children.''',
        '''\nPM10 stands for particulate matter with a diameter of 10 microns or less. Mainly caused by road transport sources, predominantly from non-exhaust sources (brakes, tyres), PM10 also includes dust from construction sites, landfills and agriculture, wildfires and brush/waste burning, industrial sources, wind-blown dust from open lands, pollen and fragments of bacteria. Long term exposure can cause a variety of issues such as respiratory issues, increased risk of stroke and coronary heart disease, reduced lung function, worsen asthma and COPD.''']


        
# Here I am choosing the additional information message that I want and am also splitting it into regular intervals, to them be re-joined with "\n" delimiters.
# This is so I can take a very long string, and output it in nicely formatted lines without going on forever. 
for i in range(6): #provides a range from 0 to 5
        if pollutant_dictionary[i] == max_pollutant:
            #choose the correct information message
            message4 = info[i]
            #split the message by " " characters
            split_message = message4.split(' ')
            #set the initial start, finish and interval
            interval = 13
            start = 0
            end = 13
            #empty list to store the broken down sentences
            sentence_list =[]
            #in this for loop I am creating a list of words that exist in regular intervals, effectively creating a list of sentences that have similar lengths.
            for x in range(0,math.floor(len(split_message)/interval)+1):
                line = split_message[start:end]
                if end < len(split_message)+1:
                    start = end
                    end = start + interval
                    if end > len(split_message):
                        end = len(split_message)+1
                separator = " "
                line = separator.join(line)
                sentence_list.append(line)
#re-join my sentences to make a whole text, separated by "\n" to ensure they print in new lines. 
paragraph = "\n"
final_info_text = paragraph.join(sentence_list)
print(final_info_text)

#Write Output to a file:
with open(current_filepath+"/AirQuality Results for "+town+"-"+county+".txt", 'w') as text_file:
    finish_time = str(datetime.now())
    end_message = finish_time + "\n" + message1 + message2 + message3 + "\n" + final_info_text
    text_file.write(end_message)
text_file.close()


#Log message to confirm successful running of the program
instance_msg = " - Program successfully run."
log(instance_msg)