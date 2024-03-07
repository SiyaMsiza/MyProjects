# COVID-19 Data Analysis Project

Welcome to the COVID-19 Data Analysis Project. This repository is dedicated to analyzing COVID-19 data to uncover insights into the pandemic's impact on different regions, particularly focusing on infection rates, death rates, and vaccination progress globally, with a special emphasis on South Africa.

## Project Overview

This project uses SQL to query a comprehensive dataset, including details about COVID-19 deaths, cases, and vaccinations from the `PortifolioProject` database. Our analysis aims to provide a clearer understanding of:

- The likelihood of dying from COVID-19 in South Africa.
- The percentage of the population infected with COVID-19 in South Africa and globally.
- The highest infection and death rates by country and continent.
- The progress of vaccination efforts compared to the total population.

## Key Queries

Here are some of the core queries used in this project:

- **Total Cases and Deaths**: Analysis of total cases vs. total deaths to understand the death percentage.
- **Infection Rates**: Comparison of total cases vs. population to gauge the infection percentage.
- **Highest Rates**: Identification of countries and continents with the highest infection and death rates per population.
- **Vaccination Analysis**: Examination of vaccination data to calculate the percentage of the population vaccinated.

## Special Features

- Use of CTEs (Common Table Expressions) and Temp Tables for advanced data manipulation.
- Creation of views (`PopvsVacci`, `ContinentsDeathCount`) for easier data visualization and analysis.

## Getting Started

To run this project locally:

1. Ensure you have a SQL Server environment set up.
2. Create the `PortifolioProject` database and import the COVID-19 datasets for deaths and vaccinations.
3. Execute the SQL queries provided in this repository to perform the analysis.

## Visualization and Reporting

- After executing the queries, the results can be exported to data visualization tools (e.g., Power BI, Tableau) for creating insightful reports and dashboards.
- The views created (`PopvsVacci`, `ContinentsDeathCount`) serve as a foundation for visual analysis and trend observation over time.

## Contributing

We welcome contributions and suggestions! If you have ideas on how to improve the analysis or expand the scope to cover additional metrics, please feel free to submit an issue or pull request.

## License

This project is open-sourced under the MIT License. See the LICENSE file for more details.

## Acknowledgments

- Data sourced from `PortifolioProject` database. Please ensure to follow any and all data use agreements and credit the original data providers accordingly.

---

Thank you for exploring the COVID-19 Data Analysis Project. Together, through data, we can gain insights and drive informed decisions to combat this pandemic more effectively.
