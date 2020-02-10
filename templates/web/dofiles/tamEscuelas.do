*******************************
*Histograma Tamaño Escuelas
*Ultima edicion: 05/11/2018
*******************************
clear all

gl temp "D:\Educacion\entrega BM\bases auxiliares\deleteMyFiles"
gl source "D:\Educacion\entrega BM\bases originales"
cd "$temp"

// ==============================================
// Código para crear histograma de tamaño de escuelas 
//================================================


//Cuenta el numero de alumnos por escuela por año
foreach anyo1 in  06 07 08 09 10 11 12{
	use "$source\B`anyo1'.dta"
	bys cct: egen asistencia_`anyo1' = count(grado)
	//Lo hace con el grado porque eun muchos casos falta el curp 
	duplicates drop cct, force
	keep  asistencia_`anyo1'
	save tamEscuela_`anyo1', replace
	 
}



//Histograma de español y matemáticas
clear all
use tamEscuela_07
append using tamEscuela_12
save tam_07_12, replace

#delimit ;
twoway 
(hist asistencia_07 if inrange(asistencia_07,0,1000), 
width(50)
frac lcolor(gs12) fcolor(eltblue)) 

(hist asistencia_12 if inrange(asistencia_12,0,1000), 
width(50)
frac fcolor(none) lcolor(black)), 

xtitle("Número de alumnos")
ytitle("Fracción")
title("Tamaño de escuela en 2007 y en 2012", `title_options')
legend(order(1 "2007" 2 "2012"))
;
#delimit cr

graph export "$temp/histTam.pdf", replace



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

