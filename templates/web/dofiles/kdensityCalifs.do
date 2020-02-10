**********************************************
* K-Density mate español
* Última Edición: 5/11/2018
*********************************************
clear all
gl temp "D:\Educacion\entrega BM\bases auxiliares\deleteMyFiles"
gl source "D:\Educacion\entrega BM\bases originales"
cd "$temp"

*tomemos 2011

use "$source\B11.dta", clear
keep if grado==3

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
title("Distribución de resultados de tercero de primaria en 2011", `title_options')
legend(order(1 "Español" 2 "Matemáticas"))
;
#delimit cr

graph export "$temp/kdensityTercero2011.pdf", replace

use "$source\B11.dta", clear
keep if grado==6

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
title("Distribución de resultados de sexto de primaria en 2011", `title_options')
legend(order(1 "Español" 2 "Matemáticas"))
;
#delimit cr

graph export "$temp/kdensitySexto2011.pdf", replace

*****************************************************************************
*tomemos 2010

use "$source\B10.dta", clear
keep if grado==3

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
title("Distribución de resultados de tercero de primaria en 2010", `title_options')
legend(order(1 "Español" 2 "Matemáticas"))
;
#delimit cr

graph export "$temp/kdensityTercero2010.pdf", replace

use "$source\B10.dta", clear
keep if grado==6

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
title("Distribución de resultados de sexto de primaria en 2010", `title_options')
legend(order(1 "Español" 2 "Matemáticas"))
;
#delimit cr

graph export "$temp/kdensitySexto2010.pdf", replace

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
