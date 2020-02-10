*genera regresión calif 6to  calif5 calif4 calif3
	
clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl dir2="$basesO"
gl basesD = "$dir\bases auxiliares\deleteMyFiles\"
**NO USAR PROMEDIO

foreach k in p_mat_std p_esp_std {
	use "$basesD\panel_fuzzy.dta", clear
	keep curp grado `k'
	*using average if retention
	*p_esp p_mat p_mat_std p_esp_std p_mat_perc p_esp_perc
	*keep if substr(curp,1,1)=="A"
	drop if grado >6
	collapse (mean) `k', by(curp grado)
	reshape wide `k', i(curp)j(grado)
	forvalues x=3/6{
		drop if `k'`x'==.
		
	}
	cd "$dir\resultados\regresiones"
	*USAR SOLO UN LAG
	reg `k'6 `k'5 `k'4 `k'3 , r
	outreg2 using reg`k'.xls, text ctitle(number of hosp.) bdec(3) sdec(3) paren(se) asterisk(coef)
}


***
***usando la última calificacion la más reciente
***
foreach k in p_mat_std p_esp_std {
	use "$basesD\panel_fuzzy.dta", clear
	gsort -anyo
	keep curp grado `k'
	*using most recent if retention
	*p_esp p_mat p_mat_std p_esp_std p_mat_perc p_esp_perc
	*keep if substr(curp,1,1)=="A"
	drop if grado >6
	duplicates drop curp grado, force
	reshape wide `k', i(curp)j(grado)
	forvalues x=3/6{
		drop if `k'`x'==.
	}
	cd "$dir\resultados\regresiones"
	reg `k'6 `k'5 `k'4 `k'3 , r
	outreg2 using recien`k'.xls, text ctitle(number of hosp.) bdec(3) sdec(3) paren(se) asterisk(coef)
	}


**********
**usando un lag
**********

use "$basesD\panel_fuzzy.dta", clear
gsort curp -anyo
keep curp grado  p_mat_std p_esp_std 
drop if grado >6
duplicates drop curp grado, force
gen aux=substr(curp,1,1)
bysort aux: gen aux2 = _n
bysort aux curp: egen auxiliar=max(aux2)
egen letra= group(aux)
gen cero= 101010
egen clave = concat(letra cero auxiliar)
keep curp grado  p_mat_std p_esp_std clave
destring clave, replace
xtset clave grado
foreach k in p_mat_std p_esp_std {
	cd "$dir\resultados\regresiones"
	xtreg `k' L.`k', fe vce(cluster clave)
	outreg2 using xtar(1).xls, text ctitle(`x') bdec(3) sdec(3) paren(se) asterisk(coef)
	}

	
foreach k in p_mat_std p_esp_std {
	cd "$dir\resultados\regresiones"
	xtreg `k' L.`k', fe 
	outreg2 using xtar(1)sinvce.xls, text ctitle(`x') bdec(3) sdec(3) paren(se) asterisk(coef)
	}
	
	
foreach k in p_mat_std p_esp_std {
	cd "$dir\resultados\regresiones"
	xtreg `k' L.`k' 
	outreg2 using xtar(1)sinfe.xls, text ctitle(`x') bdec(3) sdec(3) paren(se) asterisk(coef)
	}



