//=====================================================================
* cleans the original data bases and generates a master data base per year
* containing each student and their school, schoolyear and grades.
*
* (some data sets were first formatted from .csv to dta)
//=====================================================================

clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"

//Cleans and merges 2006 databases
if 0==0{
	use "$dir2\ENLACEBASICA\ENLACE2006.dta", clear
	rename nofolio NOFOLIO
	merge 1:1 NOFOLIO using  "$dir2\ENLACEBASICA\enl06nal_nombres.dta"
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
	save "$basesO\B06.dta", replace

//Cleans and merges 2007 databases
	use "$dir2\ENLACEBASICA\enl07_A.dta", clear
	append using  "$dir2\ENLACEBASICA\enl07_B.dta"
	rename nofolio NOFOLIOINT
	merge 1:1 NOFOLIOINT using  "$dir2\ENLACEBASICA\enl07nal_nombres.dta"
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
	save "$basesO\B07.dta", replace

//Cleans and merges 2008 databases
	use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_08_A.dta", clear
	append using  "$dir2\ENLACEBASICA\enl08_B.dta", force
	rename nofolio  NOFOLIO
	merge 1:1 NOFOLIO using  "$dir2\ENLACEBASICA\enl08nal_nombres.dta"
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
	save "$basesO\B08.dta", replace
}

//Cleans and merges 2009 databases
local anyo=09
use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_09_A.dta", clear
append using  "$dir2\ENLACEBASICA\RESULT_ALUMNOS_09_B.dta", force
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using  "$dir2\ENLACEBASICA\enl09_nal_nombres.dta"
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
save "$basesO\B09.dta", replace

//Cleans and merges 2010 databases



use "$dir2/ENLACEBASICA/RESULT_ALUMNOS_10_A.dta", clear
append using  "$dir2/ENLACEBASICA/RESULT_ALUMNOS_10_B.dta", force
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using  "$dir2/ENLACEBASICA/enl10_nal_nombres.dta"

cap rename CURP_DGEP CURP
rename CURP curp 
cap destring grado, replace
replace grado=grado+6 if nivel=="SECUNDARIA" 
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
save "$basesO/B10.dta", replace

import delimited "$dir2/2010Mauricio/basica/RES_ENLACE_10_2.csv", clear
rename nofolio NOFOLIO
merge 1:1 NOFOLIO using "$dir2/ENLACEBASICA/enl10_nal_nombres.dta"
rename  CURP curp
bysort curp: drop if _N>1
drop _merge
merge 1:n curp using "$basesO/B10.dta", gen(mimi)
bysort curp: drop if _N>1
replace p_esp=cal_esp if missing(p_esp)
replace p_mat=cal_mat if missing(p_mat)

keep curp grado p_esp p_mat cct apellido_nombre
gen anyo=2010
save "$basesO\B10.dta", replace

****2010 bis sin calificaciones
foreach anyo in 10 {
	use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_`anyo'_A.dta", clear
	append using  "$dir2\ENLACEBASICA\RESULT_ALUMNOS_`anyo'_B.dta", force
	rename nofolio NOFOLIO
	merge 1:1 NOFOLIO using  "$dir2\ENLACEBASICA\enl`anyo'_nal_nombres.dta"
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
	save "$basesO\B`anyo'bis.dta", replace

}







//Cleans and merges 2011 databases
import delimited "$dir2\2011\resul_enlace_11.csv", varn(1) clear
save "$dir2\2011\resul_enlace_11.dta", replace
import delimited "$dir2\2011\alumnos_curp_11.csv", varn(1) clear
save "$dir2\2011\alumnos_curp_11.dta", replace
merge 1:1 nofolio using "$dir2\2011\resul_enlace_11.dta"

keep if _m==3
gen apellido_nombre=""
rename cal_esp p_esp
rename cal_mat p_mat
keep curp grado p_esp p_mat cct apellido_nombre
gen anyo=2011
save "$basesO\B11.dta", replace


//Cleans and merges 2012 databases                         
use "$dir2\ENLACEBASICA\resul_alum_eb12.dta", clear
merge 1:1 NOFOLIO using "$dir2\ENLACEBASICA\nombres_enlb_12_nac.dta"
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
save "$basesO\B12.dta", replace





