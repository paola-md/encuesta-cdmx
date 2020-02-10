*******************************
*AsistenciaTodosAños
*Ultima edicion: 19/10/2018
*******************************
clear all

gl temp "D:\Educacion\entrega BM\bases auxiliares\deleteMyFiles"
gl source "D:\Educacion\entrega BM\bases originales"
cd "$temp"

// ==============================================
// Código para crear histograma de asistencias 
// Muestra cuanta gente fue por escuela comparada
// con la asistencia por escuela del año anterior
// Se muestra el porcentaje de cambio
//================================================


//Cuenta el numero de alumnos por escuela por año
foreach anyo1 in  06 07 08 09 10 11 12{
	use "$source\B`anyo1'.dta"
	bys cct: egen asistencia_`anyo1' = count(grado)
	//Lo hace con el grado porque eun muchos casos falta el curp 
	duplicates drop cct, force
	keep cct asistencia_`anyo1'
	save alumnos_`anyo1', replace
	 
}



//Juntar en una tabla el total de asistencias por año (columna) por escuela (fila)
clear all
use alumnos_06
foreach anyo1 in  06 07 08 09 10 11 12{
	merge 1:1 cct using "$temp\alumnos_`anyo1'.dta"
	drop _merge
}

order cct
save asistencia_por_anyo, replace

//Genera porcentajes de cambio 
clear all
use asistencia_por_anyo

foreach x in 07 08 09 10 11 12  {
	if `x'<11 {
		local aux = `x'-1
		local y = "0`aux'"
	} 
	else{
		local y = `x'-1
	}
	gen porcentaje_`x' = ((asistencia_`x')/(asistencia_`y'))-1
}

keep cct porcentaje_07 porcentaje_08 porcentaje_09 porcentaje_10 porcentaje_11 porcentaje_12
save asistencia_porcentajes, replace


//Junta informacion para histograma
foreach x in 07 08 09 10 11 12{
	clear all
	use asistencia_porcentajes
	keep cct porcentaje_`x'
	rename porcentaje_`x' porcentaje
	save col_porcentaje_`x', replace
}
//Junta en una misma columna
clear all
use col_porcentaje_07
foreach x in 08 09 10 11 12{
	append using "$temp\col_porcentaje_`x'.dta"
}
drop cct
save porcentaje_todas, replace

//Ver histograma
clear all 
use porcentaje_todas

#delimit ;
histogram porcentaje if inrange(porcentaje,-1,1), 
width(0.1) 
frac
fcolor(eltblue)
lcolor(ebblue) 
xtitle(Cambio Porcentual)
ytitle("Fraccion")
title("Variación de participación por escuela", `title_options')
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

