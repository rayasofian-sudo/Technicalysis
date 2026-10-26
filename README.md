# TechnicalAnalysis — BDA400 Assignment 2

## Folder contents
- `portfolio.txt`: one stock ticker per line (AAPL, MSFT, GOOGL).
- `01_install_packages.R`: installs `quantmod` and `TTR`.
- `02_technical_analysis.R`: downloads Yahoo Finance stock history, calculates mean, statistical mode, median, standard deviation, 20-day SMA and saves tables/plots.
- `BDA400_Assignment2_Report.docx`: report draft with step-by-step documentation and screenshot placeholders.

## Setup & run
1. Create a GitHub repository named `TechnicalAnalysis`, with a subfolder `Assignment2`. Upload the files in this directory to that subfolder.
2. Install R from https://cran.r-project.org/ and RStudio Desktop from https://posit.co/download/rstudio-desktop/.
3. Open RStudio and set the working directory to `Assignment2` (Session > Set Working Directory > Choose Directory).
4. Run `source("01_install_packages.R")`, then `source("02_technical_analysis.R")`. Internet access is needed to retrieve Yahoo Finance data.
5. Inspect the created `output/` folder for per-symbol CSV data, PNG charts and `statistics_summary.csv`.
6. Take actual screenshots of GitHub, R/RStudio installation, package installations, script execution and output. Insert them into the Word report.
7. Replace `[STUDENT NAME]`, `[DATE]`, and `[GITHUB REPOSITORY URL]` in the Word report with your own details.
8. Submit the Word file, R scripts, portfolio and the GitHub repository link according to instructor directions.

Note: The mode is calculated using closing prices rounded to 2 decimals; when tied, the lowest modal value is used. The assignment does not specify a moving-average window, so a standard 20-trading-day SMA is used. Live prices and screenshots cannot be included without running on a connected computer.
