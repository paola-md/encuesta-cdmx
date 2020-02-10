
clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl dir2="$basesO"
gl basesD = "$dir\bases auxiliares\deleteMyFiles\"

*si 1 alumno presento el examen en ese año en esa escuela se queda con la escuela
forvalues x = 6/12 {
	if `x'!=11{
		use "$basesA\B`x'.dta", clear
		duplicates drop cct,force
		keep cct anyo
		replace cct = substr(cct,1,9)
		rename anyo a_`x'
	}
	save "$basesD\Besc`x'.dta", replace
	}
	
use  "$basesD\Besc12.dta", clear
duplicates drop cct, force
forvalues x = 6/10 {
	merge 1:m cct using "$basesD\Besc`x'.dta"
	drop _merge
	duplicates drop cct, force
}
save "$basesA\todas_las_escuelas.dta", replace

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
use "$basesA\todas_las_escuelas.dta", clear 
 
drop if a_12!=. & a_6!=. & a_7!=. & a_8!=. & a_9!=. & a_10!=. 
gen tipo=substr(cct, 3, 1)
order cct  a_6 a_7 a_8 a_9 a_10 a_12
egen anyoAp=rowfirst( a_6 a_7 a_8 a_9 a_10 a_12)
egen anyoCierre= rowlast( a_6 a_7 a_8 a_9 a_10 a_12)
egen cuenta= anycount( a_6 a_7 a_8 a_9 a_10 a_12 ), values(2006 2007 2008 2009 2010 2012)
gen resta=  anyoCierre - anyoAp
gen raro=0
replace raro= 1 if resta!= cuenta &  anyoAp!=anyoCierre & anyoCierre==2012
replace raro= 1 if resta!= cuenta - 1 & anyoCierre<2012

save "$basesD\apertura_cierreB.dta", replace

* genera una base de las escuelas que no aparecen en un año
drop if raro!=1
save "$basesD\escuelas_raras.dta", replace

*busca a los niños de las que cerraron despues de que cerraron

use "$basesD\apertura_cierreB.dta", clear
drop if raro==1
keep if anyoCierre<2012
gen abre = anyoAp>2006
save "$basesD\cierran.dta", replace




********************************
*arma base isaac
********************************
set more off

forvalues x= 6/10{
	use "$basesD\cierran.dta", clear
	*busca a los niños de las que cerraron en otras escuelas
	if `x'==10{
		keep if anyoCierre==2010  
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
	
	if `x'==10{
		use  "$basesA\B12.dta", clear
	}
	if `x'<10{
		local k= `x'+1
		use  "$basesA\B`k'.dta", clear
	}
	
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
	
	save "$basesD\destino`x'.dta", replace
	
	}
	
	
	
	
	
use  "$basesD\destino6.dta"
forvalues x=7/10{
	append using "$basesD\destino`x'.dta"
}
drop if cct_destino==""
save "$basesD\destino.dta", replace


use "$basesA\todas_las_escuelas.dta", clear
duplicates drop cct, force
forvalues x= 6/10{
bysort a_`x': gen total`x'=_N 
}
bysort a_12: gen total12=_N 
forvalues x= 6/10{
	drop if a_`x'==. 
}
drop if a_12==. 
duplicates drop total10,force
keep total*
export excel using "$dir\resultados\analisis.xlsx", sheet("total", replace) firstrow(varlabels)



use"$basesD\destino.dta", clear
preserve
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran=_N
keep anyoCierre escuelas_cierran
duplicates drop anyoCierre escuelas_cierran, force
export excel using "$dir\resultados\analisis.xlsx", sheet("cierran", replace) firstrow(varlabels)
restore


preserve
drop if encontramos<.25
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran_25=_N
keep anyoCierre escuelas_cierran_25
duplicates drop anyoCierre escuelas_cierran_25, force
export excel using "$dir\resultados\analisis.xlsx", sheet("cierran.25", replace) firstrow(varlabels)
restore

preserve
drop if encontramos<.40
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran_40=_N
keep anyoCierre escuelas_cierran_40
duplicates drop anyoCierre escuelas_cierran_40, force
export excel using "$dir\resultados\analisis.xlsx", sheet("cierran.40", replace) firstrow(varlabels)
restore


********************************
*aperturas
********************************
set more off

forvalues x= 7/12{
	use "$basesD\apertura_cierreB.dta", clear
	*busca a los niños de las que cerraron en otras escuelas
	if `x'!=11 {
		if `x'==10 | `x'==12{
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
		clear 
		
		if `x'==12{
			use  "$basesA\B10.dta", clear
		}
		if `x'<11{
			local k= `x'-1
			use  "$basesA\B`k'.dta", clear
		}
		
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
		
		save "$basesD\anterior`x'.dta", replace
	}
	}
	
	
	
	
	
use  "$basesD\anterior12.dta"
forvalues x=7/10{
	append using "$basesD\anterior`x'.dta"
}
drop if cct_anterior==""
save "$basesD\anterior.dta", replace


use "$basesA\todas_las_escuelas.dta", clear
duplicates drop cct, force
forvalues x= 6/10{
bysort a_`x': gen total`x'=_N 
}
bysort a_12: gen total12=_N 
forvalues x= 6/10{
	drop if a_`x'==. 
}
drop if a_12==. 
duplicates drop total10,force
keep total*
export excel using "$dir\resultados\analisisAp.xlsx", sheet("total", replace) firstrow(varlabels)



use"$basesD\anterior.dta", clear
preserve
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran=_N
keep anyoCierre escuelas_cierran
duplicates drop anyoCierre escuelas_cierran, force
export excel using "$dir\resultados\analisisAp.xlsx", sheet("abre", replace) firstrow(varlabels)
restore


preserve
drop if encontramos<.25
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran_25=_N
keep anyoCierre escuelas_cierran_25
duplicates drop anyoCierre escuelas_cierran_25, force
export excel using "$dir\resultados\analisisAp.xlsx", sheet("abren.25", replace) firstrow(varlabels)
restore

preserve
drop if encontramos<.40
duplicates drop cct, force
bysort anyoCierre: gen escuelas_cierran_40=_N
keep anyoCierre escuelas_cierran_40
duplicates drop anyoCierre escuelas_cierran_40, force
export excel using "$dir\resultados\analisisAp.xlsx", sheet("abren.40", replace) firstrow(varlabels)
restore



/*
*mide distancias lineales
gen difLat = latitud_origen - latitud_destino
gen difLong = longitud_origen - longitud_destino
gen difLatkm=difLat*111.111
gen difLongkm = difLong * 111.111
gen dist= sqrt(difLongkm^2 + difLatkm^2)
rename cct cct_origen
merge 1:1 cct_origen cct_destino using "$cie\bases auxiliares\dist_coche.dta"
drop if dummy ==1

preserve
	drop if encontramos <.25
	histogram dist [w=ninos] if inrange(dist,0,22), frequency
	graph export "$cie\resultados\hist_distancias_lineal.png", as (png) replace
restore

preserve
	drop if encontramos <.25
	histogram resultados [w=ninos] if inrange(resultados,0,22), frequency
	graph export "$cie\resultados\hist_distancias_coche.png", as (png) replace
restore

preserve
	drop if encontramos <.25
	histogram dist [w=ninos] if inrange(dist,0,5), frequency
	*graph export "$cie\resultados\hist_distancias_coche.png", as (png) replace
restore
