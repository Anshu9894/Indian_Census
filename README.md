![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/8963ad00-e447-49a8-8079-f6a8538de262)
## Viewing the data from both the datasets
```
SELECT *
FROM dataset_area_population ;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/17793bb9-1681-4d52-8f9c-59fce3d08020)
```
Select *
from dataset_sex_ratio;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/bf375398-d4c9-4e41-a0bf-9bc9899d7a95)

## Calculating the number of rows in our dataset
```
SELECT COUNT(*) 
FROM dataset_area_population;
```

```
SELECT COUNT(*)
FROM dataset_sex_ratio;
```

## Generate data for two states(Jharkhand & Bihaar)
```
Select *
FROM dataset_area_population
WHERE State like 'Jharkhand' OR State like 'Bihar';
```

## Alternate way of generating data for two states (Jharkhand & Bihar)
```
Select *
FROM dataset_area_population
WHERE State in ('Jharkhand','Bihar');
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/a220081b-93ec-4bae-86d3-2a6e8f75ba0c)

## Calculate the total population of India
```
Select sum(population) AS 'Total Population'
From dataset_sex_ratio;
```
## Average growth of population from the previous census
```
Select AVG(Growth) as 'Total Average Growth'
from dataset_sex_ratio;
```
## Average growth percentage by state
```
Select State, Avg(growth)
FROM dataset_sex_ratio
GROUP BY State
ORDER BY 2 desc;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/378f00ce-306b-4011-a819-f4d4ba6c3737)

## Average Sex ratio by state & rounding off the values
```
Select State, ROUND(Avg(sex_ratio)) AS 'Average Sex ratio'
FROM dataset_sex_ratio
GROUP BY State
ORDER BY 2 DESC;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/82587fa7-24cc-42b5-b711-07170559534f)

## Average Literacy Rate by putting a condition
```
Select State, ROUND(Avg(literacy)) AS 'Average Literacy Rate'
FROM dataset_sex_ratio
GROUP BY State
HAVING ROUND(Avg(literacy)) >90
ORDER BY 2 DESC;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/c03bcb4c-1a82-4632-b329-6e6e0a9530ba)

## Top 3 states having highest growth ratio
```
Select State, round(avg(growth)) AS Average_Growth
from dataset_sex_ratio
GROUP BY State
ORDER BY round(avg(growth)) DESC LIMIT 3;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/7d55be4d-9462-45cb-9bc2-dab5c39d509a)

## Bottom three states showing the lowest sex ratio
```
SELECT state, ROUND(AVG(sex_ratio)) as Lowest_3_sex_ratio
FROM dataset_sex_ratio
Group by state
Order by lowest_3_sex_ratio Asc limit 3;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/b8166431-3458-48ec-97e0-c2cea985af7d)

## Displaying both the top three and the bottom three states by Literacy
```
DROP TABLE IF EXISTS top_state;
CREATE TEMPORARY TABLE top_state
( state TEXT,
topstates DOUBLE);
Insert into top_state (state, topstates)
SELECT state, round(avg(literacy),0)
FROM dataset_sex_ratio
group by state
order by round(avg(literacy),0) desc limit 3;
```

```
Select * from top_state;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/2ee5950f-b9b0-43d6-9ba8-d66ad5bd5b16)

```
DROP TABLE IF EXISTS bottom_state;
CREATE TEMPORARY TABLE bottom_state
( state TEXT,
bottomstates double);
INSERT INTO bottom_state (state, bottomstates)
select state, round(avg(literacy),0)
from dataset_sex_ratio
group by state
order by round(avg(literacy),0) asc limit 3;
```
```
select * from bottom_state;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/27982a02-cbc1-41eb-ace2-6e861483932f)

## Combining the two tables using union
```
select * from (Select * from top_state) a
union
select * from (select * from bottom_state) b;
```
![image](https://github.com/Anshu9894/Indian_Census/assets/102878435/476fadc8-ab83-4afd-a922-f9b6270826db)

