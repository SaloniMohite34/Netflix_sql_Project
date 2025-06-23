# Netflix Movies and TV Shows Data Analysis Using SQL
![Netflix Logo](https://github.com/SaloniMohite34/Netflix_sql_Project/blob/main/Netflixlogo.jpg)
 ## Overview
 🎬 Netflix Movies and TV Shows Data Analysis using SQL — Gain insights into Netflix’s global content library using SQL queries. 
 Analyze genres, durations, release trends, ratings, and country distributions with structured data exploration.
The following README file provide a detailed accounts of the projects objective,business problem,solutions,findings, and conclusion.


## Objectives
- Analyze the distribution of content types (eg.,movies and tv shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release year, countries, and durations.
- Explore and cotegorize content based on specific criteria and keywords.
## Dataset
The data for this Project is sourced from the kaggle dataset:
- **Dataset Link:** [Movies dataset]:(https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Schema

```sql
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
```
 ## Business Problem and Solutions

### 1. Count the number of movies vs TV Shows

```sql
SELECT type, COUNT(*) as tota_content FROM Netflix GROUP BY type
```

**Objective**:Determine the distribution of content type on Netflix.

### 2.Find the most common rating for movies and TV shows
```sql
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
```

**Objective**:Identify the most frequently occurring rating for each type of content.

### 3.list all the movies releasedin aspecific year (e.g.,2020)
-- filter 2020
-- movies
```sql
 SELECT * FROM Netflix
 WHERE 
		TYPE = 'Movie'
        AND
        release_year = 2020
```
**Objective**:Retrieves all movies release in specific year.

### 4.Find the top 5 countries with the most content on netflix.
```sql
SELECT 
	  UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	  COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5
```
**Objective**:Identifies the top 5 countries with the highest number of content items'

### 5.Identify the longest movie.
```sql
SELECT * FROM Netflix
WHERE
	type = 'Movie'
    AND
    duration = (SELECT MAX(duration) FROM Netflix)
```

**Objective**: Find the movies with the longest durations.

### 6. Find the content added in the last five years.
```sql
SELECT 
     *
FROM Netflix
WHERE
     TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
```
**Objective**:To filter and display content added to Netflix in the last five years.

### 7.Find all the movies/TV shows by director 'Rajiv Chilka'.
```sql
SELECT * FROM Netflix 
WHERE
     director LIKE '%Rajiv Chilaka%'
```
**Objective**:To find all Movies and TV Shows directed by Rajiv Chilaka.

### 8. List all the TV shows with more than 5 seasons.
```sql
SELECT 
	  *
FROM Netflix
WHERE 
      type = 'TV Show'
	  AND
	  SPLIT_PART(duration, ' ', 1)::numeric > 5
```

**Objective**:To list all TV Shows that have more than 5 seasons.

### 9.Count the number of content item in each genre.
```sql
SELECT 
      	 UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
         COUNT(show_id) as total_content
FROM Netflix
GROUP BY 1
```

**Objective**:To count the number of content items grouped by genre.

 ### 10.Find each year and the average number of content elease by india on Netflix.
### return top 5 year with highest avg content release.
```sql
SELECT
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*) as yearly_content,
	  ROUND(
	  COUNT(*)::numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India')::numeric * 100 
	  ,2)as avg_content_per_year  
FROM Netflix
WHERE country = 'India'
GROUP BY 1
```

**Objective**: To calculate the average yearly content released by India and show the top 5 years.

### 11.List the all movies thet are documentaries.
```sql
SELECT * FROM Netflix
WHERE
     listed_in ILIKE '%documentaries%'
```

**Objective**:To list all Movies on Netflix that fall under the ‘Documentaries’ genre.

### 12. Find all content without a director.
```sql
SELECT * FROM Netflix
WHERE 
     director IS NULL
```

**Objective**:To find all content items that do not have a director mentioned.

### 13. Find how many movie actor 'salman khan' appered in last 10 years.
```sql
SELECT * FROM Netflix
WHERE 
     casts ILIKE '%Salman khan%'
	 AND 
	 release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```

**Objective**:To count how many movies actor Salman Khan has appeared in during the last 10 years.

### 14. Find the top10 actors in the highest number of movies produced in India.
```sql
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
COUNT(*) as total_content
FROM Netflix
WHERE country ILIKE '%india%'
GROUP BY 1 
LIMIT 10
ORDER BY 2 DESC
```

**Objective**: To find the top 10 most featured actors in Indian-produced movies on Netflix

### 15.Categories the content based on the presences of keyword 'kill'and 'violence' in 
### the description field. Lebel the content containing these keyword as 'Bad'
### and all other content as ' Good'.count how many items all into each category.
```sql
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
```

**Objective**:To categorize Netflix content as 'Bad' or 'Good' based on the presence of keywords like ‘kill’ or ‘violence’ in the description and count the number in each category.

## Findings and Conclusions

- Content distribution: The dataset contain a diverse range of movies and TV shows with varying rating and genre.
- Common Ratings: Insights into the most common rating provide an understanding of the content's target audience.
- Geographical Insights : The top countries and the average content release by india highlight regional content distribution.
- Content Categorization : Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provide a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## Author

## Project by **Saloni Jagannath Mohite** 
- 🎓 BSc Data Science Student at Symbiosis Skills and Professional University Pune.
- 💻 Passionate about data analysis, SQL, and data visualization.  
- 📬 Email: mohitesaloni213@gmail.com
- 🔗 [LinkedIn](https://www.linkedin.com/in/saloni-mohite-215950313) 
