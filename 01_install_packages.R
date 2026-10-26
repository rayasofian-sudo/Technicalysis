# BDA400 Assignment 2 - required R packages
required_packages <- c("quantmod", "TTR")
for (package_name in required_packages) {
  if (!requireNamespace(package_name, quietly = TRUE)) {
    install.packages(package_name, repos = "https://cloud.r-project.org")
  }
}
message("Package setup finished. Run 02_technical_analysis.R next.")
