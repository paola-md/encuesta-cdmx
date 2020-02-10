
clear all
set more off
gl bases = "D:\Educacion\entrega BM\bases originales"
gl cie = "D:\Educacion\entrega BM"
gl basesA= "$cie\bases auxiliares"

******************
*seguimiento el último año en el que aparece la generación hacia atrás
******************

if 0==1{
	forvalues x =6/9{
		use "$bases\B0`x'.dta", clear
		drop apellido_nombre
		save "$basesA\B`x'.dta", replace
		
	}
	forvalues x=11/12{
		use "$bases\B`x'.dta", clear
		drop apellido_nombre
		save "$basesA\B`x'.dta", replace
		
	}
	use "$bases\B10bis.dta", clear
	drop apellido_nombre
	save "$basesA\B10.dta", replace
	
}


forvalues t = 10/12{
	if `t'!=11 {
		if `t'==12 {
			gl begin=5
			gl end=9
		}
		if `t'== 10{
			gl begin=8
			gl end=9
		}
		forvalues x=$begin / $end {
			use "$basesA\B`t'.dta", clear
			if `t'==12 {
				if  `x'==9 {
					gl first = 6
				}
				if `x'==8{
					gl first = 7 
				}
				if `x'==7{
					gl first = 8 
				}
				if `x'==6 {
					gl first = 9 
				}
				if `x'==5 {
					gl first = 10
				}	

				gl last = 11
			}
			if `t'==11 {
				gl first=6
				gl last =10
			
			}
			if `t'==10 {
				gl first=6
				gl last =9
			
			}

			keep if grado==`x' 
			keep curp grado
			rename grado grado_`t'
			duplicates drop curp, force
			forvalues a=$first / $last {
				merge 1:m curp using "$basesA\B`a'.dta", keepusing(grado)
				drop if _merge==2
				gen aux = _merge==3
				egen porcentaje_asistencia_`a' = mean(aux)
				duplicates drop curp, force
				rename grado grado_`a'
				drop _merge aux
			}
			gen porcentaje_asistencia_`t'=1
			duplicates drop porcentaje_asistencia_$last , force
			keep porcentaje_asistencia_*
			export excel using "$cie\resultados\seguimiento.xlsx", sheet("`x' en 20`t'", replace) firstrow(varlabels)
			gen grado= `x'
			reshape long porcentaje_asistencia_, i(grado) j(anyo)
				forvalues m=6/9 {
		replace anyo = 200`m' if anyo==`m'
	}
	forvalues m=10/12 {
		replace anyo = 20`m' if anyo==`m'
	}
			twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			graph export "$cie\resultados\graficas\g_`x' en 20`t'.png", as (png) replace

			}
	}
}

	
****************
*seguimiento de generaciones de las que observamos toda la primaria 
******************
forvalues t = 9/12{
	use "$basesA\B`t'.dta", clear
	if `t'==12 {
		gl first = 9 
	}
	if `t'==11 {
		gl first = 8
	}	
	if `t'==10 {
		gl first = 7
	}	
	if `t'==9 {
		gl first = 6
	}	
	gl last = `t' - 1 
	keep if grado==6
	keep curp grado
	rename grado grado_`t'
	duplicates drop curp, force
	forvalues a=$first / $last {
		merge 1:m curp using "$basesA\B`a'.dta", keepusing(grado)
		drop if _merge==2
		gen aux = _merge==3
		egen porcentaje_asistencia_`a' = mean(aux)
		duplicates drop curp, force
		rename grado grado_`a'
		drop _merge aux
	}
	gen porcentaje_asistencia_`t'=1
	duplicates drop porcentaje_asistencia_$last , force
	keep porcentaje_asistencia_*
	export excel using "$cie\resultados\seguimiento_pri.xlsx", sheet("6 en 20`t'", replace) firstrow(varlabels)
	gen grado= 6
	reshape long porcentaje_asistencia_, i(grado) j(anyo)
	forvalues m=6/9 {
		replace anyo = 200`m' if anyo==`m'
	}
	forvalues m=10/12 {
		replace anyo = 20`m' if anyo==`m'
	}
	twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 6 en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
	graph export "$cie\resultados\graficas\primaria_6 en 20`t'.png", as (png) replace

}

clear all
import excel "$cie\resultados\seguimiento_pri.xlsx", sheet("6 en 209") firstrow
gen grado= 6
reshape long porcentaje_asistencia_, i(grado) j(anyo)
forvalues m=6/9 {
	replace anyo = 200`m' if anyo==`m'
}
twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 6 en 2009") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")	
graph export "$cie\resultados\graficas\primaria_6 en 2009.png", as (png) replace

clear all
import excel using "$cie\resultados\seguimiento.xlsx", sheet("9 en 2012") firstrow
gen grado= 9
drop porcentaje_asistencia_11
reshape long porcentaje_asistencia_, i(grado) j(anyo)
forvalues m=6/9 {
	replace anyo = 200`m' if anyo==`m'
}
forvalues m=10(2)12 {
	replace anyo = 20`m' if anyo==`m'
}
twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 9 en 2012") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
graph export "$cie\resultados\graficas\g_9 en 2012.png", as (png) replace

clear all
import excel using "$cie\resultados\seguimiento.xlsx", sheet("9 en 2010") firstrow
gen grado= 9
reshape long porcentaje_asistencia_, i(grado) j(anyo)
forvalues m=6/9 {
	replace anyo = 200`m' if anyo==`m'
}
drop if anyo==2008
replace anyo = 2010 if anyo==10
twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 9 en 2010") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
graph export "$cie\resultados\graficas\g_9 en 2010.png", as (png) replace

clear all
import excel using "$cie\resultados\seguimiento.xlsx", sheet("8 en 2012") firstrow
gen grado= 8
drop porcentaje_asistencia_11
reshape long porcentaje_asistencia_, i(grado) j(anyo)
forvalues m=6/9 {
	replace anyo = 200`m' if anyo==`m'
}
forvalues m=10(2)12 {
	replace anyo = 20`m' if anyo==`m'
}
twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 8 en 2012") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
graph export "$cie\resultados\graficas\g_8 en 2012.png", as (png) replace


clear all
import excel using "$cie\resultados\seguimiento.xlsx", sheet("5 en 2012") firstrow
gen grado= 5
reshape long porcentaje_asistencia_, i(grado) j(anyo)
forvalues m=6/9 {
replace anyo = 200`m' if anyo==`m'
}
forvalues m=10/12 {
	replace anyo = 20`m' if anyo==`m'
}
twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 5 en 2012") xlabel(2010 (1) 2012) legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
graph export "$cie\resultados\graficas\g_5 en 2012.png", as (png) replace
