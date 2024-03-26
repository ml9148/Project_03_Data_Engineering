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
- Python: Pandas, locale, SQLAlchemy, Numpy, NLTK, TextBlob
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
- reviews.ipynb:
- sentiment.ipyynb:
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

### Comprehensive Reviews

The purpose of the comprehensive reviews dataframe and table are to provide a way for anyone viewing the data to be able to easily determiine what the different reviews of different hosts are, as well as sort the data as needed to find hosts with specific ratings, whether overall or by category.  

---

1. To begin we read the csv file into a pandas dataframe, reduced the columns to only the host_id primary key and those that were related to reviews, and updated the column names

# import libraries
import pandas as pd

# read in data
df=pd.read_csv("Resources/Data_Cleaning/Listings_Cleaned_Sample.csv")

# drop unnecessary columns
df_clean=df.drop(columns=[''])

# clean up column header names
df_clean = df_clean.rename(columns={'original_name': 'New Name'})

---

2. We cleaned the remaing data by dropping any elements with no reviews and duplicate hosts, and updated data types to be easy to use for the rest of the transformation and table creation in PostgreSQL

# drop any items with 0 reviews
df_clean.drop(df_clean.loc[df_clean['Number of Reviews']==0].index, inplace=True)

# drop duplicate hosts
df_clean.drop_duplicates(subset=['Host ID'], inplace=True)

# update data types for postgresql import
df_clean['First Review'] = pd.to_datetime(df_clean['First Review'])
df_clean['Last Review'] = pd.to_datetime(df_clean['Last Review'])
df_clean['Overall Rating'] = df_clean['Overall Rating'].astype('Int64')
df_clean['Accuracy'] = df_clean['Accuracy'].astype('Int64')
df_clean['Cleanliness'] = df_clean['Cleanliness'].astype('Int64')
df_clean['Check-In'] = df_clean['Check-In'].astype('Int64')
df_clean['Communication'] = df_clean['Communication'].astype('Int64')
df_clean['Location'] = df_clean['Location'].astype('Int64')
df_clean['Value'] = df_clean['Value'].astype('Int64')
df_clean['Reviews per Month'] = df_clean['Reviews per Month'].astype('string')

---

3. We bucketed the overall ratings scores and calculated the mean across categorical ratings.  We created 2 new columns in the dataframe to display.

# bucket the overall ratings 
df_clean['Review Score']=pd.cut(df_clean['Overall Rating'],5,labels=['Very Low','Low','Moderate','High','Very High'])

# find the average of each hosts subcategory ratings and round to 2 decimals
average = df_clean[['Accuracy','Cleanliness','Check-In','Communication','Location','Value']].fillna(0).mean(axis=1).round(2)

#insert data into new column
desired_index = 12
df_clean.insert(desired_index, 'Category Average', average)

---

4. Sent the transformed data to csv

# send cleaned data to csv
df_clean.to_csv("Data/reviews.csv", index=False)


### Sentiment Analysis

Our goal for this section was to recode open-end summary reviews of Airbnb's as either positive, negative, or neutral in terms of polarity and objective, subjective, or neutral in terms of subjectivity. We used Pandas, NLTK and TextBlob

---

1. We imported the necessary libraries, read our data into a dataframe, and reduced data to summaries and host_id as the primary key

# import libraries
import pandas as pd
import numpy as np

import nltk
from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer

import textblob
from textblob import TextBlob

# read data into dataframe
df=pd.read_csv(Resources/Data_Cleaning/Listings_Cleaned_Sample.csv")

# drop unnecessary columns
df_clean=df.drop(columns=[''])

---

2. We dropped null values and duplicate host_id elements

# identify null values in summary
df_clean['summary'] = df_clean['summary'].replace('', np.nan)

# drop null values in summary
df_clean.dropna(subset=['summary'], inplace=True)

# drop duplicates in host id
df_clean.drop_duplicates(subset=['host_id'], inplace=True)

---

3. We processed the text to prepare it for analysis by converting text to tokens, filtering the tokens, lemmatizing the tokens, then applying the changes to the text

# pre-process summary text for manipulation
def preprocess_text(text):
    if pd.isnull(text):
        return ""

# tokenize text    
    tokens = word_tokenize(text.lower())

 # filter out stopwords   
    filtered_tokens = [token for token in tokens if token not in stopwords.words('english')]

 # lemmatize the tokens   
    lemmatizer = WordNetLemmatizer()
    lemmatized_tokens = [lemmatizer.lemmatize(token) for token in filtered_tokens]

    processed_text = ' '.join(lemmatized_tokens)
    return processed_text

# apply changes to summary text
df_clean['summary'] = df_clean['summary'].apply(preprocess_text)

---

4. We calculated polarity and sentiment scores and used if/elseig statements to recode the scores, then displayed the scores and sentiments in new corresponding columns

# create column for sentiment polarity scores
df_clean['polarity_score'] = ""

# pull polarity sentiment scores
def calculated_sentiment(text):
    polarity_score = TextBlob(text)
    try:
        return polarity_score.sentiment.polarity
    except:
        return None

# add summary polarity scores in corresponding column
df_clean['polarity_score'] = df_clean['summary'].apply(calculated_sentiment)

# create column for polarity sentiments determined by the polarity score
df_clean['polarity_sentiment'] = ""

# recode polarity scores as sentiment (positive, negative, neutral) 
def defined_sentiment(review):
    polarity_sentiment = TextBlob(review)

    sentiment = polarity_sentiment.sentiment.polarity
    if sentiment > 0:
        return "positive"
    elif sentiment < 0:
        return "negative"
    else:
        return "neutral"

# add polarity sentiments to corresponding column
df_clean['polarity_sentiment'] = df_clean['summary'].apply(defined_sentiment)

# create column for sentiment subjectivity scores
df_clean['subjectivity_score'] = ""

# calculate subjectivity scores
def calculated_sentiment(text):
    subjectivity_score = TextBlob(text)
    try:
        return subjectivity_score.sentiment.subjectivity
    except:
        return None

# add scores to the corresponding column
df_clean['subjectivity_score'] = df_clean['summary'].apply(calculated_sentiment)

# create column for subjectivity sentiment
df_clean['subjectivity_sentiment'] = ""

# recode subjectivity scores as sentiment (positive, negative, neutral)
def defined_sentiment(review):
    subjectivity_sentiment = TextBlob(review)

    sentiment = subjectivity_sentiment.sentiment.polarity
    if sentiment > 0:
        return "objective"
    elif sentiment < 0:
        return "subjective"
    else:
        return "neutral"

# add subjectivity sentiment to the new column    
df_clean['subjectivity_sentiment'] = df_clean['summary'].apply(defined_sentiment)

---

5. We updated column names and data types for easy table creation in PostgreSQL, then pushed the transformed data to csv

# Update column header names
df_clean = df_clean.rename(columns={'old_name': 'New Name'})

# update data types for sql
df_clean['Summary'] = df_clean['Summary'].astype('string')
df_clean['Polarity Score'] = df_clean['Polarity Score'].astype('string')
df_clean['Polarity Sentiment'] = df_clean['Polarity Sentiment'].astype('string')
df_clean['Subjectivity Score'] = df_clean['Subjectivity Score'].astype('string')
df_clean['Subjectivity Sentiment'] = df_clean['Subjectivity Sentiment'].astype('string')

# save final data to csv
df_clean.to_csv("Data/summary.csv", index=False)

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

<<<<<<< HEAD
### Housing_Details Table
For the housing details obtained in (https://www.kaggle.com/datasets/oindrilasen/la-airbnb-listings), a dataframe Housing_Details.ipynb was created dropping non-related columns and specific columns related to housing details were maintained: host_id, neighbourhood_cleansed, property_type, room_type, accommodates, bathrooms, bedrooms, beds, bed_type and amenities; these columns are available for further analisys specific to the housing details topic.

For Housing_Details.ipynb the "id" or listing ID was used as it contains unique values that helped understand how many types of housing units in the LA's airbnb listings area are available (Apartment, Cabin, House, Loft, etc.), with the available sample we can pull and analyze from different angles what types of beds are listed and how many people they accommodate.

The data scraped is exported as a csv file and can be linked to the other datasets for different purposes.
=======
>>>>>>> 76fd1cadab2e0f47baa6001b2c2ff7d1912d01f9

### Other Info


### Retrieving the Data from the Database
Finally, in the read_database.ipynb file, we used SQLAlchemy to retrieve the data from the database using an engine and connecting to the database to read each table into individual dataframes, stored for future use.