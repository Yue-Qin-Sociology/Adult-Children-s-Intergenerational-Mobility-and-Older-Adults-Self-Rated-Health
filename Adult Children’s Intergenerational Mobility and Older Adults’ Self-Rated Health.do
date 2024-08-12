*******************************
*adult children's social mobility and parents' health
* Yue Qin 08.10.2024
*******************************

****************CHARLS****************

//download 2011, 2013, 2014, 2015, and the harmonized CHARLS data (2011-2018) from the official website
***https://charls.pku.edu.cn/en/

***step 1: get information on children's education

//use 2013 CHARLS child data 
use "CHARLS2013\Child.dta", clear
//our sample includes respondents who had at least one child aged 25 or older, so we need to check children's birthyear 
tab cb051_1,m
//4322 missing
tab age, m 
//2429 missing 
//to keep as many children as possible, I will use information from the 2015 CHARLS to impute children's birthyear 
clear 
//use 2015 CHARLS child data 
use "CHARLS2015\Child.dta", clear
egen childID1 = concat( ID childID )
//for the sake of later merge with 2013 CHARLS child.dta

gen byear2 = 2015 - age
replace byear = byear2 if byear >=. & byear2 <.
//because byear (direct report) also has missing values, I use age to impute these missing values 
keep ID householdID childID1 byear
save 2015child.dta

//reopen 2013 CHARLS child data 
use "CHARLS2013\Child.dta", clear
drop if alive == 0
//1297 dropped

egen childID1 = concat( ID childID )
merge 1:1 childID1 using 2015child.dta
drop if _merge ==2
drop _merge
//merge with 2015 CHARLS child data

gen birthyear = cb051_1
replace birthyear = 2013 - age if birthyear >= . & age < .
replace birthyear = byear if birthyear >= . & byear <.
tab birthyear,m
//still 1036 missing values, but much better than before 

keep ID childID householdID birthyear cb060
//cb060 is child's highest educational level

reshape wide birthyear cb060, i(ID) j(childID)
//reshape from long format to wide format (each line corresponds to one family with all children's information)

merge 1:1 ID using H_CHARLS_D_Data.dta, keepusing(ID householdID r2famr inw2)
//merge with harmonized CHARLS data which included 2011-2018 data 

keep if inw2 == 1
//respondents who participated in 2013 CHARLS
 
drop _merge
//merge with respondents' ID 

sort householdID

for var cb0601 - birthyear16: replace X= X[_n+1] if r2famr==0 & householdID==householdID[_n+1]
for var cb0601 - birthyear16: replace X= X[_n-1] if r2famr==0 & householdID==householdID[_n-1]
//child.dta is at the family level, and it is only merged with the ID who reported family information, so we need to copy information to the other member in the same family 

//now we have each respondent's children's information 

//whether the oldest child is younger than 25
egen birthx = rowmin(birthyear1 birthyear2 birthyear3 birthyear4 birthyear5 birthyear6 birthyear7 birthyear8 birthyear9 birthyear10 birthyear11 birthyear12 birthyear13 birthyear14 birthyear15 birthyear16)
sum birthx
//2013-25=1988
gen birththre = 1 if birthx <= 1988
replace birththre = 0 if birthx > 1988 & birthx < .
tab birththre
//15734 respondents had at least one child aged 25+ in 2013

reshape long birthyear cb060, i(ID) j(kid)
//reshape from wide to long 

drop if birthyear >=.
replace cb060 = . if birthyear > 1988 & birthyear <.
//the educational attainment of children whose ages were below 25 in 2013 will not be considered in later analysis 


//get kids' educational ranking by cohort
rename birthyear birthy

tab birthy,m

xtile kidedu_t1 = cb060 if birthy < 1945, nq(3)
xtile kidedu_t2 = cb060 if birthy >= 1945 & birthy <= 1949, nq(3)
xtile kidedu_t3 = cb060 if birthy == 1950, nq(3)
xtile kidedu_t4 = cb060 if birthy == 1951, nq(3)
xtile kidedu_t5 = cb060 if birthy == 1952, nq(3)
xtile kidedu_t6 = cb060 if birthy == 1953, nq(3)
xtile kidedu_t7 = cb060 if birthy == 1954, nq(3)
xtile kidedu_t8 = cb060 if birthy == 1955, nq(3)
xtile kidedu_t9 = cb060 if birthy == 1956, nq(3)
xtile kidedu_t10 = cb060 if birthy == 1957, nq(3)
xtile kidedu_t11 = cb060 if birthy == 1958, nq(3)
xtile kidedu_t12 = cb060 if birthy == 1959, nq(3)
xtile kidedu_t13 = cb060 if birthy == 1960, nq(3)
xtile kidedu_t14 = cb060 if birthy == 1961, nq(3)
xtile kidedu_t15 = cb060 if birthy == 1962, nq(3)
xtile kidedu_t16 = cb060 if birthy == 1963, nq(3)
xtile kidedu_t17 = cb060 if birthy == 1964, nq(3)
xtile kidedu_t18 = cb060 if birthy == 1965, nq(3)
xtile kidedu_t19 = cb060 if birthy == 1966, nq(3)
xtile kidedu_t20 = cb060 if birthy == 1967, nq(3)
xtile kidedu_t21 = cb060 if birthy == 1968, nq(3)
xtile kidedu_t22 = cb060 if birthy == 1969, nq(3)
xtile kidedu_t23 = cb060 if birthy == 1970, nq(3)
xtile kidedu_t24 = cb060 if birthy == 1971, nq(3)
xtile kidedu_t25 = cb060 if birthy == 1972, nq(3)
xtile kidedu_t26 = cb060 if birthy == 1973, nq(3)
xtile kidedu_t27 = cb060 if birthy == 1974, nq(3)
xtile kidedu_t28 = cb060 if birthy == 1975, nq(3)
xtile kidedu_t29 = cb060 if birthy == 1976, nq(3)
xtile kidedu_t30 = cb060 if birthy == 1977, nq(3)
xtile kidedu_t31 = cb060 if birthy == 1978, nq(3)
xtile kidedu_t32 = cb060 if birthy == 1979, nq(3)
xtile kidedu_t33 = cb060 if birthy == 1980, nq(3)
xtile kidedu_t34 = cb060 if birthy == 1981, nq(3)
xtile kidedu_t35 = cb060 if birthy == 1982, nq(3)
xtile kidedu_t36 = cb060 if birthy == 1983, nq(3)
xtile kidedu_t37 = cb060 if birthy == 1984, nq(3)
xtile kidedu_t38 = cb060 if birthy == 1985, nq(3)
xtile kidedu_t39 = cb060 if birthy == 1986, nq(3)
xtile kidedu_t40 = cb060 if birthy == 1987, nq(3)
xtile kidedu_t41 = cb060 if birthy == 1988, nq(3)

egen kidedur = rowmax( kidedu_t1 - kidedu_t41 )
//get each child's educational ranking by cohort 

keep ID householdID kid birthy cb060 kidedur birththre birthx
reshape wide birthy cb060 kidedur, i(ID) j(kid)
//reshape data from long format to wide format 

egen kidedurmax_c = rowmax(kidedur1 kidedur2 kidedur3 kidedur4 kidedur5 kidedur6 kidedur7 kidedur8 kidedur9 kidedur10 kidedur11)
//the highest ranking of all children's education 

egen kidedurmin_c = rowmin(kidedur1 kidedur2 kidedur3 kidedur4 kidedur5 kidedur6 kidedur7 kidedur8 kidedur9 kidedur10 kidedur11)
//the lowest ranking of all children's education 

egen abkidedumax = rowmax(cb0601 cb0602 cb0603 cb0604 cb0605 cb0606 cb0607 cb0608 cb0609 cb06010 cb06011)
//the highest level of all children's education 

egen abkidedumin = rowmin(cb0601 cb0602 cb0603 cb0604 cb0605 cb0606 cb0607 cb0608 cb0609 cb06010 cb06011)
//the lowest level of all children's education 

save 2013child.dta

*** Step 2: use the main dataset for estimation 

//use the harmonized CHARLS data which included 2011-2018 CHARLS 
use H_CHARLS_D_Data.dta, clear

//data cleaning and recoding

//age in 2013
gen r1age = 2011- rabyear
gen r2age = 2013- rabyear

//gender
rename ragender female
recode female(1=0)(2=1)

//marital status in 2013 
recode r2mstat (1 3=1)(4 5 7 8=0)

///self-rated health 
//I need to use the original coding in 2013 instead of harmonized "r2shlt" because r2shlt has more missing values than the original variable from 2013 CHARLS 
merge 1:1 ID using CHARLS2013\Health_Status_and_Functioning.dta, keepusing(da001 da002)
drop if _merge == 2
drop _merge


//self-rated health in 2013
gen health2 = da001
recode health2 (1 2 3=2)(4=1)(5=0)
replace health2 = 2 if da002 <3
replace health2 = 1 if da002 == 3
replace health2 = 0 if da002 == 4 | da002 == 5

tab health2
tab r2shlt
//health2 has fewer missing values than r2shlt 

rename da001 da001_2
rename da002 da002_2

//self-rated health in 2011
merge 1:1 ID using 2011health.dta
//note that when merging with data from 2011, change ID in 2011 first because 2011 CHARLS has different ID format from other waves 
//replace householdID = householdID + "0"
//replace ID = householdID + substr(ID,-2,2)

drop if _merge ==2
drop _merge

gen health1 = da001
recode health1 (1 2 3=2)(4=1)(5=0)
replace health1 = 2 if da002 <3
replace health1 = 1 if da002 == 3
replace health1 = 0 if da002 == 4 | da002 == 5

tab health1
tab r1shlt
//health1 has fewer missing values than r1shlt 

//standardize cesd (depressive symptoms in 2013)
egen r2cesd102 = std(r2cesd10)
replace r2cesd10 = r2cesd102

///social engagement in 2013 
//in 2013 CHARLS, we use the following code to get social engagement 
//egen social = rowmin( da057_1_ da057_2_ da057_3_ da057_4_ da057_5_ da057_6_ da057_7_ da057_8_ da057_9_ da057_10_ da057_11_)
//tab social
//replace social = 4 if da056s12 == 12
//recode social (1=0)(2=1)(3=2)(4=3)
//save CHARLS2013\Health_Status_and_Functioning.dta, replace

merge 1:1 ID using CHARLS2013\Health_Status_and_Functioning.dta, keepusing(social)
drop if _merge ==2
drop _merge

rename social r2social
//0:daily, 1:every week; 2:not regularly 3:no activities 
recode r2social (0 1=1)(2 3=0)

//merge 2013 child data 
merge 1:1 ID using 2013child.dta
drop if _merge ==2
drop _merge



//sample

//response rate:
tab r1iwstat r2iwstat
//25586 in total, 18612 respondents in 2013

keep if r2iwstat == 1 
//now 18612 cases remain 

drop if r1age < 50
//4929 deleted, now only 13683 cases remain
//I drop those who were aged less than 50 years old in 2011 because HRS only covers those aged 50 and above. 

//drop those who did not have any children 
drop if h2child == 0
//360 deleted
drop if h1child == 0
//171 deleted 

//the analytic sample does not include those with missing values in the dependent variable 
tab health2,m
//105 cases missing

//drop those whose oldest child is younger than 25 in 2013
drop if birththre == 0
//247
//now only 12905 remain 

//educational attainment 
rename raeduc_c edu

//recode missingness to facilitate counting missing values and later imputation 
replace female = . if female > .
replace r2mstat = . if r2mstat > .
replace r2hukou = . if r2hukou > .
replace r2work = . if r2work > .
replace h2coresd = . if h2coresd > .
replace h2fcamt= . if h2fcamt > .
replace r2cesd10 = . if r2cesd10 >.
replace health1 = . if health1 >.
replace edu =. if edu >.


tab r2age
//get respondents' educational ranking by cohort 
xtile edu_t1 = edu if r2age == 52, nq(3)
xtile edu_t2 = edu if r2age == 53, nq(3)
xtile edu_t3 = edu if r2age == 54, nq(3)
xtile edu_t4 = edu if r2age == 55, nq(3)
xtile edu_t5 = edu if r2age == 56, nq(3)
xtile edu_t6 = edu if r2age == 57, nq(3)
xtile edu_t7 = edu if r2age == 58, nq(3)
xtile edu_t8 = edu if r2age == 59, nq(3)
xtile edu_t9 = edu if r2age == 60, nq(3)
xtile edu_t10 = edu if r2age == 61, nq(3)
xtile edu_t11 = edu if r2age == 62, nq(3)
xtile edu_t12 = edu if r2age == 63, nq(3)
xtile edu_t13 = edu if r2age == 64, nq(3)
xtile edu_t14 = edu if r2age == 65, nq(3)
xtile edu_t15 = edu if r2age == 66, nq(3)
xtile edu_t16 = edu if r2age == 67, nq(3)
xtile edu_t17 = edu if r2age == 68, nq(3)
xtile edu_t18 = edu if r2age == 69, nq(3)
xtile edu_t19 = edu if r2age == 70, nq(3)
xtile edu_t20 = edu if r2age == 71, nq(3)
xtile edu_t21 = edu if r2age == 72, nq(3)
xtile edu_t22 = edu if r2age == 73, nq(3)
xtile edu_t23 = edu if r2age == 74, nq(3)
xtile edu_t24 = edu if r2age == 75, nq(3)
xtile edu_t25 = edu if r2age == 76, nq(3)
xtile edu_t26 = edu if r2age == 77, nq(3)
xtile edu_t27 = edu if r2age == 78, nq(3)
xtile edu_t28 = edu if r2age == 79, nq(3)
xtile edu_t29 = edu if r2age == 80, nq(3)
xtile edu_t30 = edu if r2age == 81, nq(3)
xtile edu_t31 = edu if r2age >= 82 & r2age <= 84, nq(3)
xtile edu_t32 = edu if r2age >= 85 & r2age <= 87, nq(3)
xtile edu_t33 = edu if r2age >= 88 & r2age <= 103, nq(3)
egen edu_t = rowmax( edu_t1 - edu_t33 )


gen rm1 = kidedurmax_c - edu_t
//use the highest children's educational ranking
gen rm2 = kidedurmin_c - edu_t
//use the lowest children's educational ranking 

tab rm1
tab rm2

//economic support from children 
//2013
gen h2fcamt2 = 2*h2fcamt
//two-years economic transfer (because HRS asked about two years)
gen h2fcamt3 = h2fcamt2 / 1000
//in thousands

gen logcs13g = log(h2fcamt3 + 0.1)
//log-transformed 


//years of education 
gen eduy = edu
recode eduy (1=0)(2 3=3)(4=6)(5=9)(6 7=12)(8=15)(9=16)(10=19)(11=22)
//children's years of education 
//the highest 
recode abkidedumax (1=0)(2 3=3)(4=6)(5=9)(6 7=12)(8=15)(9=16)(10=19)(11=22)
//the lowest 
recode abkidedumin (1=0)(2 3=3)(4=6)(5=9)(6 7=12)(8=15)(9=16)(10=19)(11=22)
//children's abosolute mobility in education 
//the highest
gen amo1 = abkidedumax - eduy
//the lowest 
gen amo2 = abkidedumin - eduy

//hukou in 2013
recode r2hukou(1=1)(2 3 4=0)



//analytical sample 
count if health2 < . & r2wtrespb <.
//12,551

//check missingness in other variables
//these variables have few missing values, so I use listwise deletion for their missingness  
tab female,m
//1 missing value 
tab r2mstat,m 
//1 missing value 
tab edu,m 
//7 missing values 
tab r2age,m 
//89 missing values 
tab r2hukou, m 
//37 missing values 

//no missing values: h2child h2coresd

//these variables have a large number of missing values, so I will use multiple imputation with chained equations to deal with their missing values 
tab rm1,m
//2.81%; 363
tab rm2,m 
//2.81%; 363
tab r2social,m 
//9.17%; 1183
tab logcs13g,m 
//13.04%; 1683
tab r2work,m 
//2.64%;341
tab r2cesd10,m 
//10.54%; 1360
tab health1,m 
//12.87%; 1661


//therefore, the final analytical sample is
count if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < . 
//12445

//report the size of missing values 
misschk rm1 rm2 r2social logcs13g r2cesd10 r2work health1 if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .


//descriptive statistics 
svyset communityID [pweight = r2wtrespb]
svy: tab health2 if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .
svy: mean r2age if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .
estat sd
//use these codes for other variables; depending on the coding of the variable; continuous variables use svy: mean and estat sd, while categorical variables use svy: tab. 

//Appendix Table 12 
gen cohort =1 if rabyear >= 1908 & rabyear <= 1929
replace cohort =2 if rabyear >= 1930 & rabyear <= 1939
replace cohort =3 if rabyear >= 1940 & rabyear <= 1949
replace cohort =4 if rabyear >= 1950 & rabyear <= 1961

svy: mean eduy if edu_t == 3 & female ==1 & cohort ==1 & health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .
estat sd
svy: mean eduy if edu_t == 3 & female ==1 & cohort ==2 & health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .

svy: mean eduy if edu_t == 3 & female ==1 & cohort ==3 & health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .

svy: mean eduy if edu_t == 3 & female ==1 & cohort ==4 & health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .
//repeat the codes above for different educational ranks, different genders, and different cohorts. 

***multiple imputation with chained equations 

mi set wide
mi register imputed rm1 rm2 r2social logcs13g r2work r2cesd10 health1 
mi register regular r2age female edu r2mstat r2hukou h2child health2 h2coresd
mi impute chained (reg)rm1 rm2 logcs13g r2cesd10 (mlogit)health1 (logit)r2social r2work= r2age female edu r2mstat r2hukou h2child health2 h2coresd if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < ., rseed(1) add(20) dots
 

//categorical measures of children's educational mobility 
mi passive: gen mobility1 = 0 if rm1 < 0
mi passive: replace mobility1 = 1 if rm1 == 0
mi passive: replace mobility1 = 2 if rm1 > 0 & rm1 < .

mi passive: gen mobility2 = 0 if rm2 < 0
mi passive: replace mobility2 = 1 if rm2 == 0
mi passive: replace mobility2 = 2 if rm2 > 0 & rm2 < .


mi svyset communityID [pweight = r2wtrespb]

//not control for self-rated health in 2011 
mi estimate, cmdok dots post: svy: mlogit health2 rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
esttab using models.rtf, b(2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) eform ci(2)

//control for self-rated health in 2011 
mi estimate, cmdok dots post: svy: mlogit health2 rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)
esttab using models.rtf, b(2) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) eform ci(2) append

//khb mediation analysis (whether controlling for health1 seems not to change the results)
//children's economic support 
mi estimate, cmdok dots post: khb mlogit health2 rm1 || logcs13g [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit health2 rm1 || logcs13g [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(2) b(0)
//respondents' social engagement 
mi estimate, cmdok dots post: khb mlogit health2 rm1 || r2social [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit health2 rm1 || r2social [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(2) b(0)
//respondents' depressive symptoms 
mi estimate, cmdok dots post: khb mlogit health2 rm1 || r2cesd10 [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit health2 rm1 || r2cesd10 [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(2) b(0)

//present average marginal effects 
mi estimate, cmdok dots post: svy: mlogit health2 rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)
mimrgns, at(rm1=(-2(1)2)) predict(outcome(2))
mimrgns, at(rm1=(-2(1)2)) predict(outcome(0))
mimrgns, at(rm1=(-2(1)2)) predict(outcome(1)) cmdmargins
mimrgns, dydx(rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1) predict(outcome(0))
mimrgns, dydx(rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1) predict(outcome(1))
mimrgns, dydx(rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1) predict(outcome(2))

****robustness checks 
//use rm2 
mi estimate, cmdok dots post: svy: mlogit health2 rm2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 rm2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)

//use categorical measures of children's educational mobility 
mi estimate, cmdok dots post: svy: mlogit health2 ib1.mobility1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 ib1.mobility1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)

mi estimate, cmdok dots post: svy: mlogit health2 ib1.mobility2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 ib1.mobility2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)


//use 1%-99% children's economic support to avoid the influence of outliers for robustness check 
preserve
sum logcs13g, detail
drop if logcs13g <r(p1) | logcs13g >r(p99)
mi estimate, cmdok dots post: khb mlogit health2 rm1 || logcs13g [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit health2 rm1 || logcs13g [pweight = r2wtrespb], concomitant(r2age female r2mstat edu r2work h2child h2coresd r2hukou health1) outcome(2) b(0)
restore


//use absolute mobility 
preserve 
mi extract 0,clear
//re-run multiple imputation with chained equations and replace rm1 and rm2 with amo1 and amo2 
mi set wide
mi register imputed amo1 amo2 r2social logcs13g r2work r2cesd10 health1 
mi register regular r2age female edu r2mstat r2hukou h2child health2 h2coresd
mi impute chained (reg)amo1 amo2 logcs13g r2cesd10 (mlogit)health1 (logit)r2social r2work= r2age female edu r2mstat r2hukou h2child health2 h2coresd if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < ., rseed(1) add(20) dots
mi svyset communityID [pweight = r2wtrespb]
mi estimate, cmdok dots post: svy: mlogit health2 amo1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 amo1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)

mi estimate, cmdok dots post: svy: mlogit health2 amo2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 amo2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou ib0.health1, b(0)
restore 



//control for childhood health rather than health in 2011 
merge 1:1 ID using CHARLS2014\Health_History.dta, keepusing(hs002)
drop if _merge ==2 
drop _merge 
gen childhealth = hs002 
recode childhealth (1 2=2)(3=1)(4 5=0)
tab hs002 if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < .,m
//12.07% missing, so need imputation 
preserve 
mi extract 0,clear
mi set wide
mi register imputed rm1 rm2 r2social logcs13g r2work r2cesd10 childhealth  
mi register regular r2age female edu r2mstat r2hukou h2child health2 h2coresd
mi impute chained (reg)amo1 amo2 logcs13g r2cesd10 (mlogit)childhealth (logit)r2social r2work= r2age female edu r2mstat r2hukou h2child health2 h2coresd if health2 < . & r2wtrespb <. & female <. & r2mstat < . & edu < . & r2age < . &  r2hukou < ., rseed(1) add(20) dots
mi svyset communityID [pweight = r2wtrespb]
mi estimate, cmdok dots post: svy: mlogit health2 rm1 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou i.childhealth, b(0)
mi estimate, cmdok dots post: svy: mlogit health2 rm2 r2age female r2mstat i.edu_t r2work h2child h2coresd r2hukou i.childhealth, b(0)
restore 


//use self-rated health in 2015 CHARLS and depressive symptoms in 2013 CHARLS 
use H_CHARLS_D_Data.dta, clear 
merge 1:1 ID using CHARLS2015\Health_Status_and_Functioning.dta, keepusing(da001 da002)
drop if _merge == 2
drop _merge
//self-rated health in 2015
gen health3 = da001
recode health3 (1 2 3=2)(4=1)(5=0)
replace health3 = 2 if da002 <3
replace health3 = 1 if da002 == 3
replace health3 = 0 if da002 == 4 | da002 == 5
rename da001 da001_3
rename da002 da002_3
//then repeat other codes and use health3 as the dependent variable, r2cesd10 as the mediator, and r3wtrespb as the new weights




///use proportions of upward mobility among all children aged 25+
clear 
use 2013child.dta
merge 1:1 ID using H_CHARLS_D_Data.dta, keepusing(edu_t)
keep if _merge == 3 | _merge == 2
drop _merge
reshape long cb060@ birthy@ kidedur@, i(ID) j(kid)
//compare each child's educational ranking with the respondent's
gen comp = 0 if kidedur < edu_t & edu_t <.
replace comp = 1 if kidedur == edu_t & edu_t <.
replace comp = 2 if kidedur > edu_t & kidedur <.
reshape wide cb060 birthy kidedur comp, i(ID) j(kid)
//number of children in each mobility situation 
//number of children in downward mobility 
egen down = anycount( comp1 comp10 comp11 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 ), values(0)
//number of children in non-mobility 
egen nomobile = anycount( comp1 comp10 comp11 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 ), values(1)
//number of children in upward mobility 
egen up = anycount( comp1 comp10 comp11 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 ), values(2)
rename edu_t redu_t
save 2013child.dta, replace
use H_CHARLS_D_Data.dta, clear 
merge 1:1 ID using 2013child.dta
//total number of children as the demominator 
egen cnum = rowtotal(up nomobile down), missing
egen childnum = rowmax(cnum h2child)
//there are some differences between cnum and h2child, I choose the larger one as the demoninator 
//calculate the proportion of children in each mobility situation  
gen downp = down/childnum
gen nomobilep = nomobile/childnum
gen upp = up/childnum
//then repeat other codes and use these new predictors to predict self-rated health in 2013




****************HRS****************

//download HRS data from the official website
**https://hrs.isr.umich.edu/data-products
//RAND HRS Family Data (1992-2014) (both respondents' and kids')
//RAND HRS Longitudinal Data (1992-2016)
//2010 and 2012 HRS 

***step 1: get information on children's education

// use data from RAND HRS Family Data (1992-2014)
use randhrsfamk1992_2014v1.dta, clear

egen birth = rowmin( k1byear k2byear k3byear k4byear k5byear k6byear k7byear k8byear k9byear k10byear k11byear k12byear )
//k1byear-k12byear: birth year of the kid reported in each wave
//birth: birth year of the kid

egen alive = rowmax( k1alive k2alive k3alive k4alive k5alive k6alive k7alive k8alive k9alive k10alive k11alive)
drop if alive == 0
//drop kids who were not alive in these waves
//k1: 1992; k11: 2012

egen edu= rowmax(k1educ k2educ k3educ k4educ k5educ k6educ k7educ k8educ k9educ k10educ k11educ)
//each kid's highest level of education 

replace edu = . if birth > 1987
//2012-25=1987 
//only consider children whose ages were 25+ in 2012

tab birth 
//get children's educational ranking by cohort
xtile kidedu_t1 = edu if birth <= 1925, nq(3)
xtile kidedu_t2 = edu if birth > 1925 & birth <= 1927, nq(3)
xtile kidedu_t3 = edu if birth == 1928, nq(3)
xtile kidedu_t4 = edu if birth == 1929, nq(3)
xtile kidedu_t5 = edu if birth == 1930, nq(3)
xtile kidedu_t6 = edu if birth == 1931, nq(3)
xtile kidedu_t7 = edu if birth == 1932, nq(3)
xtile kidedu_t8 = edu if birth == 1933, nq(3)
xtile kidedu_t9 = edu if birth == 1934, nq(3)
xtile kidedu_t10 = edu if birth == 1935, nq(3)
xtile kidedu_t11 = edu if birth == 1936, nq(3)
xtile kidedu_t12 = edu if birth == 1937, nq(3)
xtile kidedu_t13 = edu if birth == 1938, nq(3)
xtile kidedu_t14 = edu if birth == 1939, nq(3)
xtile kidedu_t15 = edu if birth == 1940, nq(3)
xtile kidedu_t16 = edu if birth == 1941, nq(3)
xtile kidedu_t17 = edu if birth == 1942, nq(3)
xtile kidedu_t18 = edu if birth == 1943, nq(3)
xtile kidedu_t19 = edu if birth == 1944, nq(3)
xtile kidedu_t20 = edu if birth == 1945, nq(3)
xtile kidedu_t21 = edu if birth == 1946, nq(3)
xtile kidedu_t22 = edu if birth == 1947, nq(3)
xtile kidedu_t23 = edu if birth == 1948, nq(3)
xtile kidedu_t24 = edu if birth == 1949, nq(3)
xtile kidedu_t25 = edu if birth == 1950, nq(3)
xtile kidedu_t26 = edu if birth == 1951, nq(3)
xtile kidedu_t27 = edu if birth == 1952, nq(3)
xtile kidedu_t28 = edu if birth == 1953, nq(3)
xtile kidedu_t29 = edu if birth == 1954, nq(3)
xtile kidedu_t30 = edu if birth == 1955, nq(3)
xtile kidedu_t31 = edu if birth == 1956, nq(3)
xtile kidedu_t32 = edu if birth == 1957, nq(3)
xtile kidedu_t33 = edu if birth == 1958, nq(3)
xtile kidedu_t34 = edu if birth == 1959, nq(3)
xtile kidedu_t35 = edu if birth == 1960, nq(3)
xtile kidedu_t36 = edu if birth == 1961, nq(3)
xtile kidedu_t37 = edu if birth == 1962, nq(3)
xtile kidedu_t38 = edu if birth == 1963, nq(3)
xtile kidedu_t39 = edu if birth == 1964, nq(3)
xtile kidedu_t40 = edu if birth == 1965, nq(3)
xtile kidedu_t41 = edu if birth == 1966, nq(3)
xtile kidedu_t42 = edu if birth == 1967, nq(3)
xtile kidedu_t43 = edu if birth == 1968, nq(3)
xtile kidedu_t44 = edu if birth == 1969, nq(3)
xtile kidedu_t45 = edu if birth == 1970, nq(3)
xtile kidedu_t46 = edu if birth == 1971, nq(3)
xtile kidedu_t47 = edu if birth == 1972, nq(3)
xtile kidedu_t48 = edu if birth == 1973, nq(3)
xtile kidedu_t49 = edu if birth == 1974, nq(3)
xtile kidedu_t50 = edu if birth == 1975, nq(3)
xtile kidedu_t51 = edu if birth == 1976, nq(3)
xtile kidedu_t52 = edu if birth == 1977, nq(3)
xtile kidedu_t53 = edu if birth == 1978, nq(3)
xtile kidedu_t54 = edu if birth == 1979, nq(3)
xtile kidedu_t55 = edu if birth == 1980, nq(3)
xtile kidedu_t56 = edu if birth == 1981, nq(3)
xtile kidedu_t57 = edu if birth == 1982, nq(3)
xtile kidedu_t58 = edu if birth == 1983, nq(3)
xtile kidedu_t59 = edu if birth == 1984, nq(3)
xtile kidedu_t60 = edu if birth == 1985, nq(3)
xtile kidedu_t61 = edu if birth == 1986, nq(3)
xtile kidedu_t62 = edu if birth == 1987, nq(3)
egen kidedur = rowmax(kidedu_t1 - kidedu_t62)
//get each child's educational ranking by cohort 

keep hhidpn birth edu kidedur
bysort hhidpn: gen X=_n

reshape wide birth edu kidedur, i(hhidpn) j(X)
//reshape data format from long to wide

egen kidedurmax_c = rowmax(kidedur1 kidedur2 kidedur3 kidedur4 kidedur5 kidedur6 kidedur7 kidedur8 kidedur9 kidedur10 kidedur11 kidedur12 kidedur13 kidedur14 kidedur15 kidedur16 kidedur17 kidedur18 kidedur19 kidedur20 kidedur21 kidedur22 kidedur23 kidedur24 kidedur25 kidedur26 kidedur27 kidedur28 kidedur29 kidedur30 kidedur31 kidedur32 kidedur33)
//get children's highest educational ranking 

egen kidedurmin_c = rowmin(kidedur1 kidedur2 kidedur3 kidedur4 kidedur5 kidedur6 kidedur7 kidedur8 kidedur9 kidedur10 kidedur11 kidedur12 kidedur13 kidedur14 kidedur15 kidedur16 kidedur17 kidedur18 kidedur19 kidedur20 kidedur21 kidedur22 kidedur23 kidedur24 kidedur25 kidedur26 kidedur27 kidedur28 kidedur29 kidedur30 kidedur31 kidedur32 kidedur33)
//get children's lowest educational ranking 

egen birthx = rowmin(birth1 birth2 birth3 birth4 birth5 birth6 birth7 birth8 birth9 birth10 birth11 birth12 birth13 birth14 birth15 birth16 birth17 birth18 birth19 birth20 birth21 birth22 birth23 birth24 birth25 birth26 birth27 birth28 birth29 birth30 birth31 birth32 birth33)
//check children's earliest birth year 
sum birthx
gen birththre = 1 if birthx <= 1987
replace birththre = 0 if birthx > 1987 & birthx <.
//do not consider respondents whose oldest child is younger than 25 years old in 2012
tab birththre

egen abkidmax = rowmax( edu1 edu2 edu3 edu4 edu5 edu6 edu7 edu8 edu9 edu10 edu11 edu12 edu13 edu14 edu15 edu16 edu17 edu18 edu19 edu20 edu21 edu22 edu23 edu24 edu25 edu26 edu27 edu28 edu29 edu30 edu31 edu32 edu33 )
//children's highest educational attainment 

egen abkidmin = rowmin( edu1 edu2 edu3 edu4 edu5 edu6 edu7 edu8 edu9 edu10 edu11 edu12 edu13 edu14 edu15 edu16 edu17 edu18 edu19 edu20 edu21 edu22 edu23 edu24 edu25 edu26 edu27 edu28 edu29 edu30 edu31 edu32 edu33 )
//children's lowest educational attainment
save hrs12child.dta

//get information on children's economic support 
use randhrsfamk1992_2014v1.dta, clear
keep hhidpn k11fcamt
bysort hhidpn: gen X=_n
reshape wide k11fcamt, i(hhidpn) j(X)
egen support11 = rowtotal(k11fcamt1 k11fcamt2 k11fcamt3 k11fcamt4 k11fcamt5 k11fcamt6 k11fcamt7 k11fcamt8 k11fcamt9 k11fcamt10 k11fcamt11 k11fcamt12 k11fcamt13 k11fcamt14 k11fcamt15 k11fcamt16 k11fcamt17 k11fcamt18 k11fcamt19  k11fcamt20 k11fcamt21 k11fcamt22 k11fcamt23 k11fcamt24 k11fcamt25 k11fcamt26 k11fcamt27 k11fcamt28 k11fcamt29  k11fcamt30 k11fcamt31 k11fcamt32 k11fcamt33)

egen rowmiss = rowmiss(k11fcamt1 k11fcamt2 k11fcamt3 k11fcamt4 k11fcamt5 k11fcamt6 k11fcamt7 k11fcamt8 k11fcamt9 k11fcamt10 k11fcamt11 k11fcamt12 k11fcamt13 k11fcamt14 k11fcamt15 k11fcamt16 k11fcamt17 k11fcamt18 k11fcamt19  k11fcamt20 k11fcamt21 k11fcamt22 k11fcamt23 k11fcamt24 k11fcamt25 k11fcamt26 k11fcamt27 k11fcamt28 k11fcamt29  k11fcamt30 k11fcamt31 k11fcamt32 k11fcamt33)

replace support11 = . if rowmiss==33
sum support11

save hrs12childsupport.dta

*** Step 2: use the main dataset for estimation
//use randhrs1992_2016v1.dta, clear 
//select variables starting with r10 (the 2010 wave) and r11 (the 2012 wave), some fundamental sociodemographic and socioeconomic variables (e.g. raedyrs rabyear ragender raracem rahispan), ID (hhidpn hhidpn1), and other variables(h11hhresp h11hhres h10hhresp h10hhres r11lbrf r10lbrf) 
//then save the dataset as hrs1011wavemerged.dta 
use hrs1011wavemerged.dta, clear

merge 1:1 hhidpn using randhrsfamr1992_2014v1.dta, keepusing(h11hhid h11resdkn h10resdkn)
//merge family-level information 
//h11hhid: householdID in 2012
//h11resdkn h10resdkn: number of co-resident children in 2012 and 2010.
drop if _merge ==2
drop _merge

merge 1:1 hhidpn using hrs12child.dta
//merge children's information
drop if _merge ==2 
drop _merge


rename hhidpn HHIDPN
tostring HHIDPN, generate(hhidpn)
merge 1:1 hhidpn using 2012hrs.dta, keepusing(NLB001A NLB001B NLB001C NLB001D NLB001E NLB001F NLB001G NLB001L NLB001N NLB017A NLB017B NLB017C)
//merge information about social engagement from 2012 HRS data 
drop if _merge ==2 
drop _merge

//social engagement in 2012
for var NLB001A NLB001B NLB001C NLB001D NLB001E NLB001F NLB001G NLB001L NLB001N: recode X (1 2 3 = 1)(4 5 6 7 = 0)
for var NLB017A NLB017B NLB017C: recode X (1 2=1)(3 4 5 6=0)
egen rowsum = rowtotal(NLB001A NLB001B NLB001C NLB001D NLB001E NLB001F NLB001G NLB001L NLB001N NLB017A NLB017B NLB017C)
gen socialize = 1 if rowsum >0 & rowsum < .
replace socialize = 0 if rowsum == 0
tab socialize
//1: once a week or more frequently 

//gender 
gen female = ragender
tab ragender
recode female (1=0)(2=1)

//marital status in 2012
gen couple = r11mstat
recode couple(1 2 3 =1)(4 5 6 7 8=0)

//self-rated health in 2010 and 2012
for var r10shlt r11shlt: recode X (1 2 3=2)(4=1)(5=0)

//race 
gen race = 0 if raracem == 1 & rahispan == 0
replace race = 1 if raracem == 2 & rahispan == 0
replace race = 2 if rahispan == 1
replace race = 3 if raracem == 3 & rahispan == 0
tab race

//labor force status in 2012
gen r11work = r11lbrf
recode r11work (1 2 4=1)(3 5 6 7=0)
//1: still work part time or full time

//coreside with children in 2012 
gen colive = 1 if h11resdkn > 0 & h11resdkn < .
replace colive = 0 if h11resdkn == 0

//economic support from children in 2012
destring hhidpn, replace
merge 1:1 hhidpn using hrs12childsupport.dta, keepusing(support11)
drop if _merge ==2
drop _merge

gen support112 = support11 / 1000
gen logcs = log(support112 + 0.1)


//get analytic sample
tab r10iwstat r11iwstat

keep if r11iwstat == 1 
//now only 20554 cases

//age in 2010 and 2012
gen age = 2010- rabyear
gen r2age = age + 2

sum age
drop if age < 50
//19582 remain 


drop if h11child == 0
//1414 deleted 
drop if h10child == 0
////42 deleted 


replace r11shlt = . if r11shlt >.
replace r10shlt = . if r10shlt >.
replace raedyrs = . if raedyrs >.
replace couple = . if couple >.
replace race = . if race >.
replace h11child = . if h11child >.
replace r11cesd = . if r11cesd >.
replace r11work =. if r11work >.

tab r11shlt,m
////only 19 missing; 0.1%

//standardize cesd(depressiv symptoms in 2012)
egen r11cesd2 = std(r11cesd)
replace r11cesd = r11cesd2 


egen birth=rowmin(birth1 birth2 birth3 birth4 birth5 birth6 birth7 birth8 birth9 birth10 birth11 birth12 birth13 birth14 birth15 birth16 birth17 birth18 birth19 birth20 birth21 birth22 birth23 birth24 birth25 birth26 birth27 birth28 birth29 birth30 birth31 birth32 birth33)
sum birth
drop if birth > 1987
//drop respondents whose oldest child was younger than 25 years old in 2012
//861 deleted 


count if birth <= 1987
//17,265



tab age
xtile edu_t1 = raedyrs if age == 50, nq(3)
xtile edu_t2 = raedyrs if age == 51, nq(3)
xtile edu_t3 = raedyrs if age == 52, nq(3)
xtile edu_t4 = raedyrs if age == 53, nq(3)
xtile edu_t5 = raedyrs if age == 54, nq(3)
xtile edu_t6 = raedyrs if age == 55, nq(3)
xtile edu_t7 = raedyrs if age == 56, nq(3)
xtile edu_t8 = raedyrs if age == 57, nq(3)
xtile edu_t9 = raedyrs if age == 58, nq(3)
xtile edu_t10 = raedyrs if age == 59, nq(3)
xtile edu_t11 = raedyrs if age == 60, nq(3)
xtile edu_t12 = raedyrs if age == 61, nq(3)
xtile edu_t13 = raedyrs if age == 62, nq(3)
xtile edu_t14 = raedyrs if age == 63, nq(3)
xtile edu_t15 = raedyrs if age == 64, nq(3)
xtile edu_t16 = raedyrs if age == 65, nq(3)
xtile edu_t17 = raedyrs if age == 66, nq(3)
xtile edu_t18 = raedyrs if age == 67, nq(3)
xtile edu_t19 = raedyrs if age == 68, nq(3)
xtile edu_t20 = raedyrs if age == 69, nq(3)
xtile edu_t21 = raedyrs if age == 70, nq(3)
xtile edu_t22 = raedyrs if age == 71, nq(3)
xtile edu_t23 = raedyrs if age == 72, nq(3)
xtile edu_t24 = raedyrs if age == 73, nq(3)
xtile edu_t25 = raedyrs if age == 74, nq(3)
xtile edu_t26 = raedyrs if age == 75, nq(3)
xtile edu_t27 = raedyrs if age == 76, nq(3)
xtile edu_t28 = raedyrs if age == 77, nq(3)
xtile edu_t29 = raedyrs if age == 78, nq(3)
xtile edu_t30 = raedyrs if age == 79, nq(3)
xtile edu_t31 = raedyrs if age == 80, nq(3)
xtile edu_t32 = raedyrs if age == 81, nq(3)
xtile edu_t33 = raedyrs if age == 82, nq(3)
xtile edu_t34 = raedyrs if age == 83, nq(3)
xtile edu_t35 = raedyrs if age == 84, nq(3)
xtile edu_t36 = raedyrs if age == 85, nq(3)
xtile edu_t37 = raedyrs if age == 86, nq(3)
xtile edu_t38 = raedyrs if age == 87, nq(3)
xtile edu_t39 = raedyrs if age == 88, nq(3)
xtile edu_t40 = raedyrs if age == 89, nq(3)
xtile edu_t41 = raedyrs if age == 90, nq(3)
xtile edu_t42 = raedyrs if age == 91 | age == 92, nq(3)
xtile edu_t43 = raedyrs if age >= 93 & age <= 102, nq(3)

egen edu_t = rowmax( edu_t1 - edu_t43 )
//get respondents' educational rank by cohort 

//adult children's educational mobility 
//use children's highest educational ranking 
gen rm1 = kidedurmax_c - edu_t
//use children's lowest educational ranking 
gen rm2 = kidedurmin_c - edu_t


//children's absolute mobility in education 
//use children's highest education 
gen amo1 = abkidmax - raedyrs
//use children's lowest education 
gen amo2 = abkidmin - raedyrs



count if r11shlt < . & r11wtcrnh <.
//17246

//no missing values: age, female, socialize, r11wtcrnh, r11work  

//these variables have few missing values, so I use listwise deletion for their missingness 
tab couple,m
//2 missing values; 0.01%
tab race,m 
//25 missing values; 0.14% 
tab colive,m 
//27 missing values; 0.16%
tab r11work,m 
//47 missing values; 0.28%
tab raedyrs, m
//74 missing values; 0.43% 

//these variables have a large number of missing values, so I will use multiple imputation with chained equations to deal with their missing values 
tab rm1,m
//587 missing values; 3.40%
tab rm2,m
//587 missing values; 3.40%
tab r10shlt,m 
//628 missing values; 3.64% 
tab h11child,m 
//260 missing values; 1.51% 
tab r11cesd,m 
//1037 missing values; 6.01% 
tab logcs,m 
//262 missing values; 1.52% 


//therefore, the final analytic sample is  
count if r11shlt < . & couple <. & race <. & colive <. & raedyrs <.
//17121


//report the size of missing values
misschk rm1 rm2 r10shlt h11child r11cesd logcs if r11shlt < . & couple <. & race <. & colive <. & raedyrs <.


//descriptive statistics 
destring HHID, replace
replace HHID = h11hhid if HHID >= .
tostring HHID, replace

svyset HHID [pweight = r11wtcrnh ]
svy: tab r11shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <.
svy: mean r2age if r11shlt < . & couple <. & race <. & colive <. & raedyrs <.
estat sd
//use these codes for other variables; depending on the coding of the variable; continuous variables use svy: mean and estat sd, while categorical variables use svy: tab. 

//Appendix Table 12 
gen cohort =1 if rabyear >= 1908 & rabyear <= 1929
replace cohort =2 if rabyear >= 1930 & rabyear <= 1939
replace cohort =3 if rabyear >= 1940 & rabyear <= 1949
replace cohort =4 if rabyear >= 1950 & rabyear <= 1960

svy: mean raedyrs if edu_t == 3 & female ==1 & cohort ==1 & r11shlt < . & couple <. & race <. & colive <. & raedyrs <.
estat sd
svy: mean raedyrs if edu_t == 3 & female ==1 & cohort ==2 & r11shlt < . & couple <. & race <. & colive <. & raedyrs <.

svy: mean raedyrs if edu_t == 3 & female ==1 & cohort ==3 & r11shlt < . & couple <. & race <. & colive <. & raedyrs <.

svy: mean raedyrs if edu_t == 3 & female ==1 & cohort ==4 & r11shlt < . & couple <. & race <. & colive <. & raedyrs <.
//repeat the codes above for different educational ranks, different genders, and different cohorts. 


//multiple imputation with chained equations 
mi set wide
mi register imputed rm1 rm2 r10shlt h11child r11cesd logcs
mi register regular r11shlt r11work colive socialize race couple edu_t female r2age
mi impute chained (reg) rm1 rm2 h11child r11cesd logcs (mlogit)r10shlt = r11shlt r11work colive socialize race couple edu_t female r2age if r11shlt < . & couple <. & race <. & colive <. & raedyrs <. , rseed(1) add(20) dots force


mi svyset HHID [pweight = r11wtcrnh ]

//not control for self-rated health in 2010 
mi estimate, dots post: svy: mlogit r11shlt rm1 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)

//control for self-rated health in 2010 
mi estimate, dots post: svy: mlogit r11shlt rm1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)

//khb mediation analysis 
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || logcs [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || logcs [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(2) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || socialize [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || socialize [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(2) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || r11cesd [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || r11cesd [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(2) b(0)

//present average marginal effects 
mi estimate, dots post: svy: mlogit r11shlt rm1 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt rm1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mimrgns, at(rm1=(-2(1)2)) predict(outcome(2))
mimrgns, at(rm1=(-2(1)2)) predict(outcome(0))
mimrgns, at(rm1=(-2(1)2)) predict(outcome(1)) cmdmargins
mimrgns, dydx(rm1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt) predict(outcome(0))
mimrgns, dydx(rm1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt) predict(outcome(1))
mimrgns, dydx(rm1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt) predict(outcome(2))


//robustness check 
//using rm2 
mi estimate, dots post: svy: mlogit r11shlt rm2 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt rm2 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)

//using categorical measures of social mobility 
mi passive: gen mobility1 = 0 if rm1 < 0
mi passive: replace mobility1 = 1 if rm1 == 0
mi passive: replace mobility1 = 2 if rm1 > 0 & rm1 < .
mi estimate, dots post: svy: mlogit r11shlt ib1.mobility1 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt ib1.mobility1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)

mi passive: gen mobility2 = 0 if rm2 < 0
mi passive: replace mobility2 = 1 if rm2 == 0
mi passive: replace mobility2 = 2 if rm2 > 0 & rm2 < .
mi estimate, dots post: svy: mlogit r11shlt ib1.mobility2 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt ib1.mobility2 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)


//use 1%-99% children's economic support to avoid the influence of outliers for robustness check 
preserve
sum logcs, detail
drop if logcs <r(p1) | logcs >r(p99)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || logcs [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(1) b(0)
mi estimate, cmdok dots post: khb mlogit r11shlt rm1 || logcs [pweight = r11wtcrnh ], concomitant(r2age female r11mstat raedyrs r11work h11child colive race r10shlt) outcome(2) b(0)
restore 

//use absolute mobility
preserve 
mi extract 0,clear
//re-run multiple imputation with chained equations and replace rm1 and rm2 with amo1 and amo2 
mi set wide
mi register imputed amo1 amo2 r10shlt h11child r11cesd logcs
mi register regular r11shlt r11work colive socialize race couple edu_t female r2age
mi impute chained (reg) amo1 amo2 h11child r11cesd logcs (mlogit)r10shlt = r11shlt r11work colive socialize race couple edu_t female r2age if r11shlt < . & couple <. & race <. & colive <. & raedyrs <. , rseed(1) add(20) dots force

destring HHID, replace
replace HHID = h11hhid if HHID >= .
tostring HHID, replace

mi svyset HHID [pweight = r11wtcrnh ]

mi estimate, dots post: svy: mlogit r11shlt amo1 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt amo1 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt amo2 r2age female couple i.edu_t r11work h11child colive i.race if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
mi estimate, dots post: svy: mlogit r11shlt amo2 r2age female couple i.edu_t r11work h11child colive i.race ib0.r10shlt if r11shlt < . & couple <. & race <. & colive <. & raedyrs <., b(0)
restore 


//control for childhood health rather than health in 2011 
//first, need to combine answers on childhood health from different waves of HRS (e.g. NB019 in 2012 HRS, MB019 in 2010 HRS, etc.) until the missing values of this variable are within a reasonable range 
//then recode this variable (three category: excellent/very good/good, fair, poor)
//then impute missing values for this variable if any 
//then replace r10shlt with this variable in regression models 
//note that CHARLS and HRS have different wording for this variable (CHARLS asked respondents to compare their childhood health with others, while HRS asked respondents to evaluate on a Likert scale) 


//use self-rated health in 2014 as dependent variable and depressive symptoms in 2012 as the mediator 
use hrs1011wavemerged.dta, clear 
merge 1:1 hhidpn using randhrs1992_2016v1.dta, keepusing(r12shlt r12wtcrnh)
drop if _merge == 2
drop _merge
//self-rated health in 2014
recode r12shlt (1 2 3=2)(4=1)(5=0)
replace r12shlt = . if r12shlt >.
//then repeat other codes and use r12shlt as the dependent variable, r11cesd as the mediator, and r12wtcrnh as the new weights

//use proportion of upward mobility as the independent variable 




clear 
use hrs12child.dta
merge 1:1 ID using hrs1011wavemerged.dta, keepusing(edu_t)
keep if _merge == 3 | _merge == 2
drop _merge
reshape long birth@ edu@ kidedur@, i(hhidpn) j(kid)
//compare each child's educational ranking with the respondent's
gen comp = 0 if kidedur < edu_t & edu_t <.
replace comp = 1 if kidedur == edu_t & edu_t <.
replace comp = 2 if kidedur > edu_t & kidedur <.
reshape wide birth edu kidedur comp, i(hhidpn) j(kid)
//number of children in each mobility situation 
//number of children in downward mobility 
egen down = anycount( comp1 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 comp10 comp11 comp12 comp13 comp14 comp15 comp16 comp17 comp18 comp19 comp20 comp21 comp22 comp23 comp24 comp25 comp26 comp27 comp28 comp29 comp30 comp31 comp32 comp33 ), values(0)
//number of children in non-mobility 
egen nomobile = anycount( comp1 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 comp10 comp11 comp12 comp13 comp14 comp15 comp16 comp17 comp18 comp19 comp20 comp21 comp22 comp23 comp24 comp25 comp26 comp27 comp28 comp29 comp30 comp31 comp32 comp33 ), values(1)
//number of children in upward mobility 
egen up = anycount( comp1 comp2 comp3 comp4 comp5 comp6 comp7 comp8 comp9 comp10 comp11 comp12 comp13 comp14 comp15 comp16 comp17 comp18 comp19 comp20 comp21 comp22 comp23 comp24 comp25 comp26 comp27 comp28 comp29 comp30 comp31 comp32 comp33 ), values(2)
rename edu_t redu_t
save hrs12child.dta, replace 

use hrs1011wavemerged.dta, clear 
merge 1:1 ID using hrs12child.dta
drop if _merge ==2
drop _merge 
merge 1:1 ID using randhrsfamr1992_2014v1.dta, keepusing(h11child)
drop if _merge ==2
drop _merge 
//total number of children as the demominator 
egen cnum = rowtotal(up nomobile down), missing
egen childnum = rowmax(cnum h11child)
//there are some differences between cnum and h2child, I choose the larger one as the demoninator 
//calculate the proportion of children in each mobility situation  
gen downp = down/childnum
gen nomobilep = nomobile/childnum
gen upp = up/childnum
//then repeat other codes and use these new predictors to predict self-rated health in 2012
