use PortfolioProject; 
select *
From  coviddeaths
where continent is not null
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1,2

-- looking at total cases vs total deaths to show likehood of dying if you contract covid in your country 
select location, date, total_cases, total_deaths, (total_deaths/ total_cases)*100 as DeathPercentage
from coviddeaths
where location like '%states%'
order by 1,2

-- looking at the total cases vs population to show what percentage of population has covid 
select location, date, population,total_cases,(total_cases/ population)*100 as PercentPopulation
from coviddeaths
where location like '%states%'
order by 1,2

-- What country has the highest infection rate compared to population 

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/ population))*100 as PercentPopulationInfected
from coviddeaths
group by location, population
order by percentPopulationInfected desc

-- Showing countries with the highest death count by population //need to clean data highcome is not location 

select location, MAX(cast(total_deaths as unsigned))as TotalDeathCount
from coviddeaths
where continent is not null
group by location
order by TotalDeathCount DESC

-- Let's Break it down by continent 
-- showing continent with highest deathcount 

select continent, MAX(cast(total_deaths as unsigned))as TotalDeathCount
from coviddeaths
where continent is not null
group by continent 
order by TotalDeathCount DESC

-- Global Numbers by date

select date, SUM(new_cases) as total_cases , SUM(new_deaths)as total_deaths, SUM(new_deaths)/ SUM(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null 
group by date
order by 1,2

-- Total Global Number 

select SUM(new_cases) as total_cases , SUM( new_deaths)as total_deaths, SUM(new_deaths)/ SUM(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null 
order by 1,2

-- Locating at Total Population vs Vaccinations 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
, 
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null 
order by 2,3 
    
    
-- USE CTE

with  PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations)OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null 
)

select * , (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- Temp Table 
DROP temporary table if exists PercentPopulationVaccinated
create temporary table PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime, 
Population numeric, 
New_vaccinations varchar(255), 
RollingPeopleVaccinated numeric 
)

Insert into PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date 

select *, (RollingPeopleVaccinated/Population)*100
from PercentPopulationVaccinated

-- view for Visualization 

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null 

select * 
from  PercentPopulationVaccinated
