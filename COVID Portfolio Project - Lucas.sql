--select *
--From PortfolioProject..CovidDeaths
--Where continent is not null
--order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--Where continent is not null
--order by 3,4

-- Select Data that we are going to be using

--select Location, date, total_cases, new_cases, total_deaths, population
--From PortfolioProject..CovidDeaths
--Where continent is not null
--order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in USA
--select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--Where location like '%states%'
--Where continent is not null
--order by 1,2

-- Looking at Total Cases vs Population
--Shows what percentage of population got Covid
--select Location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--order by 1,2


--Looking at Country with Highest Infection Rate compared to Population
--select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--Where continent is not null
--Group by Location, Population
--order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population
--select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is not null
--Group by Location
--order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINET
--select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is null
--Group by location
--order by TotalDeathCount desc


--Showing contintents with the highest death count per population
--select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
--From PortfolioProject..CovidDeaths
--Where continent is not null
--Group by continent
--order by TotalDeathCount desc


--GLOBAL NUMBERS
--Select date, SUM(new_cases) as toal_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--where continent is not null
--Group by date
--order by 1,2


-- Looking at Total Population vs Vaccinations
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
--	dea.Date) as RollingPeopleVaccinated
--	-- , (RollingPeopleVaccinated/population) * 
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


-- USE CTE
--With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollPeopleVaccinated)
--as 
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
--	dea.Date) as RollingPeopleVaccinated
--	-- , (RollingPeopleVaccinated/population) * 
--From PortfolioProject..CovidDeaths dea
--Join PortfolioProject..CovidVaccinations vac
--	On dea.location = vac.location 
--	and dea.date = vac.date
--where dea.continent is not null
----order by 2,3
--)
--Select * , (RollPeopleVaccinated/Population)*100
--From PopvsVac




--TEMP TABLE 
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
Select * , (RollPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




--Creating View to store data for later visualizations
Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
	dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * 
From PercentPopulationVaccinated