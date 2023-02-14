-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT 
	specs.film_title AS name,
	release_year,
	worldwide_gross
FROM specs
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
ORDER BY worldwide_gross
LIMIT 1;
	-- Semi-Tough (1977), $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT
	release_year,
	AVG(imdb_rating)
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year
ORDER BY AVG(imdb_rating) DESC
LIMIT 1;
	-- 1991 with average imdb rating of 7.45

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	film_title,
	mpaa_rating,
	worldwide_gross,
	company_name
FROM 
	specs
INNER JOIN
	revenue,
	distributors
ON
	specs.movie_id = revenue.movie_id
	specs.domestic_distributor_id = distributors.distributor_id
ORDER BY
	worldwide_gross DESC
LIMIT 1;

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

-- 5. Write a query that returns the five distributors with the highest average movie budget.

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
