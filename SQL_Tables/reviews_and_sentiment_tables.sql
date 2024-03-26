--CREATE DATABASE project_3;

--DROP TABLE comprehensive_reviews
CREATE TABLE comprehensive_reviews
(
    "Host ID" integer NOT NULL,
    "Number of Reviews" integer NOT NULL,
    "First Review" date,
    "Last Review" date,
    "Overall Rating" integer,
	"Review Score" varchar(10),
    "Accuracy" integer,
    "Cleanliness" integer,
    "Check-In" integer,
    "Communication" integer,
    "Location" integer,
    "Value" integer,
	"Category Average" varchar(15),
    "Reviews per Month" varchar(10),
    CONSTRAINT comprehensive_reviews_pkey PRIMARY KEY ("Host ID")
);

SELECT * FROM comprehensive_reviews;

--DROP TABLE sentiment
CREATE TABLE sentiment
(
	"Summary" varchar,
	"Host ID" integer NOT NULL,
    "Polarity Score" varchar,
    "Polarity Sentiment" varchar,
    "Subjectivity Score" varchar,
    "Subjectivity Sentiment" varchar,
    CONSTRAINT sentiment_pkey PRIMARY KEY ("Host ID")
);

SELECT * FROM sentiment;