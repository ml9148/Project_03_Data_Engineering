-- DROP TABLE reviews;

CREATE TABLE reviews (
	host_id INT PRIMARY KEY NOT NULL,
	number_of_reviews INT, 
	first_review DATE,
	last_review DATE,
	review_scores_rating INT,
	review_scores_accuracy INT,
	review_scores_cleanliness INT,
	review_scores_checkin INT,
	review_scores_communication INT,
	review_scores_location INT,
	review_scores_value INT,
	reviews_per_month VARCHAR(10)
);

SELECT*FROM reviews;