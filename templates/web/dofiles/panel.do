clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"

foreach lev in B M{
	foreach anyo1 in  06 07 08 09 10 11 12 13 14 15 16 {
		capture confirm file "$basesO/`lev'`anyo1'.dta"
		 if _rc==0 {
			append using "$basesO/`lev'`anyo1'.dta"  
		}
	}
}
bysort curp anyo: drop if _n>1
drop p_mat_std p_esp_std p_mat_perc p_esp_perc
reshape wide cct grado p_esp p_mat apellido_nombre, i(curp) j(anyo)
export delimited "$basesD/Panel.csv", replace
save panel_exacto_nuevo10, replace

clear all
use panel_exacto_nuevo10
**** Crea Panel Exacto ****
gen tam_curp = strlen(curp)
keep if tam_curp ==18
save panel_exacto_18, replace

**** Crea Panel Fuzzy ****
clear all
use panel_exacto_nuevo10

gen indice = _n

save panel_exacto_indice, replace

use panel_exacto_indice, clear
gen c_mayus = upper(curp)
gen nom_mayus = upper(apellido_nombre)
save panel_mayus, replace

gen checkc =  regexm(c_mayus, "^[A-Z][AEIOUX][A-Z][A-Z][0-9][0-9][0-9][0-9][0-9][0-9][HM][A-Z][A-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z][B-DF-HJ-NP-TV-Z]")
order checkc

save panel_regex, replace

keep if checkc ==0
save panel_para_corregir, replace


//Guarda los CURPs con formato correto
use panel_regex, clear
keep if checkc == 1
save panel_curp_formato, replace


//Corrige algunos apellidos
use panel_para_corregir, clear

//Correguir a mano algunos apellidos
replace nom_mayus=subinstr(nom_mayus, "�VAZQUEZ", "VAZQUEZ", .)
replace nom_mayus=subinstr(nom_mayus, "�LVARADO", "ALVARADO", .)
replace nom_mayus=subinstr(nom_mayus, "�NGELES", "ANGELES", .)
replace nom_mayus=subinstr(nom_mayus, "ALARC�N", "ALARCON", .)



gen nom_curp = nom_mayus
replace nom_curp=subinstr(nom_curp, "DE ", "", .)
replace nom_curp=subinstr(nom_curp, "DEL ", "", .)
replace nom_curp=subinstr(nom_curp, "LA ", "", .)
replace nom_curp=subinstr(nom_curp, "LOS ", "", .)
replace nom_curp=subinstr(nom_curp, "/ ", "", .)


//Dividir nombre y apellido
split nom_curp

egen nombres = concat(nom_curp3   nom_curp4   nom_curp5  nom_curp6  nom_curp7 ///
 nom_curp8   nom_curp9   nom_curp10  nom_curp11  nom_curp12 ///
nom_curp13   nom_curp14   nom_curp15   nom_curp16  nom_curp17  nom_curp18 ) , punct(" ")

save panel_nombres_sep, replace

// Quedarnos con lo necesario 
keep grado cct p_esp p_mat curp apellido_nombre anyo indice c_mayus nom_mayus nom_curp nom_curp1 nom_curp2 nombres
rename nom_curp1 apellidoPat
rename nom_curp2 apellidoMat


//Reconstruir curp
//primera letra: primera letra apellido paterno

gen inicial_ap = regexs(0) if regexm(apellidoPat, "(^[A-Z])")
//segunda letra: primera vocal apellido paterno
gen vocal_ap = regexs(2) if regexm(apellidoPat, "([^AEIOU]+)([AEIOU])([a-zA-Z]+)")
//tercero letra: inicial apellido materno
gen inicial_am = regexs(0) if regexm(apellidoMat, "(^[A-Z])")
//inicial nombre
gen inicial_nom = regexs(0) if regexm(nombres,  "(^[A-Z])")
//falta fecha de nacimiento y genéro


save reconstruccion_curp, replace


//General nuevo CURP corregido 
gen curp_corr = c_mayus
replace curp_corr= inicial_ap + vocal_ap + inicial_am + inicial_nom+ substr(curp_corr, 5, .) 

save buscados_panel, replace

//Buscamos para match con las que tenian el CURP en formato correcto
use buscados_panel, clear
rename indice indice_buscado
save buscados_panel, replace

//**************************************************************************************************
//This takes a long time
//The idea is to replace the CURPs from buscados_panel with the CURPs with the right formal (panel_curp_formato)
use buscados_panel, clear
matchit indice_buscado curp_corr using panel_curp_formato.dta, idu(indice) txtu(c_mayus)
gsort -similscore

rename similscore ss_curps
save match_curps, replace 

//The same thing could be done with the names of the participants
matchit indice_buscado nom_curp using panel_curp_formato.dta, idu(indice) txtu(nom_mayus)
//****************************************************************************************************

// Merges panels
use "$basesD\buscados_panel", clear
gen checkc = 0
drop c_mayus
rename curp_corr c_mayus
rename indice_buscado indice
keep checkc grado cct p_esp p_mat curp apellido_nombre anyo indice c_mayus nom_mayus
append using "$basesD\panel_curp_formato"

//Tags generations
gen generacion = . 
replace generacion = (anyo - 2000 - grado) + 4

//More data cleaning, keeps only letters and numbers and first 16 characters
egen letNum = sieve(c_mayus), keep(a n)
gen curp_fuzzy = substr(letNum,1,16)

//Calculates average per generation
duplicates tag curp_fuzzy, gen(dup_curp_fuzzy)
gen anyoEsc = dup_curp_fuzzy + 1

save panel_anyoe, replace

duplicates drop curp_fuzzy, force
drop if anyoEsc > 9
egen anyoProm2 = mean(anyoEsc), by(generacion)
save panel_prom, replace
// Total average school years
sum anyoProm

//Average school years when generations can be followed for more than a year
drop if generacion==1
drop if generacion == 2
drop if generacion== 3
drop if generacion == 13
sum anyoProm













//


gen curp_fuzzy = substr(c_mayus,1,16)


gen c_mayus = upper(curp)
egen letNum = sieve(c_mayus), keep(a n)
gen tam_curp = strlen(letNum)
save tam_curps, replace
keep if tam_curp >=16
gen curp_fuzzy = substr(letNum,1,16)
drop curp
rename curp_fuzzy curp
save info_panel_fuzzy, replace
drop letNum c_mayus tam_curp
sort curp
save panel_fuzzy_10, replace

