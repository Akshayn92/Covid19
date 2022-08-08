--Total cases vs Total Deaths
--Shows likelihood of dying from covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercent
from coviddeaths
Where location like'%Australia%' 
order by 1,2


-- Looking at total cases vs population
--Shows what percentage got covid
Select Location, date, total_cases, population, (total_cases/population)*100 as covidpercent
from coviddeaths
Where location like'%Australia%' 
order by 1,2


-- Looking at countries with highest infection rate to population
Select Location,Population, Max(total_cases) as HIGHESTINFECTIONCOUNT, MAX((total_cases/population))*100 as covidpercent
from coviddeaths
--Where location like'%Australia%' 
group by location, population
order by covidpercent desc


--Showing countries with highest death count per calculations
Select Location, MAX( cast(total_deaths as int)) as Totaldeathcount
from coviddeaths
Where continent is not null
Group by Location 
order by Totaldeathcount desc

--Break Death rate by continent
-- Continents with the highest death count 
Select continent, MAX( cast(total_deaths as int)) as Totaldeathcount
from coviddeaths
Where continent is not  null
Group by continent 
order by Totaldeathcount desc

-- Global Numbers 
Select  SUM(new_cases)as totalcases, Sum(cast(new_deaths as int)) as totaldeaths, Sum(cast(new_deaths as int))/SUM(new_cases)*100 as deathPercent
from coviddeaths
--where location like'%states%'
where continent is not null
--group by date
order by 1,2


-- Total populatiob vs vaccination
select*
from coviddeaths 
Join covidvaccination 
on coviddeaths.location = covidvaccination.location
and coviddeaths.date = covidvaccination.date

select cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations
, sum(convert(BIGINT,vac.new_vaccinations)) over (Partition by cov.location order by cov.location, cov.date)as Addingpeoplevaccinated
from coviddeaths cov
Join covidvaccination vac
on cov.location = vac.location
and cov.date = vac.date
where cov.continent is not null
order by 2,3

--Percentage of people vaccinated--

with polutionvac(continent, Location, Date, Population, New_Vaccinations, Addingpeoplevaccinated)
as
(
select cov.continent, cov.location, cov.date, cov.population, vac.new_vaccinations
, sum(convert(BIGINT,vac.new_vaccinations)) over (Partition by cov.location order by cov.location, cov.date)as Addingpeoplevaccinated
from coviddeaths cov
Join covidvaccination vac
on cov.location = vac.location
and cov.date = vac.date
where cov.continent is not null
)

select*,(Addingpeoplevaccinated/Population)*100
from polutionvac





