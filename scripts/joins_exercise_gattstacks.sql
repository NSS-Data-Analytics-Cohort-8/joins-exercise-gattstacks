-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT 
	film_title AS name,
	release_year,
	worldwide_gross :: money
FROM specs
LEFT JOIN revenue
USING (movie_id)
ORDER BY worldwide_gross
LIMIT 1;

	-- Semi-Tough (1977), $37,187,139

-- 2. What year has the highest average imdb rating?

SELECT
	release_year,
	ROUND(AVG(imdb_rating), 2) AS avg_imdb_rating
FROM specs
LEFT JOIN rating
USING (movie_id)
GROUP BY release_year
ORDER BY avg_imdb_rating DESC
LIMIT 1;

	-- 1991 with average imdb rating of 7.45.

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	film_title,
	mpaa_rating AS rating,
	worldwide_gross :: money,
	company_name AS distributing_company
FROM distributors
RIGHT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
LEFT JOIN revenue
USING (movie_id)
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC
LIMIT 1;

	-- Toy Story 4 is highest grossing G-rated movie at "$1,073,394,593.00". It was distributed by Walt Disney. 
	
-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies (specs) table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	company_name AS distributor,
	COUNT(film_title) AS film_count
FROM distributors
LEFT JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributor;
	/* 
	distributor							film_count
	"Universal Pictures"				58
	"Columbia Pictures"					15
	"American International Pictures"	1
	"Miramax"							1
	"TriStar Pictures"					9
	"DreamWorks"						17
	"Orion Pictures"					6
	"Paramount Pictures"				51
	"Icon Productions"					1
	"Sony Pictures"						31
	"IFC Films"							1
	"Summit Entertainment"				3
	"The H Collective"					1
	"Fox Searchlight Pictures"			1
	"New Line Cinema"					8
	"Metro-Goldwyn-Mayer"				13
	"Twentieth Century Fox"				49
	"Walt Disney "						76
	"Warner Bros."						71
	"Lionsgate"							5
	"Legendary Entertainment"			0
	"Vestron Pictures"					1
	"Relativity Media"					0
	*/

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT 
	distributors.company_name AS distributor,
	ROUND(AVG(revenue.film_budget), 2) :: money AS average_movie_budget
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN revenue
USING (movie_id)
GROUP BY distributor
ORDER BY average_movie_budget DESC
LIMIT 5;

	-- 1) "Walt Disney "	$148,735,526.32
	-- 2) "Sony Pictures"	$139,129,032.26
	-- 3) "Lionsgate"		$122,600,000.00
	-- 4) "DreamWorks"		$121,352,941.18
	-- 5) "Warner Bros."	$103,430,985.92

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT
	company_name,
	headquarters,
	COUNT(domestic_distributor_id) AS number_of_movies,
	film_title,
	imdb_rating
FROM distributors
INNER JOIN specs
ON distributors.distributor_id = specs.domestic_distributor_id
INNER JOIN rating
USING (movie_id)
WHERE headquarters NOT LIKE '%CA'
GROUP BY 
	company_name, 
	headquarters,
	film_title,
	imdb_rating
ORDER BY imdb_rating DESC;

	/*
	company_name			headquarters			number_of_movies	film_title					imdb_rating
	"Vestron Pictures"		"Chicago, Illinois"		1					"Dirty Dancing"				7.0
	"IFC Films"				"New York, NY"			1					"My Big Fat Greek Wedding"	6.5
	*/

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT 
	length_in_min > 120 AS over_2_hours,
	AVG(imdb_rating) AS avg_imdb_rating
FROM specs
LEFT JOIN rating
USING (movie_id)
GROUP BY length_in_min > 120;
	
	 	/*
		over_2_hours		avg_imdb_rating
		false				6.9154185022026432
		true				7.2571428571428571
		
		Based on results, movies over 2 hours on average have a higher imdb rating as compared to movies less then two hours long.
		*/