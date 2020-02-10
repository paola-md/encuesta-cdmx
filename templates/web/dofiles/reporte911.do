/* ESTE DOFILE GENERA UNA TABLA CON ESTADÍSTICOS DESCRIPTIVOS DEL PANEL 911, UNA TABLA DONDE 
   SE MUESTRA EL NÚMERO DE ALUMNOS QUE PARTICIPARON EN LA PRUEBA ENLACE DE 2006-2012, POR ENTIDAD, Y, POR ÚLTIMO, 
   UNA TABLA DONDE SE MUESTRA EL NÚMERO DE ESCUELAS QUE PARTICIPARON EN LA PRUEBA ENLACE DE 2006-2012 POR ENTIDAD. */
 
 
clear all
set more off


gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM\"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source\"
gl basesA= "$dir\basesAuxiliares\"
gl basesD = "$basesA\deleteMyFiles\"
gl resultados ="$dir\resultados\"




*====================================================
// 1) descripcion del panel 911
*====================================================

	use "$basesA\panel911_primaria_0616.dta", clear
	gen num_variables=184
	gen num_obs=_N
	duplicates drop CLAVECCT, force
	gen num_cct=_N
	
	
	gen nombre = "panel_911"
	duplicates drop num_cct, force
	keep num_variables num_obs num_cct nombre
	order nombre num_cct num_obs num_variables
	
	export excel using "$resultados\tabla_descriptiva_911.xls", sheet("panel 911", replace) firstrow(varlabels)



	
*====================================================	
// 2)por estado num escuelas num alumnos
*====================================================

/* Este 'foreach' contabiliza el número de alumnos que presentó la prueba Enlace por entidad de 2006-2012 */


forvalues a=6/12{
	use "$basesA\panel911_primaria_0616.dta", clear
	
	keep  if anyo==`a'
	*los dos primeros dígitos del CCT denotan, en orden alfabético, la entidad federativa a la cual pertenece la escuela 
	
	gen edo=substr(CLAVECCT,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	
	*sumamos los estudiantes inscritos que realizan la prueba ENLACE para cada cct 
	bysort CLAVECCT: gen ninyos_cct = insc_total_3 + insc_total_4 + insc_total_5 + insc_total_6
	bysort edo : egen num_ninyos_edo_anyo= total(ninyos_cct)
	
	duplicates drop edo, force 
	keep num_ninyos_edo_anyo edo
	
	export excel using "$resultados\tabla_alumnos_911.xls", sheet(" alumnos anyo `a'", replace) firstrow(varlabels)
}



/* Este 'foreach' contabiliza el número de escuelas que presentó la prueba Enlace por entidad de 2006-2012 
   
   El criterio para contabilizar las escuelas es independiente del número de turnos que tenga la escuela, es decir, si una escuela tiene varios turnos
   se seguira considerando como solo una escuela
   
   */


forvalues x=6/12 {
	use "$basesA\panel911_primaria_0616.dta", clear
	keep if anyo==`x'
	duplicates drop CLAVECCT, force
	gen edo=substr(CLAVECCT,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	
	
	bysort edo: egen num_escuelas = count(CLAVECCT)
	duplicates drop edo, force 
	keep edo num_escuelas
	export excel using "$resultados\tabla_escuelas_911.xls", sheet(" escuelas anyo `x'", replace) firstrow(varlabels)
}



*====================================================	
// 3) 911 vs ENLACE
*====================================================


*Investigación de sesgo en la prueba enlace 

use "$basesA\panel_exacto.dta", clear

*Hacemos el análisis solo para primaria

drop if grado>6 	

*Calculo de niños atrasados por edad

gen anyo_nac=substr(curp,5,2)
gen mes_nac=substr(curp,7,2)
destring anyo_nac, replace force
destring mes_nac, replace force
drop if mes_nac<1 | mes_nac>12
drop if anyo_nac<84
replace anyo_nac=anyo_nac+1900	

gen edad=(12*(anyo-anyo_nac)-(mes_nac-8))/12

drop anyo_nac
drop mes_nac

/* De acuerdo con la SEP la primaria se imparte de los 6 años a los 12 años (ingresando entre 
los 6 y 7 años y saliendo entre los 11 y 12 años), por lo que se consideró atrasados a los niños con el siguiente criterio:

1ro: 8 años en adelante 
2do: 9 años en adelante
3ro: 10 años en adelante
4to: 11 años en adelante
5to: 12 años en adelante 
6to: 13 años en adelante 

*/

gen atrasado=0

*Generamos dummys en caso de que el niño esté atrasado

foreach i of numlist 3/6{
	local aux=`i'+9
	replace atrasado=1 if edad>`aux' & grado==`i' 
}

*Generamos dummys EN EL SEGUNDO AÑO, en caso que el niño repitiera

sort curp grado anyo

bysort curp grado: gen aux=_n

gen reprobado=(aux>1)

drop aux

/*Generamos variable que a la hora de hacer el collapse nos cuente el numero total de alumnos
	por escuela y por grado
*/

gen total_alum=1

collapse (sum) reprobado atrasado total_alum , by(cct grado anyo)

save "$basesD\panel_exacto_repetidores.dta", replace


*Preparamos la base de f911 para realizar el merge

use "$basesA\panel911_primaria_0616.dta", clear
	
rename CLAVECCT cct
	
	*Solamente nos quedamos con variables a partir de 3er grado y los totales
	
	foreach i of numlist 3/6{
		gen repetidor_`i'=rep_h_`i'+rep_m_`i'
	}
	
replace anyo=anyo+2000
	
keep  edades_atrasadas_3 edades_atrasadas_4 edades_atrasadas_5 edades_atrasadas_6 ///
repetidor_3 repetidor_4 repetidor_5 repetidor_6 insc_total_3 insc_total_4 insc_total_5 ///
insc_total_6 cct anyo
	
*Para poder realizar el merge más adelante, para las escuelas con dos turnos se tomo como una sola
	
collapse (sum) insc_total_3 insc_total_4 insc_total_5 insc_total_6 edades_atrasadas_3 edades_atrasadas_4 edades_atrasadas_5 /// 
edades_atrasadas_6 repetidor_3 repetidor_4 repetidor_5 repetidor_6, by(cct anyo)
	
save  "$basesD\panel911_primaria_0616_repetidores.dta", replace
	
*Realizamos el reshape

use "$basesD\panel_exacto_repetidores.dta", clear
reshape wide reprobado atrasado total_alum, i(cct anyo) j(grado)
*Realizamos el merge 

	merge 1:1 cct anyo using "$basesD\panel911_primaria_0616_repetidores.dta"
	
	drop _merge
	
*Generamos variables totales por escuela.
gen reprobados_total_enlace=reprobado3+reprobado4+reprobado5+reprobado6
gen atrasados_total_enlace=atrasado3+atrasado4+atrasado5+atrasado6 
gen total_alum_enlace=total_alum3+total_alum4+total_alum5+total_alum6
gen reprobados_total_911=repetidor_3+repetidor_4+repetidor_5+repetidor_6
gen atrasados_total_911=edades_atrasadas_3+edades_atrasadas_4+edades_atrasadas_5+edades_atrasadas_6
gen total_alum_911=insc_total_3+insc_total_4+insc_total_5+insc_total_6
gen p_reprobados =reprobados_total_enlace/reprobados_total_911
gen p_atrasados=atrasados_total_enlace/atrasados_total_911
gen p_total=total_alum_enlace/total_alum_911

replace p_reprobados=1 if reprobados_total_enlace==0 & reprobados_total_911==0
replace p_atrasados=1  if atrasados_total_enlace==0 & atrasados_total_911==0
replace p_total=1  if total_alum_enlace==0 & total_alum_911==0
	
save "$basesD\merge_911_enlance.dta", replace


*Generamos las graficas

use "$basesD\merge_911_enlance.dta", clear


gen edo=substr(cct,1,2)
drop if edo=="16" | edo=="20"
drop edo
*Por qué salen valores tan grandes

drop if p_atrasados>1.3
drop if p_total>1.3
drop if p_reprobados>1.3

local labsize medlarge
local bigger_labsize large
local ylabel_options  notick labsize(`labsize') angle(horizontal)
local xlabel_options  notick labsize(`labsize')
local xtitle_options size(`labsize') margin(top)
local title_options size(`bigger_labsize') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
local T_line_options lwidth(thin) lcolor(gray) lpattern(dash)
local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)
local rcap_options_95 lcolor(black) lwidth(thin)
hist p_atrasados ,  `estimate_options_95' color(red%30) frac width(.1)  ///
title("") ///
yline(0, `manual_axis') ///
xtitle("# atrasados ENLACE / # atrasados 911", `xtitle_options') ///
ytitle("Fracción", `xtitle_options') ///
xscale(range(`min_xaxis' `max_xaxis')) ///
xscale(noline) `plotregion' `graphregion' legend(off) ///
lwidth(medthick) 
graph export  "$resultados\graficas\ATRASADOS_enlace911.png", as (png) replace




local labsize medlarge
local bigger_labsize large
local ylabel_options  notick labsize(`labsize') angle(horizontal)
local xlabel_options  notick labsize(`labsize')
local xtitle_options size(`labsize') margin(top)
local title_options size(`bigger_labsize') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
local T_line_options lwidth(thin) lcolor(gray) lpattern(dash)
local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)
local rcap_options_95 lcolor(black) lwidth(thin)
hist p_total ,  `estimate_options_95' color(red%30) frac width(.1)  ///
title("") ///
yline(0, `manual_axis') ///
xtitle("# total alum ENLACE / # total alum 911", `xtitle_options') ///
ytitle("Fracción", `xtitle_options') ///
xscale(range(`min_xaxis' `max_xaxis')) ///
xscale(noline) `plotregion' `graphregion' legend(off) ///
lwidth(medthick) 
graph export  "$resultados\graficas\TOTAL_enlace911.png", as (png) replace

*Borramos a partir del 99% 

local labsize medlarge
local bigger_labsize large
local ylabel_options  notick labsize(`labsize') angle(horizontal)
local xlabel_options  notick labsize(`labsize')
local xtitle_options size(`labsize') margin(top)
local title_options size(`bigger_labsize') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
local T_line_options lwidth(thin) lcolor(gray) lpattern(dash)
local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)
local rcap_options_95 lcolor(black) lwidth(thin)
hist p_reprobados ,  `estimate_options_95' color(red%30) frac width(.1) ///
yline(0, `manual_axis') ///
title("") ///
xtitle("# reprobados ENLACE/ # reprobados 911", `xtitle_options') ///
ytitle("Fracción", `xtitle_options') ///
xscale(range(`min_xaxis' `max_xaxis')) ///
xscale(noline) `plotregion' `graphregion' legend(off) ///
lwidth(medthick) 
graph export  "$resultados\graficas\REPROBADOS_enlace911.png", as (png) replace

*A lo mejor eliminar el cero de los reprobados para que se vea mejor la gráfica


keep  p_*
sum p_reprobados,d
sum p_atrasados,d
sum p_total,d
outreg2 using "$resultados\911_vs_ENLACE.xls", replace sum(detail) keep( p_atrasados p_reprobados p_total)






