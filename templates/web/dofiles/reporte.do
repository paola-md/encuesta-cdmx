
*Análisis
*********************************************
clear all
set more off

gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM\"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source\"
gl basesA= "$dir\basesAuxiliares\"
gl basesD = "$basesA\deleteMyFiles\"
gl resultados ="$dir\resultados\"

*====================================================
// 1) descripcion panel_exacto.dta  y panel_fuzzy.dta
*====================================================
foreach x in panel_fuzzy panel_exacto {
	use  "$basesA\\`x'.dta", clear
	gen num_variables=11
	gen num_obs=_N
	bysort curp: gen aux_prim=(grado==3 | grado==4 | grado==5 | grado==6)
	bysort curp: egen aux2_prim=total(aux_prim)
	bysort curp: gen anyos_obs=_N
	gen d_prim_completa=aux2_prim==4
	
	*es decir, alumnos con primaria completa significa alumnos que hiciero la prueba los cuatro años seguidos
	*asimismo, alumnos con secundaria completa significa que hicieron la prueba los tres años seguidos
	
	bysort curp: gen aux_sec=(grado==7 | grado==8 | grado==9)
	bysort curp: egen aux2_sec=total(aux_sec)
	gen d_sec_completa=aux2_sec==3
	duplicates drop curp, force
	gen num_curps=_N
	egen prom_anyos_obs=mean(anyos_obs)
	egen num_prim_completa=total(d_prim_completa)
	egen num_sec_completa=total(d_sec_completa)
	duplicates drop cct, force
	gen num_cct=_N
	keep num_* prom_*
	gen nombre = "`x'"
	duplicates drop num_cct, force
	order nombre num_curp num_cct num_obs num_variables ///
	num_prim num_sec prom
	
	export excel using "$resultados\describe_bases.xls", sheet("`x'", replace) firstrow(varlabels)
}

/* El siguiente 'foreach' funciona para indexar las generaciones que serán seguidas retrospectivamente. La tabla 'generaciones y años calendario' 
   contenida en el reporte sirve para guiarse acerca de cómo se van asignando los números que identifican a cada generación. Dicha tabla es generada por esta
   parte del código  */
   
foreach x in panel_fuzzy panel_exacto {
	use  "$basesA\\`x'.dta", clear
	sort curp grado
	bysort curp: gen aux=_n
	gen generacion=.
	
	replace generacion= 13 if grado==3 & anyo==2012 & aux==1
	
	replace generacion= 12 if grado==3 & anyo==2011 & aux==1
	replace generacion= 12 if grado==4 & anyo==2012 & aux==2

	replace generacion= 11 if grado==3 & anyo==2010 & aux==1
	replace generacion= 11 if grado==4 & anyo==2011 & aux==2
	replace generacion= 11 if grado==5 & anyo==2012 & aux==3
	
	
	replace generacion= 10 if grado==3 & anyo==2009 & aux==1
	replace generacion= 10 if grado==4 & anyo==2010 & aux==2
	replace generacion= 10 if grado==5 & anyo==2011 & aux==3
	replace generacion= 10 if grado==6 & anyo==2012 & aux==4
	
	
	replace generacion= 9 if grado==3 & anyo==2008 & aux==1
	replace generacion= 9 if grado==4 & anyo==2009 & aux==2
	replace generacion= 9 if grado==5 & anyo==2010 & aux==3
	replace generacion= 9 if grado==6 & anyo==2011 & aux==4
	replace generacion= 9 if grado==7 & anyo==2012 & aux==5
	
	replace generacion= 8 if grado==3 & anyo==2007 & aux==1
	replace generacion= 8 if grado==4 & anyo==2008 & aux==2
	replace generacion= 8 if grado==5 & anyo==2009 & aux==3
	replace generacion= 8 if grado==6 & anyo==2010 & aux==4
	replace generacion= 8 if grado==8 & anyo==2012 & aux==5
	
	replace generacion= 7 if grado==3 & anyo==2006 & aux==1
	replace generacion= 7 if grado==4 & anyo==2007 & aux==2
	replace generacion= 7 if grado==5 & anyo==2008 & aux==3
	replace generacion= 7 if grado==6 & anyo==2009 & aux==4
	replace generacion= 7 if grado==7 & anyo==2010 & aux==5
	replace generacion= 7 if grado==9 & anyo==2012 & aux==6
	
	
	replace generacion= 6 if grado==4 & anyo==2006 & aux==1
	replace generacion= 6 if grado==5 & anyo==2007 & aux==2
	replace generacion= 6 if grado==6 & anyo==2008 & aux==3
	replace generacion= 6 if grado==7 & anyo==2009 & aux==4
	replace generacion= 6 if grado==8 & anyo==2010 & aux==5
	
	replace generacion= 5 if grado==5 & anyo==2006 & aux==1
	replace generacion= 5 if grado==6 & anyo==2007 & aux==2
	replace generacion= 5 if grado==8 & anyo==2009 & aux==3
	replace generacion= 5 if grado==9 & anyo==2010 & aux==4
	
	replace generacion= 4 if grado==6 & anyo==2006 & aux==1
	replace generacion= 4 if grado==9 & anyo==2009 & aux==2
	
	replace generacion= 3 if grado==9 & anyo==2008 & aux==1
	
	replace generacion= 2 if grado==9 & anyo==2007 & aux==1
	
	replace generacion= 1 if grado==9 & anyo==2007 & aux==1
	
	bysort curp: gen num_anyo_obs=_N
	bysort curp: egen su_generacion=min(generacion)
	duplicates drop curp, force
	bysort generacion: egen media_anyos_obs=mean(num_anyo_obs)
	bysort generacion: gen num_ninyos=_N
	duplicates drop generacion, force 
	keep generacion num_ninyos media_anyos_obs
	gen anyos_obs=.
	
	*los siguientes replace contabilizan los años observados por generación
	
	replace anyos_obs=1 if generacion<4 | generacion==13
	replace anyos_obs=2 if generacion==4  | generacion==12
	replace anyos_obs=3 if generacion==11
	replace anyos_obs=4 if generacion==5 | generacion==10
	replace anyos_obs=5 if generacion==9 | generacion==6 | generacion==8
	replace anyos_obs=6 if generacion==7
	gen porc_observado= media_anyos_obs/anyos_obs
	gen nombre = "`x'"
	order nombre generacion anyos_obs media_anyos_obs porc_observado num_ninyos
	export excel using "$resultados\describe_bases.xls", sheet("`x' g", replace) firstrow(varlabels)
}

*====================================================	
// 3)por estado num escuelas num alumnos
*====================================================

/* Este 'foreach' contabiliza el número de alumnos que presentó la prueba Enlace por entidad de 2006-2012 */

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'.dta", clear
	keep if grado<7
	*los dos primeros dígitos del CCT denotan, en orden alfabético, la entidad federativa a la cual pertenece la escuela 
	
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_ninyos=_N
	duplicates drop edo, force 
	keep edo num_ninyos
	export excel using "$resultados\ninyos_edo.xls", sheet(" curp anyo `x'", replace) firstrow(varlabels)
}

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'_r.dta", clear
	keep if grado<7
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_ninyos=_N
	duplicates drop edo, force 
	keep edo num_ninyos
	export excel using "$resultados\ninyos_edo.xls", sheet(" folio anyo `x'", replace) firstrow(varlabels)
}

/* Este 'foreach' contabiliza el número de escuelas que presentó la prueba Enlace por entidad de 2006-2012 */

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'.dta", clear
	keep if grado<7
	duplicates drop cct, force
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_escuelas=_N
	duplicates drop edo, force 
	keep edo num_escuelas
	export excel using "$resultados\escuelas_edo.xls", sheet(" anyo `x'", replace) firstrow(varlabels)
}

foreach x in 06 07 08 09 10 11 12 {
	use "$basesA\B`x'_r.dta", clear
	keep if grado<7
	duplicates drop cct, force
	gen edo=substr(cct,1,2)
	destring edo, replace force
	drop if edo<1 | edo>32
	bysort edo: gen num_escuelas=_N
	duplicates drop edo, force 
	keep edo num_escuelas
	export excel using "$resultados\escuelas_edo.xls", sheet("raw anyo `x'", replace) firstrow(varlabels)
}

//FALTA

*====================================================
//4) mapa
*====================================================
gl shp = "E:\Proy_Paola_Salo\Educacion\hechosNotables\source\889463526636_s\"


cd "$basesD"


 
 
if 0==0{ 
	***transforma shp files a dta
	
	
	shp2dta using "$shp\01_aguascalientes\conjunto de datos\01ent.shp", database(data_1_ent) coordinates(coord_1_ent) 
	shp2dta using "$shp\02_bajacalifornia\conjunto de datos\02ent.shp", database(data_2_ent) coordinates(coord_2_ent) 
	shp2dta using "$shp\03_bajacaliforniasur\conjunto de datos\03ent.shp", database(data_3_ent) coordinates(coord_3_ent) 
	shp2dta using "$shp\04_campeche\conjunto de datos\04ent.shp", database(data_4_ent) coordinates(coord_4_ent) 
	shp2dta using "$shp\05_coahuiladezaragoza\conjunto de datos\05ent.shp", database(data_5_ent) coordinates(coord_5_ent) 
	shp2dta using "$shp\06_colima\conjunto de datos\06ent.shp", database(data_6_ent) coordinates(coord_6_ent) 
	shp2dta using "$shp\07_chiapas\conjunto de datos\07ent.shp", database(data_7_ent) coordinates(coord_7_ent) 
	shp2dta using "$shp\08_chihuahua\conjunto de datos\08ent.shp", database(data_8_ent) coordinates(coord_8_ent) 
	shp2dta using "$shp\09_ciudaddemexico\conjunto de datos\09ent.shp", database(data_9_ent) coordinates(coord_9_ent) 
	shp2dta using "$shp\10_durango\conjunto de datos\10ent.shp", database(data_10_ent) coordinates(coord_10_ent) 
	shp2dta using "$shp\11_guanajuato\conjunto de datos\11ent.shp", database(data_11_ent) coordinates(coord_11_ent) 
	shp2dta using "$shp\12_guerrero\conjunto de datos\12ent.shp", database(data_12_ent) coordinates(coord_12_ent) 
	shp2dta using "$shp\13_hidalgo\conjunto de datos\13ent.shp", database(data_13_ent) coordinates(coord_13_ent) 
	shp2dta using "$shp\14_jalisco\conjunto de datos\14ent.shp", database(data_14_ent) coordinates(coord_14_ent) 
	shp2dta using "$shp\15_mexico\conjunto de datos\15ent.shp", database(data_15_ent) coordinates(coord_15_ent) 
	shp2dta using "$shp\16_michoacandeocampo\conjunto de datos\16ent.shp", database(data_16_ent) coordinates(coord_16_ent) 
	shp2dta using "$shp\17_morelos\conjunto de datos\17ent.shp", database(data_17_ent) coordinates(coord_17_ent) 
	shp2dta using "$shp\18_nayarit\conjunto de datos\18ent.shp", database(data_18_ent) coordinates(coord_18_ent) 
	shp2dta using "$shp\19_nuevoleon\conjunto de datos\19ent.shp", database(data_19_ent) coordinates(coord_19_ent) 
	shp2dta using "$shp\20_oaxaca\conjunto de datos\20ent.shp", database(data_20_ent) coordinates(coord_20_ent) 
	shp2dta using "$shp\21_puebla\conjunto de datos\21ent.shp", database(data_21_ent) coordinates(coord_21_ent) 
	shp2dta using "$shp\22_queretaro\conjunto de datos\22ent.shp", database(data_22_ent) coordinates(coord_22_ent) 
	shp2dta using "$shp\23_quintanaroo\conjunto de datos\23ent.shp", database(data_23_ent) coordinates(coord_23_ent) 
	shp2dta using "$shp\24_sanluispotosi\conjunto de datos\24ent.shp", database(data_24_ent) coordinates(coord_24_ent) 
	shp2dta using "$shp\25_sinaloa\conjunto de datos\25ent.shp", database(data_25_ent) coordinates(coord_25_ent) 
	shp2dta using "$shp\26_sonora\conjunto de datos\26ent.shp", database(data_26_ent) coordinates(coord_26_ent) 
	shp2dta using "$shp\27_tabasco\conjunto de datos\27ent.shp", database(data_27_ent) coordinates(coord_27_ent) 
	shp2dta using "$shp\28_tamaulipas\conjunto de datos\28ent.shp", database(data_28_ent) coordinates(coord_28_ent)
	shp2dta using "$shp\29_tlaxcala\conjunto de datos\29ent.shp", database(data_29_ent) coordinates(coord_29_ent) 
	shp2dta using "$shp\30_veracruzignaciodelallave\conjunto de datos\30ent.shp", database(data_30_ent) coordinates(coord_30_ent) 
	shp2dta using "$shp\31_yucatan\conjunto de datos\31ent.shp", database(data_31_ent) coordinates(coord_31_ent) 
	shp2dta using "$shp\32_zacatecas\conjunto de datos\32ent.shp", database(data_32_ent) coordinates(coord_32_ent) 
}
	*crea una variable en cada estado que "registre" el orden y crea la variable entidad
	*para las coordenadas
		forvalues x= 1/32 {
			use "$basesD\coord_`x'_ent.dta", clear
			gen ent = `x'
			gen orden = _n
		save "$basesD\coord_`x'_ent.dta", replace
}
	*crea la variable entidad para los nombres de los enticipios
		forvalues x= 1/32 {
			use "$basesD\data_`x'_ent.dta", clear
			gen ent = `x'
		save "$basesD\data_`x'_ent.dta", replace
}

   


****une los 32 estados
cd "$basesD"
use "$basesD\coord_1_ent.dta", clear
forvalues x= 2/32 {
	append using "$basesD\coord_`x'_ent.dta"
	}
save "$basesA\coord_mexico_ent.dta", replace

use "$basesD\data_1_ent.dta", clear
forvalues x= 2/32 {
	append using "$basesD\data_`x'_ent.dta"
	}
sort ent _ID
gen aux =_n
save "$basesA\data_mexico_ent.dta", replace

*genera un ID nuevo 
use "$basesA\data_mexico_ent.dta", replace 
merge 1:m _ID ent  using "$basesA\coord_mexico_ent.dta"
sort ent _ID orden
keep aux _X _Y 
rename aux _ID
sort _ID
save "$basesA\coord_mexico_ent_orden.dta" , replace 

*volver a correr para que quede bien el mapa

clear 
import excel "$resultados\ninyos_edo.xls", sheet(" curp anyo 09") firstrow
rename  num_ninyos  num_ninyos_enlace
save "$basesD\enlace.dta", replace


clear 
import excel "$resultados\tabla_alumnos_911.xls", sheet(" alumnos anyo 9") firstrow
merge 1:1 edo using "$basesD\enlace.dta"
gen Ratio = num_ninyos_enlace/num_ninyos_edo_anyo
rename edo ent 
drop _merge
save "$basesD\ratio.dta", replace


*grafica mapas de enticipios
use "$basesA\data_mexico_ent.dta", clear
merge m:1 ent using "$basesA\ratio.dta"
sort aux
gen aux2=ent>20

sum Ratio, d
local p25 = round(`r(p25)', .01)
local p50 = round(`r(p50)', .01)
local p75 = round(`r(p75)', .01)


spmap Ratio using  "$basesA\coord_mexico_ent_orden.dta" ,  id(aux) ///
  clmethod(custom) fcolor(Blues)  legstyle(2) legend(size(vlarge)) ///
 clb(0 `p25' `p50' `p75' 100)

graph export "$resultados\graficas\mapa_ratio.png", as (png) replace


*====================================================
// 5)seguimiento escuelas
*====================================================


/* Esta parte del código genera las 2 gráficas que muestran el seguimiento retrospectivo desde 2012 hasta 2006 por escuela: una que incluye primarias y secundarias
   y otra que solo incluye primarias */
   
/* Nótese que en cada 'foreach' de esta sección del código la cota superior del recorrido de 'x' es 11 ya que estamos suponiendo que en 2012 se tiene el 100% de asistencia */   

foreach x  in 06 07 08 09 10 11 12  {
		use "$basesA\B`x'.dta", clear
		gen edo=substr(cct,1,2)
		drop if edo=="16" | edo=="20"
		*duplicates drop cct,force
		keep cct anyo grado
		replace cct = substr(cct,1,9) /* Nos quedamos con los CCT bien capturados pues deben de tener 9 dígitos */
		duplicates drop cct,force
		rename anyo a_`x'
		save "$basesD\Besc`x'.dta", replace
}
			*variables locales para detalles de formato de las gráficas
			
			local labsize medlarge
			local bigger_labsize large
			local xtitle_options size(`labsize') margin(top)
			local title_options size(`bigger_labsize') margin(bottom) color(black)
			local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
			local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
			local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
			local T_line_options lwidth(thin) lcolor(gray) 
			*lpattern(dash)
			local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)
		

use "$basesD\Besc12.dta", clear
foreach x  in 06 07 08 09 10 11  {			
	merge 1:1 cct using "$basesD\Besc`x'.dta"
	drop if _merge==2 /* Nos deshachemos de las observaciones que no hicieron match*/
	gen aux = _merge==3
	egen porcentaje_asistencia_`x' = mean(aux)
	duplicates drop cct, force
	drop _merge aux
}

local s=6
foreach x  in 06 07 08 09   {			
	rename porcentaje_asistencia_`x' porcentaje_asistencia_`s'
	local s=`s'+1
}

gen porcentaje_asistencia_12=1
duplicates drop porcentaje_asistencia_12 , force
keep porcentaje_asistencia_*
export excel using "$resultados\seguimiento_escuelas.xls", sheet("escuelas todas", replace) firstrow(varlabels)
gen grado=1
reshape long porcentaje_asistencia_, i(grado) j(anyo)
replace anyo=anyo+2000


twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
xtitle("año", `xtitle_options') ///
ytitle("Porcentaje de escuelas encontradas", `xtitle_options') ///
yline(0, `manual_axis') ///
legend(off) `plotregion' `graphregion'
graph export "$resultados\graficas\seguimiento_escuelas_todas.png", as (png) replace

*seguimiento retrospectivo de las escuelas pero solo primarias

foreach x  in 06 07 08 09 10 11 12  {
		use "$basesA\B`x'.dta", clear
		gen edo=substr(cct,1,2)
		drop if edo=="16" | edo=="20"
		drop edo
		*duplicates drop cct,force
		keep cct anyo grado
		replace cct = substr(cct,1,9)
		duplicates drop cct,force
		rename anyo a_`x'
		drop if grado>6 
		save "$basesD\Besc`x'.dta", replace
}

use "$basesD\Besc12.dta", clear
drop if grado>6
drop grado

foreach x  in 06 07 08 09 10 11  {			
	merge 1:1 cct using "$basesD\Besc`x'.dta"
	drop if _merge==2
	gen aux = _merge==3
	egen porcentaje_asistencia_`x' = mean(aux)
	duplicates drop cct, force
	drop _merge aux
}

local s=6
foreach x  in 06 07 08 09   {			
	rename porcentaje_asistencia_`x' porcentaje_asistencia_`s'
	local s=`s'+1
}

gen porcentaje_asistencia_12=1
duplicates drop porcentaje_asistencia_12 , force
keep porcentaje_asistencia_*
export excel using "$resultados\seguimiento_escuelas.xls", sheet("escuelas prim", replace) firstrow(varlabels)
gen grado=1
reshape long porcentaje_asistencia_, i(grado) j(anyo)
replace anyo=anyo+2000


twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
xtitle("año", `xtitle_options') ///
ytitle("Porcentaje de escuelas encontradas", `xtitle_options') ///
yline(0, `manual_axis') ///
legend(off) `plotregion' `graphregion'

graph export "$resultados\graficas\seguimiento_escuelas_prim.png", as (png) replace

*====================================================
// 6)seguimiento
*====================================================



local labsize medlarge
local bigger_labsize large
local xtitle_options size(`labsize') margin(top)
local title_options size(`bigger_labsize') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
local T_line_options lwidth(thin) lcolor(gray) 
*lpattern(dash)
local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)

******************
*seguimiento hacia atrás (retrospectivo) a partir del último año en el que aparece la generación 
******************

/* Se escojen los años de 2010, 2011 y 2012 para el forvalues de `t' pues
 en esos años el seguimiento retrospectivo
 de las generaciones es casi ininterrumpido*/
						
			
forvalues t = 10/12{
	if `t'!=11 {
		if `t'==12 {
			gl begin=5
			gl end=9
		}
		
			/* 'begin' denota la cota inferior para el grado donde empezará la 
			    secuencia que se analizará a partir del año `t', 
				asimismo con 'end' que denota la cota superior*/ 
		if `t'== 10{
			gl begin=8
			gl end=9
		}
		
		/* Este 'forvalues' está pensado para definir el rango de la sucesión de 
		   grados para una generación que se analizará retrospectivamente */
		forvalues x=$begin / $end {
			use "$basesA\B`t'.dta", clear
			gen edo=substr(cct,1,2)
			drop if edo=="16" | edo=="20"
			drop edo
			
			if `t'==12 {
				/* Para estos 'if', `x' denota el grado. x toma los valores 5 y 6 que representan
				5to y 6to de primaria, mientras que 7, 8 y 9 representan 1ero, 
				2ndo y 3ro de secundaria, respectivamente. Por ejemplo, 
				si el grado `x' es 9 (i.e 3ero de secundaria), entonces se hará 
				el analisis de seguimiento retrospectivo hasta el último grado 
				donde se tiene información de esa generación, esto es hasta 6to
				de primaria definiendo a first=6. Todo esto para el año `t'*/
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
			if `t'==10 {
				gl first=6
				gl last =9
			
			}

			/* solo nos quedamos con las variables grado y curp*/
			keep if grado==`x' 
			keep curp grado
			rename grado grado_`t'
			duplicates drop curp, force
			forvalues a=$first / $last {
				local nm= "`a'"
				if `a'<10{
					local nm="0`a'"
				}
				
				merge 1:m curp using "$basesA\B`nm'.dta", keepusing(grado cct)
				gen edo=substr(cct,1,2)
				drop if edo=="16" | edo=="20"
				drop edo cct
				drop if _merge==2
				gen aux = _merge==3
				egen porcentaje_asistencia_`a' = mean(aux)
				duplicates drop curp, force
			/* Con este 'forvalue' de 'a' se hará el seguimiento retrospectivo de la 
			siguiente manera: unimos con merge las bases del 2010 con las de 200`a',
			nos deshacemos de las observaciones de la base 200`a' que no hicieron
			match. A la variable 'aux' le asignamos las observaciones que sí 
			son match (_merge==3) y con la media de 'aux' obtenemos el porcentaje
			de asistencias de forma retrospectiva, donde el porcentaje de asist.
			en 2012 es 100*/
				rename grado grado_`a'
				drop _merge aux
			}
			gen porcentaje_asistencia_`t'=1
			duplicates drop porcentaje_asistencia_$last , force
			keep porcentaje_asistencia_*
			export excel using "$resultados\seguimiento.xls", sheet("`x' en 20`t'", replace) firstrow(varlabels)
			gen grado= `x'
			if `t'==12 & `x'>6{
				drop porcentaje_asistencia_11
			}
			if `t'==10 & `x'==9{
				drop porcentaje_asistencia_8
			}
			
			reshape long porcentaje_asistencia_, i(grado) j(anyo)
			replace anyo=anyo+2000
			
		
			twoway (line porcentaje_asistencia anyo, lwidth(thick)) ///
			(scatter porcentaje_asistencia anyo, `estimate_options_95'), ///
			xtitle("año", `xtitle_options') ///
			ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
			yline(0, `manual_axis') ///
			legend(off) `plotregion' `graphregion'
			*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			graph export "$resultados\graficas\g_`x'en20`t'.png", as (png) replace

			}
	}
}

	
****************
*seguimiento de generaciones de las que observamos toda la primaria 
******************


/* Esta parte del código es estructuralemente muy similar a la pasada */

forvalues t = 9/12{
	
	local num = `t'
	if `t'==9 {
		local num = "09"
	}
	
	use "$basesA\B`num'.dta", clear
	gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo
			
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
	
	*solo nos quedamos con las generaciones que seguiremos a partir de sexto
	keep if grado==6
	keep curp grado
	rename grado grado_`t'
	duplicates drop curp, force
	forvalues a=$first / $last {
		local nums = `a'
		if `a'<10 {
			local nums = "0`a'"
		}
		merge 1:m curp using "$basesA\B`nums'.dta", keepusing(grado cct)
			gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo cct

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
	export excel using "$resultados\seguimiento_pri.xls", sheet("6 en 20`num'", replace) firstrow(varlabels)
	gen grado= 6
	reshape long porcentaje_asistencia_, i(grado) j(anyo)
	replace anyo=anyo+2000
	twoway (line porcentaje_asistencia_ anyo, lwidth(thick)) ///
			(scatter porcentaje_asistencia anyo, `estimate_options_95'), /// 
			xtitle("año", `xtitle_options') ///
			ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
			yline(0, `manual_axis') /// 
			legend(off) `plotregion' `graphregion'
			*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			*graph export "$resultados\graficas\g_`x' en 20`t'.png", as (png) replace

	*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 6 en 20`num'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
	graph export "$resultados\graficas\primaria_6en20`num'.png", as (png) replace

}




/* Esta parte del código es estructuralemente muy similar a la pasada */
local labsize medlarge
local bigger_labsize large
local xtitle_options size(`labsize') margin(top)
local title_options size(`bigger_labsize') margin(bottom) color(black)
local manual_axis lwidth(thin) lcolor(black) lpattern(solid)
local plotregion plotregion(margin(sides) fcolor(white) lstyle(none) lcolor(white)) 
local graphregion graphregion(fcolor(white) lstyle(none) lcolor(white)) 
local T_line_options lwidth(thin) lcolor(gray) 
*lpattern(dash)
local estimate_options_95 mcolor(gs7) msymbol(Oh)  msize(medlarge)


forvalues t = 9/12{
	
	local num = `t'
	if `t'==9 {
		local num = "09"
	}
	
	use "$basesA\B`num'.dta", clear
		gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo

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
	gl ultima = `t' - 3
	if $ultima <10 {
		local numero = "0$ultima"
	}
	
	duplicates drop curp,force
	merge 1:m curp using "$basesA\B`numero'.dta", keepusing(grado cct)
		gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo cct

	drop if _merge != 3 
	drop _merge 
	duplicates drop curp,force
		
	
	*solo nos quedamos con las generaciones que seguiremos a partir de sexto
	keep if grado==6
	keep curp grado
	rename grado grado_`t'
	duplicates drop curp, force
	forvalues a=$first / $last {
		local nums = `a'
		if `a'<10 {
			local nums = "0`a'"
		}
		merge 1:m curp using "$basesA\B`nums'.dta", keepusing(grado cct)
			gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo cct

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
	export excel using "$resultados\seguimiento_pri_3y4.xls", sheet("6 en 20`num'", replace) firstrow(varlabels)
	gen grado= 6
	reshape long porcentaje_asistencia_, i(grado) j(anyo)
	replace anyo=anyo+2000
	twoway (line porcentaje_asistencia_ anyo, lwidth(thick)) ///
			(scatter porcentaje_asistencia anyo, `estimate_options_95'), /// 
			xtitle("año", `xtitle_options') ///
			ytitle("Porcentaje de alumnos encontrados", `xtitle_options') ///
			yline(0, `manual_axis') /// 
			legend(off) `plotregion' `graphregion'
			*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento `x' en 20`t'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
			*graph export "$resultados\graficas\g_`x' en 20`t'.png", as (png) replace

	*twoway line porcentaje_asistencia anyo || scatter porcentaje_asistencia anyo, title("Seguimiento 6 en 20`num'") legend(off) xtitle("año") ytitle("Porcentaje de alumnos encontrados")
	graph export "$resultados\graficas\3y6prim_6en20`num'.png", as (png) replace

}





*====================================================
// 7) tamaño de las escuelas
*====================================================

/* Esta sección del código genera el histograma que presenta
 las diferencias relativas en el tamaño de las escuelas
 
 (tamaño de la matrícula) comparando 2007 con 2012 */

use "$basesA\panel_exacto.dta", clear
gen edo=substr(cct,1,2)
drop if edo=="16" | edo=="20"
drop edo

keep if anyo==2007 | anyo==2012
*drop if grado>7
bysort cct anyo: gen asistencia=_N
duplicates drop cct anyo, force



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

#delimit ;
twoway (histogram asistencia if anyo==2007 & inrange(asistencia,0,500) , 
frac width(30) fcolor(eltblue) lcolor(white) ) 
(histogram asistencia if anyo==2012 & inrange(asistencia,0,500) , 
frac width(30) fcolor(eltblue) lcolor(black) ), 
xtitle(Cambio Porcentual)
ytitle("Fracción")
legend (order( 1 "2007" 2 "2012"))
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\tamanyo.png", replace


*====================================================
// 8) variacion tamaño de las escuelas
*====================================================


use "$basesA\panel_exacto.dta", clear
	gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"
	drop edo

bysort cct anyo: gen asistencia=_N
duplicates drop cct anyo, force

*para cada CCT en nuestra base de datos panel le asignamos un id con 'group'
egen cct_id = group(cct)

/* con 'xtset' lo que hacemos es un multiconjunto donde cada elemento del multiconjunto (id del CCT) tiene asociada una multiplicidad (cuántas veces aparece),
 de esta forma estamos declarandole a STATA que estamos usando una base de datos panel  */
xtset cct_id anyo 

* el lag que establece el comando 'L.' nos permite sacar la tasa de variación entre cada año consecutivo 
gen p_asistencia= (L.asistencia-asistencia)/L.asistencia


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

#delimit ;
/* Establecemos un rango de variación en la tasa de crecimiento de las escuelas dado por el intervalo (-1,1) pues así nos deshacemos de observaciones atípicas 
   donde una escuela decrece o crece más del 100% (?) */
histogram p_asistencia if inrange(p_asistencia,-1,1), 
width(0.1) 
frac
fcolor(eltblue)
lcolor(ebblue) 
xtitle(Cambio Porcentual)
ytitle("Fracción")
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\variacionResultados.png", replace



*====================================================
// 9) calif 2011
*====================================================

/* En esta parte del código se generarán las distribuciones o gráficas de densidad de probabilidad de las calificaciones de Matemáticas y Español para 3ero de primaria
   y sexto de primaria */

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


*tomemos 2011

use "$basesA\B11.dta", clear

keep if grado==3

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
legend(order(1 "Español" 2 "Matemáticas"))
`graphregion' `plotregion'

;
#delimit cr

graph export "$resultados\graficas\kdensityTercero2011.png", replace

use "$basesA\B11.dta", clear
keep if grado==6

#delimit 
twoway 
(kdensity p_esp) 
(kdensity p_mat),
xtitle("Resultados")
ytitle("Densidad")
legend(order(1 "Español" 2 "Matemáticas"))
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\kdensitySexto2011.png", replace


*====================================================
//10) estabilidad percentil escuela
*====================================================
	

	

use "$basesA\panel_exacto.dta", clear
*sample 1
egen cct_id=group(cct grado)
bysort cct_id anyo: egen m_p_mat=mean(p_mat)
bysort cct_id anyo: egen m_p_esp=mean(p_esp)
duplicates drop cct_id anyo, force

drop p_esp_perc p_mat_perc

foreach x in esp mat {
	sort anyo grado p_`x'
	bysort anyo grado: gen ranking=_n
	bysort anyo grado: gen total_a=_N
	gen aux=(ranking/total_a)*100
	gen p_`x'_perc= ceil(aux)
	drop aux ranking total_a

}


xtset cct_id anyo



gen cambio_percentil_mat =L.p_mat_perc - p_mat_perc

gen cambio_percentil_esp = L.p_esp_perc -p_esp_perc 


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

foreach x in mat esp {
	#delimit ;
	histogram cambio_percentil_`x' if inrange(cambio_percentil_`x',-20,20), 
	width(2) 
	frac
	fcolor(eltblue)
	lcolor(ebblue) 
	xtitle(Diferencia absoluta)
	ytitle("Fracción")
	`graphregion' `plotregion'
	;
	#delimit cr

	graph export "$resultados\graficas\perc_`x'_esc.png", replace

}




	

*====================================================
//11) estabilidad percentil alumnos
*====================================================
	

	

use "$basesA\panel_exacto.dta", clear
*sample 1
gsort curp -anyo
drop if grado >6
gen aux=substr(curp,1,1)
bysort aux: gen aux2 = _n
bysort aux curp: egen auxiliar=max(aux2)
egen letra= group(aux)
gen cero= 101010
egen clave = concat(letra cero auxiliar)
destring clave, replace
duplicates drop clave anyo, force
xtset clave anyo

gen cambio_percentil_mat =L.p_mat_perc - p_mat_perc

gen cambio_percentil_esp = L.p_esp_perc -p_esp_perc 


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

foreach x in mat esp {
	#delimit ;
	histogram cambio_percentil_`x' if inrange(cambio_percentil_`x',-20,20), 
	width(2) 
	frac
	fcolor(eltblue)
	lcolor(ebblue) 
	xtitle(Diferencia absoluta)
	ytitle("Fracción")
	`graphregion' `plotregion'
	;
	#delimit cr

	graph export "$resultados\graficas\percentil_`x'.png", replace

}


*====================================================
//12) estabilidad regresion alumnos
*====================================================

use "$basesA\panel_exacto.dta", clear
*sample 1
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
	cd "$resultados\regresiones"
	xtreg `k' L.`k' 
	outreg2 using xtar(1)sinfe.xls, text ctitle(`x') bdec(3) sdec(3) paren(se) asterisk(coef)
	}



*====================================================
//13) abren y cierran
*====================================================
*si 1 alumno presento el examen en ese año en esa escuela se queda con la escuela
foreach x  in 06 07 08 09 10 11 12  {
		use "$basesA\B`x'.dta", clear
		drop if grado>6
		duplicates drop cct,force
		keep cct anyo
		replace cct = substr(cct,1,9)
		rename anyo a_`x'
	save "$basesD\Besc`x'.dta", replace
	}
	
use  "$basesD\Besc06.dta", clear
duplicates drop cct, force
foreach x in 07 08 09 10 11 12  {
	merge 1:m cct using "$basesD\Besc`x'.dta"
	drop _merge
	duplicates drop cct, force
}

save "$basesA\todas_las_escuelas_pri.dta", replace

use "$basesA\todas_las_escuelas_pri.dta", clear 
 
drop if a_12!=. & a_06!=. & a_07!=. & a_08!=. & a_09!=. & a_10!=. & a_11!=.
gen tipo=substr(cct, 3, 1)
egen anyoAp=rowfirst( a_06 a_07 a_08 a_09 a_10 a_11 a_12)
egen anyoCierre= rowlast( a_06 a_07 a_08 a_09 a_10 a_11 a_12)
egen cuenta= anycount( a_06 a_07 a_08 a_09 a_10 a_11 a_12 ), values(2006 2007 2008 2009 2010 2011 2012)
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

foreach x in  06 07 08 09 10 11{
	use "$basesD\cierran_pri.dta", clear
	*busca a los niños de las que cerraron en otras escuelas
	keep if anyoCierre==20`x'  
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
	if `k'>9 {
	use  "$basesA\B`k'.dta", clear
	}
	if `k'<10 {
	use  "$basesA\B0`k'.dta", clear
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
	save "$basesD\destino`x'_pri.dta", replace
	}
	
	
	
	
	
use  "$basesD\destino06_pri.dta", clear
foreach x in 07 08 09 10 11{
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
	foreach x in 06 07 08 09 10 11 12{
	bysort a_`x': gen total`x'=_N 
	}

	foreach x in 06 07 08 09 10 11 12{
		drop if a_`x'==. 
	}
	duplicates drop total10,force
	keep total*
	export excel using "$resultados\analisis_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\destino_pri.dta", clear
	gen edo=substr(cct,1,2)
	drop if edo=="16" | edo=="20"

	gen tipo=substr(cct, 3, 1)
	gen pop = tipo=="P"
	drop if pop!=`m'
	preserve
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran=_N
	keep anyoCierre escuelas_cierran
	duplicates drop anyoCierre escuelas_cierran, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran_`m'", replace) firstrow(varlabels)
	restore


	preserve
	drop if encontramos<.25
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_25=_N
	keep anyoCierre escuelas_cierran_25
	duplicates drop anyoCierre escuelas_cierran_25, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran.25_`m'", replace) firstrow(varlabels)
	restore

	preserve
	drop if encontramos<.40
	duplicates drop cct, force
	bysort anyoCierre: gen escuelas_cierran_40=_N
	keep anyoCierre escuelas_cierran_40
	duplicates drop anyoCierre escuelas_cierran_40, force
	export excel using "$resultados\analisis_pri.xlsx", sheet("cierran.40_`m'", replace) firstrow(varlabels)
	restore
}


****aqui voy
********************************
*aperturas
********************************
set more off

foreach  x in 07 08 09 10 11 12{
use "$basesD\apertura_cierre_pri.dta", clear
*busca a los niños de las que cerraron en otras escuelas
	keep if anyoAp==20`x'	
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
	if `k'>9 {
	use  "$basesA\B`k'.dta", clear
	}
	if `k'<10 {
	use  "$basesA\B0`k'.dta", clear
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
	
	save "$basesD\anterior`x'_pri.dta", replace
}
	
use  "$basesD\anterior12_pri.dta"
foreach x in 07 08 09 10 11{
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
	foreach x in 06 07 08 09 10 11 12{
		bysort a_`x': gen total`x'=_N 
	}
	foreach x in 06 07 08 09 10 11 12{
		drop if a_`x'==. 
	}
	drop if a_12==. 
	duplicates drop total10,force
	keep total*
	export excel using "$dir\resultados\analisisAp_pri.xlsx", sheet("total_`m'", replace) firstrow(varlabels)



	use"$basesD\anterior_pri.dta", clear
	 gen edo=substr(cct,1,2)
drop if edo=="16" | edo=="20"

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

*====================================================
//14) distancia
*====================================================
clear
import delimited "$source\escuelas_coord.csv"
replace cct= substr(cct,1,9)
duplicates drop cct, force
save "$basesA\coordenadas.dta", replace

use  "$basesD\destino_pri.dta", clear	
merge m:1 cct using "$basesA\coordenadas.dta" , keepusing( longitud latitud)
rename cct cct_origen
rename latitud latitud_origen
rename longitud longitud_origen
drop if _merge!=3
drop _merge
rename cct_destino cct
merge m:1 cct using "$basesA\coordenadas.dta" , keepusing( longitud latitud)
rename cct cct_destino
rename latitud latitud_destino
rename longitud longitud_destino
drop if _merge!=3

drop _merge

foreach x in latitud_destino longitud_destino latitud_origen longitud_origen {
	destring `x', replace force
}
drop if latitud_destino>90 | latitud_destino<0

drop if latitud_origen>90 | latitud_origen<0
 geodist latitud_destino longitud_destino latitud_origen longitud_origen, gen(distancia)
 
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

#delimit ;
histogram distancia if inrange(distancia,0,20), 
width(1) 
frac
fcolor(eltblue)
lcolor(ebblue) 
xtitle(Distancia en km)
ytitle("Fracción")
`graphregion' `plotregion'
;
#delimit cr

graph export "$resultados\graficas\distancia.png", replace

