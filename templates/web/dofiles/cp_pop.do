//==================================================
// Grade Distribution
// Editado 12/14/2018
// =================================================
clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"
gl res = "$dir\resultados"

use "$basesD\panel_cp_3.dta", clear

gen tipo=substr(cct, 3, 1)
gen privada=tipo=="P"

gen mat_pr = p_mat_std if privada == 1
gen mat_pu = p_mat_std if privada == 0

gen esp_pr = p_esp_std if privada == 1
gen esp_pu = p_esp_std if privada == 0


save "$basesD\pop_k.dta", replace

use "$basesD\pop_k.dta", clear
//Grade distribution
#delimit 
twoway 
(kdensity p_mat_std) 
(kdensity mat_pr)
(kdensity mat_pu),
xtitle("Mathematics standarized results")
ytitle("Density")
title("Grade distribution", `title_options')
legend(order(1 "Private and Public" 2 "Private" 3 "Public" ))
;
#delimit cr

graph export "$res/kdensityMath.png", replace


#delimit 
twoway 
(kdensity p_esp_std) 
(kdensity esp_pr)
(kdensity esp_pu),
xtitle("Spanish standarized results")
ytitle("Density")
title("Grade distribution", `title_options')
legend(order(1 "Private and Public" 2 "Private" 3 "Public" ))
;
#delimit cr

graph export "$temp/kdensityEsp.png", replace


//Percentage difference in CP
// Using SD per year per grade.Finding z score (number of SD away from the mean)
bysort cct anyo grado: egen prom_cct_e=mean(p_esp_std)
bysort cct anyo grado: egen prom_cct_m=mean(p_mat_std)

//Generate National Mean and SD per year per grade
bysort anyo grado: egen prom_nac_e = mean(p_esp_std)
bysort anyo grado: egen sd_nac_e = sd(p_esp_std)
bysort anyo grado: egen prom_nac_m = mean(p_mat_std)
bysort anyo grado: egen sd_nac_m = sd(p_mat_std)

//Z value per school
gen z_e = (prom_cct_e - prom_nac_e) / sd_nac_e
gen z_m = (prom_cct_m - prom_nac_m) / sd_nac_m

//Calculate percental change
egen max_e = max(z_e), by(postalcode) 
egen min_e = min(z_e), by(postalcode)
gen dif_e = (max_e - min_e)/max_e

egen max_m = max(z_m), by(postalcode) 
egen min_m = min(z_m), by(postalcode)
gen dif_m = (max_m - min_m)/max_m

//Calculate percental change for public schools
gen z_e_pu = z_e if privada == 0
gen z_m_pu = z_m if privada == 0

egen max_e_pu = max(z_e_pu), by(postalcode) 
egen min_e_pu = min(z_e_pu), by(postalcode)
gen dif_e_pu = (max_e_pu - min_e_pu)/max_e_pu

egen max_m_pu = max(z_m_pu), by(postalcode) 
egen min_m_pu = min(z_m_pu), by(postalcode)
gen dif_m_pu = (max_m_pu - min_m_pu)/max_m_pu

//Calculate percental change for private schools
gen z_e_pr = z_e if privada == 1
gen z_m_pr = z_m if privada == 1

egen max_e_pr = max(z_e_pr), by(postalcode) 
egen min_e_pr = min(z_e_pr), by(postalcode)
gen dif_e_pr = (max_e_pr - min_e_pr)/max_e_pr

egen max_m_pr = max(z_m_pr), by(postalcode) 
egen min_m_pr = min(z_m_pr), by(postalcode)
gen dif_m_pr = (max_m_pr - min_m_pr)/max_m_pr

save "$basesD/cp_dif.dta", replace

duplicates drop postalcode, force

//Keep CP with more than one school
drop if dif_m_pu ==0
drop if dif_m_pr ==0



//Spanish

#delimit ;
twoway 
(hist dif_e_pr if inrange(dif_e_pr,0,5), 
width(0.1)
frac lcolor(gs12) fcolor(eltblue)) 

(hist dif_e_pu if inrange(dif_e_pu,0,5), 
width(0.1)
frac fcolor(none) lcolor(black))

(hist dif_e if inrange(dif_e,0,5), 
width(0.1)
frac fcolor(none) lcolor(green)), 

xtitle("Percentage change")
ytitle("Fraction")
title("Spanish Results Percental Change per Postalcode", size(medium))
legend(order(1 "Private" 2 "Public" 3 "Private and Public"))
;
#delimit cr

graph export "$res/SD_hist_CP_Spanish.png", replace

//Maths
//Spanish

#delimit ;
twoway 
(hist dif_m_pr if inrange(dif_m_pr,0,5), 
width(0.1)
frac lcolor(gs12) fcolor(eltblue)) 

(hist dif_m_pu if inrange(dif_m_pu,0,5), 
width(0.1)
frac fcolor(none) lcolor(black))

(hist dif_m if inrange(dif_m,0,5), 
width(0.1)
frac fcolor(none) lcolor(green)), 

xtitle("Percentage change")
ytitle("Fraction")
title("Mathematics Results Percental Change per Postalcode", size(medium))
legend(order(1 "Private" 2 "Public" 3 "Private and Public"))
;
#delimit cr

graph export "$res/SD_hist_CP_Maths.png", replace



//Differnce rather than change
gen dif_e2 = (max_e - min_e)
gen dif_m2 = (max_m - min_m)

gen dif_e_pu2 = (max_e_pu - min_e_pu)
gen dif_e_pr2 = (max_e_pr - min_e_pr)

gen dif_m_pu2 = (max_m_pu - min_m_pu)
gen dif_m_pr2 = (max_m_pr - min_m_pr)

save "$basesD/cp_dif_sd.dta", replace

#delimit ;
twoway 
(hist dif_e_pr2 if inrange(dif_e_pr2,0,5), 
width(0.1)
frac lcolor(gs12) fcolor(eltblue)) 

(hist dif_e_pu2 if inrange(dif_e_pu2,0,5), 
width(0.1)
frac fcolor(none) lcolor(black))

(hist dif_e2 if inrange(dif_e2,0,5), 
width(0.1)
frac fcolor(none) lcolor(green)), 

xtitle("Difference")
ytitle("Fraction")
title("Difference between the highest and lowest performing school in Spanish per postalcode", size(small))
legend(order(1 "Private" 2 "Public" 3 "Private and Public"))
;
#delimit cr

graph export "$res/SD_hist_CP_Spanish_dif.png", replace

//Maths
//Spanish

#delimit ;
twoway 
(hist dif_m_pr2 if inrange(dif_m_pr2,0,5), 
width(0.1)
frac lcolor(gs12) fcolor(eltblue)) 

(hist dif_m_pu2 if inrange(dif_m_pu2,0,5), 
width(0.1)
frac fcolor(none) lcolor(black))

(hist dif_m2 if inrange(dif_m2,0,5), 
width(0.1)
frac fcolor(none) lcolor(green)), 

xtitle("Percentage change")
ytitle("Fraction")
title("Difference between the highest and lowest performing school in Mathematics per postalcode", size(small))
legend(order(1 "Private" 2 "Public" 3 "Private and Public"))
;
#delimit cr

graph export "$res/SD_hist_CP_Maths_dif.png", replace

// GRAPH FORMATTING
// For graphs:
local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`tiny') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
