select * 
From [DataExploration_Project]..CovidDeaths$
order by 3,4 

--order by 3,4 sorts columns  data will be sorted alphabetically by location, and within each location, sorted chronologically by date.

--select * 
--From [DataExploration_Project]..CovidVaccinations$
--order by 3,4  

select Location,date,total_cases, new_cases, total_deaths, population
From [DataExploration_Project]..CovidDeaths$
order by 1,2

--- Looking for Total Cases and Total DEaths 

select Location,date,total_cases, total_deaths, population
From [DataExploration_Project]..CovidDeaths$
order by 1,2

--Looking at total cases vs total deaths

select Location,date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [DataExploration_Project]..CovidDeaths$
where location like '%states%'
order by 1,2

--- Looking at Total Cases vs Population
select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
From [DataExploration_Project]..CovidDeaths$
where location like '%States%'
order by 1,2


---Looking at countries with Highest_Infection_Rate compared to Population

select location, population, Max(total_cases) as Highest_Infection_Rate, Max((total_cases/population))*100 as PercentPopulationInfected
From [DataExploration_Project]..CovidDeaths$
group by location , population
order by PercentPopulationInfected



------ Showing countries with Highest death count per Population
Select location, Max(cast(Total_deaths as int)) as TotalDeathCount
From [DataExploration_Project]..CovidDeaths$
where continent is null
Group by location
order by TotalDeathCount desc


----continent with Highest death count per Population
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From [DataExploration_Project]..CovidDeaths$
where continent is not null
Group by continent
order by TotalDeathCount desc


---- Global Numbers
select SUM([new_cases]) as total_cases, SUM(CAST([new_deaths] as int)) as total_deaths, 
 SUM(CAST([new_deaths] as int))/SUM([new_cases]) * 100  as DeathPercentage
 From [DataExploration_Project]..CovidDeaths$
 where continent is not null
 order by 1,2


 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 From [DataExploration_Project]..CovidDeaths$ dea
 join [DataExploration_Project]..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


















