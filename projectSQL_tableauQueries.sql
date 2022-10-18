-- Global numbers
Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_death_case, SUM(cast(new_deaths as int))/Sum(new_cases) *100 as Death_percentage
from project..covid_deaths$  
where continent is not null
order by 1,2

-- Continent wise Deaths
Select location, Sum(cast(new_deaths as int)) as Total_Death_Count 
from project..covid_deaths$
where continent is null
and location not in ('World', 'Europiam Union','International', 'High income', 'Upper middle income', 'Low income', 'Lower middle income')
Group by location
order by Total_Death_Count desc

--Infected_per_population of countries rate
Select location, Population, MAX(total_cases) as Highest_Infected_Count, MAX(total_cases/population)*100 as Percent_Population_Infected
From project..covid_deaths$
group by location, population
order by Percent_Population_Infected desc

--Infected_per_population of countries rate over time
Select location, Population, date, MAX(total_cases) as Highest_Infected_Count, MAX(total_cases/population)*100 as Percent_Population_Infected
From project..covid_deaths$
group by location, population,date
order by Percent_Population_Infected desc

