-- Netflix Project
CREATE TABLE Netflix(show_id VARCHAR(8),
                     type	VARCHAR(10),
                     title 	VARCHAR(150),
                     director	VARCHAR(208),
                     casts VARCHAR(1000),
                     country VARCHAR(150),
                     date_added	VARCHAR(50),
                     release_year INT,
                     rating VARCHAR(10),	
                     duration VARCHAR(15),	
                     listed_in VARCHAR(100),
                     description VARCHAR(250));
SELECT * FROM Netflix;
SELECT COUNT(*) as total_content FROM Netflix;  

SELECT DISTINCT type FROM Netflix;

15 Business Problems
Q1) Count the number of movies vs TV Shows
SELECT type, COUNT(*) as tota_content FROM Netflix GROUP BY type

Q2)Find the most common rating for movies and TV shows
SELECT 
      type,
	  rating
FROM 
(	  
   SELECT
     	 type,
	 	 rating,
	 	 COUNT(*),
	 	 RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM Netflix
	GROUP BY 1, 2
) as t1
WHERE
     ranking = 1

Q3) list all the movies releasedin aspecific year (e.g.,2020)
-- filter 2020
-- movies
 SELECT * FROM Netflix
 WHERE 
		TYPE = 'Movie'
        AND
        release_year = 2020
			
Q4)Find the top 5 countries with the most content on netflix
SELECT 
	  UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	  COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5
 

Q5)Identify the longest movie.
SELECT * FROM Netflix
WHERE
	type = 'Movie'
    AND
    duration = (SELECT MAX(duration) FROM Netflix)

Q6) Find the content added in the last five years.
SELECT 
     *
FROM Netflix
WHERE
     TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

Q7)Find all the movies/TV shows by director 'Rajiv Chilka'.
SELECT * FROM Netflix 
WHERE
     director LIKE '%Rajiv Chilaka%'

Q8) List all the TV shows with more than 5 seasons.
SELECT 
	  *
FROM Netflix
WHERE 
      type = 'TV Show'
	  AND
	  SPLIT_PART(duration, ' ', 1)::numeric > 5 
	  
Q9)Count the number of content item in each genre.
SELECT 
      	 UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
         COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1

 Q10)Find each year and the average number of content elease by india on Netflix.
return top 5 year with highest avg content release !
SELECT
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*) as yearly_content,
	  ROUND(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India')::numeric * 100 
	  ,2)as avg_content_per_year  
FROM Netflix
WHERE country = 'India'
GROUP BY 1

Q11)List the all movies thet are documentaries
SELECT * FROM Netflix
WHERE
     listed_in ILIKE '%documentaries%'

Q12] Find all content without a director
SELECT * FROM Netflix
WHERE 
     director IS NULL

Q13] Find how many movie actor 'salman khan' appered in last 10 years.
SELECT * FROM Netflix
WHERE 
     casts ILIKE '%Salman khan%'
	 AND 
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

Q14] Find the top10 actors in the highest number of movies produced in India.
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
COUNT(*) as total_content
FROM Netflix
WHERE country ILIKE '%india%'
GROUP BY 1 
LIMIT 10
ORDER BY 2 DESC

Q15]Categories the content based on the presences of keyword 'kill'and 'violence' in 
the description field. Lebel the content containing these keyword as 'Bad'
and all other content as ' Good'.count how many items all into each category.

WITH new_table
AS 
(
SELECT 
*, 
   CASE 
   WHEN description ILIKE '%kill%' OR
        description ILIKE '%violence%' THEN 'Bad_content'
		ELSE 'Good_content'
	END category
FROM Netflix
)
SELECT 
       category,
	   COUNT(*) as total_content
FROM new_table
GROUP BY 1