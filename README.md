# Catarina Mesquita #

# Assignment 2 - Python #

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
 



# Assignment 3 - SQL #


For this assignment we are to come up with a unique scenario where we will create a database, and perform a series of SQL commands to showcase our skill.


## My Project - Purrs-R-Us, the Cat Shelter & Supply Shop ##


My scenario is a Cat Shelter called Purrs-R-Us. In order to promote their business and increase engagement, they have decided to open a store alongside the shelter. 

The income from the shop will help fund the care that the cats need whilst they wait to be adopted. The store runs well but they want to increase engagement even more. A proposed change that has been approved is to create discount offers for people who adopt a cat from the shelter, encouraging them to buy items in the shelter shop. 

This also has a second effect, where regular customers may be more likely to adopt a cat if the cats are in the same location as the shop, but if they also provide a discount for future purchases.

As part of this scenario I will demonstrate the creation of the database, and any mechanisms coded that will help the shop to make data-driven decisions, automate processes where we can and understand their clientelle.

*Note: Screenshots have been provided of all tables, including before & after certain processes. Images are numbered, so they follow the same order of each step of code.*

### Notes on Database Normalization and how the Database meets the required criteria ###


+ **First Normal Form (1NF)**
  + Each table in the database has a primary key and that each column in the table contains atomic values. For example, in the customer_contact table, the City is stored separately from the Street.

+ **Second Normal Form (2NF)**
  +  Each non-key column is dependent on the primary key. There should be no partial dependencies in the table. For example, the customers table details are kept separate from the cats table details, despite having a connection.
 
+ **Third Normal Form (3NF)**
  + Each non-key column is not transitively dependent on the primary key. For example, the shop_orders table is kept separate from item_prices table, if they are together the price would depend on the item, rather than the order_id.

+ **BCNF — Boyce-Codd Normal Form**
  + The possibility of functional dependencies between non-key attributes is eliminated. For example, in the cats table, the determinant is cat_id, and the non-key attribute is owner_id. However, a customer can have multiple cats, so there is a possibility of functional dependencies between non-key attributes. Therefore they have been kept separate.
 
+ **Fourth Normal Form (4NF)**
  + This is used to eliminate the possibility of multi-valued dependencies in a table. A multi-valued dependency occurs when one or more attributes are dependent on a part of the primary key, but not on the entire primary key. None of the Purrs-R-Us tables have columns that are partially dependant on the Primary Key.
 
+ **Fifth Normal Form (5NF)**
  + Is the highest level of normalization and is also known as Project-Join Normal Form (PJNF). It is used to handle complex many-to-many relationships in a database. In my Scenario, there are one to one and one to many relationships between tables. I have taken all the data I want to include and decomposed it into smaller tables. I have then created an additional table & view that gathers all of the data for better comprehension from a user perspective (shop_orders_enhanced). Each table has a single primary key, and the enhanced table includes foreign keys to the other tables.


## Situations faced and the implemented solutions ##


**The main goal of this project is to modernize the current processes in the shop, as well as consolidate the information accross tables. Shop_orders is a direct feed from the cashiers input terminal and cannot be changed.**

*Solution:*

+ I have created an additional table that will be called SHOP_ORDERS_ENHANCED. This will consolidate much of the information.


**Part of the initiative is to assist with some of the manual processes involved in processing a sale. The cashier currently has to manually check what is the item_id for each item in order to input it in the system and get the price. They also have to check if a customer is eligible for a promo, which promo & calculate the discounted price separately. For online orders, the user can only request a quote for the order total, as opposed to being able to get a total and pay immediately.**

*Solution:* 

+ An SQL Procedure was developed so that the cashier can input a sales order with more user friendly inputs (Item Description as opposed to ID), which also automatically generates the latest order id. The cashier's input is then stored in the shop_orders table as normal, not interfering with the existing system.
+ A Trigger was also developed so that when a new order is input into the shop_orders table, it will:
  + Automatically populate the new order info in the shop_orders_enhanced Table.
  + Automatically populate the item's description, the price, the item's category (needed for the promo) and calculates the order_total
  + Automatically check if a customer is entitled to a promotion (whether they have adopted or not).
  + Automatically check which promotion they are entitled to (2-for-1 or 20%)
  + Automatically calculate the order total after discount (if no discount then it will be the same as the original order total)


**At the end of the day, the shop staff has to verify the stock levels and offset the orders processed throughout the day against each item's stock levels. This has led to unexpected shortages in the past, especially when dealing with multiple online orders.**

*Solution:*

+ In order to improve this process, within the Procedure that allows the user to input a new order easily (which houses a Transaction), an additional Procedure has been incorporated that:
  + Checks if there is enough stock available
  + If there isn't enough stock (for example online orders), a message will be provided to the user that there isn't enough stock.
  + If there is enough stock, the stock levels will be adjusted as per the order.

 
**The shop_orders_enhanced table is now very comprehensive, and staff users may be bombarded with information that they don't necessarily need when dealing with day to day transactions.**

*Solution:*

+ In order to creat a more user-friendly interface, I have created a view, which displays the organized information and skips unnecessary fields.


**With the growing awareness of Purrs-R-Us more customers have decided to start visiting our shop. Adding a new user is an unnecessary delay when processing orders.**

*Solution:*

+ Within the new Procedure to add new orders, I have impletemented some additional code that ensures that any users not present in the customer list are immediately added to the customer table. This does not populate the customer_contact table, as customers may not be comfortable giving such details. Customers can have their contact details added at the point of sale, or online, when setting up an account.


**The Sales team want to regularly check who are the top spending customers that use the shop. The parameters are:**

  1. **Only display the Top 6, sorted from Highest Spending to Least.**
  1. **Only show results for the latest month**
  1. **Sum of Sales is for ALL items bought in that time period**
  1. **An additional column displays the type of item the customer spends most money on, and what percentage of their overall spend that category makes up.**

  *Solution:*
  
+ A view was created that provides all of the above parameters.


**The Shelter part of the business still has some furbabies to be adopted. In light of this, the Marketing team is going to lauch targeted campaigns to try and persuade customers who haven't chosen to adopt some of our kitties. The first thing to do is to understand our kitties that haven't been adopted. Fur colour is a well known factor that sways some people when choosing to adopt one cat v.s. another
so let's extract some facts on our own kitties. Within the adopted and non-adopted population of our shelter, what is the colour most present in each sub-set?**

*Solution:*

+  The developed code finds the most present colour within each sub-set, and divide it by the overall count of cats in that sub-set giving us the percentage of most frequent colour within the adopted and non-adopted groups. The output will be two statements describing the percentages.


**After obtaining the cat fur colours statistics within each group (adopted and non-adopted), the team wants to find out if Average age within a breed makes a difference.**

*Solution:*

+ Two queries were developed to verify this information. No trends were observed.


**The Marketing team is confident that the basis for the campaign targeting customers with no adopted cats should be to promote cats that have black fur, as these for the highest group within the Non-Adopted sub-set. So we need the details of any customers that have and haven't adopted.**

*Solution:*

+ A series of queries were developed to provide the Marketing team with:
  + A list of Customer Names that have adopted, and their Cat's names.
  + A list of Least to Most sold items to date.
  + A joint list of Customer names that haven't adopted, along with a joint list of cats that haven't been adopted.
    
+ For the Adopted Campaign:
  + A list was provided of Customer Names that have adopted, as well as the names of their cats.
  + A list of Least to Most sold items to date was provided, whose top 3 include items that fall under the "Toys" and "Food" Categories (promotions are only available for these type of items).
  + In light of this information, the Marketing team is going to release an email campaign, which will promote Catnip Puzzle & the Healthy Nibbles products to the Customers that have adopted cats, highlighting the existing promotions that they are eligible for, and how they apply to these two items. The email will also address the customer including the name of their adopted cat(s), for a higher chance of engagement.
    
+ For the Non Adopted Campaign:
  + A multi-channel campaign is going to be launched using meme culture to promote the idea of adopting a Black Cat (for example, *"You stare into the void, and the void wants Chicken"*)
  + A print campaign in store, which will display the images and names of the non-adopted cats.

 
**Unexpectedly, there has been a recall on a product issued by Fluffy & Co, the "Scratchy Pole". In light of this information, we need to identify which customers purchased this item, and when, so we can reach out to inform them and issue refunds.** 

*Solution:*

+ An SQL query retrieves this data, which includes the date the order was placed, who was the Customer, and their contact details.


**Edgar Adams has reached out to the store informing us that he is moving to Spain, and therefore doesn't want to be contacted about promotions or marketing campaigns, however he still might buy some treats for his mum's cat when he comes to visit, so he just wants his contact details removed from the database.**

*Solution:*

+ A procedure was developed that allows a user to remove the contact details of a Customer without accessing the full table, so the contact details of the remaining Customers are protected.
+ An additional query was built that checks if a Customer present in the customer table has contact details in the customer_contact table. The query returns a list of names.
