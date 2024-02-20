-- Viewing the data from both the datasets
SELECT *
FROM dataset_1 ;

Select *
from dataset_2;

-- Calculating the number of rows in our dataset
SELECT COUNT(*) 
FROM dataset_1;

SELECT COUNT(*)
FROM DATASET_2;

-- Generate data for two states(Jharkhand & Bihaar)
Select *
FROM dataset_1
WHERE State like 'Jharkhand' OR State like 'Bihar';

-- Alternate way of generating data for two states (Jharkhand & Bihar)
Select *
FROM dataset_1
WHERE State in ('Jharkhand','Bihar');

-- Calculate the total population of India
Select sum(population) AS 'Total Population'
From dataset_2;

-- Average growth of population from the previous census
Select AVG(Growth) as 'Total Average Growth'
from dataset_1;

-- Average growth percentage by state
Select State, Avg(growth)
FROM dataset_1
GROUP BY State
ORDER BY 2 desc;

-- Average Sex ratio by state & rounding off the values
Select State, ROUND(Avg(sex_ratio)) AS 'Average Sex ratio'
FROM dataset_1
GROUP BY State
ORDER BY 2 DESC;

-- Average Literacy Rate by putting a condition
Select State, ROUND(Avg(literacy)) AS 'Average Literacy Rate'
FROM dataset_1
GROUP BY State
HAVING ROUND(Avg(literacy)) >90
ORDER BY 2 DESC;

-- Top 3 states having highest growth ratio
Select State, round(avg(growth)) AS Average_Growth
from dataset_1
GROUP BY State
ORDER BY round(avg(growth)) DESC LIMIT 3;

-- Bottom three states showing the lowest sex ratio
SELECT state, ROUND(AVG(sex_ratio)) as Lowest_3_sex_ratio
FROM dataset_1
Group by state
Order by lowest_3_sex_ratio Asc limit 3;

-- Displaying both the top three and the bottom three states by Literacy
DROP TABLE IF EXISTS top_state;
CREATE TEMPORARY TABLE top_state
( state TEXT,
topstates DOUBLE);
Insert into top_state (state, topstates)
SELECT state, round(avg(literacy),0)
FROM dataset_1
group by state
order by round(avg(literacy),0) desc limit 3;

Select * from top_state;

DROP TABLE IF EXISTS bottom_state;
CREATE TEMPORARY TABLE bottom_state
( state TEXT,
bottomstates double);
INSERT INTO bottom_state (state, bottomstates)
select state, round(avg(literacy),0)
from dataset_1
group by state
order by round(avg(literacy),0) asc limit 3;
select * from bottom_state;

-- Combining the two tables using union
select * from (Select * from top_state) a
union
select * from (select * from bottom_state) b;

-- States all data where state name starting with letter a
select *
from dataset_1
where lower(State) like 'a%';

-- Select the distinct name of states starting with A
select distinct state
from dataset_1
where State like 'A%';

-- Select the distinct name of states starting with A or B
select distinct state
from dataset_1
where State like 'A%' OR State like 'B%';

-- selectng state names starting with letter A and ending with letter b
select distinct state
from dataset_1
where State like 'A%m';

-- joining both the tables
Select d1.district, d1.state, sex_ratio, population
from dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district;

-- Creating seperate columns to count the number of males & females
-- Formula Males = population/(sex_ratio + 1)
-- Formula Female = Population - Population(sex_ratio + 1)
Select c.district, c.state, ROUND(c.population/(c.sex_ratio + 1)) AS Males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1)) as females
FROM
(Select d1.district, d1.state, d1.sex_ratio/1000 AS sex_ratio,d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c;

-- Getting seperate columns to count the number of males & females by state
Select d.state, sum(d.males) AS total_males,sum(d.females) AS total_females
FROM
(Select c.district, c.state, ROUND(c.population/(c.sex_ratio + 1)) AS Males, ROUND((c.population*c.sex_ratio)/(c.sex_ratio+1)) as females
FROM
(Select d1.district, d1.state, d1.sex_ratio/1000 AS sex_ratio,d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c) d
GROUP BY d.state;

-- Average literacy rate by state
Select c.state, Round(AVG(c.literacy),2)
FROM
(select d1.district, d1.state, d1.literacy
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c
Group by c.state;

-- Distribution of literate & illiterate population by district
Select c.district,c.state, round(c.population*c.literacy) as literate, round(c.population*(1-c.literacy)) as illeterate
FROM
(select d1.district,d1.state, d1.literacy/100 as literacy, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c;

-- Distribution of literate & illiterate population by state
Select c.state, sum(round(c.population*c.literacy)) as literate, sum(round(c.population*(1-c.literacy))) as illeterate
FROM
(select d1.district,d1.state, d1.literacy/100 as literacy, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c
GROUP BY c.state;

-- Population in the previous census by District
Select c.district, c.state, c.growth, c.population AS current_population, ROUND((c.population*100)/(100+c.growth)) as previous_year_population
FROM
(SELECT d1.district,d1.state, d1.growth as growth, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c ;

-- Population in the previous census by state
Select  c.state, sum(c.population) AS current_population, sum(ROUND((c.population*100)/(100+c.growth))) as previous_year_population
FROM
(SELECT d1.district,d1.state, d1.growth as growth, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c 
Group by c.state;

-- Total population of India previous year & current yeaar
Select sum(e.current_population) AS Total_current_population, sum(e.previous_year_population) as Total_previous_population
FROM
(Select  c.state, sum(c.population) AS current_population, sum(ROUND((c.population*100)/(100+c.growth))) as previous_year_population
FROM
(SELECT d1.district,d1.state, d1.growth as growth, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c 
Group by c.state) e;

-- Population vs area (Population Density= Total population/land area)
Select state, Sum(population)/sum(area_km2) as population_density
FROM dataset_2
group by state;

-- Putting total population previous year, current year and total area in a single table
SELECT q.*, r.total_area
from(
SELECT *,'1' as keyy
FROM
(Select sum(j.current_population) AS Total_current_population, sum(j.previous_year_population) as Total_previous_population
FROM
(Select  c.state, sum(c.population) AS current_population, sum(ROUND((c.population*100)/(100+c.growth))) as previous_year_population
FROM
(SELECT d1.district,d1.state, d1.growth as growth, d2.population
FROM dataset_1 d1
INNER JOIN dataset_2 d2
ON d1.district = d2.district) c 
Group by c.state)j) e)q
INNER JOIn
(select *, '1' as keyy
FROM
(SELECT SUM(area_km2) as total_area
FROM
dataset_2)z)r
on q.keyy = r.keyy;

-- Top three districts from each state that has the highest literacy ratio
Select a.* 
FROM
(Select district, state, literacy,rank() over(partition by state order by literacy desc) as rnk
FROM dataset_1) a
WHERE a.rnk in(1,2,3) order by state