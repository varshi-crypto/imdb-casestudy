USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Number of rows = 3867
SELECT COUNT(*) FROM DIRECTOR_MAPPING;

-- Number of rows = 14662
SELECT COUNT(*) FROM GENRE ;

-- Number of rows = 7997
SELECT COUNT(*) FROM  MOVIE;

-- Number of rows = 25735
SELECT COUNT(*) FROM  NAMES;

-- Number of rows = 7997
SELECT COUNT(*) FROM  RATINGS;

-- Number of rows = 15615
SELECT COUNT(*) FROM  ROLE_MAPPING;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Query to count the number of nulls in each column using case statements
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 
-- Country, worlwide_gross_income, languages and production_company columns have NULL values


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

-- Number of movies released each year
SELECT year,
       Count(title) AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY year;

-- Number of movies released each month 
SELECT Month(date_published) AS MONTH_NUM,
       Count(*)              AS NUMBER_OF_MOVIES
FROM   movie
GROUP  BY month_num
ORDER  BY month_num; 

-- Highest number of movies were released in 2017


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Pattern matching using LIKE operator for country column
SELECT Count(DISTINCT id) AS number_of_movies, year
FROM   movie
WHERE  ( country LIKE '%INDIA%'
          OR country LIKE '%USA%' )
       AND year = 2019; 

-- 1059 movies were produced in the USA or India in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Finding unique genres using DISTINCT keyword
SELECT DISTINCT genre
FROM   genre; 

-- Movies belong to 13 genres in the dataset.

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Using LIMIT clause to display only the genre with highest number of movies produced
SELECT     genre,
           Count(m.id) AS number_of_movies
FROM       movie       AS m
INNER JOIN genre       AS g
where      g.movie_id = m.id
GROUP BY   genre
ORDER BY   number_of_movies DESC limit 1 ;

-- 4265 Drama movies were produced in total and are the highest among all genres. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Using genre table to find movies which belong to only one genre
-- Grouping rows based on movie id and finding the distinct number of genre each movie belongs to
-- Using the result of CTE, we find the count of movies which belong to only one genre
SELECT COUNT(*) AS movies_with_one_genre
FROM (
    SELECT movie_id
    FROM genre
    GROUP BY movie_id
    HAVING COUNT(DISTINCT genre) = 1
) AS movies_with_one_genre;

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

-- Finding the average duration of movies by grouping the genres that movies belong to 
SELECT     genre,
           Round(Avg(duration),2) AS avg_duration
FROM       movie                  AS m
INNER JOIN genre                  AS g
ON      g.movie_id = m.id
GROUP BY   genre
ORDER BY avg_duration DESC;

-- Action genre has the highest duration of 112.88 seconds followed by romance and crime genres.

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

-- CTE : Finds the rank of each genre based on the number of movies in each genre
-- Select query displays the genre rank and the number of movies belonging to Thriller genre
SELECT 
    genre,
    movie_count,
    (SELECT COUNT(*) + 1 
     FROM genre AS g2 
     WHERE g2.genre <> gs.genre 
       AND (SELECT COUNT(movie_id) FROM genre AS g3 WHERE g3.genre = g2.genre) > movie_count) AS genre_rank
FROM (
    SELECT 
        genre,
        COUNT(movie_id) AS movie_count
    FROM 
        genre
    GROUP BY 
        genre
) AS gs
WHERE genre = 'THRILLER';


-- Thriller has rank=3 and movie count of 1484

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

-- Using MIN and MAX functions for the query 
SELECT Min(avg_rating)    AS MIN_AVG_RATING,
       Max(avg_rating)    AS MAX_AVG_RATING,
       Min(total_votes)   AS MIN_TOTAL_VOTES,
       Max(total_votes)   AS MAX_TOTAL_VOTES,
       Min(median_rating) AS MIN_MEDIAN_RATING,
       Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 


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

-- Finding the rank of each movie based on it's average rating
-- Displaying the top 10 movies using LIMIT clause
SELECT 
    m.title,
    r.avg_rating,
    (
        SELECT COUNT(DISTINCT r2.avg_rating) 
        FROM ratings AS r2
        WHERE r2.avg_rating > r.avg_rating
    ) + 1 AS movie_rank
FROM 
    ratings AS r
INNER JOIN 
    movie AS m ON m.id = r.movie_id
ORDER BY 
    r.avg_rating DESC
LIMIT 10;

-- top 10 movies can also be displayed using WHERE caluse with CTE
SELECT
    m.title,
    r.avg_rating,
    (SELECT COUNT(*)
     FROM (
         SELECT AVG(r1.avg_rating) AS avg_rating
         FROM ratings AS r1
         GROUP BY r1.movie_id
     ) AS subquery
     WHERE subquery.avg_rating > r.avg_rating
    ) + 1 AS movie_rank
FROM
    ratings AS r
INNER JOIN
    movie AS m ON m.id = r.movie_id
GROUP BY
    m.title, r.avg_rating
ORDER BY
    r.avg_rating DESC
LIMIT 10;

-- Top 3 movies have average rating >= 9.8


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

-- Finding the number of movies vased on median rating and sorting based on movie count.
SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY movie_count DESC; 


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

-- CTE: Finding the rank of production company based on movie count with average rating > 8 using RANK function.
-- Querying the CTE to find the production company with rank=1
SELECT 
    pc.production_company,
    pc.MOVIE_COUNT,
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT 
                production_company,
                COUNT(movie_id) AS MOVIE_COUNT
            FROM 
                ratings AS R
                INNER JOIN movie AS M ON M.id = R.movie_id
            WHERE 
                avg_rating > 8
                AND production_company IS NOT NULL
            GROUP BY 
                production_company
        ) AS subquery
        WHERE subquery.MOVIE_COUNT > pc.MOVIE_COUNT
    ) AS PROD_COMPANY_RANK
FROM (
    SELECT 
        production_company,
        COUNT(movie_id) AS MOVIE_COUNT
    FROM 
        ratings AS R
        INNER JOIN movie AS M ON M.id = R.movie_id
    WHERE 
        avg_rating > 8
        AND production_company IS NOT NULL
    GROUP BY 
        production_company
) AS pc
WHERE 
    PROD_COMPANY_RANK = 1;


-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

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

-- Query to find 
-- 1. Number of movies released in each genre 
-- 2. During March 2017 
-- 3. In the USA  (LIKE operator is used for pattern matching)
-- 4. Movies had more than 1,000 votes

SELECT genre,
       Count(M.id) AS MOVIE_COUNT
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes


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

-- Query to find:
-- 1. Number of movies of each genre that start with the word ‘The’ (LIKE operator is used for pattern matching)
-- 2. Which have an average rating > 8?
-- Grouping by title to fetch distinct movie titles as movie belog to more than one genre

SELECT  title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN genre AS G
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
GROUP BY title
ORDER BY avg_rating DESC;

-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.
-- All the movies belong to the top 3 genres.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

-- BETWEEN operator is used to find the movies released between 1 April 2018 and 1 April 2019
SELECT median_rating, Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Two approaches - one is search based on language and the other by country column

-- Approach 1: By language column

-- Compute the total number of votes for German and Italian movies.
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%Italian%'
UNION
SELECT languages,
       Sum(total_votes) AS VOTES
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%GERMAN%'
ORDER  BY votes DESC; 

-- Query to check if German votes > Italian votes using SELECT IF statement
-- Answer is YES if German votes > Italian votes
-- Answer is NO if German votes <= Italian votes
SELECT IF(languages = 'GERMAN', 'YES', 'NO') AS ANSWER
FROM (
    SELECT 
        languages,
        SUM(total_votes) AS VOTES
    FROM 
        MOVIE AS M
        INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID
    WHERE 
        languages LIKE '%Italian%'
    GROUP BY 
        languages
    
    UNION ALL
    
    SELECT 
        languages,
        SUM(total_votes) AS VOTES
    FROM 
        MOVIE AS M
        INNER JOIN RATINGS AS R ON R.MOVIE_ID = M.ID
    WHERE 
        languages LIKE '%GERMAN%'
    GROUP BY 
        languages
) AS VOTES_SUMMARY
ORDER BY 
    VOTES DESC
LIMIT 1;



-- Approach 2: By country column
SELECT country, sum(total_votes) as total_votes
FROM movie AS m
	INNER JOIN ratings as r ON m.id=r.movie_id
WHERE country = 'Germany' or country = 'Italy'
GROUP BY country;

-- By observation, German movies received the highest number of votes when queried against language and country columns.

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

-- NULL counts for individual columns of names table
SELECT Count(*) AS name_nulls
FROM   names
WHERE  NAME IS NULL;

SELECT Count(*) AS height_nulls
FROM   names
WHERE  height IS NULL;

SELECT Count(*) AS date_of_birth_nulls
FROM   names
WHERE  date_of_birth IS NULL;

SELECT Count(*) AS known_for_movies_nulls
FROM   names
WHERE  known_for_movies IS NULL; 


-- NULL counts for columns of names table using CASE statements
SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
		
FROM names;

-- Height, date_of_birth, known_for_movies columns contain NULLS

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

-- CTE: Computes the top 3 genres using average rating > 8 condition and highest movie counts
-- Using the top genres derived from the CTE, the directors are found whose movies have an average rating > 8 and are sorted based on number of movies made.  
SELECT
    n.NAME AS director_name,
    COUNT(d.movie_id) AS movie_count
FROM
    director_mapping AS d
INNER JOIN
    names AS n ON n.id = d.name_id
INNER JOIN (
    SELECT
        g.genre,
        COUNT(m.id) AS movie_count
    FROM
        movie AS m
    INNER JOIN
        genre AS g ON g.movie_id = m.id
    INNER JOIN
        ratings AS r ON r.movie_id = m.id
    WHERE
        r.avg_rating > 8
    GROUP BY
        g.genre
    ORDER BY
        movie_count DESC
    LIMIT 3
) AS top_genres ON g.genre = top_genres.genre
INNER JOIN
    ratings AS r ON r.movie_id = d.movie_id
WHERE
    r.avg_rating > 8
GROUP BY
    n.NAME
ORDER BY
    movie_count DESC
LIMIT 3;


-- James Mangold , Joe Russo and Anthony Russo are top three directors in the top three genres whose movies have an average rating > 8


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


SELECT N.name          AS actor_name,
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
LIMIT  2; 
        
-- Top 2 actors are Mammootty and Mohanlal.

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

-- Approach 1: Using select statement 
SELECT
    production_company,
    vote_count,
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT
                production_company,
                SUM(total_votes) AS vote_count
            FROM
                movie AS m
            INNER JOIN
                ratings AS r ON r.movie_id = m.id
            GROUP BY
                production_company
        ) AS subquery
        WHERE subquery.vote_count > pc.vote_count
    ) AS prod_comp_rank
FROM (
    SELECT
        production_company,
        SUM(total_votes) AS vote_count
    FROM
        movie AS m
    INNER JOIN
        ratings AS r ON r.movie_id = m.id
    GROUP BY
        production_company
    ORDER BY
        vote_count DESC
    LIMIT 3
) AS pc;


-- Approach 2: using CTEs
SELECT 
    production_company,
    vote_count,
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT 
                production_company,
                SUM(total_votes) AS vote_count
            FROM 
                movie AS m
            INNER JOIN 
                ratings AS r ON r.movie_id = m.id
            GROUP BY 
                production_company
        ) AS subquery
        WHERE subquery.vote_count > SUM(r.total_votes)
    ) AS prod_comp_rank
FROM 
    movie AS m
INNER JOIN 
    ratings AS r ON r.movie_id = m.id
GROUP BY 
    production_company
ORDER BY 
    prod_comp_rank DESC
LIMIT 3;


-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.


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

SELECT 
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating
FROM (
    SELECT 
        N.name AS actor_name,
        SUM(R.total_votes) AS total_votes,
        COUNT(R.movie_id) AS movie_count,
        ROUND(SUM(R.avg_rating * R.total_votes) / SUM(R.total_votes), 2) AS actor_avg_rating
    FROM 
        movie M
        INNER JOIN ratings R ON M.id = R.movie_id
        INNER JOIN role_mapping RM ON M.id = RM.movie_id
        INNER JOIN names N ON RM.name_id = N.id
    WHERE 
        RM.category = 'ACTOR'
        AND M.country = 'India'
    GROUP BY 
        N.name
    HAVING 
        COUNT(R.movie_id) >= 5
) AS actor_summary
ORDER BY 
    actor_avg_rating DESC;


-- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu.


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

SELECT 
    actress_name,
    total_votes,
    movie_count,
    actress_avg_rating
FROM (
    SELECT 
        n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(r.movie_id) AS movie_count,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating
    FROM 
        movie m
        INNER JOIN ratings r ON m.id = r.movie_id
        INNER JOIN role_mapping rm ON m.id = rm.movie_id
        INNER JOIN names n ON rm.name_id = n.id
    WHERE 
        rm.category = 'ACTRESS'
        AND m.country = 'India'
        AND m.languages LIKE '%HINDI%'
    GROUP BY 
        n.name
    HAVING 
        COUNT(r.movie_id) >= 3
) AS actress_summary
ORDER BY 
    actress_avg_rating DESC
LIMIT 5;


-- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using CASE statements to classify thriller movies as per avg rating 
SELECT 
    title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS avg_rating_category
FROM (
    SELECT DISTINCT 
        M.title,
        R.avg_rating
    FROM 
        movie AS M
        INNER JOIN ratings AS R ON R.movie_id = M.id
        INNER JOIN genre AS G ON G.movie_id = M.id
    WHERE 
        G.genre LIKE 'THRILLER'
) AS thriller_movies;




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

SET @running_total = 0;
SET @row_number = 0;
SET @sum_avg_duration = 0;

SELECT
    g.genre,
    ROUND(AVG(m.duration), 2) AS avg_duration,
    @running_total := @running_total + ROUND(AVG(m.duration), 2) AS running_total_duration,
    ROUND((@sum_avg_duration := @sum_avg_duration + ROUND(AVG(m.duration), 2)) / (@row_number := @row_number + 1), 2) AS moving_avg_duration
FROM
    movie AS m
INNER JOIN
    genre AS g ON m.id = g.movie_id
GROUP BY
    g.genre
ORDER BY
    g.genre;


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

-- Step 1: Create a temporary table to identify the top three genres by the number of movies.

CREATE TEMPORARY TABLE top_three_genre AS
SELECT
    g.genre,
    COUNT(m.id) AS movie_count
FROM
    movie m
INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY
    g.genre
ORDER BY
    movie_count DESC
LIMIT 3;

-- Step 2: Create a second temporary table to store the top five movies from each of the top three genres for each year based on worldwide gross income.
-- Step 1: Create a temporary table to identify the top three genres by the number of movies.
-- Step 1: Identify the top three genres by the number of movies.

CREATE TEMPORARY TABLE top_three_genres AS
SELECT
    g.genre,
    COUNT(m.id) AS movie_count
FROM
    movie m
INNER JOIN
    genre g ON g.movie_id = m.id
GROUP BY
    g.genre
ORDER BY
    movie_count DESC
LIMIT 3;

-- Step 2: Filter movies by these top genres and calculate worldwide gross income.
CREATE TEMPORARY TABLE movie_income AS
SELECT
    m.id,
    g.genre,
    m.year,
    m.title,
    CAST(REPLACE(REPLACE(IFNULL(m.worlwide_gross_income, '0'), 'INR', ''), '$', '') AS DECIMAL(10, 2)) AS worlwide_gross_income
FROM
    movie m
INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    g.genre IN (SELECT genre FROM top_three_genres);

-- Step 3: Select and rank the top 5 movies per genre and year.
CREATE TEMPORARY TABLE ranked_movies AS
SELECT
    mi.genre,
    mi.year,
    mi.title,
    mi.worlwide_gross_income,
    (SELECT COUNT(*)
     FROM movie_income mi2
     WHERE mi2.genre = mi.genre
       AND mi2.year = mi.year
       AND mi2.worlwide_gross_income > mi.worlwide_gross_income
    ) + 1 AS movie_rank
FROM
    movie_income mi;

-- Step 4: Retrieve the top 5 movies per genre and year.
SELECT
    genre,
    year,
    title,
    worlwide_gross_income,
    movie_rank
FROM
    ranked_movies
WHERE
    movie_rank <= 5
ORDER BY
    genre, year, movie_rank;

-- Cleanup: Drop temporary tables
DROP TEMPORARY TABLE top_three_genres;
DROP TEMPORARY TABLE movie_income;
DROP TEMPORARY TABLE ranked_movies;



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

-- Step 1: Create a temporary table to count high-rated multilingual movies for each production house

CREATE TEMPORARY TABLE production_house_counts AS
SELECT
    m.production_company,
    COUNT(*) AS movie_count
FROM
    movie m
INNER JOIN
    ratings r ON m.id = r.movie_id
WHERE
    r.median_rating >= 8
    AND POSITION(',' IN m.languages) > 0 -- Movies with multiple languages
    AND m.production_company IS NOT NULL
GROUP BY
    m.production_company;

-- Step 2: Create a temporary table to rank production houses by the movie count

CREATE TEMPORARY TABLE ranked_production_houses AS
SELECT
    production_company,
    movie_count,
    (
        SELECT COUNT(*)
        FROM production_house_counts p2
        WHERE p2.movie_count > p1.movie_count
    ) + 1 AS prod_comp_rank
FROM
    production_house_counts p1;

-- Step 3: Select the top 2 production houses

SELECT
    production_company,
    movie_count,
    prod_comp_rank
FROM
    ranked_production_houses
WHERE
    prod_comp_rank <= 2
ORDER BY
    prod_comp_rank;

-- Cleanup: Drop temporary tables

DROP TEMPORARY TABLE production_house_counts;
DROP TEMPORARY TABLE ranked_production_houses;


-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among multilingual movies.


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

-- Top 3 actresses based on number of Super Hit movies
-- Top 3 actresses in the drama genre with Super Hit movies

-- Step 1: Create a temporary table to count movies per actress in the drama genre

CREATE TEMPORARY TABLE actress_movie_counts AS
SELECT
    n.name AS actress_name,
    COUNT(m.id) AS movie_count,
    SUM(r.total_votes) AS total_votes,
    AVG(r.avg_rating) AS actress_Avg_rating
FROM
    names n
INNER JOIN
    role_mapping rm ON n.id = rm.name_id
INNER JOIN
    movie m ON m.id = rm.movie_id
INNER JOIN
    ratings r ON r.movie_id = m.id
INNER JOIN
    genre g ON g.movie_id = m.id
WHERE
    r.avg_rating > 8
    AND g.genre = 'drama'
    AND rm.category = 'actress'
GROUP BY
    n.name;

-- Step 2: Create a temporary table to rank actresses by the number of movies

CREATE TEMPORARY TABLE ranked_actresses AS
SELECT
    actress_name,
    movie_count,
    total_votes,
    actress_Avg_rating,
    (
        SELECT COUNT(*)
        FROM actress_movie_counts a2
        WHERE a2.movie_count > a1.movie_count
    ) + 1 AS actress_rank
FROM
    actress_movie_counts a1;

-- Step 3: Select the top 3 actresses
SELECT
    actress_name,
    movie_count,
    total_votes,
    actress_Avg_rating
FROM
    ranked_actresses
WHERE
    actress_rank <= 3
ORDER BY
    movie_count DESC;

-- Cleanup: Drop temporary tables

DROP TEMPORARY TABLE actress_movie_counts;
DROP TEMPORARY TABLE ranked_actresses;

-- Top 3 actresses based on number of Super Hit movies are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence


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

-- First, create a view to calculate the average difference between two movie dates

-- Step 1: Calculate the average difference between two movie dates for each director

-- Step 1: Calculate the average difference between movie dates for each director
-- Use a self-join to find the next movie date for each movie

-- Create a temporary table to store movie dates

CREATE TEMPORARY TABLE movie_dates AS
SELECT
    nm.id AS director_id,
    nm.name AS director_name,
    m.id AS movie_id,
    m.date_published AS movie_date
FROM
    names nm
INNER JOIN
    director_mapping dm ON nm.id = dm.name_id
INNER JOIN
    movie m ON dm.movie_id = m.id;

-- Create a temporary table to calculate the difference between consecutive movie dates

CREATE TEMPORARY TABLE date_differences AS
SELECT
    md1.director_id,
    md1.director_name,
    DATEDIFF(md2.movie_date, md1.movie_date) AS date_diff
FROM
    movie_dates md1
INNER JOIN
    movie_dates md2 ON md1.director_id = md2.director_id
    AND md1.movie_date < md2.movie_date;

-- Calculate the average date difference for each director

CREATE TEMPORARY TABLE avg_diff_between_movie_dates AS
SELECT
    director_id,
    director_name,
    AVG(date_diff) AS avg_inter_movie_days
FROM
    date_differences
GROUP BY
    director_id, director_name;

-- Step 2: Determine the top 9 directors based on the number of movies

CREATE TEMPORARY TABLE top_directors AS
SELECT
    nm.id AS director_id,
    nm.name AS director_name,
    COUNT(DISTINCT dm.movie_id) AS number_of_movies,
    ROUND(AVG(r.avg_rating), 2) AS avg_rating,
    SUM(r.total_votes) AS total_votes,
    MIN(r.avg_rating) AS min_rating,
    MAX(r.avg_rating) AS max_rating,
    SUM(m.duration) AS total_duration,
    (
        SELECT COUNT(*)
        FROM (
            SELECT COUNT(DISTINCT dm2.movie_id) AS movie_count
            FROM names nm2
            INNER JOIN director_mapping dm2 ON nm2.id = dm2.name_id
            INNER JOIN movie m2 ON dm2.movie_id = m2.id
            INNER JOIN ratings r2 ON m2.id = r2.movie_id
            GROUP BY nm2.id
            HAVING COUNT(DISTINCT dm2.movie_id) > td.number_of_movies
        ) ranked_directors
    ) + 1 AS director_rank
FROM
    names nm
INNER JOIN
    director_mapping dm ON nm.id = dm.name_id
INNER JOIN
    movie m ON dm.movie_id = m.id
INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY
    nm.id, nm.name;

-- Step 3: Combine the results with the average inter-movie days

SELECT
    td.director_id,
    td.director_name,
    td.number_of_movies,
    AVGD.avg_inter_movie_days AS avg_inter_movie_days,
    td.avg_rating,
    td.total_votes,
    td.min_rating,
    td.max_rating,
    td.total_duration
FROM
    top_directors td
LEFT JOIN
    avg_diff_between_movie_dates AVGD ON td.director_id = AVGD.director_id
WHERE
    td.director_rank <= 9
ORDER BY
    td.number_of_movies DESC;

-- Cleanup: Drop temporary tables
DROP TEMPORARY TABLE movie_dates;
DROP TEMPORARY TABLE date_differences;
DROP TEMPORARY TABLE avg_diff_between_movie_dates;
DROP TEMPORARY TABLE top_directors;
