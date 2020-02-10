**********************************************
*Nueva Calidad Español y Mate con Porcentajes
*Último Edición: 18/10/2018
*********************************************
clear all
gl temp "D:\Educacion\entrega BM\bases auxiliares\deleteMyFiles"
gl source "D:\Educacion\entrega BM\bases originales"
cd "$temp"


// Calcula los promedios por escuela desde 2006 hasta el 2012
foreach anyo1 in  06 07 08 09 10 11 12  {
	capture confirm file "$source\B`anyo1'.dta"
	 if _rc==0 {
		use "$source\B`anyo1'.dta"
		keep cct p_esp p_mat
		sort cct
		bys cct: egen promEscuela_20`anyo1'_mat = mean(p_mat) 
		bys cct: egen promEscuela_20`anyo1'_esp = mean(p_esp) 
		duplicates drop cct, force
		keep cct promEscuela_20`anyo1'_mat promEscuela_20`anyo1'_esp
		save r20`anyo1'_me, replace							 
	 }
}

// Junta los promedios por escuela de todos los años
clear all
use r2006_me //Usa el primer año. me es de matemáticas y español
foreach anyo1 in  07 08 09 10 11 12  {
	merge 1:1 cct using "$temp\r20`anyo1'_me.dta"
	drop _merge
}

save prom_me, replace

//Calculo de cambios porcentuales (cp) para matematicas y español


clear all
use prom_me
foreach x in 07 08 09 10 11 12  {
	if `x'<11 {
		local aux = `x'-1
		local y = "0`aux'"
	} 
	else{
		local y = `x'-1
	}
	gen cp_`x'_m = ((promEscuela_20`x'_mat)-(promEscuela_20`y'_mat))/(promEscuela_20`x'_mat)
	gen cp_`x'_e = ((promEscuela_20`x'_esp)-(promEscuela_20`y'_esp))/(promEscuela_20`x'_esp)
}

save cp_me, replace //cambios porcentuales de matematicas y español


//Prepara inforacion para histograma
//Para matematicas
foreach x in 07 08 09 10 11 12  {
	clear all
	use cp_me
	keep cct cp_`x'_m //Para matematicas
	rename cp_`x' cp_m //Append todos los años en una columna 
	save col_cp_`x'_m, replace
}

//Junta las columnas en una
clear all
use col_cp_07_m 
foreach x in 08 09 10 11 12  {
	append using "$temp\col_cp_`x'_m.dta"
}
drop cct
save cp_todas_m, replace

//Para español
foreach x in 07 08 09 10 11 12  {
	clear all
	use cp_me
	keep cct cp_`x'_e //Para matematicas
	rename cp_`x' cp_e //Append todos los años en una columna 
	save col_cp_`x'_e, replace
}

//Junta las columnas en una
clear all
use col_cp_07_e 
foreach x in 08 09 10 11 12  {
	append using "$temp\col_cp_`x'_e.dta"
}
drop cct
save cp_todas_e, replace

//Histograma de español y matemáticas
clear all
use cp_todas_e
append using cp_todas_m
save calidad_grafica, replace

use calidad_grafica, clear
#delimit ;
twoway 
(hist cp_e if inrange(cp_e,-.5,.5), 
width(0.1)
frac lcolor(gs12) fcolor(eltblue)) 

(hist cp_m if inrange(cp_m,-.5,.5), 
width(0.1)
frac fcolor(none) lcolor(black)), 

xtitle("Cambio Porcentual")
ytitle("Fracción")
title("Variación de resultados entre años consecutivos", `title_options')
legend(order(1 "Español" 2 "Matemáticas"))
;
#delimit cr

graph export "$temp/variacionResultados.pdf", replace



// GRAPH FORMATTING
// For graphs:
local smaller_labsize vsmall
local labsize medlarge
local bigger_labsize large
local ylabel_options nogrid notick labsize(`labsize') angle(horizontal)
local xlabel_options nogrid notick labsize(`labsize')
local xtitle_options size(`smaller_labsize') margin(top)
local title_options size(`medsmall') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 

