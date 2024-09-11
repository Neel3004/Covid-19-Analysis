select * from Project.dbo.coviddeaths where continent is not null order by 3,4


-- To get an overview of total cases and deaths 
for a specific country, date, day and to know how many died in respect to total population.
select location,date,total_cases,new_cases, total_deaths, population, total_cases_per_million, 
total_deaths_per_million from Project..coviddeaths where continent is not null order by 1,2


-- To know which days recorded the most  percentage of deaths in India.
select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent 
from Project..coviddeaths where location = 'India' and continent is not null order by death_percent desc


-- To know as time passed by, how the total percent of population infected changed
select location,date,population,total_cases,(total_cases/population) as infectedpercent 
from Project..coviddeaths where location = 'India' and continent is not null order by 2


-- To see which country has highest number of infected patients corresponding to their population
select location, population, max(total_cases) as HighestNumberInfected,
round(max(total_cases/population)*100,2) as percentinfected from Project..coviddeaths 
where continent is not null group by location,population order by casespercent desc


-- To calculate highest number of deaths of any country compared to their population
select location,max(cast(total_deaths as int)) as Highestdead,
round(max(total_deaths/population)*100,4) as percentdead from Project..coviddeaths 
where continent is not null group by location order by Highestdead desc


-- Same query as above just in terms of continent(has some weird output 
-- but is correct as compared to previous output where total deaths of continent 
-- for North America showed equal to total deaths of America)
select location, max(cast(total_deaths as int)) as Highestdead,
round(max(total_deaths/population)*100,4) as percentdead from Project..coviddeaths 
where continent is null group by location order by Highestdead desc


-- To know datewise at global level what was the death percentage, total cases and total deaths
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
round(sum(cast(new_deaths as int))/sum(New_Cases)*100,2) as Death_Percentage from Project..CovidDeaths 
where continent is not null group by date order by 1,2


-- To calculate total deaths, cases and percentage of people which were also infected globally.
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
round(sum(cast(new_deaths as int))/sum(New_Cases)*100,2) as Death_Percentage 
from Project..CovidDeaths where continent is not null order by 1,2


-- To check country wise at what rate the percent of people taking vaccination is 
-- increasing, what percent of people are taking vaccination everyday compared to their population
-- and at what rate the total vaccinated number is increasing.
select cd.location, cd.date, cd.continent, cd.population, convert(bigint,cv.new_vaccinations) as daily_vaccinations, 
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) 
as cumulat_vaccinations, (sum(convert(bigint,cv.new_vaccinations)) 
over (partition by cd.location order by cd.location, cd.date))/(cd.population) as Vaccination_Percentage 
from Project..coviddeaths cd 
join Project..covidvaccinations cv on cd.date = cv.date and cd.location = cv.location 
where cd.continent is not null order by 1,2


-- Same result as above with the use of CTE
with vaccination_percentage(location, date, continent, population, daily_vaccinations,
cumulative_vaccinations)
as
(select cd.location, cd.date, cd.continent, cd.population, convert(bigint,cv.new_vaccinations) as daily_vaccinations, 
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) 
as cumulative_vaccinations 
from Project..coviddeaths cd 
join Project..covidvaccinations cv on cd.date = cv.date and cd.location = cv.location 
where cd.continent is not null)
select *,(convert(bigint, cumulative_vaccinations)/population)*100 as percent_vaccinated 
from vaccination_percentage order by location, date


-- Same thing with temp tables
drop table if exists total_population_vaccinated
create table total_population_vaccinated(location nvarchar(255), date datetime, continent nvarchar(255), 
population numeric, daily_vaccinations numeric, cumulative_vaccinations numeric)
insert into total_population_vaccinated
select cd.location, cd.date, cd.continent, cd.population, convert(bigint,cv.new_vaccinations) as daily_vaccinations, 
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) 
as cumulative_vaccinations 
from Project..coviddeaths cd 
join Project..covidvaccinations cv on cd.date = cv.date and cd.location = cv.location 
where cd.continent is not null
select *,(convert(bigint, cumulative_vaccinations)/population)*100 as percent_vaccinated 
from total_population_vaccinated order by location, date

-- Creating a view for tableau/PowerBI purposes
Create View percent_vaccinated_location1 as 
select cd.location, cd.date, cd.continent, cd.population, convert(bigint,cv.new_vaccinations) as daily_vaccinations, 
sum(convert(bigint,cv.new_vaccinations)) over (partition by cd.location order by cd.location, cd.date) 
as cumulative_vaccinations 
from Project..coviddeaths cd 
join Project..covidvaccinations cv on cd.date = cv.date and cd.location = cv.location 
where cd.continent is not null
select * from percent_vaccinated_location1
