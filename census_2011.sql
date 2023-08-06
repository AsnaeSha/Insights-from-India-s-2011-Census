-- census 2011 insights - project

-- number of rows in our datasets

-- select count(*) from dataset1;
-- select count(*) from dataset2

-- dataset of jharkhand and bihar

-- select * from dataset1 
-- where state in ('Jharkhand','bihar')

-- total population of india

-- select sum(Population) from dataset2

-- avg growth of india in 2011

-- select avg(Growth) as avg_growth from dataset1

-- avg growth of each state

-- select state, avg(growth) from dataset1
-- group by state

-- avg sex ratio per state

-- select state,round(avg(Sex_ratio),0) as avg_sex_ratio from dataset1
-- group by state
-- order by avg_sex_ratio desc

-- india avg literacy rate

-- select avg(Literacy) from dataset1

-- state wise literacy rate

-- select state,round(avg(literacy),0) as avg_literacy_rate from dataset1
-- group by state
-- order by avg_literacy_rate desc

-- which state has 90 above literacy rate

-- select state,round(avg(literacy),0) as avg_literacy_rate from dataset1
-- group by state
-- having avg_literacy_rate >= 90;

-- which are the top 3 states displaying highest growth rate

-- select state, round(avg(growth),0) as avg_growth_rate from dataset1
-- group by state
-- order by avg_growth_rate desc
-- limit 3;

-- which are the bottom 3 states displaying lowest sex ratio rate

-- select state, round(avg(sex_ratio),0) as avg_sex_ratio_rate from dataset1
-- group by state
-- order by avg_sex_ratio_rate  asc
-- limit 3

-- show the top 3 and bottom 3 state on the basis of literacy rate

-- select state, literacy_rate from
-- (select state,round(avg(literacy),0) as literacy_rate from dataset1
-- group by state
-- order by literacy_rate asc
-- limit 3) as lowest_literacy
-- union 
-- select state, literacy_rate from
-- (select state,round(avg(literacy),0) as literacy_rate from dataset1
-- group by state
-- order by literacy_rate desc
-- limit 3) as highest_literacy

-- filter out all the data from all the states starting from the letter 'A' and ending with 'A' AND 'M'

-- select * from dataset1
-- where state like lower('A%')

-- select * from dataset1
-- where state like lower('a%m')

-- calculate no of male and no of female population in india from the given sex ratio and total population
-- in india sex ratio = female population * 1000 / male population
-- total population = male_population + female_population
-- male_population = (population) / (1 + (sex ratio /1000)
-- female_population = population - male population which means population - (population) / (1 + (sex ratio /1000))

-- select d1.state,sum(d1.male_population) as no_of_males,sum(d1.female_population) as no_of_female from
-- (select district,state,round(((population) / (1+(sex_ratio / 1000))),0) as male_population,round((Population) - (population / (1+(sex_ratio / 1000))),0) as female_population,Population from 
-- (select d1.district,d1.state,d1.sex_ratio,d2.population from dataset1 as d1
-- join dataset2 as d2 on d1.District = d2.District) d1)d1
-- group by d1.state

-- total literacy rate no of Literate and literate_people as per states
-- Literacy Ratio = (Literate Population / Total Population) * 100

-- select d1.state,round(sum(literate_people),0) as Literate_Population, round(sum(illiterate_people),0) as Illiterate_Population from 
-- (select district,state,((literacy / 100) * population) as literate_people,Population - ((literacy / 100) * population) as illiterate_people, Population from 
-- (select d1.district,d1.state,d1.Literacy,d2.population from dataset1 as d1
-- join dataset2 as d2 on d1.District = d2.District) d1) d1
-- group by d1.state
-- order by d1.state 

-- population in previous census
-- previous year population = (current population / 1 +(growth percent/100))

-- select avg(previous_census),avg(current_census) from
-- (select d.state,round(sum(d.previous_year_population),0) as previous_census, sum(d.current_population)as current_census from
-- (select d1.state, (d1.population / (1 + (d1.growth / 100))) as previous_year_population,d1.Population as current_population from
-- (select d1.district,d1.state,d1.growth,d2.population from dataset1 as d1
-- join dataset2 as d2 on d1.District = d2.District) d1) d
-- group by d.state) d

-- population density
-- Population Density = Current Population / Area (in km²)
-- if the population density of current year is greater than previous year it shows that the population has increased and the given area km2 has experienced a increased in population and it reduced in size 

-- select sum(current_density)as current_population_density,sum(previous_density)as previous_population_density from
-- (select state,round(sum(current_population / area),0) as current_density, round(sum((previous_year_population/ area))) as previous_density from 
-- (select district,state, round(sum(population / (1+(growth /100))),0) as previous_year_population,sum(population) as current_population,Area_km2 as area from
-- (select d1.district,d1.state,d1.growth,d2.population,Area_km2 from dataset1 as d1
-- join dataset2 as d2 on d1.District = d2.District) d1
-- group by district,state,area) d1
-- group by state) d1

-- top 3 district from each state who has the highest literacy rate
-- select state,literacy,rnk from
-- (select state,district,literacy,rank() over(partition by state order by literacy desc) as rnk from dataset1) dataset1
-- where rnk <=3
-- order by state,literacy desc
