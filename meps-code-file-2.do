************************************************************************************************************
** Health Care Discrimination, Low-Quality Care, and the Health of Disabled U.S. Adults, MEPS 2015-2023
** Code by Dielle J. Lundberg
** Last Updated: December 23, 2025
** Code File 2 of 4: Merge Data, Clean Data and Create Sample
************************************************************************************************************

****************************
**** PART 1:            ****
**** MERGE & CLEAN DATA ****
****************************

// Set Directory to Folder Where Data Are Saved
cd "/Users/djlwork/Library/Mobile Documents/com~apple~CloudDocs/Independent Research/MEPS-Ableism-Health-Care-Project/MEPS-Ableism-Health-Care-Code-12-2025/"

// Store Variable Names in Macros
/* List Identifiers */
local vars1 DUPERSID PANEL 
/* List Disability Measures */
local vars2 DFHEAR42 DFSEE42 DFCOG42 DFWLKC42 DFDRSB42 DFERND42
/* List SAQ Variables */
local vars3 SAQELIG ADAPPT42 ADLIST42 ADRESP42 ADEXPL42 ADPRTM42 ADHECR42 ADGENH42 K6SUM42 PHQ242 ADPAIN42
/* List SDOH Survey Variables */
local vars4 SDOHELIG SDOHWT21F SDDSCRMDR SDPROX 
/* List Covariates */
local vars5 SEX RACEV1X RACEAX HISPANX HISPNCAT AGE42X HIDEG RESP42
/* Variables Whose Name Changes by Year */
/* SAQWT`num'F POVCAT`num' INSCOV`num' OBTOTV`num' */

// 2015 Sample 
use h181.dta, clear
keep `vars1' `vars2' `vars3' `vars5' SAQWT15F POVCAT15 INSCOV15 ADPRXY42 EDUYRDG
rename (SAQWT15F POVCAT15 INSCOV15 ADPRXY42) (SAQWT POVCAT INSCOV ADPROX42)
gen year = 2015
save data_2015.dta, replace

// 2017 Sample 
use h201.dta, clear
keep `vars1' `vars2' `vars3' `vars5' SAQWT17F POVCAT17 INSCOV17 ADPROX42
rename (SAQWT17F POVCAT17 INSCOV17) (SAQWT POVCAT INSCOV)
gen year = 2017
save data_2017.dta, replace

// 2021 Sample 
use h233.dta, clear
keep `vars1' `vars2' `vars3' `vars4' `vars5' SAQWT21F POVCAT21 INSCOV21 ADPROX42
rename (SAQWT21F POVCAT21 INSCOV21 SDOHWT21F) (SAQWT POVCAT INSCOV SDOHWT)
gen year = 2021
save data_2021.dta, replace

// 2023 Sample
use h251.dta, clear
keep `vars1' `vars2' `vars3' `vars5' SAQWT23F POVCAT23 INSCOV23 ADPROX42
rename (SAQWT23F POVCAT23 INSCOV23) (SAQWT POVCAT INSCOV)
gen year = 2023
save data_2023.dta, replace

// Combine Samples (2015, 2016, 2017, 2019, 2021, and 2023)
use data_2015.dta, clear
append using data_2017.dta
append using data_2021.dta
append using data_2023.dta
label var year "Year"
save data_pooled.dta, replace

// Erase Temporary Datasets
erase data_2015.dta
erase data_2017.dta
erase data_2021.dta
erase data_2023.dta

*************************
**** PART 2:         ****
**** CLEAN VARIABLES ****
*************************

// Load Data
use data_pooled.dta, replace

// Divide SAQ Survey Weights by 4
// Pooled 4 Years (2015, 2017, 2021, 2023)
replace SAQWT = SAQWT / 4 

**************************
** Exposure: Disability **
**************************

// Ambulation Disability
/* Serious difficulty walking or climbing stairs */
/* 0: no; 1: yes */
gen disability_ambulation = . 
replace disability_ambulation = 0 if DFWLKC42 == 2
replace disability_ambulation = 1 if DFWLKC42 == 1
label var disability_ambulation "Ambulation Disability"
label define disabilitylab 0 "Nondisabled" 1 "Disabled"
label values disability_ambulation disabilitylab
drop DFWLKC42

// Cognition Disability 
/* serious difficulty concentrating, remembering or making decisions */
/* 0: no; 1: yes */
gen disability_cognition = . 
replace disability_cognition = 0 if DFCOG42 == 2
replace disability_cognition = 1 if DFCOG42 == 1
label var disability_cognition "Cognition Disability"
label values disability_cognition disabilitylab
drop DFCOG42

// Hearing Disability 
/* deaf or serious difficulty with hearing */
/* 0: no; 1: yes */
gen disability_hearing = .
replace disability_hearing = 0 if DFHEAR42 == 2
replace disability_hearing = 1 if DFHEAR42 == 1
label var disability_hearing "Hearing Disabiity"
label values disability_hearing disabilitylab
drop DFHEAR42

// Independent Living Disability 
/* difficulty doing errands alone such as visiting a doctor's office or shopping */
/* 0: no; 1: yes */
gen disability_independent = . 
replace disability_independent = 0 if DFERND42 == 2
replace disability_independent = 1 if DFERND42 == 1
label var disability_independent "Independent Living Disability"
label values disability_independent disabilitylab
drop DFERND42

// Seeing Disability
/* blind or serious difficulty with seeing even with corrective glasses */
/* 0: no; 1: yes */
gen disability_seeing = .
replace disability_seeing = 0 if DFSEE42 == 2
replace disability_seeing = 1 if DFSEE42 == 1
label var disability_seeing "Seeing Disability"
label values disability_seeing disabilitylab
drop DFSEE42

// Self-Care Disability 
/* difficulty dressing or bathing */ 
/* 0: no; 1: yes */
gen disability_selfcare = . 
replace disability_selfcare = 0 if DFDRSB42 == 2
replace disability_selfcare = 1 if DFDRSB42 == 1
label var disability_selfcare "Self-Care Disability"
label values disability_selfcare disabilitylab
drop DFDRSB42

// Disability
/* 0: Nondisabled; 1: Disabled */
gen disability = .
replace disability = 0 if disability_hearing == 0 & disability_seeing == 0 & disability_ambulation == 0 & disability_cognition == 0 & disability_selfcare == 0 & disability_independent == 0
replace disability = 1 if disability_hearing == 1 | disability_seeing == 1 | disability_ambulation == 1 | disability_cognition == 1 | disability_selfcare == 1 | disability_independent == 1
label var disability "Disability"
label values disability disabilitylab

// Disabled or Deaf
/* 0: Nondisabled (and Not Deaf); 1: Disabled (and Not Deaf); 2: Deaf */
gen disabled_deaf = .
replace disabled_deaf = 0 if disability_hearing == 0 & disability_seeing == 0 & disability_ambulation == 0 & disability_cognition == 0 & disability_selfcare == 0 & disability_independent == 0
replace disabled_deaf = 1 if disability_seeing == 1 | disability_ambulation == 1 | disability_cognition == 1 | disability_selfcare == 1 | disability_independent == 1
replace disabled_deaf = 2 if disability_hearing == 1
label var disabled_deaf "Disabled (and Not Deaf) or Deaf"
label define disabled_deaflab 0 "Nondisabled (and Not Deaf)" 1 "Disabled (and Not Deaf)" 2 "Deaf"
label values disabled_deaf disabled_deaflab

****************
** Covariates **
****************

// Sex
/* 1: Female; 2: Male */
gen sex = .
replace sex = 1 if SEX == 2
replace sex = 2 if SEX == 1
label var sex "Sex Assigned at Birth"
label define sexlab 1 "Female" 2 "Male"
label values sex sexlab
drop SEX

// Age
/* 1: 18-29; 2: 30-39; 3: 40-49; 4: 50-59; 5: 60-69; 6: 70+ */
/* Note: MEPS top-codes age at 85 */
gen age = .
replace age = 1 if AGE42X >= 18 & AGE42X <= 29
replace age = 2 if AGE42X >= 30 & AGE42X <= 39
replace age = 3 if AGE42X >= 40 & AGE42X <= 49
replace age = 4 if AGE42X >= 50 & AGE42X <= 59
replace age = 5 if AGE42X >= 60 & AGE42X <= 69
replace age = 6 if AGE42X >= 70 & AGE42X <= 85
label var age "Age"
label define agelab 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "70+"
label values age agelab
drop AGE42X

// Race
/* 1: Asian; 2: Black or African American; 3: multiracial; 4: white; 5: an identity less represented in MEPS */
generate race = .
replace race = 1 if RACEV1X == 4 & RACEAX == 1 
replace race = 2 if RACEV1X == 2
replace race = 3 if RACEV1X == 6
replace race = 4 if RACEV1X == 1
replace race = 5 if RACEV1X == 3 | (RACEV1X == 4 & RACEAX != 1)
label var race "Race"
label define racelab 1 "Asian" 2 "Black or African American" 3 "Multiracial" 4 "White" 5 "Identity Less Represented in MEPS"
label values race racelab
drop RACEV1X RACEAX

// Ethnicity (Hispanic, Latino, or of Spanish origin)
/* 1: Yes (Mexican origin); 2: Yes (all other origins); 3: No */
generate ethnicity = .
replace ethnicity = 1 if HISPANX == 1 & HISPNCAT == 1
replace ethnicity = 2 if HISPANX == 1 & HISPNCAT != 1
replace ethnicity = 3 if HISPANX == 2
label var ethnicity "Hispanic Ethnicity"
label define ethnicitylab 1 "Yes (Mexican Origin)" 2 "Yes (All Other Origins)" 3 "No"
label values ethnicity ethnicitylab
drop HISPANX HISPNCAT

// Educational Attainment
/* 1: No Degree; 2: High School Grad or GED; 3: Bachelor's Degree; 4: Master's/Doctorate Degree; 5: Other Degree */
/* Note: HIDEG is not available for some respondents in 2015, which is why EDUYRDG is needed */
gen education = .
replace education = 1 if HIDEG == 1 | EDUYRDG == 1 | EDUYRDG == 2
replace education = 2 if HIDEG == 2 | HIDEG == 3 | EDUYRDG == 3 | EDUYRDG == 4 | EDUYRDG == 5
replace education = 3 if HIDEG == 4 | EDUYRDG == 8
replace education = 4 if HIDEG == 5 | HIDEG == 6 | EDUYRDG == 9
replace education = 5 if HIDEG == 7 | EDUYRDG == 6 | EDUYRDG == 7
label var education "Educational Attainment"
label define educationlab 1 "No Degree" 2 "High School Grad or GED" 3 "Bachelor's Degree" 4 "Master's/Doctorate Degree" 5 "Other Degree" 
label values education educationlab
drop HIDEG EDUYRDG

// Family Income
/* 1: Below Poverty Line; 2: Near Poverty Line; 3: Low Income; 4: Middle Income; 5: High Income */
gen income = .
replace income = 1 if POVCAT == 1
replace income = 2 if POVCAT == 2
replace income = 3 if POVCAT == 3
replace income = 4 if POVCAT == 4
replace income = 5 if POVCAT == 5
label var income "Family Income"
label define incomelab 1 "Below Poverty Line" 2 "Near Poverty Line" 3 "Low Income" 4 "Middle Income" 5 "High Income"
label values income incomelab
drop POVCAT

// Health Insurance
/* 1: Any Private; 2: Public Only; 3: Uninsured */
gen insurance = . 
replace insurance = 1 if INSCOV == 1
replace insurance = 2 if INSCOV == 2
replace insurance = 3 if INSCOV == 3
label var insurance "Health Insurance"
label define insurancelab 1 "Any Private" 2 "Public Only" 3 "Uninsured"
label values insurance insurancelab
drop INSCOV

// Any Health Care Visits
/* in the last 12 months, times you went to a doctor's office or clinic to get health care */
/* 0: No; 1: Yes */
gen any_visits = .
replace any_visits = 0 if ADAPPT42 == 0
replace any_visits = 1 if ADAPPT42 >= 1 & ADAPPT42 <= 6
label var any_visits "Any Health Care Visits in Last 12 Months"
label define yesno 0 "No" 1 "Yes"
label values any_visits yesno

// Number of Health Care Visits
/* in the last 12 months, times you went to a doctor's office or clinic to get health care */
/* 1: 1; 2: 2; 3: 3-4; 4: 5-9; 5: 10+ */
gen visits = .
replace visits = 1 if ADAPPT42 == 1 
replace visits = 2 if ADAPPT42 == 2
replace visits = 3 if ADAPPT42 == 3 | ADAPPT42 == 4
replace visits = 4 if ADAPPT42 == 5
replace visits = 5 if ADAPPT42 == 6
label var visits "Health Care Visits in Last 12 Months"
label define visitslab 1 "1" 2 "2" 3 "3-4" 4 "5-9" 5 "10+"
label values visits visitslab
drop ADAPPT42 

// Survey Year
/* 1: 2015; 2: 2017; 3: 2021; 4: 2023 */
gen survey_year = .
replace survey_year = 1 if year == 2015
replace survey_year = 2 if year == 2017
replace survey_year = 3 if year == 2021
replace survey_year = 4 if year == 2023
label var survey_year "Survey Year"
label define survey_yearlab 1 "2015" 2 "2017" 3 "2021" 4 "2023"
label values survey_year survey_yearlab

// Self-Reported Disability Status
/* 0: No; 1: First Respondent */
gen proxy_disability = .
replace proxy_disability = 0 if RESP42 == 2
replace proxy_disability = 1 if RESP42 == 1
label var proxy_disability "Self-Reported Disability Status"
label define proxy_disabilitylab 0 "No" 1 "First Respondent"
label values proxy_disability proxy_disabilitylab
drop RESP42

// Self-Reported SAQ Responses
/* 0: No or Unknown; 1: Yes */
gen proxy_saq = .
replace proxy_saq = 0 if SAQELIG == 1
replace proxy_saq = 1 if SAQELIG == 1 & ADPROX42 == 1
label var proxy_saq "Self-Reported SAQ Responses"
label define proxy_lab 0 "No or Unknown" 1 "Yes"
label values proxy_saq proxy_lab
drop ADPROX42

// Self-Reported SDOH Survey Responses
/* 0: No (Paper); 1: Yes (Paper or Web) */
/* SDPROX is only available for paper respondents */
/* All web respondents assumed to be self-administered (confirmed via email to MEPS) */
gen proxy_sdoh = .
replace proxy_sdoh = 1 if SDOHELIG == 1 
replace proxy_sdoh = 0 if SDOHELIG == 1 & SDPROX >=2 & SDPROX <= 7
label var proxy_sdoh "Self-Reported SDOH Survey Responses"
label values proxy_sdoh yesno
drop SDPROX

*****************************************
** Outcome: Health Care Discrimination **
*****************************************

// Perceived Health Care Discrimination
/* ever experienced discrimination at a doctor's office, hospital, or clinic */
/* 0: no; 1: yes */
gen discrimination = .
replace discrimination = 0 if SDDSCRMDR == 2
replace discrimination = 1 if SDDSCRMDR == 1
label var discrimination "Health Care Discrimination"
label values discrimination yesno
drop SDDSCRMDR

**************************************
** Outcome: Low-Quality Health Care **
**************************************

// Health Professionals Did Not Listen Carefully 
/* doctors or other health professionals never or only sometimes listened carefully to you */
/* 0: no; 1: yes */
gen listening = .
replace listening = 0 if ADLIST42 == 3 | ADLIST42 == 4
replace listening = 1 if ADLIST42 == 1 | ADLIST42 == 2
label var listening "Did Not Listen Carefully "
label values listening yesno
drop ADLIST42

// Health Professionals Did Not Communicate Clearly 
/* doctors or other health professionals never or only sometimes explained things in a way that was easy to understand */
/* 0: no; 1: yes */
gen explain = .
replace explain = 0 if ADEXPL42 == 3 | ADEXPL42 == 4
replace explain = 1 if ADEXPL42 == 1 | ADEXPL42 == 2
label var explain "Did Not Communicate Clearly"
label values explain yesno
drop ADEXPL42

// Health Professionals Did Not Show Respect 
/* doctors or other health professionals never or only sometimes showed respect for what you had to say */
/* 0: no; 1: yes */
gen respect = .
replace respect = 0 if ADRESP42 == 3 | ADRESP42 == 4
replace respect = 1 if ADRESP42 == 1 | ADRESP42 == 2
label var respect "Did Not Show Respect"
label values respect yesno
drop ADRESP42

// Health Professionals Did Not Spend Enough Time 
/* doctors or other health professionals never or only sometimes spent enough time with you */
/* 0: no; 1: yes */
gen time = .
replace time = 0 if ADPRTM42 == 3 | ADPRTM42 == 4
replace time = 1 if ADPRTM42 == 1 | ADPRTM42 == 2
label var time "Did Not Spend Enough Time"
label values time yesno
drop ADPRTM42

// Dissatisfaction with Health Care
/* rated all health care as less than 5 out of 10 [0 was worst possible care and 10 was best]) */
/* 0: no; 1: yes */
gen satisfaction = .
replace satisfaction = 0 if ADHECR42 >= 5 & ADHECR42 <= 10
replace satisfaction = 1 if ADHECR42 >= 0 & ADHECR42 <= 4
label var satisfaction "Disatisfied with Health Care"
label values satisfaction yesno
drop ADHECR42

// Low-Quality Health Care
/* reported one or more of the above 5 dimensions of low-quality health care */
/* 0: no; 1: yes */
gen combined = .
replace combined = 0 if listening == 0 & respect == 0 & explain == 0 & time == 0 & satisfaction == 0 
replace combined = 1 if listening == 1 | respect == 1 | explain == 1 | time == 1 | satisfaction == 1 
label var combined "Low-Quality Health Care"
label values combined yesno

// Any Health Care Discrimination or Low-Quality Care
/* 0: no; 1: yes */
gen discrimination_combined = .
replace discrimination_combined = 0 if combined == 0 & discrimination == 0
replace discrimination_combined = 1 if combined == 1 | discrimination == 1
label var discrimination_combined "Health Care Discrimination or Low-Quality Care"
label values discrimination_combined yesno

*********************
** Outcome: Health **
*********************

// Low Perceived Health
/* health today was poor or fair rather than good, very good, or excellent */
/* 0: no; 1: yes */
gen gen_health = .
replace gen_health = 0 if ADGENH42 == 1 | ADGENH42 == 2 | ADGENH42 == 3
replace gen_health = 1 if ADGENH42 == 4 | ADGENH42 == 5
label var gen_health "Low Perceived Health"
label values gen_health yesno
drop ADGENH42

// Serious Psychological Distress (K6)
/* scored a 13 or higher over the past 30 days on the Kessler-6 Index */
/* 0: no; 1: yes */
gen distress = .
replace distress = 0 if K6SUM42 >= 0 & K6SUM42 <= 12
replace distress = 1 if K6SUM42 >= 13 & K6SUM42 <= 24
label var distress "Serious Psychological Distress (K6)"
label values distress yesno
drop K6SUM42

// Depressed Mood (PHQ-2)
/* scored a 3 or higher over the past 2 weeks on the PHQ-2 */
/* 0: no; 1: yes */
gen depressed = .
replace depressed = 0 if PHQ242 >= 0 & PHQ242 <= 2
replace depressed = 1 if PHQ242 >= 3 & PHQ242 <= 6
label var depressed "Depressed Mood (PHQ-2)"
label values depressed yesno
drop PHQ242 

// High-Impact Pain
/* pain that interfered with your normal work [work outside the home and housework] moderately, extremely, or quite a bit over the past 4 weeks */
/* 0: no; 1: yes */
gen pain = .
replace pain = 0 if ADPAIN42 == 1 | ADPAIN42 == 2
replace pain = 1 if ADPAIN42 == 3 | ADPAIN42 == 4 | ADPAIN42 == 5
label var pain "High-Impact Pain"
label values pain yesno
drop ADPAIN42

// Save Full Clean Pooled Data
save data_pooled.dta, replace

**********************************
**** PART 3:                  ****
**** MERGE IN POOLED VARIANCE ****
**********************************

// Merge in Variance Structure
use h36u23.dta, clear
keep DUPERSID PANEL STRA9623 PSU9623
save variance_temp.dta, replace
use data_pooled.dta, clear
merge 1:1 DUPERSID PANEL using variance_temp.dta
keep if _merge == 3 

***********************
**** PART 4:       ****
**** CREATE SAMPLE ****
***********************

// Note: Output Used for eFigure 1 (Flow Chart)

// Limit Dataset to SAQ and/or SDOH Survey Respondents
count
keep if SAQELIG == 1 | SDOHELIG == 1
count

// Create Sample Flag for SAQ Respondents
gen mainsample = .
label var mainsample "Main Sample Flag"
replace mainsample = 1 if SAQELIG == 1 
count if mainsample == 1

// Limit to Respondents who Reported 1+ Health Care Visits
replace mainsample = . if any_visits == . | any_visits == 0
count if mainsample == 1

// Exclude Respondents from Sample Flag with Missing Data on Disability
replace mainsample = . if disability == .
count if mainsample == 1

// Exclude Respondents from Sample Flag with Missing Data on Covariates
foreach lname in age sex race ethnicity education income insurance {
replace mainsample = . if `lname' == .
count if mainsample == 1
}

// Exclude Respondents from Sample Flag with Missing Data on Health Care Quality
replace mainsample = . if combined == .
count if mainsample == 1

// Exclude Respondents from Sample Flag with Missing Data on Health Outcomes
foreach lname in gen_health distress depressed pain {
replace mainsample = . if `lname' == .
count if mainsample == 1
}

// Create Subsample Flag
generate subsample = 1 if mainsample == 1 & SDOHELIG == 1
label var subsample "Subsample Flag"
count if mainsample == 1 & subsample == .
count if subsample == 1

// Exclude Respondents from Subsample Flag with Missing Data on Health Care Discrimination
replace subsample = . if discrimination == .
count if subsample == 1

// Save Dataset
drop SAQELIG SDOHELIG year _merge
save dataset.dta, replace
erase data_pooled.dta
erase variance_temp.dta

****************
** End of File *
****************
