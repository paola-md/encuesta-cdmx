//============================================================================================
// Interview Regressions 
// 12/29/2018
//============================================================================================


clear all
set more off
gl dir = "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Entrevista\build"


gl basesS = "C:\Users\pmeji\Dropbox\CIE\2018-Educacion\BasesRafael\EntregaSAT"
gl basesCP = "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\temp\stata"

import delimited "$basesS\Encuesta1.csv", encoding(UTF-8) clear
save "$dir\encuesta.dta", replace 


use "$dir\source\encuesta.dta", clear

//============ DATA CLEANIG ==============
//Clean unsignificant variables
drop v1 nofolio_6_2007 nofolio_9_2010 nofolio_8_2009 nofolio nofolio_12_2013

drop r96 r95 r94 r93 r92 r91 r90 r89 r88 r87 r86 r85 r84 r83 r82 r81 r80 r79 r78 r77 r76 r75 r74 r73 r72 r71 r70 r69 r68 r67 r66 r65 r64 r63 r62 r61 r60 r59 r58 r57 r56 r55 r54 r53 r52 r51 r50 r49 r48 r47 r46 r45 r44 r43 r42 r41 r40 r39 r38 r37 r36 r35 r34 r33 r32 r31 r30 r29 r28 r27 r26 r25 r24 r23 r22 r21 r14 r15

//Variables with many non availables (NA) observations
//drop bina libros_hog ingresos_hog pro_hog num_hijos num_habit_hog


//2016
use "$dir\source\encuesta.dta", clear
keep  cct_serv_6 cal_esp_6_2007 cal_mat_6_2007 ///
prom_prim curp municipio sexo modalidad duracion edad civil lengua_m lengua_p trabajo tiempo_trab sem_hor_tra mot_trab niv_est_alc e11_a_3040 e12_tu_3040 exu_a3040 exu_tu3040 obsesion desanimo metas_mes esmero meta_camb distraccion termino trab_duro periodicos noticias text_acad novelas internet word correo excel preescolar primaria esc_sec tipo_sec prom_sec ing_ems esc_ems area_ems beca_altren beca_nececo pro_ems pro_mat prom_esp camb_ems mot_camb de_sem mot_de exi_ems biblio computo practicas salones fal_esp llegan_esp disc_esp conoc_esp prepa_esp int_esp tarea_esp libro_esp ejem_esp ejerc_esp retro_esp dudas_esp temas_esp mem_esp conad_esp exp_esp apren_esp rel_esp esc_esp estimul_esp invol_esp ayuda_esp emplea_esp orga_esp fal_mat llegan_mat disc_mat conoc_mat prepa_mat int_mat tarea_mat soltar_mat libro_mat ejem_mat ejerc_mat retro_mat dudas_mat temas_mat ense_mat mem_mat conad_mat exp_mat apren_mat rel_mat esc_mat estimul_mat invol_mat ayuda_mat emplea_mat orga_mat seg_esc insultan pelean destruyen cons_drogas armas vivir_madre vivir_padre duda_acad sup_calif sup_tarea sup_activ est_madre est_padre exp_padres libros_casa vac_ult2 estrm_visi tel_casa cel_casa lavado_casa refri_casa estufa horno_micr tele interne tableta num_repdvd num_comp num_tele num_auto turno extens rub dan localidad n_sostenim n_subsiste nvl_educ_madre ocup_madre tipo_trab_madre opcup_prin_madre ran_edad_madre nvl_educ_padre ocup_padre tipo_trab_padre opcup_prin_padre ran_edad_padre 
rename cct_serv_6 cct
rename cal_esp_6_2007 cal_esp
rename cal_mat_6_2007 cal_mat
destring cal_mat cal_esp, replace force 
gen anyo = 2007

save "$dir\temp\encuesta_6.dta", replace 


//keep only grades "cal_esp" "cal_mat"
forvalues i = 9/13 {
	if `i' <11 | `i' >12 {
		use "$dir\source\encuesta.dta", clear
		local j = `i'-1
		local k = `i' + 2000
		keep cal_esp_`j'_`k' cal_mat_`j'_`k' ///
		prom_prim curp cct municipio sexo modalidad duracion edad civil lengua_m lengua_p trabajo tiempo_trab sem_hor_tra mot_trab niv_est_alc e11_a_3040 e12_tu_3040 exu_a3040 exu_tu3040 obsesion desanimo metas_mes esmero meta_camb distraccion termino trab_duro periodicos noticias text_acad novelas internet word correo excel preescolar primaria esc_sec tipo_sec prom_sec ing_ems esc_ems area_ems beca_altren beca_nececo pro_ems pro_mat prom_esp camb_ems mot_camb de_sem mot_de exi_ems biblio computo practicas salones fal_esp llegan_esp disc_esp conoc_esp prepa_esp int_esp tarea_esp libro_esp ejem_esp ejerc_esp retro_esp dudas_esp temas_esp mem_esp conad_esp exp_esp apren_esp rel_esp esc_esp estimul_esp invol_esp ayuda_esp emplea_esp orga_esp fal_mat llegan_mat disc_mat conoc_mat prepa_mat int_mat tarea_mat soltar_mat libro_mat ejem_mat ejerc_mat retro_mat dudas_mat temas_mat ense_mat mem_mat conad_mat exp_mat apren_mat rel_mat esc_mat estimul_mat invol_mat ayuda_mat emplea_mat orga_mat seg_esc insultan pelean destruyen cons_drogas armas vivir_madre vivir_padre duda_acad sup_calif sup_tarea sup_activ est_madre est_padre exp_padres libros_casa vac_ult2 estrm_visi tel_casa cel_casa lavado_casa refri_casa estufa horno_micr tele interne tableta num_repdvd num_comp num_tele num_auto turno extens rub dan localidad n_sostenim n_subsiste nvl_educ_madre ocup_madre tipo_trab_madre opcup_prin_madre ran_edad_madre nvl_educ_padre ocup_padre tipo_trab_padre opcup_prin_padre ran_edad_padre 

		gen anyo = `k'
		rename cal_esp_`j'_`k' cal_esp
		rename cal_mat_`j'_`k' cal_mat
		destring cal_mat cal_esp, replace force 
		save "$dir\temp\encuesta_`i'.dta", replace
	}
}


//2013 pmat
use "$dir\source\encuesta.dta", clear
local i = 12
local k = `i' + 2000

keep p_esp_`i' p_mat_`i' ///
prom_prim curp cct municipio sexo modalidad duracion edad civil lengua_m lengua_p trabajo tiempo_trab sem_hor_tra mot_trab niv_est_alc e11_a_3040 e12_tu_3040 exu_a3040 exu_tu3040 obsesion desanimo metas_mes esmero meta_camb distraccion termino trab_duro periodicos noticias text_acad novelas internet word correo excel preescolar primaria esc_sec tipo_sec prom_sec ing_ems esc_ems area_ems beca_altren beca_nececo pro_ems pro_mat prom_esp camb_ems mot_camb de_sem mot_de exi_ems biblio computo practicas salones fal_esp llegan_esp disc_esp conoc_esp prepa_esp int_esp tarea_esp libro_esp ejem_esp ejerc_esp retro_esp dudas_esp temas_esp mem_esp conad_esp exp_esp apren_esp rel_esp esc_esp estimul_esp invol_esp ayuda_esp emplea_esp orga_esp fal_mat llegan_mat disc_mat conoc_mat prepa_mat int_mat tarea_mat soltar_mat libro_mat ejem_mat ejerc_mat retro_mat dudas_mat temas_mat ense_mat mem_mat conad_mat exp_mat apren_mat rel_mat esc_mat estimul_mat invol_mat ayuda_mat emplea_mat orga_mat seg_esc insultan pelean destruyen cons_drogas armas vivir_madre vivir_padre duda_acad sup_calif sup_tarea sup_activ est_madre est_padre exp_padres libros_casa vac_ult2 estrm_visi tel_casa cel_casa lavado_casa refri_casa estufa horno_micr tele interne tableta num_repdvd num_comp num_tele num_auto turno extens rub dan localidad n_sostenim n_subsiste nvl_educ_madre ocup_madre tipo_trab_madre opcup_prin_madre ran_edad_madre nvl_educ_padre ocup_padre tipo_trab_padre opcup_prin_padre ran_edad_padre 

gen anyo = `k'
rename p_esp_`i' cal_esp
rename p_mat_`i' cal_mat
destring cal_mat cal_esp, replace force 
save "$dir\temp\encuesta_`i'.dta", replace


clear all
forvalues i = 6/12 {
	capture confirm file "$dir\temp\encuesta_`i'.dta"
	 if _rc==0 {
		append using "$dir\temp\encuesta_`i'.dta", force 
	}
}


save "$dir\temp\encuesta_panel.dta", replace



//============== Create Dummy for Private Schools ==================
gen tipo=substr(cct, 3, 1)
gen privada=tipo=="P"

replace privada = 1 if modalidad == "PARTICULAR"

drop tipo
save "$dir\temp\encuesta_panel.dta", replace



//============= Get PostCode ===================
use "$basesCP\cct_C.dta", clear 
duplicates drop cct, force
save "$basesCP\cct_D.dta", replace

forvalues i = 6/13 {
	use "$dir\temp\encuesta_panel.dta", clear
	local k = `i' + 2000
	keep if anyo == `k'
	
	//Junta codigos postales
	merge m:1 cct using  "$basesCP\cct_D.dta"
	keep if _merge == 3
	drop _merge
		
	save "$dir\temp\cp_`i'.dta", replace
}

clear all
forvalues i = 6/12 {
	capture confirm file"$dir\temp\cp_`i'.dta"
	 if _rc==0 {
		append using "$dir\temp\cp_`i'.dta", force 
	}
}

drop building county additionaldata_2_value additionaldata_2_key street state label housenumber district country city additionaldata_1_value additionaldata_1_key additionaldata_0_value additionaldata_0_key v1

save "$dir\temp\entrevista_cp.dta", replace


//================== Controls =======================
encode cct, gen(cct2)
egen curp2 = group(curp)
 
save "$dir\temp\entrevista_cp.dta", replace

//================ Standarize grades =============
use "$dir\temp\entrevista_cp.dta", clear

bys anyo : egen sd_m = sd(cal_mat)
bys anyo : egen sd_e = sd(cal_esp)

bys anyo : egen avr_m = mean(cal_mat)
bys anyo : egen avr_e = mean(cal_esp)

replace cal_esp_s = (cal_esp - avr_e ) /sd_e  
replace cal_mat_s = (cal_mat - avr_m ) /sd_m  

save "$dir\temp\entrevista_cp.dta", replace

//================= Maths Regression =============

use "$dir\temp\entrevista_cp.dta", clear
cd "$dir\output"

keep cal_mat_s privada anyo postalcode prom_prim niv_est_alc periodicos curp2 est_madre est_padre
drop if cal_mat_s==.

drop if prom_prim == "NA"
destring prom_prim, replace

drop if niv_est_alc == "NA"
destring niv_est_alc, replace

drop if periodicos == "NA"
destring periodicos, replace

reg cal_mat_s privada, r
outreg2 using reg_intervw2.xls, replace text ctitle(sin abs) bdec(3) sdec(3) paren(se) asterisk(coef)

reghdfe cal_mat_s privada, absorb(postalcode) vce(r)
outreg2 using reg_intervw2.xls, text ctitle(abs pc) bdec(3) sdec(3) paren(se) asterisk(coef)

reghdfe cal_mat_s privada, absorb(est_madre est_padre) vce(r)
outreg2 using reg_intervw2.xls, text ctitle( abs est) bdec(3) sdec(3) paren(se) asterisk(coef)

reghdfe cal_mat_s privada, absorb(postalcode est_madre est_padre) vce(r)
outreg2 using reg_intervw2.xls, text ctitle(abs est cp) bdec(3) sdec(3) paren(se) asterisk(coef)



//================= Spanish Regression =============
use "$dir\temp\entrevista_cp.dta", clear

cd "$dir\output"
keep cal_esp_s privada anyo postalcode prom_prim niv_est_alc periodicos curp2
drop if cal_esp_s==.


drop if prom_prim == "NA"
destring prom_prim, replace

drop if niv_est_alc == "NA"
destring niv_est_alc, replace

drop if periodicos == "NA"
destring periodicos, replace


reghdfe cal_esp_s privada prom_prim niv_est_alc periodicos, absorb(anyo postalcode curp2) vce(cluster curp2)
outreg2 using reg3.xls, text ctitle(prim:p_esp_std) bdec(3) sdec(3) paren(se) asterisk(coef)







//====================================

//Contar escuelas 
use "$dir\temp\entrevista_cp.dta", clear
by cct, sort: gen nvals = _n 

duplicates tag cct, gen(dup_cct)
//CCT n hay unics 

duplicates tag curp2, gen(dup_curp)

duplicates tag municipi, gen(dup_mun)


replace nvals = sum(nvals)
replace nvals = nvals[_N] 
sum(nvals)
//1746

//Count students
by curp, sort: gen nvalsc = _n == 1 
replace nvalsc = sum(nvalsc)
replace nvalsc = nvalsc[_N] 
sum(nvalsc)
//182,458

//municipio
drop nmun
by municipio, sort: gen nmun = _n == 1 
replace nmun = sum(mun)
replace nmun = nmun[_N] 
sum(nmun)
//259


unique curp
unique cct
unique municipio 









use 

keep cct cal_esp_8_2009 cal_mat_8_2009
rename cal_esp_8_2009 cal_esp
rename cal_mat_8_2009 cal_mat

keep cct cal_esp_9_2010 cal_mat_9_2010
rename cal_esp_8_2009 cal_esp
rename cal_mat_8_2009 cal_mat

// =========== Reshape from wide format to long format ============
//2006 variables
p_esp_6 p_mat_6 sp_esp_6 sp_mat_6 nvl_esp_6 nvl_mat_6 in6
dec_esp_6 dec_mat_6
state_6 cct_serv_6 priv_6 conafe_6 reg_6 cct_type_6

//2007 variables
cct_6_2007 cal_esp_6_2007 cal_mat_6_2007 ne_6_2007 nm_6_2007

//2008 variables
p_esp_8 p_mat_8 sp_esp_8 sp_mat_8
nvl_esp_8 nvl_mat_8 in8
dec_esp_8 dec_mat_8

//2009 variables
 ne_8_2009 nm_8_2009 cal_esp_8_2009 cal_mat_8_2009
 p_esp_9 sp_esp_9 sp_esp_9 sp_mat_9
 nvl_esp_9 nvl_mat_9 in9 drop9
 dec_esp_9 dec_mat_9

//2010 variables
ne_9_2010 nm_9_2010 cal_esp_9_2010 cal_mat_9_2010

//2012 variables
nm_12_2012 ne_12_2012 cal_esp_12_2012 cal_mat_12_2012
p_esp_12 p_mat_12 sp_esp_12 sp_mat_12
nvl_esp_12 nvl_mat_12 in12 drop12
dec_esp_12 dec_mat_12

//2013 variables
ne_12_2013 nm_12_2013 cal_esp_12_2013 cal_mat_12_2013


//Otras variables
cct municipio sexo modalidad duracion edad civil lengua_m lengua_p trabajo tiempo_trab sem_hor_tra mot_trab niv_est_alc e11_a_3040 e12_tu_3040 exu_a3040 exu_tu3040 obsesion desanimo metas_mes esmero meta_camb distraccion termino trab_duro periodicos noticias text_acad novelas internet word correo excel preescolar primaria esc_sec tipo_sec prom_sec ing_ems esc_ems area_ems beca_altren beca_nececo pro_ems pro_mat prom_esp camb_ems mot_camb de_sem mot_de exi_ems biblio computo practicas salones fal_esp llegan_esp disc_esp conoc_esp prepa_esp int_esp tarea_esp libro_esp ejem_esp ejerc_esp retro_esp dudas_esp temas_esp mem_esp conad_esp exp_esp apren_esp rel_esp esc_esp estimul_esp invol_esp ayuda_esp emplea_esp orga_esp fal_mat llegan_mat disc_mat conoc_mat prepa_mat int_mat tarea_mat soltar_mat libro_mat ejem_mat ejerc_mat retro_mat dudas_mat temas_mat ense_mat mem_mat conad_mat exp_mat apren_mat rel_mat esc_mat estimul_mat invol_mat ayuda_mat emplea_mat orga_mat seg_esc insultan pelean destruyen cons_drogas armas vivir_madre vivir_padre duda_acad sup_calif sup_tarea sup_activ est_madre est_padre exp_padres libros_casa vac_ult2 estrm_visi tel_casa cel_casa lavado_casa refri_casa estufa horno_micr tele interne tableta num_repdvd num_comp num_tele num_auto turno extens rub dan localidad n_sostenim n_subsiste nvl_educ_madre ocup_madre tipo_trab_madre opcup_prin_madre ran_edad_madre nvl_educ_padre ocup_padre tipo_trab_padre opcup_prin_padre ran_edad_padre 



reshape wide cct grado p_esp p_mat apellido_nombre, i(curp) j(anyo)

reshape long cct grado p_esp p_mat apellido_nombre, i(curp) j(anyo)

//Crear dummy PP

//Merge de CCT con CP
