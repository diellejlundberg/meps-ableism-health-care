************************************************************************************************************
** Health Care Discrimination, Low-Quality Care, and the Health of Disabled U.S. Adults, MEPS 2015-2023
** Code by Dielle J. Lundberg
** Last Updated: December 23, 2025
** Code File 1 of 4: Complete Full Analysis Work Flow
************************************************************************************************************

***********************
**** PART 1:       ****
**** DOWNLOAD DATA ****
***********************

// MEPS HC-181: 2015 Full Year Consolidated Data File (ASCII Format, Stata Programming Statement)
**** Link: https://meps.ahrq.gov/mepsweb/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-181

// MEPS HC-201: 2017 Full Year Consolidated Data File (Stata Format)
**** Link: https://meps.ahrq.gov/mepsweb/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-201

// MEPS HC-233: 2021 Full Year Consolidated Data File (Stata Format)
**** Link: https://meps.ahrq.gov/mepsweb/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-233

// MEPS HC-251: 2023 Full Year Consolidated Data File (Stata Format)
**** Link: https://meps.ahrq.gov/mepsweb/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-251

// MEPS HC-036: 1996-2023 Pooled Linkage File for Common Variance Structure
**** Link: https://meps.ahrq.gov/mepsweb/data_stats/download_data_files_detail.jsp?cboPufNumber=HC-036

********************************
**** PART 2:                ****
**** RUN FULL ANALYTIC CODE ****
********************************

// Set Directory to Folder Where Data (and Other Do Files) Are Saved
cd "/Users/djlwork/Library/Mobile Documents/com~apple~CloudDocs/Independent Research/MEPS-Ableism-Health-Care-Project/MEPS-Ableism-Health-Care-Code-12-2025/"

// Run Code File 2 of 4: Merge Data, Clean Data and Create Sample
do "meps-code-file-2.do"

// Run Code File 3 of 4: Main Tables and Figures
/* Note: This file requires several hours to run due to bootstrapping */
do "meps-code-file-3.do"

// Code File 4 of 4: Supplementary Tables and Figures
/* Note: This file requires several hours to run due to bootstrapping */
do "meps-code-file-4.do"
