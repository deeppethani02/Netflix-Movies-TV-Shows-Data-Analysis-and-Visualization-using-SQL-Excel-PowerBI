
CREATE TABLE public.netflix (
    show_id VARCHAR PRIMARY KEY,       
    type VARCHAR,                       
    title VARCHAR,                      
    director VARCHAR,                  
    "cast" TEXT,                        
    country VARCHAR,                    
    date_added DATE,                   
    release_year INTEGER,               
    rating VARCHAR,                    
    duration VARCHAR,                   
    listed_in VARCHAR,                  
    description TEXT                   
);

-- Q1: Count the Number of Movies Vs TV Shows
-- drop table netflix
select * from netflix;

SELECT type, count(*)
from netflix
GROUP BY type;

-- Q2: Find the most common rating for Movies and Tv shows

WITH temp AS(SELECT type,rating,
DENSE_RANK() OVER(PARTITION BY type ORDER BY count(*) DESC) AS rk
FROM netflix
GROUP BY type,rating)
SELECT type,rating
FROM temp 
WHERE rk=1;

-- Q3: List all the Movies released in a specific year(2020):
SELECT title 
from netflix 
WHERE type = 'Movie' AND release_year = 2020

-- Q4: Find the top 5 countries with the most content on Netflix
SELECT country, count(show_id) as total_content
FROM netflix 
GROUP BY country
ORDER BY total_content DESC LIMIT 5

-- Q5: Identify the longest movie or TV show duration
SELECT * from netflix


SELECT title, type, duration
FROM netflix 
WHERE type = 'Movie' AND 
duration = (SELECT MAX(duration) FROM netflix)

-- Q6: Find content added in the Last 5 years

SELECT * FROM (SELECT *, 
TO_DATE(date_added, 'Month DD, YYYY') AS date 
FROM netflix
) AS temp
WHERE date >= CURRENT_DATE - INTERVAL '5 years';


-- Q7: Find all the movies/TV shows by director 'Rajiv Chilaka'

SELECT * from netflix;

SELECT title, director
FROM netflix 
WHERE director = 'Rajiv Chilaka';

-- Q8: List all Tv shows with more than 5 seasons
SELECT title, duration, type
FROM netflix
WHERE duration ILIKE '%Season%' AND type = 'TV Show'
AND CAST(split_part(duration, ' ', 1) AS integer) > 5;

-- Q9: COUNT THE NUM OF CONTANT ITEMS IN EACH GENRE
select genre,count(genre) from 
(SELECT split_part(listed_in, ',', 1) AS genre
FROM netflix) as temp
GROUP BY genre;

-- 10. Top 10 years of content release in India on netflix.

Select  release_year, count(*) as total_content
FROM netflix
WHERE country = 'India'
GROUP BY release_year
ORDER BY total_content DESC LIMIT 10;

-- Q10: Find each year and avg number of content released by India on netflix, 
-- return top 5 year with highest content release

SELECT
extract(YEAR FROM date_added) AS year_value,
(100 * (SELECT count(*) FROM netflix WHERE country = 'India') 
/ (count(*))) AS avg_ind
FROM netflix
WHERE country = 'India'
GROUP BY year_value
ORDER BY avg_ind DESC LIMIT 5;

-- Q10 : list all movie that are documentries
select * from netflix
SELECT title, listed_in
FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- Q11: Find all content without a director

SELECT * FROM netflix
WHERE director IS null

-- Q12 Find how many movies actor 'Salman Khan' appeared in last 10 years
SELECT title, type
FROM netflix
WHERE type = 'Movie' 
AND cast like '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

- Q13: Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT 
split_part(cast,',',1) AS actors,
COUNT(*) as total_content
FROM netflix
WHERE type LIKE 'Movies' AND country LIKE 'India'
GROUP BY actors
ORDER BY total_content DESC LIMIT 10

-- Q14: Categorize the content based on the presence of the keywords 'Kill' and 'violence' in the description field. Label content containing 
-- these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category

SELECT Category, count(*) as total_content
FROM (SELECT 
CASE WHEN description LIKE 'Kill' OR description LIKE 'Violence' THEN 'Bad'
ELSE 'Good' END Category
FROM netflix) AS temp
GROUP BY a




