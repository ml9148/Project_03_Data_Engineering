-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

DROP TABLE IF EXISTS host;

CREATE TABLE "host" (
    "host_id" int,
    "host_name" VARCHAR,
    "host_since" DATE,
    "host_location" VARCHAR,
    "host_response_time" VARCHAR,
    "host_response_rate" FLOAT,
    "host_is_superhost" BOOLEAN,
    "host_neighbourhood" VARCHAR,
    "host_total_listings_count" FLOAT,
    "host_listings_in_sample" FLOAT,
    "host_verifications" VARCHAR,
    "host_has_profile_pic" BOOLEAN,
    "host_identity_verified" BOOLEAN,
    CONSTRAINT "pk_host" PRIMARY KEY (
        "host_id"
     )
);

DROP TABLE IF EXISTS pricing_vs_reviews;

CREATE TABLE "pricing_vs_reviews" (
    "price" varchar,
    "avg_review_per_price" float,
    "number_of_reviews_sum" int,
    "affordability" varchar,
    CONSTRAINT "pk_pricing_vs_reviews" PRIMARY KEY (
        "price","affordability"
     )
);

DROP TABLE IF EXISTS Reviews;

CREATE TABLE "Reviews" (
    "host_id" int,
    "number_of_reviews" int,
    "first_review" varchar,
    "last_review" varchar,
    "review_scores_rating" float,
    "review_scores_accuracy" float,
    "review_scores_cleanliness" float,
    "review_scores_checkin" float,
    "review_scores_communication" float,
    "review_scores_location" float,
    "review_scores_value" float,
    "reviews_per_month" float
);

DROP TABLE IF EXISTS final_listing_cleaned;

CREATE TABLE "final_listing_cleaned" (
    "id" int,
    "host_id" int,
    "price" varchar,
    "affordability" varchar,
    CONSTRAINT "pk_final_listing_cleaned" PRIMARY KEY (
        "id"
     )
);

DROP TABLE IF EXISTS sentiment;

CREATE TABLE "sentiment" (
	"Summary" varchar,
	"Host ID" integer NOT NULL,
    "Polarity Score" varchar,
    "Polarity Sentiment" varchar,
    "Subjectivity Score" varchar,
    "Subjectivity Sentiment" varchar
);

DROP TABLE IF EXISTS listing_location_details;

CREATE TABLE "listing_location_details" (
    "listing_id" int,
    "country" varchar,
    "country_code" varchar,
    "city" varchar,
    "zipcode" varchar,
    "neighborhood" varchar,
    "latitude" float,
    "longitude" float,
    "market" varchar,
    "is_location_exact" varchar,
    "property_type" varchar,
    "name" varchar,
    "summary" varchar,
    "neighborhood_overview" varchar,
    "host_id" int
);

DROP TABLE IF EXISTS housing_details_data_cleaned;

CREATE TABLE "housing_details_data_cleaned" (
    "id" int,
    "host_id" int,
    "neighbourhood_cleansed" varchar,
    "property_type" varchar,
    "room_type" varchar,
    "accommodates" int,
    "bathrooms" float,
    "bedrooms" float,
    "beds" float,
    "bed_type" varchar,
    "amenities" varchar
);

ALTER TABLE "Reviews" ADD CONSTRAINT "fk_Reviews_host_id" FOREIGN KEY("host_id")
REFERENCES "host" ("host_id");

ALTER TABLE "final_listing_cleaned" ADD CONSTRAINT "fk_final_listing_cleaned_host_id" FOREIGN KEY("host_id")
REFERENCES "host" ("host_id");

ALTER TABLE "final_listing_cleaned" ADD CONSTRAINT "fk_final_listing_cleaned_price_affordability" FOREIGN KEY("price", "affordability")
REFERENCES "pricing_vs_reviews" ("price", "affordability");

ALTER TABLE "sentiment" ADD CONSTRAINT "fk_sentiment_Host ID" FOREIGN KEY("Host ID")
REFERENCES "host" ("host_id");

ALTER TABLE "listing_location_details" ADD CONSTRAINT "fk_listing_location_details_listing_id" FOREIGN KEY("listing_id")
REFERENCES "final_listing_cleaned" ("id");

ALTER TABLE "housing_details_data_cleaned" ADD CONSTRAINT "fk_housing_details_data_cleaned_id" FOREIGN KEY("id")
REFERENCES "final_listing_cleaned" ("id");