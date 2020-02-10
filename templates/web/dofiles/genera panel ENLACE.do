//=====================================================================

* Limpia las bases de datos originales y genera una base de datos maestra por año
* dicha base contiene cada estudiante y su escuela, el grado escolar y sus calificaciones 
* (algunas bases de datos fueron primero formateadas de .csv a dta)

//=====================================================================


*********************************************
clear all
set more off
gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM\"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source\"
gl basesA= "$dir\basesAuxiliares\"
gl basesD = "$basesA\deleteMyFiles\"
gl resultados ="$dir\resultados\"



//Limpia y fusiona las bases de 2006 
if 0==0{
	use "$source\ENLACEBASICA\ENLACE2006.dta", clear
	rename nofolio NOFOLIO
	merge 1:1 NOFOLIO using  "$source\ENLACEBASICA\enl06nal_nombres.dta"
	rename CURP curp 
	replace grado=grado+6 if nivel=="SECUNDARIA" 
	foreach var in NOMBRE APELLIDO_M APELLIDO_P{
	*quitamos los caracteres que causan conflicto
	
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

//Limpia y fusiona las bases de 2007
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

//Limpia y fusiona las bases de 2008
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

//Limpia y fusiona las bases de 2009
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

//Limpia y fusiona las bases de 2010
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
* nos deshacemos de los curp que tienen más de una observación
bysort curp: drop if _N>1
drop _merge
merge 1:m curp using "$basesD\B10_antes.dta" //, gen(mimi)
*reemplazamos los valores faltantes 
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
//Limpia y fusiona las bases del 2011
import delimited "$source\2011\resul_enlace_11.csv", varn(1) clear
save "$source\2011\resul_enlace_11.dta", replace
import delimited "$source\2011\alumnos_curp_11.csv", varn(1) clear
save "$source\2011\alumnos_curp_11.dta", replace
merge 1:1 nofolio using "$source\2011\resul_enlace_11.dta"
*nos quedamos con las observaciones que sí hicieron match
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



foreach x in   06 07 08 09 10 11 12 {
	use "$basesA\B`x'_r.dta", clear
	*borra curps repetidos
	bysort curp:  gen aux=_N
	drop if aux>1
	drop aux
	gen aux =strlen(curp)
	drop if aux<18
	drop aux
	gen c_mayus = upper(curp)
	/*checamos que los curp de la base de datos estén en el formato típico de 18 dígitos y con las descripciones normales que denotan los dígitos y su orden
	  esto es posible con el comando 'regexm' */
	gen checkc =  regexm(c_mayus, "^[A-Z][AEIOUX][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HM][A-Z][A-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][0-9A-Z][0-9]")
	order checkc
	*nos quedamos con los curp que cumplen con los requisitos formales del curp
	keep if checkc ==1
	drop checkc curp 
	rename c_mayus curp
	save "$basesA\B`x'.dta", replace
}

*ESTANDARIZA

foreach anyo1 in  06 07 08 09 10 11 12  {
	use "$basesA\B`anyo1'.dta", clear
	replace p_mat=. if p_mat<50
	replace p_esp=. if p_esp<50
	foreach vari in medmat sdmat medesp sdesp p_mat_std p_esp_std p_mat_perc p_esp_perc{
		cap drop `vari'
	}
	*estandariza calificaciones
	*calculamos las medias y desviaciones estandar para las calificaciones de Español y Matemáticas
	bysort grado: egen medmat=mean(p_mat)
	bysort grado: egen sdmat=sd(p_mat)
	bysort grado: egen medesp=mean(p_esp)
	bysort grado: egen sdesp=sd(p_esp)
	/* La estandarización se lleva a cabo de la siguiente forma: 
	   tomamos la calificación del alumno y le restamos la media de las calificaciones de todos los alumnos, a ese número lo dividimos entre la
	   la desviación estandar de las calificaciones. Esto se hace para Español y Matemáticas */
	   
	gen p_mat_std=(p_mat-medmat)/sdmat
	gen p_esp_std=(p_esp-medesp)/sdesp
	
	*guardamos en una macro los grados que se tienen registrados para la variable 'grado'
	
	*genera percentiles con el comando 'xtile' usando las variables 'aux1' y 'aux2' como puentes, después se desechan.
	foreach x in esp mat {
		sort  grado p_`x'
		bysort  grado: gen ranking=_n if p_`x'!=.
		bysort  grado: gen total_a=_N if p_`x'!=.
		gen aux=(ranking/total_a)*100
		gen p_`x'_perc= ceil(aux)
		drop aux ranking total_a

		}
	drop medmat sdmat medesp sdesp
	save "$basesA\B`anyo1'.dta", replace
}

*CREA pane_exacto

use "$basesA\B06.dta", clear 

*con 'append' unimos verticalmente las bases de datos de 2006 a 2012
foreach anyo1 in   07 08 09 10 11 12 {
	append using "$basesA\B`anyo1'.dta"

}

save "$basesA\panel_exacto.dta", replace


*limpia bases de datos preparatorias 

foreach anyo in 08 09 10 11 12 13 14 {
	use "$source\M\M`anyo'.dta",clear
	save "$basesA\M`anyo'_r.dta",replace
}


foreach anyo in 08 09 10 11 12 13 14 {
	use "$basesA\M`anyo'_r.dta",clear
	bysort curp:  gen aux=_N
	drop if aux>1
	drop aux
	gen aux =strlen(curp)
	drop if aux<18
	drop aux
	* Nos quedamos con los curp que cumplen con el formato típico
	gen c_mayus = upper(curp)
	gen checkc =  regexm(c_mayus, "^[A-Z][AEIOU][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HM][A-Z][A-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][0-9A-Z][0-9]")
	order checkc
	keep if checkc ==1
	drop checkc curp 
	rename c_mayus curp
	*replace p_mat=. if p_mat<50
	*replace p_esp=. if p_esp<50
	*estandariza calificaciones
	*Mismo proceso de estandarizamiento de calificaciones que se usó previamente 
	egen medmat=mean(p_mat)
	egen sdmat=sd(p_mat)
	egen medesp=mean(p_esp)
	egen sdesp=sd(p_esp)
	gen p_mat_std=(p_mat-medmat)/sdmat
	gen p_esp_std=(p_esp-medesp)/sdesp
	levels grado, local(grados)
	drop medmat sdmat medesp sdesp
	foreach x in esp mat{
		sort  grado p_`x'
		bysort  grado: gen ranking=_n if p_`x'!=.
		bysort  grado: gen total_a=_N if p_`x'!=.
		gen aux=(ranking/total_a)*100
		gen p_`x'_perc= ceil(aux)
		drop aux ranking total_a
		}
	save "$basesA\M`anyo'.dta",replace
}

/* el siguiente 'foreach' creará la base de datos panel donde están incluidas las observaciones 
   de primaria, secundaria y preparatoria */

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


*anonimiza
use  "$basesA\panel_fuzzy.dta", clear

shasum curp, sha1(curp_id)
drop curp  curp_largo apellido_nombre
save  "$basesA\panel_fuzzy_a.dta", replace


use  "$basesA\panel_exacto_18_con_prepa.dta", clear
shasum curp, sha1(curp_id)
drop curp apellido_nombre
save "$basesA\panel_exacto_18_con_prepa_a.dta", replace



use  "$basesA\panel_exacto.dta", clear
shasum curp, sha1(curp_id)
drop curp apellido_nombre
save "$basesA\panel_exacto_a.dta", replace




