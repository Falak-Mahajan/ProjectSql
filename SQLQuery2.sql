SELECT location, date, total_cases, new_cases, total_deaths, population 
from project..covid_deaths$ 
order by 1,2

--Looking at Total cases vs Total Deaths
Select location,date,total_cases,total_deaths,total_deaths/total_cases * 100 as death_percentage 
from project..covid_deaths$  
where location = 'India'
order by 1,2

--Looking at Total cases vs Population 
--> shows what percentage of population got Covid
Select location,date,total_cases,population,total_cases/population * 100 as Case_percentage_per_population 
from project..covid_deaths$  
where location = 'India'
order by 1,2


--Looking at countries with Highest Infactuation Rate compared to population
Select location, population, MAX(total_cases) as Highest_Infactuation_Count , MAX(total_cases/population)*100 as Percent_Population_Infactuated
FROM project..covid_deaths$ 
GROUP BY location,population
order by 4 desc 

--> Infactuation percentage rate compared to population in INDIA
Select location, population, MAX(total_cases) as Highest_Infactuation_Count , MAX(total_cases/population)*100 as Percent_Population_Infactuated
FROM project..covid_deaths$ where location ='India'
GROUP BY location,population
order by 4 desc 

-- Showing countries with highest Death_count per population
Select location, MAX(cast(total_deaths as int)) as Total_death_counts 
FROM project..covid_deaths$ 
GROUP BY location
order by Total_death_counts desc
--> We got some unwanted rows

-->Checking for null continents
Select location from project..covid_deaths$ where continent is null
--> there are many rows with null Continent so we will take care of this in our future queries

-- Showing countries with highest Death_count per population
Select location, MAX(cast(total_deaths as int)) as Total_death_counts 
FROM project..covid_deaths$ 
where continent is not null
GROUP BY location
order by Total_death_counts desc


--Looking at continent with Highest Infactuation Rate compared to population
Select continent, MAX(total_cases) as Highest_Infactuation_Count , MAX(total_cases/population)*100 as Percent_Population_Infactuated
FROM project..covid_deaths$ 
where continent is not null
GROUP BY continent
order by 3 desc 

--Showing Continents with highest Death_count per population
Select continent, MAX(cast(total_deaths as int)) as Total_death_counts 
FROM project..covid_deaths$ 
where continent is not null
GROUP BY continent
order by Total_death_counts desc

--> GLOBAL NUMBERS

--Looking at Total cases vs Total Deaths
Select date,SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_death_case, SUM(cast(new_deaths as int))/Sum(new_cases) *100 as Death_percentage
from project..covid_deaths$  
where continent is not null
group by date
order by 1,2

--Looking at Total cases vs Total Deaths
Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_death_case, SUM(cast(new_deaths as int))/Sum(new_cases) *100 as Death_percentage
from project..covid_deaths$  
where continent is not null
order by 1,2

--> Joining two tables ( covid_deaths and covid_vaccinations)

SELECT * FROM project..covid_deaths$ dea 
JOIN project..covid_vaccinations$ vac 
ON dea.location = vac.location and dea.date = vac.date


-- looking at total population vs vaccinations
--Using CTE

With PopulationVsVac (Continent, Location, Date, Population, New_vaccination, PeopleVaccinated )
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int, new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as PeopleVaccinated
From project..covid_deaths$ dea 
Join project..covid_vaccinations$ vac on 
dea.location= vac.location and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (PeopleVaccinated/Population)*100 from PopulationVsVac



--> Creating view to store data for visualization

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, 
SUM(convert(int, new_vaccinations))
OVER (Partition by dea.Location order by dea.location, dea.date) as PeopleVaccinated
From project..covid_deaths$ dea 
Join project..covid_vaccinations$ vac on 
dea.location= vac.location and dea.date = vac.date
where dea.continent is not null


SELECT * From PercentPopulationVaccinated







