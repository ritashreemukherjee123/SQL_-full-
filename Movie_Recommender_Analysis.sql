CREATE TABLE movies (
  movie_id INT PRIMARY KEY,
  title VARCHAR(255),
  genres VARCHAR(255)
);

CREATE TABLE users (
  user_id INT PRIMARY KEY,
  gender CHAR(1),
  age INT,
  occupation VARCHAR(100),
  zip_code VARCHAR(20)
);

#Enable local in file support
SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE "secure_file_priv";


# Upload the dataset movies
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/movie_fixed_int.csv'
INTO TABLE movies
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(movie_id, title, genres);


#Analytics with movies.csv dataset
#Get all movies from a specific genre (e.g., Comedy)
SELECT *
FROM movies
WHERE genres LIKE '%Comedy%';

#List distinct genres available
SELECT DISTINCT SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', n.n), '|', -1) AS genre
FROM movies
JOIN (
    SELECT a.N + b.N * 10 + 1 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) b
    ORDER BY n
) n ON n.n <= 1 + LENGTH(genres) - LENGTH(REPLACE(genres, '|', ''))
GROUP BY genre
ORDER BY genre;

#Genre Frequency Analysis (Multi-label Normalization)
WITH RECURSIVE seq AS (
  SELECT 1 AS n
  UNION ALL
  SELECT n + 1 FROM seq WHERE n < 5
),
normalized_genres AS (
  SELECT
    movie_id,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(genres, '|', n), '|', -1)) AS genre
  FROM movies
  JOIN seq ON n <= 1 + LENGTH(genres) - LENGTH(REPLACE(genres, '|', ''))
)
SELECT genre, COUNT(*) AS num_movies
FROM normalized_genres
GROUP BY genre
ORDER BY num_movies DESC;

#Find Movies Belonging to the Most Popular Genre(s)
-- Replace 'Drama' with genre found above
SELECT *
FROM movies
WHERE genres LIKE '%Drama%';

#Count of Movies per Decade
SELECT
  CASE
    WHEN SUBSTRING(title, -5, 1) = '(' AND RIGHT(title, 1) = ')' THEN
      FLOOR(SUBSTRING(title, -5, 4) / 10) * 10
    ELSE NULL
  END AS decade,
  COUNT(*) AS num_movies
FROM movies
GROUP BY decade
ORDER BY decade;

#Identifying duplicate movie titles(remakes or sequels)
SELECT title, COUNT(*) as count
FROM movies
GROUP BY title
HAVING COUNT(*) > 1;

#Data Quality Analysis – Movies with Missing or Unknown Genre
SELECT *
FROM movies
WHERE genres = '(no genres listed)' OR genres IS NULL;

















