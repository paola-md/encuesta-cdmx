	

clear all
set more off
gl bases = "D:\Educacion\entrega BM\bases originales"
gl cie = "D:\Educacion\entrega BM"
gl basesA= "$cie\bases auxiliares"
	
*******************
*xoxo
****************	
if 0==1{
	use "$basesA\B6.dta", clear
	keep curp grado anyo
	forvalues x=7/12{
		append using "$basesA\B`x'.dta" , keep(curp grado anyo)
		duplicates drop curp anyo, force
		}

	drop if grado ==.
	egen clave = group(curp)

	duplicates drop clave anyo, force
	xtset clave anyo
	bysort curp: egen gmax= max(grado)
	bysort curp: egen amax= max(anyo)
	bysort curp: egen gmin= min(grado)
	bysort curp: egen amin= min(anyo)
	save "$basesA\panelEnlace.dta" , replace
}

use "$basesA\panelEnlace.dta" , clear
bysort curp grado: gen aux=_N
bysort curp: egen reprobar= max(aux)
replace aux = aux-1
drop if reprobar>2
drop reprobar aux
*** seguir
forvalues m=5/9 {
	preserve
		drop if gmax == 8 & amax==2010
		drop if gmax == 9 & amax==2010
		drop if gmin == 5 & amin==2006
		drop if gmin == 6 & amin==2006
		if `m'==5{
			keep if (grado==5 & anyo==2012) | (grado==4 & anyo==2011) | (grado==3 & anyo==2010) 
			local s 10 11 12 
			}
		if `m'==6{
			keep if (grado==6 & anyo==2012) | (grado==5 & anyo==2011) | (grado==4 & anyo==2010) | (grado==3 & anyo== 2009)
			local s 09 10 11 12 
		}
		if `m'==7{
			keep if (grado==7 & anyo==2012) | (grado==6 & anyo==2011) | (grado==5 & anyo==2010) | (grado==4 & anyo== 2009)| (grado==3 & anyo==2008) 
			local s 08 09 10 11 12
			}
		if `m'==8{
			keep if (gmax==8 & amax==2012)  | (grado==6 & anyo==2010) | (grado==5 & anyo== 2009)| (grado==4 & anyo==2008) | (grado==3 & anyo==2007)
			local s 07 08 09 10 12
		}
		if `m'==9{
			keep if (gmax==9 & amax==2012) |  (grado==7 & anyo==2010) | (grado==6 & anyo== 2009)| (grado==5 & anyo==2008)| (grado==4 & anyo==2007) | (grado==3 & anyo==2006)
			local s 06 07 08 09 10 12
		}
		drop gmax amax curp amin gmin
		****cosas que hacer
		bysort anyo: gen total_ninos=_N
		reshape wide grado total_ninos , i(clave) j(anyo)
		foreach k in `s'{
			replace grado20`k'=0 if grado20`k'==.
			egen total_`k'= max(total_ninos20`k')
			drop total_ninos20`k'
		}
		if `m'==5{
			egen combinaciones=group( grado2010 grado2011 grado2012)
			order clave grado2010 grado2011 grado2012 
		
			}
		if `m'==6{
			egen combinaciones=group(grado2009 grado2010 grado2011 grado2012)
			order clave  grado2009 grado2010 grado2011 grado2012
		
		}
		if `m'==7{
			egen combinaciones=group(grado2008 grado2009 grado2010 grado2011 grado2012)
			order clave grado2008 grado2009 grado2010 grado2011 grado2012 
			}
		if `m'==8{
			egen combinaciones=group( grado2007 grado2008 grado2009 grado2010  grado2012)
			order clave  grado2007 grado2008 grado2009 grado2010  grado2012 
		
		}
		if `m'==9{
			egen combinaciones=group(grado2006 grado2007 grado2008 grado2009 grado2010 grado2012)
			order clave grado2006 grado2007 grado2008 grado2009 grado2010  grado2012
		}
		bysort combinaciones: gen numero=_N
		duplicates drop combinaciones, force
		egen obs_total=total(numero)
		gen porcentaje=numero/obs_total
		drop if porcentaje<.01
		export excel using "$cie\resultados\asistencia.xlsx", sheet("`m' en 2012", replace) firstrow(varlabels)
	
	restore
}
preserve
	keep if (grado == 8 & anyo==2010) | (grado == 7 & anyo==2009)| (grado == 6 & anyo==2008) | (grado == 5 & anyo==2007)| (grado == 4 & anyo==2006)
	drop gmax amax curp amin gmin
	bysort anyo: gen total_ninos=_N
	reshape wide grado total_ninos, i(clave) j(anyo)
	foreach k in 06 07 08 09 10 {
				replace grado20`k'=0 if grado20`k'==.
				egen total_`k'= max(total_ninos20`k')
				drop total_ninos20`k'
			}
	egen combinaciones=group(grado2006 grado2007 grado2008 grado2009 grado2010  )
	bysort combinaciones: gen numero=_N
	duplicates drop combinaciones, force
	egen obs_total=total(numero)
	gen porcentaje=numero/obs_total
	drop if porcentaje<.01
	export excel using "$cie\resultados\asistencia.xlsx", sheet("8 en 2010", replace) firstrow(varlabels)
restore
preserve
	keep if (grado == 9 & anyo==2010) | (grado == 8 & anyo==2009)|   (grado == 6 & anyo==2007)| (grado == 5 & anyo==2006) 
	drop gmax amax curp amin gmin
	bysort anyo: gen total_ninos=_N
	reshape wide grado total_ninos, i(clave) j(anyo)
	foreach k in 06 07 09 10{
				replace grado20`k'=0 if grado20`k'==.
				egen total_`k'= max(total_ninos20`k')
				drop total_ninos20`k'
			}
	egen combinaciones=group(grado2006 grado2007 grado2009 grado2010  )
	bysort combinaciones: gen numero=_N
	duplicates drop combinaciones, force
	egen obs_total=total(numero)
	gen porcentaje=numero/obs_total
	drop if porcentaje<.01
	export excel using "$cie\resultados\asistencia.xlsx", sheet("9 en 2010", replace) firstrow(varlabels)
restore

***********
**xtdes
***********
if 0==0 {
	use "$basesA\panelEnlace.dta" , clear
	xtset clave anyo
	*** seguir
	cd "$cie\resultados"
	log using asistencia
*** seguir
	forvalues m=5/9 {
		preserve
			drop if gmax == 8 & amax==2010
			drop if gmax == 9 & amax==2010
			drop if gmin == 5 & amin==2006
			drop if gmin == 6 & amin==2006
			if `m'==5{
				keep if (grado==5 & anyo==2012) | (grado==4 & anyo==2011) | (grado==3 & anyo==2010) 
				local s 10 11 12 
				}
			if `m'==6{
				keep if (grado==6 & anyo==2012) | (grado==5 & anyo==2011) | (grado==4 & anyo==2010) | (grado==3 & anyo== 2009)
				local s 09 10 11 12 
			}
			if `m'==7{
				keep if (grado==7 & anyo==2012) | (grado==6 & anyo==2011) | (grado==5 & anyo==2010) | (grado==4 & anyo== 2009)| (grado==3 & anyo==2008) 
				local s 08 09 10 11 12
				}
			if `m'==8{
				keep if (gmax==8 & amax==2012)  | (grado==6 & anyo==2010) | (grado==5 & anyo== 2009)| (grado==4 & anyo==2008) | (grado==3 & anyo==2007)
				local s 07 08 09 10 12
			}
			if `m'==9{
				keep if (gmax==9 & amax==2012) |  (grado==7 & anyo==2010) | (grado==6 & anyo== 2009)| (grado==5 & anyo==2008)| (grado==4 & anyo==2007) | (grado==3 & anyo==2006)
				local s 06 07 08 09 10 12
			}
			drop gmax amax curp amin gmin
			****cosas que hacer
			xtdes
		restore
	}
	preserve
		keep if (gmax == 8 & amax==2010) | (grado == 7 & anyo==2009)| (grado == 6 & anyo==2008) | (grado == 5 & anyo==2007)| (gmin == 4 & amin==2006)
		drop gmax amax curp amin gmin
		xtdes
	restore

	preserve
		keep if (gmax == 9 & amax==2010) | (grado == 8 & anyo==2009)| (grado == 7 & anyo==2008)|   (grado == 6 & anyo==2007)| (gmin == 5 & amin==2006) 
		drop gmax amax curp amin gmin
		xtdes
	restore
	log close
}
	**************
	***********NONONONONO
	*******************
	forvalues m=5/9 {
		preserve
			drop if gmax == 8 & amax==2010
			drop if gmax == 9 & amax==2010
			drop if gmin == 5 & amin==2006
			drop if gmin == 6 & amin==2006
			if `m'==5{
				keep if (gmax==5 & amax==2012) | (grado==4 & anyo==2011) | (grado==3 & anyo==2010) 
			}
			if `m'==6{
				keep if (gmax==6 & amax==2012) | (grado==5 & anyo==2011) | (grado==4 & anyo==2010) | (grado==3 & anyo== 2009)
			}
			if `m'==7{
				keep if (gmax==7 & amax==2012) | (grado==6 & anyo==2011) | (grado==5 & anyo==2010) | (grado==4 & anyo== 2009)| (grado==3 & anyo==2008) 
				}
			if `m'==8{
				keep if (gmax==8 & amax==2012) | (grado==7 & anyo==2011) | (grado==6 & anyo==2010) | (grado==5 & anyo== 2009)| (grado==4 & anyo==2008) | (gmin==3 & amin==2007)
			}
			if `m'==9{
				keep if (gmax==9 & amax==2012) | (grado==8 & anyo==2011) | (grado==7 & anyo==2010) | (grado==6 & anyo== 2009)| (grado==5 & anyo==2008)| (grado==4 & anyo==2007) | (gmin==3 & amin==2006)
			}
			drop gmax amax curp amin gmin
			****cosas que hacer
			xtdes
		restore
	}

	preserve
		keep if (gmax == 8 & amax==2010) | (grado == 7 & anyo==2009)| (grado == 6 & anyo==2008)| (gmin == 5 & amin==2006)
		xtdes
	restore
	preserve
		keep if (gmax == 9 & amax==2010) | (grado == 8 & anyo==2009)| (grado == 7 & anyo==2008)|   (grado == 6 & anyo==2007)| (gmin == 5 & amin==2006) 
		drop gmax amax curp amin gmin
		xtdes
	restore
	log close
}



