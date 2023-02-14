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
	-- 1991 with average imdb rating of 7.45.

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	film_title AS movie_name,
	mpaa_rating AS rating,
	worldwide_gross,
	company_name as distributing_company
FROM specs
INNER JOIN revenue
USING (movie_id)
INNER JOIN distributors
ON specs.domestic_distributor_id = distributors.distributor_id
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC
LIMIT 1;
	-- Toy Story 4 is highest grossing G-rated movie. It was distributed by Walt Disney. 
	
-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies (specs) table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	distributors.company_name AS distributor,
	COUNT(domestic_distributor_id) AS number_of_movies
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY number_of_movies DESC;
	/* 
	"Walt Disney "						76
	"Warner Bros."						71
	"Universal Pictures"				58
	"Paramount Pictures"				51
	"Twentieth Century Fox"				49
	"Sony Pictures"						31
	"DreamWorks"						17
	"Columbia Pictures"					15
	"Metro-Goldwyn-Mayer"				13
	"TriStar Pictures"					9
	"New Line Cinema"					8
	"Orion Pictures"					6
	"Lionsgate"							5
	"Summit Entertainment"				3
	"Vestron Pictures"					1
	"American International Pictures"	1
	"Miramax"							1
	"Icon Productions"					1
	"IFC Films"							1
	"The H Collective"					1
	"Fox Searchlight Pictures"			1
	*/

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT 
	distributors.company_name AS distributor,
	ROUND(AVG(revenue.film_budget), 2) AS average_movie_budget
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue
USING (movie_id)
GROUP BY distributor
ORDER BY average_movie_budget DESC
LIMIT 5;
	-- 1) "Walt Disney "	148,735,526.32
	-- 2) "Sony Pictures"	139,129,032.26
	-- 3) "Lionsgate"		122,600,000.00
	-- 4) "DreamWorks"		121,352,941.18
	-- 5) "Warner Bros."	103,430,985.92

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT
	distributors.company_name,
	distributors.headquarters,
	COUNT(domestic_distributor_id) AS number_of_movies,
	specs.film_title,
	rating.imdb_rating
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)
WHERE distributors.headquarters NOT LIKE '%CA'
GROUP BY 
	distributors.company_name, 
	distributors.headquarters,
	film_title,
	rating.imdb_rating
ORDER BY rating.imdb_rating DESC;
	/*
	"Vestron Pictures"	"Chicago, Illinois"	1	"Dirty Dancing"				7.0
	"IFC Films"			"New York, NY"		1	"My Big Fat Greek Wedding"	6.5
	*/

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT
	specs.length_in_min,
	rating.imdb_rating
FROM specs
INNER JOIN rating
USING (movie_id)
GROUP BY specs.length_in_min, rating.imdb_rating
ORDER BY specs.length_in_min DESC;
	-- Using averageif function in excel, movies over 2 hours long perform better with critics with an average rating of approx 7.27 vs moves under 2 hours long with an average rating of approx 6.91 
	