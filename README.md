# Project_03_Data_Engineering
Project 3 - Data Engineering



## Pricing vs Total Review Score

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
- The conditions were selected based off the 



