-- Creating new tables and setting PRIMARY KEYs:

CREATE TABLE housing_details (
    id INT NOT NULL PRIMARY KEY,
    host_id INT,
    neighbourhood_cleansed VARCHAR(255),
    property_type VARCHAR(255),
    room_type VARCHAR(255),
    accommodates INT,
    bathrooms FLOAT,
    bedrooms FLOAT,
    beds FLOAT,
    bed_type VARCHAR(255),
    amenities TEXT
);

SELECT * FROM housing_details

SELECT COUNT (room_type) FROM housing_details
-- WHERE room_type = 'Entire home/apt';