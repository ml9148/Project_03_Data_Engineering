CREATE TABLE reviews
(
    id integer NOT NULL,
    number_of_reviews integer NOT NULL,
    first_review date,
    last_review date,
    review_scores_rating integer,
    review_scores_accuracy integer,
    review_scores_cleanliness integer,
    review_scores_checkin integer,
    review_scores_communication integer,
    review_scores_location integer,
    review_scores_value integer,
    reviews_per_month character varying(10),
    CONSTRAINT reviews_pkey PRIMARY KEY (id)
);

SELECT * FROM reviews;

