# Project_03_Data_Engineering

## Group Members
- Ben Comfort
- Amanda Dunaway
- Matt Flanagan
- Luis Martinez
- Charity Ovando

## Project Summary
We utilized ETL workflows to create an analysis-ready database of Los Angeles AirBnb listings from [data webscraped](https://www.kaggle.com/datasets/oindrilasen/la-airbnb-listings) in March 2017.  

## Tools
- Python: Pandas, locale, SQLAlchemy
- SQL: PgAdmin
- QuickDBD
- Microsoft PowerPoint

## File Descriptions
### Main repo folder
- extract.ipynb: Extracts the csv file of webscraped data, draws a random sample for our project, and exports the sample csv to the Resources folder. 
     - Note: Both the original and sample dataset are in the Resources folder (as also noted below). However, due to the large file size, the original dataset, "Detail_listings.csv," must first be unzipped for the extract .ipynb file to run properly.
- listing_location_details.ipynb: Summarizes the location details for every listing in the sample and exports csv to the data folder.
- prices_VS_reviews.ipynb: Simplifies the pricing table and exports csv to the data folder.
- hosts.ipynb: Creates a table with all the host-related information for each host id and exports to csv in the data folder.
- .ipynb:
- .ipyynb:
- .ipynb:
- read_database.ipynb: Uses SQLAlchemy to read the data from our database and store it for future use as Pandas DataFrames.
- config.py: Stores username and password information to access the database from PgAdmin using the read_database.ipynb file.
- .gitignore: Secures the config.py file.

### Resources folder
- Detail_Listings.csv: The original dataset downloaded from Kaggle.com. Utilized by the extract.ipynb file, but must be unzipped due to large file size.
- Listings_Cleaned_Sample: The 10,000 observations we used to create the database tables.
### "data" folder
- Contains the csv files we created for the database.
-------------------------------------------------------------------------------------------

## Database Creation Outline

### Sample selection
First, we chose the columns that would be appropriate for our database. We then drew a random sample of 10,000 observations (approximately 1/3 of the original dataset) to eliminate issues with large file sizes. Next, we prepared the file to be inserted into the database by checling for null values in columns we intended to be primary keys.  We then exported our dataframe to a .csv file (Listings_Cleaned_Sample.csv) to use in creating individual tables. 

**Need to discuss our ethical considerations and anything else designated in the rubric.

### Pricing vs Total Review Score

My goal for this extract was to simplify the pricing of the table by grouping the price column and aggregating the respective reviews. 

1. Beginning with reading in the sampled csv file and extracting only the price, review_scores_value, and number_of_reviews

```
# import libraries

import pandas as pd
import locale
--------------------------------------------------------------------------------------------
# read in csv and show data frame
listings_path = 'Resources/Listings_Cleaned_Sample.csv'
extract_df = pd.read_csv(listings_path)
prices_df = extract_df[['price','review_scores_value','number_of_reviews']]
prices_df.info()
prices_df.head()
```
2. In order to group the price column I needed to convert each value in the column to a float

```
prices_df['price'] = prices_df['price'].str.replace('$','')
prices_df['price'] = prices_df['price'].replace(',','',regex=True)
prices_df['price'] = prices_df['price'].astype(float)
prices_df.info()
```
- regarding step 2. The array items needed to be converted to strings first in order for the replace function to work according to this: https://stackoverflow.com/questions/38516481/trying-to-remove-commas-and-dollars-signs-with-pandas-in-python 
- I did run into issues getting this to work with more efficient methods so I kept the functioning codeblock

3. Get the average review score for each unique price and get the total number of reviews of that price.

```
# aggregate tracked columns to show the average rating of each price
# sum the number of reviews for each price
clean_prices = prices_df.groupby('price').agg({'review_scores_value':['mean'], 
                                                'number_of_reviews':['sum']}).reset_index()
# join the sum and mean so that the columns are one dimensional
clean_prices.columns = clean_prices.columns.map('_'.join)
clean_prices
```
- after aggregation I renamed the columns 
```
clean_prices = clean_prices.rename(columns={'price_':'price',
                             'review_scores_value_mean':'avg_review_per_price'})
```
4. Run a for-loop that appends each desired price range to a list that corresponds with the value in the prices column
```
# create a new column that identifies if the price is groups cheap, affordable, expensive, or extravagent
# create empty price rating list
affordability = []

# if the value fits the condition then append to list
for i in clean_prices['price']:
    if i <= 50.0:
        affordability.append('Cheap $0-49')
    elif i > 50.0 and i <= 200.0:
        affordability.append('affordable $51-200')
    elif i > 200.0 and i <= 500.0:
        affordability.append('expensive $200-500')
    elif i > 500.0:
        affordability.append('very expensive $500+')
    else:
        affordability.append('NA')
```
- The conditions were selected based off the numbers given to me by my manager (I made them up)


### Hosts_Info Table
In the hosts.ipynb file, we first read in the sample csv file and create a dataframe of the host-related columns: host_id, host_name, host_since, host_location, host_response_time, host_response_rate, host_is_superhost, host_neighbourhood, host_total_listings_count, host_listings_in_sample, host_verifications, host_has_profile_pic, host_identity_verified.

Next, we explore the datatypes and convert them as needed. We removed the percent symbol from the host response rate so that it could be used in analysis. We also mapped the columns containing "t" and "f" to "True" and "False" so that they could be analyzed as boolean columns. 

To create the Hosts table, we want to use host_id as the primary key. We confirmed that since some hosts have multiple listings, and all host-related information is identical for each host's listing, we would drop the duplicate host_ids. However, we needed to take more steps in transforming the Hosts table before doing so.

Using .value_counts(), we created a dictionary of each host_id and the corresponding number of properties contained in the sample and mapped this to create a new column. This will allow the analyst to view both the total number of properties a host has list on the AirBnb website and the total number of properties a host has in our sample. 

Lastly, we sorted the DataFrame by host_id and exported it as a csv file to be imported into our database.


### Other Info


### Retrieving the Data from the Database
Finally, in the read_database.ipynb file, we used SQLAlchemy to retrieve the data from the database using an engine and connecting to the database to read each table into individual dataframes, stored for future use.