# Catarina Mesquita - Assignment 2 #

For this Assignment, we are to create a console app that interacts with an API of our choice, gets some data out of it and does a meaningful transformation.

## My Project - Postcode Air Quality Checker ##

The purpose of the Console app I have designed is for a user to input a Postcode (the covered area doesn't include Scotland) and receive an overall score of the Air Quality in the chosen location. The user will also be informed of which pollutant has the highest concentration and their individual score.

A log will also be produced, which will log the API request statuses at the time they were run. It will also log a message for any pollutant readings that have negative values as this could indicate faulty reading equipment.

This project uses the following APIs:
+ OpenAq
+ Postcodes.io
+ OS Names

**OpenAQ** is a Database that gathers information on the presence and concentration of certain pollutants in the air of a given area.

**Postcodes.io** is a public Postcode Database that provides a range of information on certain locations.

**OS Names** is a Database that also gathers and stores location data, such as postcodes, boroughs, etc, but focuses more on the Names of the locations rather that the geographical position.

## API Keys - How to obtain them ##

API Keys for OpenAQ and OS Names can be obtained for free via their websites after creating an account:

+ **OpenAQ**:
  + Register for an API Key at [https://explore.openaq.org/register](https://explore.openaq.org/register).
  + Once registered with a valid email, you can access your API by signing in and visiting your OpenAQ Explorer account settings at [https://explore.openaq.org/account](https://explore.openaq.org/account).
  + To use the API Key in requests to the OpenAQ API, add the key to the request headers using the X-API-Keyheader key. e.g.
   
+ **OS Names**:
  + Please follow this [link](https://osdatahub.os.uk/) and click the "Sign Up for Free" link.
  + Choose the OS OpenData Plan option (Free). Follow the steps to set up an account as well as account verification steps.
  + Once you have an account, log in and click on the "API Dashboard" section of the Menu.
  + First you need to create a Project - Go to the API section of the left-hand side menu.
  + A list of APIs will appear, scroll until you find the OS Names API - under the API there is a button stating "Add to API Project". A dropdown will appear, select "Add to new API Project.
  + Give the Project a name.
  + You will then be taken to your new API Project area, which will have the API key.
    
+ **Postcodes.io** does not require an API key.

In order to protect my API keys I have stored them in a .env file and added it to a .gitignore file.

## Expected Outputs: ##

- Console Messages informing the user:
  - Which Location their postcode is fetching data from.
  - If the location isn't available in OpenAQ, it will select the nearest location and inform the user.
  - What is the overall Air Quality Score for the chosen area.
  - What is the highest pollutant present in the chosen area, and what is the Score for that particular pollutant.
  - A brief explanation of what the highest pollutant is.
  - Any error messages in case the code cannot compute their input (this can happen at various stages, and the error message will specify why the code couldn't process the request).
    
- A log of events as a .txt file, which will be generated and stored in the same folder as the .py file. This will store messages detailing:
  - The code has run successfully.
  - The API status code for each API.
  - The code has not run due to an error, and this issue has caused it.
  - The measurements in OpenAQ have negative values, and for tech teams to check their AirQuality measuring instruments (this was backed up by research done for this Assignment, where negative values had been flagged as possible faulty equipment).
  - *ALL* log messages will be preceded by the date and timestamp of the event (successful or unsuccessful).
    
- A single .txt file output for the location selected which includes all of the messages provided to the user via the console if the program has run successfully. A new file will be generated for each new location and will be saved in the same folder as the .py file.

## The Code Explained ##

So how does my code achieve the required result?

***Note: Instead of importing json, I am using the requests' library json module. With modern REST APIs and a library that can handle the requests and the response, it makes sense to use a single library to get the json data from the HTTP get. The json module can still be used for many other tasks, such as loading files that contain JSON, or parse strings into JSON.***

+ Import required packages (please refer to requirements.txt file).
+ Import API Keys from the .env file. (.env file will not be available in Github as it will be excluded by .gitignore)
+ Definte my current file path for the outputs using Path.cwd() for the Outputs
+ Define my Log function for any upcoming issues. (*Function*)
+ Ask the user to input a Postcode, and transform the input into an acceptable format for the API query.
+ Query the OS Names API to retrieve City/Town name, the ID (Postcode is the ID) and County name.
+ Query the Postcode.io API in order to obtain the latitude & longitude coordinates.
+ Query the OpenAQ API "locations" endpoint to retrieve the location data OpenAQ has for that location.
+ Define the time period that we will use to request data from the API - currently set to the last 30 days before the day the code is run. This retrieves 30 days worth of hourly data for the chosen location.
+ Use the location retrieved from the OpenAQ Api "locations" endpoint and use it to query the OpenAQ API "measurements" endpoint (*Function*).
+ Group the pollutants found in the results, with their respective hourly average measurements.
+ Using the same scoring system as the below image:

 ![European CAQI AQI](https://github.com/user-attachments/assets/581a9fe5-6d81-47c1-bd43-a6b1e8714cc8)

  Import the Excel table, specifying the sheet that matches each summarized pollutant, merge it with its respective Range table, and select the row where the measure falls under. This assigns it a Score of 1 to 5, with 1 being the Lowest (Best) and 5 being the Highest (Worst). Append each score result to a list.(*Function*)
+ Sum the list values and divide them by the list's length (didn't want to use .mean() twice). This gives us the overall Air Quality Score in integer format.
+ Run the overall score through a scoring function that assigns a written description to the score. (*Function*)
+ Check for negative values in the pollutant summary and write a message in the log if any are present.
+ Reset the score list.
+ Find the pollutant with the highest average.
+ Run it through the scoring function, which will append the single score to the newly emptied list.
+ Inform the user which is the highest pollutant and what is the presence level in the chosen area.
+ Using the highest pollutant, the code will pick a specific information paragraph I have hardcoded (taken from the web - with further enhancement I would set up a scraper for this info.).
+ Using a for loop, the code will split the paragraph, reshape it into separate lines of 13 words each, and re-join them with new line identations built in. This is so the text is written to the file in an easy to read format.
+ Write all of the user messages into an output (as well as printing them).
+ Log the final message stating the program has run successfully.

Output Files are included in this Pull Request, as well as Screenshots of the Terminal output.
In order to test the code thoroughly I have provide outputs for the below locations:

- **BH9 2DH (Bournemouth)** - With this postcode we get a pure success
- **BH1 2AT (Poole Postcode**- With this postcode we get a success using the nearest location (defaults to Bournemouth)
- **B1 1AY (Birmingham**) - This one showcases the negative measurements controls, and how the program picks the Borough instead of the county, based on the data available.
- **NG1 1AP (Nottingham)** - With this postcode we get a pure success
- **DT6 6JQ (Chideock)** - With this postcode the code cannot run as the information is not available (to showcase the logging of issues)

## Issues found during the build & How they were overcome ##

- OS Names API postcode queries work as a fuzzy match.
  - ***Solution:*** Perform a check on the retrieved data to ensure the user input and the retrieved postcode match. The program stops if they don't, the user is informed and the issue is logged.
    
- OS Names API City/Town names will be very specific to an area and not the most user friendly.
  -  ***Solution:*** Utilize the name of the County area of that location - for example: "Hampton" is not specific enough, so we bring in the county from the "COUNTY_UNITARY" field to enhance the resulting information on the chosen area: "Hampton - Greater London".
    
- OS Names API results sometimes lack the County area.
  -  ***Solution:*** Perform a try statement and if the field "COUNTY_UNITARY" is not present, to then use the field 'DISTRICT_BOROUGH' enhanced with the word "Borough" on the end. So for example, "Birmingham - Birmingham Borough".
  
- OS Names API does not provide latitude and longitude.
  -  ***Solution:*** Utilize the Postcodes.io API for lat & lon.
    
- Postcode.io API results are not as extensive as OS Names API but they do provide the required coordinates.
  -  ***Solution:*** Perform a try statement and if results cannot be retrieved from Postcodes.io, then the program stops, the user is informed and the issue is logged.
    
- As OpenAQ relies on some locations to have Air Quality measuring devices, not all locations found in the prior APIs will be present in the OpenAQ database.
  -  ***Solution:*** Make use of the "nearest" option in the API query and retrieve the top 10 closest locations to the coordinates given.

- The information paragraphs given are very long and aren't easy to read when written to a .txt file because they are so long.
  -  ***Solution:*** Split the words in the paragraph by white space, re-join words as sentences so they have an equal number of words, re-join sentences with a "\n" inbetween them so when the paragraph is written to .txt or displayed in the terminal it has a limited length and better format for reading.

## Assignment Criteria & Line references ##

As my code is quite long, please see below some line references of examples where I meet the assignment criteria:

+ **Use boolean values and if..else statements to branch logic of your program**
  - Line 48
  - Line 109
  - Line 223

+ **Use a data structure like a list, dictionary, set or tuple to store values**
  - Line 217
  - Line 270
  - Line 272

+ **Use a for loop or a while loop to reduce repetition**
  - Line 186
  - Line 216
  - Line 296

+ **Use functions with returns to make code reusable**
  - Line 21
  - Line 134
  - Line 184

+ **Use string slicing**
  - Line 264
  - Line 288

+ **Use at least two inbuilt functions**
  - Line 171
  - Line 249
  - Line 296
    
+ **Use any free API to get some information as json.**
  - Line 35
  - Line 64
  - Line 87
    
+ **Add comments to explain how your instructor can set up any necessary API keys and
briefly how you are using the API**
  - In this READM.md file, and comments are also available throughout the code. 
    
+ **Import an additional module you have not used in this assignment yet and use it. If it
needs to be installed, explain how to do that in the comments, and briefly note what it is
for.**
  - pandas - can be installed by typing "pip install pandas" in the cmd terminal (note it also needs openpyxl installed - "pip install openpyxl"). I'm using pandas to create dataframes with the extracted data so I can easily manipulate it. I am also using pandas to read in an external excel file. Overall Pandas is a great data analysis and manipulation tool.
  - dotenv - can be installed by typing "pip install python-dotenv" in the cmd terminal. I am using this library to read in my API keys from an external .env file.
    
+ **Write your final results to a file**
  - Line 21 - This is my Log Function
  - Line 311 - This is my ouput file.
