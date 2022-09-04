--select * from Project.dbo.coviddeaths where continent is not null order by 3,4

--To get an overview of total cases and deaths for a specific country, date, day and to know how many died in respect to total population.
--select location,date,total_cases,new_cases, total_deaths, population, total_cases_per_million, total_deaths_per_million from Project..coviddeaths where continent is not null order by 1,2

-- To know which days recorded the most  percentage of deaths in India.
--select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent from Project..coviddeaths where location = 'India' and continent is not null order by death_percent desc

--To know as time passed by, how the total percent of population infected changed
--select location,date,population,total_cases,(total_cases/population) as infectedpercent from Project..coviddeaths where location = 'India' and continent is not null order by 2

--To see which country has highest number of infected patients corresponding to their population
--select location, population, max(total_cases) as HighestNumberInfected,round(max(total_cases/population)*100,2) as percentinfected from Project..coviddeaths where continent is not null group by location,population order by casespercent desc

--To calculate highest number of deaths of any country compared to their population
--select location,max(cast(total_deaths as int)) as Highestdead,round(max(total_deaths/population)*100,4) as percentdead from Project..coviddeaths where continent is not null group by location order by Highestdead desc

--Same query as above just in terms of continent(has some weird output but is correct as compared to previous output where total deaths of continent for North America showed equal to total deaths of America)
--select location, max(cast(total_deaths as int)) as Highestdead,round(max(total_deaths/population)*100,4) as percentdead from Project..coviddeaths where continent is null group by location order by Highestdead desc

