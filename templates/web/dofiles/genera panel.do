//=====================================================================
* cleans the original data bases and generates a master data base per year
* containing each student and their school, schoolyear and grades.
*
* (some data sets were first formatted from .csv to dta)
//=====================================================================

clear all
set more off
*********************************************
clear all
set more off
gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source"
gl basesA= "$dir\basesAuxiliares"
gl basesD = "$basesA\deleteMyFiles"
gl resultados ="$dir\resultados"
gl dofile = "$dir\do files"


//Cleans and merges 2006 databases
if 0==0{
	use "$source\ENLACEBASICA\ENLACE2006.dta", clear
	rename nofolio NOFOLIO
	merge 1:1 NOFOLIO using  "$source\ENLACEBASICA\enl06nal_nombres.dta"
	rename CURP curp 
	replace grado=grado+6 if nivel=="SECUNDARIA" 
	foreach var in NOMBRE APELLIDO_M APELLIDO_P{
		replace `var'=subinstr(`var', "-", "N", .)
		replace `var'=subinstr(`var', "Т", "N", .)
		replace `var'=subinstr(`var', "Ñ", "N", .)
		replace `var'=subinstr(`var', "ç", "N", .)
	}
	gen apellido_nombre=APELLIDO_P+" "+APELLIDO_M+" "+NOMBRE
	keep curp grado p_esp p_mat cct apellido_nombre apellido_nombre
	replace apellido_nombre=strlower(apellido_nombre)
	gen anyo=2006
	save "$basesA\B06_r.dta", replace

//Cleans and merges 2007 databases
	use "$source\ENLACEBASICA\enl07_A.dta", clear
	append using  "$source\ENLACEBASICA\enl07_B.dta"
	rename nofolio NOFOLIOINT
	merge 1:1 NOFOLIOINT using  "$source\ENLACEBASICA\enl07nal_nombres.dta"
	rename CURP curp 
	replace grado=grado+6 if nivel=="SECUNDARIA" 
	rename cal_esp p_esp
	rename cal_mat p_mat
	cap rename NOMBRE NOM_ALUM
	foreach var in NOM_ALUM APELLIDO_M APELLIDO_P{
		replace `var'=subinstr(`var', "-", "N", .)
		replace `var'=subinstr(`var', "Т", "N", .)
		replace `var'=subinstr(`var', "Ñ", "N", .)
		replace `var'=subinstr(`var', "ç", "N", .)
	}
	gen apellido_nombre=APELLIDO_P+" "+APELLIDO_M+" "+NOM_ALUM
	keep curp grado p_esp p_mat cct apellido_nombre
	replace apellido_nombre=strlower(apellido_nombre)
	gen anyo=2007
	save "$basesA\B07_r.dta", replace

//Cleans and merges 2008 databases
	use "$source\ENLACEBASICA\RESULT_ALUMNOS_08_A.dta", clear
	append using  "$source\ENLACEBASICA\enl08_B.dta", force
	rename nofolio  NOFOLIO
	merge 1:1 NOFOLIO using  "$source\ENLACEBASICA\enl08nal_nombres.dta"
	rename CURP curp 
	replace grado=grado+6 if nivel=="SECUNDARIA" 
	rename cal_esp p_esp
	rename cal_mat p_mat
	foreach var in NOMBRE{
		replace `var'=subinstr(`var', "-", "N", .)
		replace `var'=subinstr(`var', "Т", "N", .)
		replace `var'=subinstr(`var', "Ñ", "N", .)
		replace `var'=subinstr(`var', "ç", "N", .)
	}
	rename NOMBRE apellido_nombre
	keep curp grado p_esp p_mat cct apellido_nombre
	replace apellido_nombre=strlower(apellido_nombre)
	gen anyo=2008
	save "$basesA\B08_r.dta", replace
}

//Cleans and merges 2009 databases
local anyo=09
use "$source\ENLACEBASICA\RESULT_ALUMNOS_09_A.dta", clear
append using  "$source\ENLACEBASICA\RESULT_ALUMNOS_09_B.dta", force
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using  "$source\ENLACEBASICA\enl09_nal_nombres.dta"
cap rename CURP_DGEP CURP
rename CURP curp 
cap destring grado, replace
replace grado=grado+6 if nivel=="SECUNDARIA" 
rename cal_esp p_esp
rename cal_mat p_mat
foreach var in NOMBRE{
	replace `var'=subinstr(`var', "-", "N", .)
	replace `var'=subinstr(`var', "Т", "N", .)
	replace `var'=subinstr(`var', "Ñ", "N", .)
	replace `var'=subinstr(`var', "ç", "N", .)
}
rename NOMBRE apellido_nombre
keep curp grado p_esp p_mat cct apellido_nombre
replace apellido_nombre=strlower(apellido_nombre)
gen anyo=2000+`anyo'
save "$basesA\B09_r.dta", replace

//Cleans and merges 2010 databases
use "$source\ENLACEBASICA\RESULT_ALUMNOS_10_A.dta", clear
append using  "$source\ENLACEBASICA\RESULT_ALUMNOS_10_B.dta", force
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using  "$source\ENLACEBASICA\enl10_nal_nombres.dta"
destring grado, replace force
replace grado=grado+6 if nivel=="SECUNDARIA" 
rename CURP curp 
rename cal_esp p_esp
rename cal_mat p_mat
replace NOMBRE=subinstr(NOMBRE, "-", "N", .)
replace NOMBRE=subinstr(NOMBRE, "Т", "N", .)
replace NOMBRE=subinstr(NOMBRE, "Ñ", "N", .)
replace NOMBRE=subinstr(NOMBRE, "ç", "N", .)
rename NOMBRE apellido_nombre
keep curp grado p_esp p_mat cct apellido_nombre
replace apellido_nombre=strlower(apellido_nombre)
gen anyo=2000+10
save "$basesD\B10_antes.dta", replace

import delimited "$source\2010Mauricio\basica\RES_ENLACE_10_2.csv", clear
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using "$source\ENLACEBASICA\enl10_nal_nombres.dta"
rename  CURP curp
replace grado=grado+6 if nivel=="SECUNDARIA" 
bysort curp: drop if _N>1
drop _merge
merge 1:m curp using "$basesD\B10_antes.dta" //, gen(mimi)
replace p_esp=cal_esp if missing(p_esp)
replace p_mat=cal_mat if missing(p_mat)
keep curp grado p_esp p_mat cct apellido_nombre
gen anyo=2010
save "$basesA\B10_r.dta", replace

/*
use "$basesA\B10_antes.dta", clear
drop p_esp p_mat
bysort curp: gen aux=(_N>1)
			drop if aux==1
			drop aux
merge 1:m curp using "$basesA\B10_mauricio.dta", keepusing(p_esp p_mat)
drop _merge
save "$basesA\B10_mauricio.dta", replace
*/
//Cleans and merges 2011 databases
import delimited "$source\2011\resul_enlace_11.csv", varn(1) clear
save "$source\2011\resul_enlace_11.dta", replace
import delimited "$source\2011\alumnos_curp_11.csv", varn(1) clear
save "$source\2011\alumnos_curp_11.dta", replace
merge 1:1 nofolio using "$source\2011\resul_enlace_11.dta"
keep if _m==3
gen apellido_nombre=""
rename cal_esp p_esp
rename cal_mat p_mat
keep curp grado p_esp p_mat cct apellido_nombre
gen anyo=2011
save "$basesA\B11_r.dta", replace

//Cleans and merges 2012 databases                         
use "$source\ENLACEBASICA\resul_alum_eb12.dta", clear
merge 1:1 NOFOLIO using "$source\ENLACEBASICA\nombres_enlb_12_nac.dta"
rename v4 curp 
rename cal_esp p_esp
rename cal_mat p_mat
foreach var in v5 v6 v7{
	replace `var'=subinstr(`var', "-", "N", .)
	replace `var'=subinstr(`var', "Т", "N", .)
	replace `var'=subinstr(`var', "Ñ", "N", .)
	replace `var'=subinstr(`var', "ç", "N", .)
	replace `var'=subinstr(`var', "¥", "N", .)
}
gen apellido_nombre=v5+" "+v6+" "+v7
keep curp grado p_esp p_mat cct apellido_nombre
replace apellido_nombre=strlower(apellido_nombre)
gen anyo=2012
save "$basesA\B12_r.dta", replace



foreach x in  10  {
	use "$basesA\B`x'_r.dta", clear
	*borra curps repetidos
	bysort curp:  gen aux=_N
	drop if aux>1
	gen c_mayus = upper(curp)
	gen checkc =  regexm(c_mayus, "^[A-Z][AEIOUX][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HM][A-Z][A-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z]")
	order checkc
	keep if checkc ==1
	drop checkc curp aux
	rename c_mayus curp
	save "$basesA\B`x'.dta", replace
}

*ESTANDARIZA

foreach anyo1 in  10  {
	use "$basesA\B`anyo1'.dta", clear
	replace p_mat=. if p_mat<50
	replace p_esp=. if p_esp<50
	foreach vari in medmat sdmat medesp sdesp p_mat_std p_esp_std p_mat_perc p_esp_perc{
		cap drop `vari'
	}
	*estandariza calificaciones
	bysort grado: egen medmat=mean(p_mat)
	bysort grado: egen sdmat=sd(p_mat)
	bysort grado: egen medesp=mean(p_esp)
	bysort grado: egen sdesp=sd(p_esp)
	gen p_mat_std=(p_mat-medmat)/sdmat
	gen p_esp_std=(p_esp-medesp)/sdesp
	levels grado, local(grados)
	*genera percentiles
	gen p_mat_perc=.
	gen p_esp_perc=.
	foreach grad in `grados'{
		foreach vari in p_mat p_esp{
			gen aux1=`vari' if grado==`grad'
			xtile aux2=aux1, nq(100)
			replace `vari'_perc=aux2 if grado==`grad'
			drop aux1 aux2
		}
	}
	drop medmat sdmat medesp sdesp
	save "$basesA\B`anyo1'.dta", replace
}

*CREA PANEL

use "$basesA\B06.dta", clear 


foreach anyo1 in   07 08 09 10 11 12 {
	append using "$basesA\B`anyo1'.dta"

}

save "$basesA\panel_exacto.dta", replace


*limpia M 

foreach anyo in 08 09 10 11 12 13 14 {
	use "$source\M\M`anyo'.dta",clear
	save "$basesA\M`anyo'_r.dta",replace
}


foreach anyo in 08 09 10 11 12 13 14 {
	use "$basesA\M`anyo'_r.dta",clear
	bysort curp:  gen aux=_N
	drop if aux>1
	gen c_mayus = upper(curp)
	gen checkc =  regexm(c_mayus, "^[A-Z][AEIOUX][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HM][A-Z][A-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z]")
	order checkc
	keep if checkc ==1
	drop checkc curp aux
	rename c_mayus curp
	*replace p_mat=. if p_mat<50
	*replace p_esp=. if p_esp<50
	*estandariza calificaciones
	egen medmat=mean(p_mat)
	egen sdmat=sd(p_mat)
	egen medesp=mean(p_esp)
	egen sdesp=sd(p_esp)
	gen p_mat_std=(p_mat-medmat)/sdmat
	gen p_esp_std=(p_esp-medesp)/sdesp
	levels grado, local(grados)
	*genera percentiles
	gen p_mat_perc=.
	gen p_esp_perc=.
	foreach vari in p_mat p_esp{
		gen aux1=`vari' 
		xtile aux2=aux1, nq(100)
		replace `vari'_perc=aux2
		drop aux1 aux2
	}
	drop medmat sdmat medesp sdesp
	
	save "$basesA\M`anyo'.dta",replace
}


clear
foreach l in B M{
	foreach anyo1 in  06 07 08 09 10 11 12 13 14 15 16 {
		capture confirm file "$basesA/`l'`anyo1'.dta"
		 if _rc==0 {
			append using "$basesA/`l'`anyo1'.dta"  
		}
	}
}


save "$basesA\panel_exacto_18_con_prepa.dta", replace




**** Crea Panel Fuzzy ****
clear all
clear
foreach l in B M{
	foreach anyo1 in  06 07 08 09 10 11 12 13 14  {
		capture confirm file "$basesA/`l'`anyo1'_r.dta"
		 if _rc==0 {
			append using "$basesA/`l'`anyo1'_r.dta"  
		}
	}
}
rename curp curp_largo
gen curp = substr(curp,1,16)
save "$basesA\panel_fuzzy.dta", replace




