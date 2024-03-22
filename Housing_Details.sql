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

SELECT property_type, COUNT(*) AS frequency
FROM housing_details
GROUP BY property_type
ORDER BY property_type ASC;

SELECT bed_type, COUNT(*) AS frequency
FROM housing_details
GROUP BY bed_type
ORDER BY bed_type ASC;

SELECT 
    property_type,
    COUNT(*) AS frequency,
    FLOOR(AVG(accommodates)) AS avg_accommodates
FROM 
    housing_details
GROUP BY 
    property_type
ORDER BY 
    property_type ASC;

SELECT * FROM housing_details

