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
- Python: Pandas, ___
- SQL
- QuickDBD
- Google Slides

## File Descriptions
### Main repo folder
- extract.ipynb: First, we chose the columns that would be appropriate for our database. We then drew a random sample of 10,000 observations (approximately 1/3 of the original dataset) to eliminate issues with large file sizes. Next, we prepared the file to be inserted into the database by checing for null values and converting the datatype of each column.  We then exported our dataframe to a .csv file (Listings_Cleaned_Sample.csv) to use in creating individual tables. Note: Both the original and sample dataset are in the Resources folder (as also noted below). However, due to the large file size, the original dataset, "Detail_listings.csv," must first be unzipped for the extract .ipynb file to run properly.
### Resources folder
- Detail_Listings.csv: The original dataset downloaded from Kaggle.com. Utilized by the extract.ipynb file, but must be unzipped due to large file size.
- Listings_Cleaned_Sample: The 10,000 observations we used to create the database.
### Tables folder
- contains the tables we create