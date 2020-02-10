
clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl dir2="$basesO"
gl basesD = "$dir\bases auxiliares\deleteMyFiles\"

*si 1 alumno presento el examen en ese año en esa escuela se queda con la escuela
forvalues x = 6/12 {
		use "$basesA\B`x'.dta", clear
		drop if grado>6
		duplicates drop cct,force
		keep cct anyo
		replace cct = substr(cct,1,9)
		rename anyo a_`x'
	save "$basesD\Besc`x'.dta", replace
	}
	
use  "$basesD\Besc12.dta", clear
duplicates drop cct, force
forvalues x = 6/11 {
	merge 1:m cct using "$basesD\Besc`x'.dta"
	drop _merge
	duplicates drop cct, force
}
save "$basesA\todas_las_escuelas_pri.dta", replace

*pega direcciones a todas las escuelas
/*
clear all
import delimited "$dir\source\escuelas_coord.csv"
duplicates drop cct, force
replace cct = substr(cct,1,9)
keep longitud latitud cct 
duplicates drop cct, force
merge 1:m cct using "$basesA\todas_las_escuelas.dta"

*guarda todas las escuelas con sus direcciones
drop if _merge!=3 
drop _merge
save "$basesD\todas_las_escuelas_dir.dta", replace
 */
use "$basesA\todas_las_escuelas_pri.dta", clear 
 
drop if a_12!=. & a_6!=. & a_7!=. & a_8!=. & a_9!=. & a_10!=. & a_11!=.
gen tipo=substr(cct, 3, 1)
order cct  a_6 a_7 a_8 a_9 a_10 a_11 a_12
egen anyoAp=rowfirst( a_6 a_7 a_8 a_9 a_10 a_11 a_12)
egen anyoCierre= rowlast( a_6 a_7 a_8 a_9 a_10 a_11 a_12)
egen cuenta= anycount( a_6 a_7 a_8 a_9 a_10 a_11 a_12 ), values(2006 2007 2008 2009 2010 2011 2012)
gen resta=  anyoCierre - anyoAp
gen raro=0
replace raro= 1 if resta!= cuenta - 1

save "$basesD\apertura_cierre_pri.dta", replace

*busca a los niños de las que cerraron despues de que cerraron

use "$basesD\apertura_cierre_pri.dta", clear
drop if raro==1
keep if anyoCierre<2012
gen abre = anyoAp>2006
save "$basesD\cierran_pri.dta", replace




********************************
*arma base isaac
********************************
set more off

forvalues x= 6/11{
	use "$basesD\cierran_pri.dta", clear
	*busca a los niños de las que cerraron en otras escuelas
	if `x'>9{
		keep if anyoCierre==20`x'  
		}
	if `x'<10{
		keep if anyoCierre==200`x'  
	}
	duplicates drop cct, force
	save "$basesD\ayuda.dta", replace
	use  "$basesA\B`x'.dta", clear
	bysort cct: gen alumnos=_N
	replace cct = substr(cct,1,9)
	merge m:1 cct using "$basesD\ayuda.dta"
	drop if _merge!=3
	drop _merge
	*rename latitud latitud_origen
	*rename longitud longitud_origen
	save "$basesD\auxiliar.dta", replace
	clear 
	local m=`x'
	local k= `x'+1
	use  "$basesA\B`k'.dta", clear
	gen cct_destino = substr(cct,1,9) 
	drop cct
	duplicates drop curp, force
	merge 1:m curp using  "$basesD\auxiliar.dta"
	drop if _merge!=3
	drop _merge
	bysort cct: gen total=_N
	bysort cct cct_destino: gen ninos = _N
	gen encontramos=total/alumnos
	duplicates drop cct cct_destino, force
	keep cct anyoAp anyoCierre cct_destino alumnos ninos encontramos 
	save "$basesD\destino`x'_pri.dta", replace
	
	}
	
	
	
	
	
use  "$basesD\destino6_pri.dta", clear
forvalues x=7/11{
	append using "$basesD\destino`x'_pri.dta"
}
drop if cct_destino==""
save "$basesD\destino_pri.dta", replace

************

foreach m in 0 1 { 
	use "$basesA\todas_las_escuelas_pri.dta", clear
	duplicates drop cct, force
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	forvalues x= 6/12{
	bysort a_`x': gen total`x'=_N 
	}

	forvalues x= 6/12{
		drop if a_`x'==. 
	}
	duplicates drop total10,force
	keep total*
	export excel using "$dir\resultados\analisis_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\destino_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	preserve
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran=_N
	keep anyoCierre escuelas_cierran
	duplicates drop anyoCierre escuelas_cierran, force
	export excel using "$dir\resultados\analisis_pri.xlsx", sheet("cierran_`m'", replace) firstrow(varlabels)
	restore


	preserve
	drop if encontramos<.25
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_25=_N
	keep anyoCierre escuelas_cierran_25
	duplicates drop anyoCierre escuelas_cierran_25, force
	export excel using "$dir\resultados\analisis_pri.xlsx", sheet("cierran.25_`m'", replace) firstrow(varlabels)
	restore

	preserve
	drop if encontramos<.40
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_40=_N
	keep anyoCierre escuelas_cierran_40
	duplicates drop anyoCierre escuelas_cierran_40, force
	export excel using "$dir\resultados\analisis_pri.xlsx", sheet("cierran.40_`m'", replace) firstrow(varlabels)
	restore
}

********************************
*aperturas
********************************
set more off

forvalues x= 7/12{
use "$basesD\apertura_cierre_pri.dta", clear
*busca a los niños de las que cerraron en otras escuelas
	if `x'>9{
		keep if anyoAp==20`x'
		}
	if `x'<10{
		keep if anyoAp==200`x'  
	}
	drop if raro==1
	duplicates drop cct, force
	save "$basesD\ayuda.dta", replace
	use  "$basesA\B`x'.dta", clear
	bysort cct: gen alumnos=_N
	replace cct = substr(cct,1,9)
	merge m:1 cct using "$basesD\ayuda.dta"
	drop if _merge!=3
	drop _merge
	*rename latitud latitud_origen
	*rename longitud longitud_origen
	save "$basesD\auxiliar.dta", replace
	local k= `x'-1
	use  "$basesA\B`k'.dta", clear
	gen cct_anterior = substr(cct,1,9) 
	drop cct
	duplicates drop curp, force
	merge 1:m curp using  "$basesD\auxiliar.dta"
	drop if _merge!=3
	drop _merge
	bysort cct: gen total=_N
	bysort cct cct_anterior: gen ninos = _N
	gen encontramos=total/alumnos
	duplicates drop cct cct_anterior, force
	keep cct anyoAp anyoCierre cct_anterior alumnos ninos encontramos 
	
	save "$basesD\anterior`x'_pri.dta", replace

}

	
	
	
	
use  "$basesD\anterior12_pri.dta"
forvalues x=7/11{
	append using "$basesD\anterior`x'_pri.dta"
}
drop if cct_anterior==""
save "$basesD\anterior_pri.dta", replace

foreach m in 0 1 {

	use "$basesA\todas_las_escuelas_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	duplicates drop cct, force
	forvalues x= 6/12{
	bysort a_`x': gen total`x'=_N 
	}
	forvalues x= 6/12{
		drop if a_`x'==. 
	}
	drop if a_12==. 
	duplicates drop total10,force
	keep total*
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\anterior_pri.dta", clear
	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	preserve
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren=_N
	keep anyoAp escuelas_abren
	duplicates drop escuelas_abren , force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abre_`m'", replace) firstrow(varlabels)
	restore


	preserve
	drop if encontramos<.25
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren_25=_N
	keep anyoAp escuelas_abren_25
	duplicates drop  escuelas_abren_25, force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abren.25_`m'", replace) firstrow(varlabels)
	restore

	
	preserve
	drop if encontramos<.40
	duplicates drop cct, force
	bysort anyoAp: gen escuelas_abren_40=_N
	keep anyoAp escuelas_abren_40
	duplicates drop anyoAp escuelas_abren_40, force
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("abren.40_`m'", replace) firstrow(varlabels)
	restore

}
