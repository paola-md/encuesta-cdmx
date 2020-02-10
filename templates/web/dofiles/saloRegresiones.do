	

clear all
set more off
gl bases = "D:\Educacion\entrega BM\bases originales"
gl cie = "D:\Educacion\entrega BM"
gl basesA= "$cie\bases auxiliares"
gl basesD = "$dir\bases auxiliares\deleteMyFiles\"	


use "$basesD\panel_cp_2.dta", clear
gsort curp -anyo
keep curp grado cct anyo p_mat_std p_esp_std c_estado c_mnpio d_codigo postalcode
duplicates drop curp grado, force
gen aux=substr(curp,1,1)
bysort aux: gen aux2 = _n
bysort aux curp: egen auxiliar=max(aux2)
egen letra= group(aux)
gen cero= 101010
egen clave = concat(letra cero auxiliar)
keep curp grado cct anyo p_mat_std p_esp_std clave c_estado c_mnpio d_codigo postalcode
destring clave, replace
xtset clave grado
gen priv=substr(cct,3,1)
gen privada=priv=="P"
/*
*omitimos 2006
forvalues x=2007/2012{
	gen d_`x'=anyo==`x'
}
forvalues x=4/6{
	gen g_`x'=grado==`x'
}
forvalues x=8/9{
	gen g_`x'=grado==`x'
}
*/
rename d_codigo codigo
save "$basesA\panel_reg.dta", replace

use "$basesA\panel_reg.dta", clear
*primera regresion con controles de 
drop if grado>6
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo
drop if p_mat_std==.
reghdfe p_mat_std privada , absorb(grado anyo)
outreg2 using reg1.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesA\panel_reg.dta", clear
drop if grado>6
keep p_esp_std privada grado anyo
cd "$cie\resultados\regresiones"
reghdfe  p_esp_std privada , absorb(grado anyo)
outreg2 using reg1.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesA\panel_reg.dta", clear 

drop if grado<7
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo
reghdfe p_mat_std privada , absorb(grado anyo)
outreg2 using reg1.xls,  text ctitle(sec:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesA\panel_reg.dta", clear
drop if grado<7
keep p_esp_std privada grado anyo
cd "$cie\resultados\regresiones"
reghdfe  p_esp_std privada , absorb(grado anyo)
outreg2 using reg1.xls, text ctitle(sec:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)


**segunda falta cp
***



use "$basesA\panel_reg.dta", clear 
xtset clave anyo
drop if grado>6
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo postalcode
*falta poner efectos fijos de cp
reghdfe p_mat_std privada , absorb(postalcode grado anyo) vce(cluster postalcode)
outreg2 using reg2.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use  "$basesA\panel_reg.dta", clear
drop if grado>6
keep p_esp_std privada grado anyopostalcode
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de c
reghdfe p_esp_std privada , absorb(postalcode grado anyo) vce(cluster postalcode)
outreg2 using reg2.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)


use "$basesA\panel_reg.dta", clear 
drop if grado<7
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo postalcode
*falta poner efectos fijos de cp
reghdfe p_mat_std privada ,  absorb(postalcode grado anyo) vce(cluster postalcode)
outreg2 using reg2.xls,  text ctitle(sec:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use  "$basesA\panel_reg.dta", clear
drop if grado<7
keep p_esp_std privada grado anyo postalcode
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de cp
reghdfe p_esp_std privada,  absorb(postalcode grado anyo) vce(cluster postalcode)
outreg2 using reg2.xls, text ctitle(sec:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)


*tercera 
***

use "$basesA\panel_reg.dta", clear
drop if grado>6
duplicates drop cct curp, force
bysort curp: gen aux=_n 
keep if aux==2
keep curp 
merge 1:m curp using "$basesA\panel_reg.dta"
drop if _merge !=3
drop _merge
save "$basesD\panel_reg_sw.dta" , replace


drop if grado>6
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo postalcode clave
*falta poner efectos fijos de cp
reghdfe p_mat_std privada, absorb(postalcode clave grado anyo) vce(cluster clave)
outreg2 using reg3.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use  "$basesD\panel_reg_sw.dta" , clear
drop if grado>6
keep p_esp_std privada grado anyo postalcode clave
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de cp
reghdfe p_esp_std privada , absorb(postalcode clave grado anyo) vce(cluster clave)
outreg2 using reg4.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)

***
*prepara cuarta regresion usando base isaac
***
use "$basesD\destino.dta", clear
drop if encontramos <.25
duplicates drop cct, force 
drop cct_destino anyoAp
save "$basesD\escuelas_cierran.dta", replace

forvalues x=2006/2012{
	use "$basesA\panel_reg.dta", clear
	keep if anyo==`x'
	rename anyo anyoCierre
	replace cct=substr(cct,1,9)
	merge m:1 anyoCierre cct using "$basesD\escuelas_cierran.dta"
	save "$basesD\bas`x'.dta", replace
	}
use "$basesD\bas2006", clear
forvalues x=2007/2012{
	append using "$basesD\bas`x'.dta"
}

bysort curp: egen aux=max(_merge)
drop if aux<3
save "$basesD\panel_cierra_reg.dta", replace
drop if grado>6
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo postalcode clave
*falta poner efectos fijos de cp
reghdfe p_mat_std privada, absorb(postalcode clave grado anyo) vce(cluster clave)
outreg2 using reg4.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesD\panel_cierra_reg.dta", clear
drop if grado>6
keep p_esp_std privada grado anyo postalcode clave
cd "$cie\resultados\regresiones"

*falta poner efectos fijos de cp
reghdfe p_esp_std privada , absorb(postalcode clave grado anyo)  vce(cluster clave)
outreg2 using reg4.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)


***
*ojo se queda con muy pocas observaciones y no corre!!
***
/*
use "$basesD\panel_cierra_reg.dta", clear
drop if grado<7
keep p_mat_std privada d_* g_* postalcode clave
*falta poner efectos fijos de cp
reghdfe p_mat_std privada d_*  g_*, absorb(postalcode clave)  vce(cluster clave)
outreg2 using reg4.xls, text ctitle(sec:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesD\panel_cierra_reg.dta", clear
drop if grado<7
keep p_esp_std privada d_* g_* postalcode clave
cd "$cie\resultados\regresiones"
drop g_8 g_9
*falta poner efectos fijos de cp
reghdfe p_esp_std privada d_*  g_*, absorb(postalcode clave)  vce(cluster clave)
outreg2 using reg4.xls, text ctitle(sec:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)
*/

***
*quinta regresion
***

use"$basesD\anterior.dta", clear
drop if encontramos <.25
duplicates drop cct, force 
drop  anyoCierre
save "$basesD\escuelas_cierran.dta", replace

forvalues x=2006/2012{
	use "$basesA\panel_reg.dta", clear
	keep if anyo==`x'
	rename anyo anyoAp
	replace cct= substr(cct,1,9)
	merge m:1 anyoAp cct using "$basesD\escuelas_cierran.dta"
	save "$basesD\bas`x'.dta", replace
	}
use "$basesD\bas2006", clear
forvalues x=2007/2012{
	append using "$basesD\bas`x'.dta"
}

bysort curp: egen aux=max(_merge)
drop if aux<3
save "$basesD\panel_abre_reg.dta", replace

drop if grado>6
cd "$cie\resultados\regresiones"
keep p_mat_std privada grado anyo postalcode clave
*falta poner efectos fijos de cp
reghdfe p_mat_std privada , absorb(postalcode clave grado anyo)  vce(cluster clave)
outreg2 using reg5.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesD\panel_abre_reg.dta", clear
drop if grado>6
keep p_esp_std privada  postalcode clave grado anyo
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de cp
reghdfe p_esp_std privada , absorb(postalcode clave grado anyo)  vce(cluster clave)
outreg2 using reg5.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)



use "$basesD\panel_abre_reg.dta", clear
drop if grado<7
keep p_mat_std privada grado anyo postalcode clave
*falta poner efectos fijos de cp
reghdfe p_mat_std privada , absorb(postalcode clave grado anyo)  vce(cluster clave)
outreg2 using reg5.xls, text ctitle(sec:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesD\panel_abre_reg.dta", clear
drop if grado<7
keep p_esp_std privada grado anyo postalcode clave
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de cp
reghdfe p_esp_std privada , absorb(postalcode clave grado anyo)  vce(cluster clave)
outreg2 using reg5.xls, text ctitle(sec:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)

***
*regresiones con violencia
***
use "$cie\source\BASE_GRANDE_FINAL_MUN.dta", clear
tostring fecha_m, gen(aux)
gen anyo=2006
 local m=2007
 destring aux, replace
forvalues x= 563(12)623{
	replace anyo=`m' if aux>`x'
	local m=`m'+1
}
*calcula el numero de homicidios que hubo en cada municipio pada añño

bysort anyo cvemun: egen hom_mun= total(totmun)
duplicates drop anyo cvemun,force
egen tot_hom=total(hom_mun)

*pega la base con una base de marginación municipal en la que vienen datos de poblacion total
*del municipio
gen año=2005
replace año=2010 if anyo>2008
tostring cvemun , gen(cve_mun)
merge m:1 cve_mun año using  "$cie\bases originales\marginacion_municipal_90-15.dta", keepusing(pob_tot)
keep if _merge==3
drop _merge
*usando la poblacion total del municipio en el censo 2010 o la encuesta intercensal 2005
*genera la variable factor 
gen mult = 100000/pob_tot
*con la variable factor calculamos la tasa de himicidios por 100,000 habitantes dentro de un municipio
gen totmun100=mult*hom_mun
drop mult
save "$basesD\violencia.dta", replace




forvalues x=2006/2012{
	use "$basesA\panel_reg.dta", clear
	destring c_estado, gen(aux)
	tostring aux, replace
	egen cve_mun= concat(aux c_mnpio)
	drop aux
	keep if anyo==`x'
	merge m:1 cve_mun anyo  using "$basesD\violencia.dta"
	save "$basesD\bas`x'.dta", replace
	}
use "$basesD\bas2006", clear
forvalues x=2007/2012{
	append using "$basesD\bas`x'.dta"
}

drop if _merge!=3
drop _merge
save "$basesD\panel_violencia_reg.dta", replace

gen letra=substr(curp,1,1)
drop if letra!="A"
drop if grado>6
cd "$cie\resultados\regresiones"
*falta poner efectos fijos de cp
destring cve_mun, replace
reghdfe p_mat_std totmun100  , absorb(cve_mun grado) 
outreg2 using regviolencia.xls, replace text ctitle(prim:p_mat_std) bdec(3) sdec(3) paren(se) asterisk(coef)

use "$basesD\panel_violencia_reg.dta", clear
drop if grado>6

gen letra=substr(curp,1,1)
drop if letra!="A"
cd "$cie\resultados\regresiones"

destring cve_mun, replace
*falta poner efectos fijos de cp
reghdfe p_esp_std totmun100 , absorb(cve_mun grado)  vce(cluster cve_mun)
outreg2 using regviolencia.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)


