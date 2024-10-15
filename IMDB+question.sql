USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(*)
FROM movie;

-- Number of rows in table name - "movie" = 7997

SELECT count(*)
FROM names;

-- Number of rows in table name - "names" = 25735 

SELECT count(*)
FROM role_mapping;

-- Number of rows in table name - "role_mapping" = 15615

SELECT count(*)
FROM director_mapping;

-- Number of rows in table name - "director_mapping" = 3867
 
SELECT count(*)
FROM ratings;

-- Number of rows in table name - "ratings" = 7997


 SELECT count(*)
FROM genre;

-- Number of rows in table name - "genre" = 14662
 



-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- Checking columns names in table movie
SELECT *
FROM movie;

-- Null_counts in each column in movie table 
SELECT 
		SUM(CASE
			WHEN id IS NULL THEN 1
            ELSE 0
            END) as Id_null_counts,
		SUM(CASE
			WHEN title IS NULL THEN 1
            ELSE 0
            END) as title_null_counts,
		SUM(CASE
			WHEN year IS NULL THEN 1
            ELSE 0
            END) as year_null_counts,
		SUM(CASE
			WHEN date_published IS NULL THEN 1
            ELSE 0
            END) as date_published_null_count,
		SUM(CASE
			WHEN country IS NULL THEN 1
            ELSE 0
            END) as country_null_counts,
		SUM(CASE
			WHEN worlwide_gross_income IS NULL THEN 1
            ELSE 0
            END) as worlwide_gross_income_null_counts,
		SUM(CASE
			WHEN languages IS NULL THEN 1
            ELSE 0
            END) as languages_null_counts,
		SUM(CASE
			WHEN production_company IS NULL THEN 1
            ELSE 0
            END) as production_company_null_counts
FROM movie;
		   
/* ID_null_counts = 0
title_null_counts = 0
year_null_counts = 0
date_published_null_count = 0
country_null_counts = 20
worlwide_gross_income_null_counts = 3724
languages_null_counts = 194
production_company_null_counts = 528 */



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+




Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,
		count(year) as number_of_movies
FROM movie
GROUP BY year;

-- In year 2017 maximum movies as released followed by year 2018 and 2019. Year after year it is declining 


SELECT MONTH(date_published) as month_num,
	   COUNT(year) as number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published) ASC;

 
/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


SELECT
    country,
    COUNT(country) AS count_movies
FROM
    movie
WHERE
    country IN ("India", "USA") AND
    year = 2019
GROUP BY
    country;





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS 
				List_of_Unique_Genres
FROM genre;


-- Movies belong to 13 genres in imdb dataset.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:



SELECT g.genre, COUNT(g.genre) AS number_of_movies
FROM movie AS m
INNER JOIN
genre AS g
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY number_of_movies DESC
LIMIT 1;

-- 4265 Drama movies were produced in total and Drama movies having the highest among all genres. 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


WITH movies_with_only_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_with_one_genre
FROM   movies_with_only_one_genre; 

-- 3289 movies belong to only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/



-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:



SELECT *
FROM movie;


SELECT g.genre,
		ROUND(AVG(m.duration)) AS avg_duration
FROM movie as m
INNER JOIN 
GENRE AS g
ON m.id = g.movie_id
GROUP BY g.genre;





/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rankings AS(
					SELECT g.genre, 
							COUNT(g.genre) as movie_count,
                            RANK() OVER(ORDER BY COUNT(g.genre) DESC) AS genre_rank
					FROM genre g
					GROUP BY g.genre)
                            
                    
SELECT * 
FROM genre_rankings
WHERE genre = "Thriller";

-- Thriller genre has ranked 3 among all genres and movie count of 1484



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

-- Using Min and Max function
SELECT MIN(avg_rating) AS min_avg_rating,
		MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
 FROM ratings;
 
        




/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT 	m.title,
		r.avg_rating,
        RANK() OVER(ORDER BY r.avg_rating DESC) as movie_rank
FROM movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
LIMIT 10;

/* KIRKET AND LOVE IN KILNERRY ARE TOP MOST RANKED MOVIES.
   SHIBU MOVIE RANKED 10TH ACCORDING TO RANK() FUNCTION
 */
 





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT  median_rating,
		COUNT(median_rating) as movie_count	
FROM ratings
GROUP BY median_rating
ORDER BY median_rating ASC;
        

-- Movies with a median rating of 1 is lowest in number.

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_company_with_most_hit
     AS(
SELECT m.production_company,
		COUNT(m.production_company) as movie_count,
        RANK() OVER(ORDER BY COUNT(m.production_company) DESC) as prod_company_rank
FROM movie as m
INNER JOIN Ratings as r
ON m.id = r.movie_id
WHERE r.avg_rating>8
GROUP BY m.production_company
)

SELECT *
FROM production_company_with_most_hit
WHERE prod_company_rank = 1;




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT  DISTINCT g.genre,
		COUNT(r.movie_id) as movie_count
FROM genre g
		INNER JOIN ratings AS r 
			Using (movie_id)
		INNER JOIN movie AS m
			ON m.id = r.movie_id
WHERE
	r.total_votes>1000
	AND m.year = 2017
	AND MONTH(m.date_published) = 3
	AND m.country like "%USA%"
GROUP BY 
	g.genre
ORDER BY 
	movie_count DESC;


-- 24 Drama movies were released during March 2017 in the USA having more than 1,000 votes


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



SELECT  UPPER(M.title),
		R.avg_rating,
		G.genre
FROM
		movie AS M
		INNER JOIN ratings AS R
			ON m.id = r.movie_id
		INNER JOIN genre AS G
			ON m.id = G.movie_id
WHERE title LIKE "THE%"
       AND R.avg_rating> 8
ORDER BY R.avg_rating DESC;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:



SELECT median_rating, Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
			ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;


-- 361 movies are accounted under median_rating = 8

		


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


With country_wise_votes As(
SELECT country, sum(total_votes) as total_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country
)

Select *
FROM 
	country_wise_votes
ORDER BY total_votes DESC
LIMIT 1;

-- BY removing limit by observation also it is clear that German has more votes than Italian
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;
 
-- Height_nulls having maximum null values


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


WITH top_three_genres AS
(SELECT genre,
		Count(m.id) AS movie_count ,
		Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
FROM movie AS m
		INNER JOIN genre AS g
           ON g.movie_id = m.id
		INNER JOIN ratings AS r
           ON r.movie_id = m.id
WHERE avg_rating > 8
GROUP BY genre
limit 3 )

SELECT n.NAME AS director_name ,
		Count(d.movie_id) AS movie_count
FROM director_mapping  AS d
		INNER JOIN genre G
				USING (movie_id)
		INNER JOIN names AS n
			ON n.id = d.name_id
		INNER JOIN top_three_genres
				USING (genre)
		INNER JOIN ratings
				USING (movie_id)
WHERE avg_rating > 8
GROUP BY n.name
ORDER BY movie_count DESC 
limit 3 ;

            
            
/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT N.name  AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
Limit 2; 
  

-- Mammoothy has movie_count of 8 and Mohanlal has movie count of 5 both having median_rating > 8.



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT m.production_company,
		SUM(r.total_votes) as vote_count,
        RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_rank
FROM movie as m
		INNER JOIN ratings as r
			ON M.id =  R.movie_id
GROUP BY production_company
limit 3;


-- Marvel Studios, Twentieth Century Fox and Warner Bros are the top 3 ranked production houses based on the number of votes received by their movies.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH INDIAN_ACTOR_RANKINGS AS (
SELECT N.name as Actor_name,
				Sum(R.total_votes) as total_votes,
                COUNT(rm.movie_id) as movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actor_avg_rating
FROM movie as m
		INNER JOIN ratings as R
				ON R.movie_id = M.id
		INNER JOIN role_mapping as RM
				ON M.ID  = RM.movie_id
		INNER JOIN names as n
				ON Rm.name_id = n.id
WHERE  rm.category = "Actor" and m.country ="india"
GROUP BY N.name
HAVING movie_count>=5
)

SELECT *,
		RANK()OVER(ORDER BY (actor_avg_rating) DESC) AS Actor_rank
FROM INDIAN_ACTOR_RANKINGS
Limit 10;




-- Vijay sethupathi having total votes = 23114

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH INDIAN_ACTRESS_RANKINGS AS (
SELECT N.name as Actress_name,
				Sum(R.total_votes) as total_votes,
                COUNT(rm.movie_id) as movie_count,
                Round(Sum(r.avg_rating * r.total_votes) / Sum(r.total_votes), 2) AS actress_avg_rating
FROM movie as m
		INNER JOIN ratings as R
				ON R.movie_id = M.id
		INNER JOIN role_mapping as RM
				ON M.ID  = RM.movie_id
		INNER JOIN names as n
				ON Rm.name_id = n.id
WHERE  rm.category = "Actress" and m.languages = "hindi" and  m.country ="india"
GROUP BY N.name
HAVING movie_count>=3
)

SELECT *,
		RANK()OVER(ORDER BY (actress_avg_rating) DESC) AS Actress_rank
FROM INDIAN_ACTRESS_RANKINGS
Limit 3;



-- All top 3 having movie_count = 3 
/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH GENRE_AVG_RATING AS(
SELECT  M.title,
		G.genre,
		R.avg_rating
FROM genre as G
		INNER JOIN movie as M
			ON G.movie_id = M.id
		INNER JOIN ratings as R 
			ON M.id = R.movie_id
WHERE G.genre = "Thriller"
ORDER BY R.avg_rating DESC)

SELECT *,
		CASE
        WHEN avg_rating > 8 THEN "SUPERHIT MOVIES"
        WHEN avg_rating BETWEEN 7 AND 8 THEN "HIT MOVIES"
		WHEN avg_rating BETWEEN 5 AND 7 THEN "ONE TIME WATCH MOVIES"
		ELSE "FLOP" END AS AVG_RATING_CATEGORY
FROM
GENRE_AVG_RATING;




/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
	ROUND(AVG(duration)) AS avg_duration,
	SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
	ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH TOP_3_GENRES AS(
SELECT  g.genre,
		COUNT(movie_id) as movie_count
FROM genre as g
GROUP BY g.genre
ORDER BY movie_count DESC
limit 3
),
TOP_5 AS (
		SELECT  genre,
				year,
                title as movie_name,
                worlwide_gross_income,
                DENSE_RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
		FROM movie as m
			INNER JOIN genre as g
				ON m.id = g.movie_id
		WHERE genre IN (SELECT genre 
						FROM TOP_3_GENRES)
		)

SELECT *
FROM top_5
WHERE movie_rank <=5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.production_company,
		COUNT(m.id) as movie_count,
        RANK() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie as m 
		INNER JOIN ratings as r
			ON m.id = r.movie_id
WHERE r.median_rating >= 8 AND production_company IS NOT NULL AND position(',' IN languages)>0
GROUP BY m.production_company
ORDER BY COUNT(m.id) DESC
Limit 2;


-- Star Cinema and Twentieth Century Fox are 2 top production company having the highest number of hits (median rating >= 8) among multilingual movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT N.name as  actress_name,
				SUM(total_votes) as total_votes,
                COUNT(RM.movie_id) as movie_count,
                avg_rating as actress_avg_rating,
                DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS Actress_rank
FROM names as N
		INNER JOIN role_mapping as RM
			ON N.id = RM.movie_id
		INNER JOIN ratings as R
			ON R.movie_id = RM.movie_id
		INNER JOIN genre as G
			ON R.movie_id = G.movie_id
WHERE category = "actress" AND R.avg_rating>8 AND genre = "Drama"
GROUP BY N.name
LIMIT 3;



WITH actress_summary AS
(
SELECT n.NAME AS actress_name,
			SUM(total_votes) AS total_votes,
			Count(r.movie_id) AS movie_count,
			Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
FROM movie AS m
           INNER JOIN ratings AS r
				ON m.id=r.movie_id
           INNER JOIN role_mapping AS rm
				ON m.id = rm.movie_id
           INNER JOIN names AS n
				ON rm.name_id = n.id
           INNER JOIN GENRE AS g
				ON g.movie_id = m.id
	WHERE category = 'ACTRESS' AND avg_rating>8 AND genre = "Drama"
	GROUP BY N.NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary LIMIT 3;





/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH movie_date_info AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),

date_difference AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_difference
	 GROUP BY name_id
 ),
 
 final_results AS
 (
	 SELECT d.name_id AS director_id,
		 name AS director_name,
		 COUNT(d.movie_id) AS number_of_movies,
		 ROUND(avg_inter_movie_days) AS inter_movie_days,
		 ROUND(AVG(avg_rating),2) AS avg_rating,
		 SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
		 MAX(avg_rating) AS max_rating,
		 SUM(duration) AS total_duration,
		 ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_row_rank
	 FROM
		 names AS n 
         JOIN director_mapping AS d 
         ON n.id=d.name_id
		 JOIN ratings AS r 
         ON d.movie_id=r.movie_id
		 JOIN movie AS m 
         ON m.id=r.movie_id
		 JOIN avg_inter_days AS a 
         ON a.name_id=d.name_id
	 GROUP BY director_id
 )
 SELECT *	
 FROM final_results
 LIMIT 9;


-- Director Andrew jones having maximum 5 number of movies but avg_rating is comparatively lesser than others
