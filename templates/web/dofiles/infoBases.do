//Statistics

clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"

//====== Datos 2006 =====
*Solo folios
use "$dir2\ENLACEBASICA\ENLACE2006.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numCURP = group(nofolio)
bysort numCURP: gen howmany=_N
tab howmany


* Folio y CURPs
clear all 
use "$dir2\ENLACEBASICA\enl06nal_nombres.dta"

egen numCURP = group(CURP)
sum numCURP

egen numFol = group(NOFOLIO)
sum numFol

gen tam_curp = strlen(CURP)
keep if tam_curp ==16

egen numCURP_16 = group(CURP)
sum numCURP_16

//===== Datos 2007 =====
use "$dir2\ENLACEBASICA\enl07_A.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany

use "$dir2\ENLACEBASICA\enl07_B.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany


use "$dir2\ENLACEBASICA\enl07nal_nombres.dta", clear
egen numCURP = group(CURP)
sum numCURP

egen numFol = group(NOFOLIO)
sum numFol

gen tam_curp = strlen(CURP)
keep if tam_curp ==16

egen numCURP_16 = group(CURP)
sum numCURP_16

//===== Datos 2008 =====
use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_08_A.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany

use "$dir2\ENLACEBASICA\enl08_B.dta", clear
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany

use "$dir2\ENLACEBASICA\enl08nal_nombres.dta", clear
egen numCURP = group(CURP)
sum numCURP

egen numFol = group(nofolio)
sum num

gen tam_curp = strlen(CURP)
keep if tam_curp ==16

egen numCURP_16 = group(CURP)
sum numCURP_16

//===== Datos 2009 =====
use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_09_A.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany

use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_09_B.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany


use "$dir2\ENLACEBASICA\enl09_nal_nombres.dta", clear
egen numCURP = group(CURP_DGAIR)
sum numCURP

egen numFol = group(NOFOLIO)
sum numFol

gen tam_curp = strlen(CURP_DGEP)
keep if tam_curp ==16

egen numCURP_16 = group(CURP_DGEP)
sum numCURP_16



//===== Datos 2010 =====
use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_10_A.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany

use "$dir2\ENLACEBASICA\RESULT_ALUMNOS_10_B.dta", clear
*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
tab howmany


use "$dir2\ENLACEBASICA\enl10_nal_nombres.dta", clear
egen numCURP = group(CURP)
sum numCURP

egen numFol = group(NOFOLIO)
sum numFol

gen tam_curp = strlen(CURP)
keep if tam_curp ==16

egen numCURP_16 = group(CURP)
sum numCURP_16



// ===== Datos 2011 =====
use "$dir2\2011\resul_enlace_11.dta", clear

*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
sum howmany


use "$dir2\2011\alumnos_curp_11.dta", clear

egen numFol = group(nofolio)
bysort numFol: gen howmany=_N
sum howmany

egen numCURP1 = group(curp)
sum numCURP1

gen tam_curp = strlen(curp)
keep if tam_curp ==16

egen numCURP_16 = group(curp)
sum numCURP_16


// ===== Datos 2012 =====
use "$dir2\ENLACEBASICA\resul_alum_eb12.dta", clear

*Numero de escuelas
egen numCCT = group(cct)
sum numCCT
**Numero de CURPs
egen numFol = group(NOFOLIO)
bysort numFol: gen howmany=_N
sum howmany


use "$dir2\ENLACEBASICA\nombres_enlb_12_nac.dta", clear

egen numFol = group(NOFOLIO)
bysort numFol: gen howmany=_N
sum howmany

egen numCURP2 = group(v4)
sum numCURP2

gen tam_curp = strlen(v4)
keep if tam_curp ==16

egen numCURP_162 = group(v4)
sum numCURP_162

// ====== Panel Exacto ======
use  "$basesD\panel_exacto_18.dta", clear

egen numCURP = group(curp)
bysort numCURP: gen howmany=_N

duplicates tag curp, gen(dup_curp)
gen anyoEsc = dup_curp + 1
sum anyoEsc

duplicates drop curp, force
sum anyoEsc




**********************************************
duplicates report curp


sort curp
by curp: gen newid = 1 if _n==1
replace newid = sum(newid)
replace newid = . if missing(curp)

gen curp1 = substr(curp,1,8)
gen curp2 = substr(curp,9,18)

sort curp1 curp2
by curp1 curp2: gen newid2 = 1 if _n==1
replace newid2 = sum(newid2)
replace newid2 = . if missing(curp)

egen numCURP2 = group(curp1 curp2)

*duplicates drop curp, force
sum howmany //prom 
