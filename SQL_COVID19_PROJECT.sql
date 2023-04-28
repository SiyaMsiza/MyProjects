
SELECT *
FROM PortifolioProject..CovidDeaths
ORDER BY 1, 2

--SELECT *
--FROM PortifolioProject..CovidVaccinations
--ORDER BY 3, 4

/* Select Data that we gonna be using */

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortifolioProject..CovidDeaths
ORDER BY 1, 2

--LOOKING AT TOTAL CASES VS TOTALS DEATHS
-- SHOWS LIKELIHOOD OF DYING DUE TO COVID IN SOUTH AFRICA
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortifolioProject..CovidDeaths
WHERE location = 'south africa'
ORDER BY 1, 2

--LOOKING AT TOTAL CASES VS POPULATION
-- SHOWS PERCENTAGE OF THE POPULATION THAT HAD COVID-19 IN SOUTH AFRICA
SELECT location, date, population, total_cases, (total_cases/population) * 100 AS TotalCasesPercentage
FROM PortifolioProject..CovidDeaths
WHERE location LIKE '%south africa%'
ORDER BY 1, 2

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM PortifolioProject..CovidDeaths
--WHERE location LIKE '%south africa%'
ORDER BY 1, 2

--COUNTRIES WITH THE HIGHEST INFECTION RATE COMPARED TO POPULATION
SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM PortifolioProject..CovidDeaths
GROUP BY population, location
ORDER BY PercentPopulationInfected DESC

-- SWOWING COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount
FROM PortifolioProject..CovidDeaths
WHERE continent IN( 'Africa', 'Asia', 'South America', 'North America', 'World', 'Europe', 'Oceania')
GROUP BY location
ORDER BY TotalDeathCount DESC

--OR

-- SWOWING COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION
SELECT location, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount
FROM PortifolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--LET'S SORT THE DEATH COUNT BY CONTINENTS
SELECT location, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount
FROM PortifolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION (DRILLING DOWN)
SELECT continent, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount
FROM PortifolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL SCALE
SELECT date, SUM(New_cases) AS Total_Cases, SUM(CONVERT(INT, new_deaths)) AS Total_Deaths,
SUM(CONVERT(INT, new_deaths))/SUM(new_cases) * 100 AS DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortifolioProject..CovidDeaths
--WHERE location LIKE '%south africa%'
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2


--GLOBAL SCALE
SELECT SUM(New_cases) AS Total_Cases, SUM(CONVERT(INT, new_deaths)) AS Total_Deaths,
SUM(CONVERT(INT, new_deaths))/SUM(new_cases) * 100 AS DeathPercentage --total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortifolioProject..CovidDeaths
--WHERE location LIKE '%south africa%'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2


-- LOOKING AT TOTAL POPULATION VS TOTAL VACCINATION

SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
--, (PeopleVaccinated/dea.population) *100
FROM PortifolioProject..CovidDeaths dea
JOIN PortifolioProject..CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 ORDER BY 2, 3

--USE CTE

WITH PopvsVacc (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
( 
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
--, (SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)/dea.population) *100
FROM PortifolioProject..CovidDeaths dea
JOIN PortifolioProject..CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 )

 SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentagePopulationVaccinated
 FROM PopvsVacc

 -- TEMP TABLE
 DROP TABLE IF EXISTS #PercentagePopVaccinated
 CREATE TABLE #PercentagePopVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 population numeric,
 new_vaccinations numeric,
 RollingPoepleVaccinated numeric
 )

 INSERT INTO #PercentagePopVaccinated
 SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population) *100
FROM PortifolioProject..CovidDeaths dea
JOIN PortifolioProject..CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL
 --ORDER BY 2, 3

 SELECT *, (RollingPeopleVaccinated/population)*100 AS PercentagePopulationVaccinated
 FROM #PercentagePopVaccinated


 -- Creating View to store data for later visualization

CREATE VIEW PopvsVacci as
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)
AS RollingPeopleVaccinated
--, (SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date)/dea.population) *100
FROM PortifolioProject..CovidDeaths dea
JOIN PortifolioProject..CovidVaccinations vac
 ON dea.location = vac.location
 AND dea.date = vac.date
 WHERE dea.continent IS NOT NULL

CREATE VIEW ContinentsDeathCount as
SELECT continent, MAX(CONVERT(INT, total_deaths)) AS TotalDeathCount
FROM PortifolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
--ORDER BY TotalDeathCount DESC