************************************************************************************************************
** Health Care Discrimination, Low-Quality Care, and the Health of Disabled U.S. Adults, MEPS 2015-2023
** Code by Dielle J. Lundberg
** Last Updated: December 23, 2025
** Code File 3 of 4: Main Tables and Figures
************************************************************************************************************

// Set Directory to Folder Where Data Are Saved
cd "/Users/djlwork/Library/Mobile Documents/com~apple~CloudDocs/Independent Research/MEPS-Ableism-Health-Care-Project/MEPS-Ableism-Health-Care-Code-12-2025/"

*****************************************************************************************************************
** Figure 1. Risk of Experiencing Health Care Discrimination and Low-Quality Care for Disabled and Nondisabled **
** U.S. Adults Seeking Health Care                                                                             **
*****************************************************************************************************************

// Load Data and Set Output
use dataset.dta, clear
putexcel set "main-text.xlsx", sheet("figure-1", replace) modify

// Set Survey Weights (SDOH Survey Subsample)
svyset [pweight=SDOHWT], strata(STRA9623) psu(PSU9623) 
local num = 1 

// Risk of Health Care Discrimination by Disability
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
foreach lname in discrimination_combined discrimination {
svy, subpop(if subsample == 1): logistic `lname' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.disability, post
putexcel A`num' = "`r(predict1_label)'"
lincom _b[0.disability] * 1000
putexcel B`num' = `r(estimate)'
putexcel C`num' = `r(lb)'
putexcel D`num' = `r(ub)'
lincom _b[1.disability] * 1000
putexcel E`num' = `r(estimate)'
putexcel F`num' = `r(lb)'
putexcel G`num' = `r(ub)'
nlcom ((_b[1.disability] / _b[0.disability]) - 1) * 100
putexcel H`num' = mat(r(table)[1,1])
putexcel I`num' = mat(r(table)[5,1])
putexcel J`num' = mat(r(table)[6,1])
local num = `num' + 1
}

// Set Survey Weights
svyset [pweight=SAQWT], strata(STRA9623) psu(PSU9623)

// Risk of Low-Quality Health Care by Disability
// Main sample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, survey year, proxy-reported disability, and proxy-reported SAQ
foreach lname in combined listening explain respect time satisfaction {
svy, subpop(if mainsample == 1): logistic `lname' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year i.proxy_disability i.proxy_saq
margins i.disability, post
putexcel A`num' = "`r(predict1_label)'"
lincom _b[0.disability] * 1000
putexcel B`num' = `r(estimate)'
putexcel C`num' = `r(lb)'
putexcel D`num' = `r(ub)'
lincom _b[1.disability] * 1000
putexcel E`num' = `r(estimate)'
putexcel F`num' = `r(lb)'
putexcel G`num' = `r(ub)'
nlcom ((_b[1.disability] / _b[0.disability]) - 1) * 100
putexcel H`num' = mat(r(table)[1,1])
putexcel I`num' = mat(r(table)[5,1])
putexcel J`num' = mat(r(table)[6,1])
local num = `num' + 1
}

************************************************************************************************************
** Figure 2. Differences in Health for Disabled and Nondisabled Adults and for Adults Who Did and Did Not **
** Experience Health Care Discrimination or Low-Quality Health Care                                       **
************************************************************************************************************

// Load Data and Set Output
use dataset.dta, clear
putexcel set "main-text.xlsx", sheet("figure-2", replace) modify

// Set Survey Weights
svyset [pweight=SAQWT], strata(STRA9623) psu(PSU9623) 
local num = 1 

// Health Risks by Disability
// Main sample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, survey year, proxy-reported disability, and proxy-reported SAQ
foreach health in gen_health distress depressed pain {
svy, subpop(if mainsample == 1): logistic `health' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year i.proxy_disability i.proxy_saq
margins i.disability, post
lincom _b[0.disability] * 1000
putexcel A`num' = "`health'"
putexcel B`num' = `r(estimate)'
putexcel C`num' = `r(lb)'
putexcel D`num' = `r(ub)'
lincom _b[1.disability] * 1000
putexcel E`num' = `r(estimate)'
putexcel F`num' = `r(lb)'
putexcel G`num' = `r(ub)'
nlcom ((_b[1.disability] / _b[0.disability]) - 1) * 100
putexcel H`num' = mat(r(table)[1,1])
putexcel I`num' = mat(r(table)[5,1])
putexcel J`num' = mat(r(table)[6,1])
local num = `num' + 1
}

// Set Survey Weights (SDOH Survey Subsample)
svyset [pweight=SDOHWT], strata(STRA9623) psu(PSU9623) 

// Health Risk by Exposure to Health Care Discrimination or Low-Quality Care
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
foreach health in gen_health distress depressed pain {
svy, subpop(if subsample == 1): logistic `health' i.discrimination_combined i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.discrimination_combined, post
lincom _b[0.discrimination_combined] * 1000
putexcel A`num' = "`health'"
putexcel B`num' = `r(estimate)'
putexcel C`num' = `r(lb)'
putexcel D`num' = `r(ub)'
lincom _b[1.discrimination_combined] * 1000
putexcel E`num' = `r(estimate)'
putexcel F`num' = `r(lb)'
putexcel G`num' = `r(ub)'
nlcom ((_b[1.discrimination_combined] / _b[0.discrimination_combined]) - 1) * 100
putexcel H`num' = mat(r(table)[1,1])
putexcel I`num' = mat(r(table)[5,1])
putexcel J`num' = mat(r(table)[6,1])
local num = `num' + 1
}

// Health Risk for Disabled Adults by Exposure to Health Care Discrimination or Low-Quality Care
// Subsample and limited to disabled adults; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
foreach health in gen_health distress depressed pain {
svy, subpop(if subsample == 1 & disability == 1): logistic `health' i.discrimination_combined i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.discrimination_combined, post
lincom _b[0.discrimination_combined] * 1000
putexcel A`num' = "`health'"
putexcel B`num' = `r(estimate)'
putexcel C`num' = `r(lb)'
putexcel D`num' = `r(ub)'
lincom _b[1.discrimination_combined] * 1000
putexcel E`num' = `r(estimate)'
putexcel F`num' = `r(lb)'
putexcel G`num' = `r(ub)'
nlcom ((_b[1.discrimination_combined] / _b[0.discrimination_combined]) - 1) * 100
putexcel H`num' = mat(r(table)[1,1])
putexcel I`num' = mat(r(table)[5,1])
putexcel J`num' = mat(r(table)[6,1])
local num = `num' + 1
} 

****************************************************************************************
** Table 1. Characteristics of MEPS Adults Reporting at Least One Visit to a Doctor's **
** Office or Clinic in the Last 12 Months, 2015-2023                                  **
****************************************************************************************

// Load Data
use dataset.dta, clear

// Set Survey Weights (SAQ Sample)
svyset [pweight=SAQWT], strata(STRA9623) psu(PSU9623) 

// Descriptive Statistics for Main Sample
dtable i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year 1.proxy_disability 1.proxy_saq 1.combined 1.gen_health 1.distress 1.depressed 1.pain, svy subpop(if mainsample == 1) by(disability) sample(,statistics(freq percent) place(seplabels)) factor(,statistics(fvrawfreq fvpercent)) nformat(%7.0fc)
collect style header proxy_disability proxy_saq combined gen_health distress depressed pain, level(hide)
collect preview
collect export "main-text.xlsx", sheet("table-1a", replace) modify
dtable, svy subpop(if mainsample == 1) by(disability) sample(,statistics(sumw))
collect export "main-text.xlsx", sheet("table-1a") modify cell(A70)

// Set Survey Weights (SDOH Survey Subsample)
svyset [pweight=SDOHWT], strata(STRA9623) psu(PSU9623) 

// Descriptive Statistics for Subsample
dtable i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year 1.proxy_disability 1.proxy_saq 1.proxy_sdoh 1.combined 1.discrimination 1.gen_health 1.distress 1.depressed 1.pain, svy subpop(if subsample == 1) by(disability) sample(,statistics(freq percent)) factor(,statistics(fvrawfreq fvpercent)) nformat(%7.0fc)
collect style header proxy_disability proxy_saq proxy_sdoh combined discrimination gen_health distress depressed pain, level(hide)
collect export "main-text.xlsx", sheet("table-1b", replace) modify

*************************************************************************************************************
** Table 2. Population Differences in Physical and Mental Health Risks for Disabled vs. Nondisabled Adults **
** Explained by Differences in Exposure to Health Care Discrimination and Low-Quality Health Care          **
*************************************************************************************************************

// Load Data and Set Output
use dataset.dta, clear

// Set Survey Weights (SAQ Sample)
svyset [pweight=SAQWT], strata(STRA9623) psu(PSU9623) 

// Calculate Weighted Population of Disabled U.S. Adults Seeking Health Care
svy, subpop(if mainsample == 1): total i.disability
matrix M = r(table)
scalar disabled_pop = M[1,2]

// PAF Calculation Bootstrap Program #1
capture program drop paf_bootstrap1
program define paf_bootstrap1, rclass

// Loop Health Outcomes
local num = 1
foreach health in gen_health distress depressed pain {

// Calculate Risk When Exposure Is As Observed
// Main sample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, survey year, proxy-reported disability, and proxy-reported SAQ
svy, subpop(if mainsample == 1): logistic `health' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year i.proxy_disability i.proxy_saq
margins i.disability, post
scalar nondis_obs = r(b)[1,1]
scalar dis_obs = r(b)[1,2]

// Calculate Risk When Exposure Is Zero
// Main sample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, survey year, proxy-reported disability, and proxy-reported SAQ
svy, subpop(if mainsample == 1): logistic `health' i.disability combined i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.survey_year i.proxy_disability i.proxy_saq
margins i.disability, at(combined=(0)) post
scalar nondis_0 = r(b)[1,1]
scalar dis_0 = r(b)[1,2]

// Calculate PAF, PAR and Naitonal Estimates
scalar paf_`health' = (((dis_obs - dis_0) - (nondis_obs - nondis_0)) / (dis_obs - nondis_obs)) * 100
scalar par_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * 1000
scalar national_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * disabled_pop
}

// Return Values
return scalar paf_gen_health = paf_gen_health
return scalar paf_distress = paf_distress
return scalar paf_depressed = paf_depressed
return scalar paf_pain = paf_pain
return scalar par_gen_health = par_gen_health
return scalar par_distress = par_distress
return scalar par_depressed = par_depressed
return scalar par_pain = par_pain
return scalar national_gen_health = national_gen_health
return scalar national_distress = national_distress
return scalar national_depressed = national_depressed
return scalar national_pain = national_pain
end

// Run Bootstrap (1000 reps)
bootstrap ///
paf_gen_health = r(paf_gen_health) par_gen_health = r(par_gen_health) national_gen_health = r(national_gen_health) ///
paf_distress = r(paf_distress) par_distress = r(par_distress) national_distress = r(national_distress) ///
paf_depressed = r(paf_depressed) par_depressed = r(par_depressed) national_depressed = r(national_depressed) ///
paf_pain = r(paf_pain) par_pain = r(par_pain) national_pain = r(national_pain), ///
reps(1000) seed(12345): paf_bootstrap1

// Save Bootstrap Results
estat bootstrap, all
matrix results = e(b)'
putexcel set "main-text.xlsx", sheet("table-2", replace) modify
putexcel A1 = matrix(results)
matrix results = e(ci_normal)'
putexcel B1 = matrix(results)

// Set Survey Weights (SDOH Survey Subsample)
svyset [pweight=SDOHWT], strata(STRA9623) psu(PSU9623) 

// PAF Calculation Bootstrap Program #2
capture program drop paf_bootstrap2
program define paf_bootstrap2, rclass

// Loop Health Outcomes
local num = 1
foreach health in gen_health distress depressed pain {

// Calculate Risk When Exposure Is As Observed
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
svy, subpop(if subsample == 1): logistic `health' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.disability, post
scalar nondis_obs = r(b)[1,1]
scalar dis_obs = r(b)[1,2]

// Calculate Risk When Exposure Is Zero
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
svy, subpop(if subsample == 1): logistic `health' i.disability discrimination i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.disability, at(discrimination=(0)) post
scalar nondis_0 = r(b)[1,1]
scalar dis_0 = r(b)[1,2]

// Calculate PAF, PAR and Naitonal Estimates
scalar paf_`health' = (((dis_obs - dis_0) - (nondis_obs - nondis_0)) / (dis_obs - nondis_obs)) * 100
scalar par_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * 1000
scalar national_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * disabled_pop
}

// Return Values
return scalar paf_gen_health = paf_gen_health
return scalar paf_distress = paf_distress
return scalar paf_depressed = paf_depressed
return scalar paf_pain = paf_pain
return scalar par_gen_health = par_gen_health
return scalar par_distress = par_distress
return scalar par_depressed = par_depressed
return scalar par_pain = par_pain
return scalar national_gen_health = national_gen_health
return scalar national_distress = national_distress
return scalar national_depressed = national_depressed
return scalar national_pain = national_pain
end

// Run Bootstrap (1000 reps)
bootstrap ///
paf_gen_health = r(paf_gen_health) par_gen_health = r(par_gen_health) national_gen_health = r(national_gen_health) ///
paf_distress = r(paf_distress) par_distress = r(par_distress) national_distress = r(national_distress) ///
paf_depressed = r(paf_depressed) par_depressed = r(par_depressed) national_depressed = r(national_depressed) ///
paf_pain = r(paf_pain) par_pain = r(par_pain) national_pain = r(national_pain), ///
reps(1000) seed(12345): paf_bootstrap2

// Save Bootstrap Results
estat bootstrap, all
putexcel set "main-text.xlsx", sheet("table-2") modify
matrix results = e(b)'
putexcel A21 = matrix(results)
matrix results = e(ci_normal)'
putexcel B21 = matrix(results)

// PAF Calculation Bootstrap Program #3
capture program drop paf_bootstrap3
program define paf_bootstrap3, rclass

// Loop Health Outcomes
local num = 1
foreach health in gen_health distress depressed pain {

// Calculate Risk When Exposure Is As Observed
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
svy, subpop(if subsample == 1): logistic `health' i.disability i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.disability, post
scalar nondis_obs = r(b)[1,1]
scalar dis_obs = r(b)[1,2]

// Calculate Risk When Exposure Is Zero
// Subsample; adjusted for age, sex, race, ethnicity, education, income, health insurance, number of visits, proxy-reported disability, proxy-reported SAQ, and proxy-reported SDOH
svy, subpop(if subsample == 1): logistic `health' i.disability discrimination_combined i.age i.sex i.race i.ethnicity i.education i.income i.insurance i.visits i.proxy_disability i.proxy_saq i.proxy_sdoh
margins i.disability, at(discrimination_combined=(0)) post
scalar nondis_0 = r(b)[1,1]
scalar dis_0 = r(b)[1,2]

// Calculate PAF, PAR and Naitonal Estimates
scalar paf_`health' = (((dis_obs - dis_0) - (nondis_obs - nondis_0)) / (dis_obs - nondis_obs)) * 100
scalar par_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * 1000
scalar national_`health' = ((dis_obs - dis_0) - (nondis_obs - nondis_0)) * disabled_pop
}

// Return Values
return scalar paf_gen_health = paf_gen_health
return scalar paf_distress = paf_distress
return scalar paf_depressed = paf_depressed
return scalar paf_pain = paf_pain
return scalar par_gen_health = par_gen_health
return scalar par_distress = par_distress
return scalar par_depressed = par_depressed
return scalar par_pain = par_pain
return scalar national_gen_health = national_gen_health
return scalar national_distress = national_distress
return scalar national_depressed = national_depressed
return scalar national_pain = national_pain
end

// Run Bootstrap (1000 reps)
bootstrap ///
paf_gen_health = r(paf_gen_health) par_gen_health = r(par_gen_health) national_gen_health = r(national_gen_health) ///
paf_distress = r(paf_distress) par_distress = r(par_distress) national_distress = r(national_distress) ///
paf_depressed = r(paf_depressed) par_depressed = r(par_depressed) national_depressed = r(national_depressed) ///
paf_pain = r(paf_pain) par_pain = r(par_pain) national_pain = r(national_pain), ///
reps(1000) seed(12345): paf_bootstrap3

// Save Bootstrap Results
estat bootstrap, all
putexcel set "main-text.xlsx", sheet("table-2") modify
matrix results = e(b)'
putexcel A41 = matrix(results)
matrix results = e(ci_normal)'
putexcel B41 = matrix(results)

****************
** End of File *
****************
