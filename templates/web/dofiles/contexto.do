//============================================================================================
// Cuestionario de Contexto
// Last edition: 2/15/2018
//============================================================================================

clear all
set more off
gl dir = "C:\Users\pmeji\Dropbox\ITAM\OctavoSemestre\PredecirDesempeño\CuestionarioContexto"
gl basesJ = "$dir\source\viejasJanina"

set maxvar 32767
use "$basesJ\cohorte_20072013_padres4-v12.dta", clear

import delimited C:\Users\pmeji\Dropbox\ITAM\OctavoSemestre\PredecirDesempeño\CuestionarioContexto\source\viejasJanina\cohorte_20072013_padres4-R.csv, rowrange(400) 
