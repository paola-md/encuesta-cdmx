
*Limpia de base de datos, renombramiento y creación de variables para primaria 911 de 2006-2016
*OJO: las variables se encuentran a nivel escuela

gl dir = "E:\Proy_Paola_Salo\Educacion\entregaBM\"
gl source="E:\Proy_Paola_Salo\Educacion\hechosNotables\source\"
gl basesA= "$dir\basesAuxiliares\"
gl basesD = "$basesA\deleteMyFiles\"
gl resultados ="$dir\resultados\"



cd "$source\911 PRIMARIA\"


foreach j of numlist 6/16{
	*Primaria general 
	use PRIMGI0`j', clear
	*Creación de variables:
	*Inscripción, repetidores por año desglosados por sexo y totales
	label var V12 "Nuevo ingreso hombres 1 de primaria"
	label var V23 "Repetidores hombres 1 de primaria"
	label var V35 "Nuevo ingreso mujeres 1 de primaria"
	label var V46 "Repetidores mujeres 1 de primaria"
	
	label var V70 "Nuevo ingreso hombres 2 de primaria"
	label var V81 "Repetidores hombres 2 de primaria"
	label var V92 "Nuevo ingreso mujeres 2 de primaria"
	label var V103 "Repetidores mujeres 2 de primaria"
	
	label var V125 "Nuevo ingreso hombres 3 de primaria"
	label var V135 "Repetidores hombres 3 de primaria"
	label var V145 "Nuevo ingreso mujeres 3 de primaria"
	label var V155 "Repetidores mujeres 3 de primaria"
	
	label var V175 "Nuevo ingreso hombres 4 de primaria"
	label var V184 "Repetidores hombres 4 de primaria"
	label var V193 "Nuevo ingreso mujeres 4 de primaria"
	label var V202 "Repetidores mujeres 4 de primaria"
	
	label var V220 "Nuevo ingreso hombres 5 de primaria"
	label var V228 "Repetidores hombres 5 de primaria"
	label var V236 "Nuevo ingreso mujeres 5 de primaria"
	label var V244 "Repetidores mujeres 5 de primaria"
	
	label var V260 "Nuevo ingreso hombres 6 de primaria"
	label var V267 "Repetidores hombres 6 de primaria"
	label var V274 "Nuevo ingreso mujeres 6 de primaria"
	label var V281 "Repetidores mujeres 6 de primaria"
	
	label var V301 "Total de hombres de nuevo ingreso (de todos los grados)"
	label var V312 "Total de hombres repetidores (de todos los grados)"
	label var V324 "Total de mujeres de nuevo ingreso (de todos los grados)"
	label var V335 "Total de mujeres repetidores (de todos los grados)"
	
	
	rename V12 ing_h_1
	rename V23 rep_h_1
	rename V35 ing_m_1 
	rename V46 rep_m_1
	
	rename V70 ing_h_2
	rename V81 rep_h_2
	rename V92 ing_m_2
	rename V103 rep_m_2
	
	rename V125 ing_h_3
	rename V135 rep_h_3
	rename V145 ing_m_3
	rename V155 rep_m_3
	
	rename V175 ing_h_4
	rename V184 rep_h_4
	rename V193 ing_m_4
	rename V202 rep_m_4
	
	rename V220 ing_h_5
	rename V228 rep_h_5
	rename V236 ing_m_5
	rename V244 rep_m_5
	
	rename V260 ing_h_6
	rename V267 rep_h_6
	rename V274 ing_m_6 
	rename V281 rep_m_6
	
	foreach i of numlist 1/6{
		gen ing_total_`i'=ing_h_`i'+ing_m_`i'
		gen rep_total_`i'=rep_h_`i'+rep_m_`i'
		label var ing_total_`i' "Total de alumnos de nuevo ingreso en `i' de primaria"
		label var rep_total_`i' "Total de alumnos repetidores en `i' de primaria"
		gen insc_h_`i'=ing_h_`i'+rep_h_`i'
		gen insc_m_`i'=ing_m_`i'+rep_m_`i'
		label var insc_h_`i' "Alumnos hombres que inician `i' de primaria (repetidores y nuevo ingreso)"
		label var insc_m_`i' "Alumnos mujeres que inician `i' de primaria (repetidores y nuevo ingreso)"
		gen insc_total_`i'=insc_h_`i'+insc_m_`i'
		label var insc_total_`i' "Total de alumnos que inician `i' de primaria (repetidores y nuevo ingreso)"
	}

	rename V301 ing_h_total
	rename V312 rep_h_total
	rename V324 ing_m_total
	rename V335 rep_m_total	
	*Número de alumnos atrasados por año (nos enfocamos en la edad)
	/*De acuerdo con la SEP la primaria se imparte de los 6 años a los 12 años (ingresando entre los 6 y 7 años y saliendo entre los 11 y 12 años), por lo 
	que se consideró atrasados a los niños con el siguiente criterio
	1ro de primaria: De 8 años en adelante
	2do de primaria: De 9 años en adelante
	3ro de primaria: De 10 años en adelante
	4to de primaria: De los 11 años en adelante
	5to de primaria: De los 12 años en adelante 
	6to de primaria: De los 13 años en adelante
	*/
	gen edades_atrasadas_h_1=V4+V5+V6+V7+V8+V9+V10+V11+V15+V16+V17+V18+V19+V20+V21+V22
	gen edades_atrasadas_m_1=V28+V29+V30+V31+V32+V33+V34+V38+V39+V40+V41+V42+V43+V44+V45
	gen edades_atrasadas_1=V50+V51+V52+V53+V54+V55+V56+V57
	
	gen edades_atrasadas_h_2=V63+V64+V65+V66+V67+V68+V69+V74+V75+V76+V77+V78+V79+V80
	gen edades_atrasadas_m_2=V85+V86+V87+V88+V89+V90+V91+V96+V97+V98+V99+V100+V101+V102
	gen edades_atrasadas_2=V107+V108+V109+V110+V111+V112+V113
	
	gen edades_atrasadas_h_3=V119+V120+V121+V122+V123+V124+V129+V130+V131+V132+V133+V134
	gen edades_atrasadas_m_3=V139+V140+V141+V142+V143+V144+V149+V150+V151+V152+V153+V154
	gen edades_atrasadas_3=V159+V160+V161+V162+V163+V164
	
	
	gen edades_atrasadas_h_4=V170+V171+V172+V173+V174+V179+V180+V181+V182+V183
	gen edades_atrasadas_m_4=V188+V189+V190+V191+V192+V197+V198+V199+V200+V201
	gen edades_atrasadas_4=V206+V207+V208+V209+V210
	
	
	gen edades_atrasadas_h_5=V216+V217+V218+V219+V224+V225+V226+V227
	gen edades_atrasadas_m_5=V232+V233+V234+V235+V240+V241+V242+V243
	gen edades_atrasadas_5=V248+V249+V250+V251

	
	gen edades_atrasadas_h_6=V257+V258+V259+V264+V265+V266
	gen edades_atrasadas_m_6=V271+V272+V273+V278+V279+V280
	gen edades_atrasadas_6=V285+V286+V287
	gen edades_atrasadas_total=edades_atrasadas_1+edades_atrasadas_2+edades_atrasadas_3+edades_atrasadas_4+edades_atrasadas_5+edades_atrasadas_6	
	foreach i of numlist 1/6{
		label var edades_atrasadas_`i' "Numero total de alumnos en `i' de primaria que están atrasados por edad"
		label var edades_atrasadas_h_`i' "Numero total de alumnos hombres en `i' de primaria que están atrasados por edad"	
		label var edades_atrasadas_m_`i' "Numero total de alumnos mujeres en `i' de primaria que están atrasados por edad"	
	}
	
	*Ciclo escolar	
	*Cuando metamos el loop de las bases de datos generamos la variable
	gen anyo=0`j'
	label var anyo "Ciclo escolar"
	*Guardamos cambios
	save "$basesD\PRIMGI0`j'_mod.dta", replace		
}
*Las siguientes variables únicamente se encuentran después del año 2010
foreach j of numlist 10/16{
	use "$basesD\PRIMGI0`j'_mod.dta", clear
	*Escolaridad promedio de los profesores por escuela, número de docentes mujeres, total de personal,etc.
		*OJO: PARA AQUELLOS PROFESORES QUE NO TUVIERON COMPLETO EL GRADO ESTUDIADO SE TOMÓ COMO SI CURSARAN UN SOLO AÑO
		*Se tomaron una educación de 12 años para la profesional técnico
		*Se tomaron una educación de 16 años para las carreras normales, sin distinción de la especialidad (preescolar, primaria, etc.)
		*Para la licenciatura pasante o titulado no se hizo distinción de años.
		*Se tomaron 19 años de educación para aquellos con doctorado incompleto
		*Para el numero total de directivos docentes, docentes especiales y personal adm.
		*se omitieron la categoria "OTROS" (únicamente para el cálculo de escolaridad promedio)
	gen per_dir_h_2=V820-V770-V787-V804+V822-V806-V789-V772
	gen per_dir_m_2=V821-V805-V788-V771+V823-V807-V790-V773
	
	rename V820 per_dir_h 
	rename V821 per_dir_m
	label var per_dir_h "Total de personal directivos hombres"
	label var per_dir_m "Total de personal directivos mujeres"
	gen per_doc_h_2=V824-V808-V791-V774
	gen per_doc_m_2=V825-V809-V792-V775
	rename V824 per_doc_h
	rename V825 per_doc_m
	label var per_doc_h "Total de personal docente hombres"
	label var per_doc_m "Total de personal docente mujeres"
	gen per_doc_ef_h_2=V826-V810-V793-V776
	gen per_doc_ef_m_2=V827-V811-V794-V777
	rename V826 per_doc_ef_h
	rename V827 per_doc_ef_m
	label var per_doc_ef_h "Total de personal docente de educación fisica hombre" 
	label var per_doc_ef_m "Total de personal docente de educación fisica mujer"
	gen per_doc_art_h_2=V828-V812-V795-V778
	gen per_doc_art_m_2=V829-V813-V796-V779
	rename V828 per_doc_art_h 
	rename V829 per_doc_art_m
	label var per_doc_art_h "Total de personal doncente de act. artísticas hombre"
	label var per_doc_art_m "Total de personal docente de act. artísticas mujer"
	gen per_doc_tec_h_2=V830-V814-V797-V780
	gen per_doc_tec_m_2=V831-V815-V798-V771
	rename V830 per_doc_tec_h 
	rename V831 per_doc_tec_m
	label var per_doc_tec_h "Total de personal docente de act. tecnológicas hombre"
	label var per_doc_tec_m "Total de personal docente de act. tecnológicas mujer"	
	gen per_doc_idi_h_2=V832-V816-V799-V782
	gen per_doc_idi_m_2=V833-V817-V800-V783
	rename V832 per_doc_idi_h 
	rename V833 per_doc_idi_m
	label var per_doc_idi_h "Total de personal docente de idiomas hombre"
	label var per_doc_idi_m "Total de personal docente de idiomas mujer"	
	gen per_adm_h_2=V834-V818-V801-V784
	gen per_adm_m_2=V835-V819-V802-V785
	rename V834 per_adm_h 
	rename V835 per_adm_m
	label var per_adm_h "Total de personal administrativo aux y de servicios hombre"
	label var per_adm_m "Total de personal administrativo aux y de servicios mujer"	
	gen prom_edu_dir=(V433+V434+V435+V436+6*(V449+V450+V451+V452)+7*(V465+V466+V467+V468)+9*(V481+V482+V483+V484)+12*(V497+V498+V499+V500) ///
	+10*(V513+V514+V515+V516)+12*(V529+V530+V531+V532)+13*(V545+V546+V547+V548+V577+V578+V579+V580+V609+V610+V611+V612+V657+V658+V659+V660) ///
	+16*(V561+V562+V563+V564+V593+V594+V595+V596+V625+V626+V627+V628+V641+V642+V643+V644+V673+V674+V675+V676+V689+V690+V691+V692) ///
	+17*(V705+V706+V707+V708)+18*(V721+V722+V723+V724)+19*(V737+V738+V739+V740)+21*(V753+V754+V755+V756))/(per_dir_h_2+per_dir_m_2)	
	label var prom_edu_dir "Escolaridad promedio del personal directivo"

	gen prom_edu_doc=(V437+V438+6*(V453+V454)+7*(V471+V472)+9*(V485+V486)+12*(V501+V502)+10*(V517+V518)+12*(V533+V534)+13*(V549+V550+V581+V582+V613+V614+V661+V662) ///
	+16*(V565+V566+V597+V598+V629+V630+V645+V646+V677+V678+V693+V694)+17*(V709+V710)+18*(V725+V726)+19*(V741+V742)+21*(V757+V758))/(per_doc_h_2+per_doc_m_2)	
	label var prom_edu_doc "Escolaridad promedio del personal docente"
	gen prom_edu_doc_esp=(V439+V440+V441+V442+V443+V444+V445+V446+6*(V455+V456+V457+V458+V459+V460+V461+V462) ///
	+7*(V471+V472+V473+V474+V475+V476+V477+V478)+9*(V487+V488+V489+V490+V491+V492+V493+V494) ///
	+12*(V503+V504+V505+V506+V507+V508+V509+V510)+10*(V519+V520+V521+V522+V523+V524+V525+V526) ///
	+12*(V535+V536+V537+V538+V539+V540+V541+V542)+13*(V551+V552+V553+V554+V555+V556+V557+V558+V583+V584+V585+V586+V587+V588+V589+V590+V615+V616+V617+V618+V619+V620+V621+V622+V663+V664+V665+V666+V667+V668+V669+V670) ///
	+16*(V567+V568+V569+V570+V571+V572+V573+V574+V599+V600+V601+V602+V603+V604+V605+V606+V631+V632+V633+V634+V635+V636+V637+V638+V647+V648+V649+V650+V651+V652+V653+V654+V679+V680+V681+V682+V683+V684+V685+V686+V695+V696+V697+V698+V699+V700+V701+V702) ///
	+17*(V711+V712+V713+V714+V715+V716+V717+V718)+18*(V727+V728+V729+V730+V731+V732+V733+V734)+19*(V743+V744+V745+V746+V747+V748+V749+V750)+21*(V759+V760+V761+V762+V763+V764+V765+V766))/(per_doc_ef_h_2+per_doc_ef_m_2+per_doc_art_h_2+per_doc_art_m_2+per_doc_tec_h_2+per_doc_tec_m_2+per_doc_idi_h_2+per_doc_idi_m_2)
	
	label var prom_edu_doc_esp "Escolaridad promedio del personal docente especial (arte, deportes, idiomas y tec.)"
	gen prom_edu_adm=(V447+V448+6*(V463+V464)+7*(V479+V480)+9*(V495+V496)+12*(V511+V512)+10*(V527+V528)+12*(V543+V544) ///
	+13*(V559+V560+V591+V592+V623+V624+V671+V672)+16*(V575+V576+V607+V608+V639+V640+V655+V656+V687+V688+V703+V704)+17*(V719+V720)+18*(V735+V736)+19*(V751+V752)+21*(V767+V768))/(per_adm_h_2+per_adm_m_2)
	label var prom_edu_adm "Escolaridad promedio del personal administrativo, auxiliar y de servicios"
	gen per_doc_total=per_doc_h+per_doc_m 
	label var per_doc_total "Número total de docentes"
	gen per_doc_esp_total=per_doc_idi_h+per_doc_idi_m+per_doc_tec_h+per_doc_tec_m+per_doc_art_h+per_doc_art_m+per_doc_ef_h+per_doc_ef_m
	label var per_doc_esp_total "Número total de docentes especiales"
	label var V836 "Total de personal"
	rename V836 total_per
	label var V876 "Cantidad de profesores con carrera magisterial"
	rename V876 prof_magist
	foreach i of numlist 1/6{
		local aux=863+`i'
		label var V`aux' "Número de profesores que atienden `i' de primaria"
		rename V`aux' num_prof_`i'
	}
	*Colegiatura mensual, inscripción, gastos en utiles, etc.
	label var V916 "Colegiatura mensual"
	rename V916 colegiatura_mensual
	rename V917 num_mensualidad
	label var num_mensualidad "Número de mensualidades que se pagan"
	label var V915 "Gasto promedio anual en inscripción"
	rename V915 inscripcion 
	label var V912 "Gasto promedio anual en útiles y libros"
	rename V912 gasto_utiles
	label var V913 "Gasto promedio anual en uniformes"
	rename V913 gasto_uniforme
	label var V914 "Gasto promedio anual cuotas"
	rename V914 gasto_cuotas
	*Aulas 
	label var V895 "Número de aulas existentes"
	rename V895 aula_exist
	label var V903 "Número de aulas en uso total"
	foreach i of numlist 1/6{
		local aux=895+`i'
		label var V`aux' "Numéro de aulas en uso utilizadas por `i' de primaria"
		rename V`aux' aula_uso_`i'	
	}
	label var V911 "Número de aulas adapatadas totales"
	rename  V911 aula_adap 
	foreach i of numlist 1/6{
		local aux=903+`i' 
		label var V`aux' "Número de aulas adapatadas utilizadas por `i' de primaria"	
		rename V`aux' aula_adap_`i'
	}
	*TURNO
		*DUDA: HAY 7 VALORES PARA ESTA VARIABLE POR LO QUE NO SE SABE QUE SIGNIFICA
	*Número de alumnos extranjeros, con necesidades especiales y con alguna discapacidad 
	label var V399 "Total de alumnos extranjeros"
	
	rename V399 alum_ext
	
	label var V375 "Total de alumnos extranjeros de EUA"
	
	rename V375 alum_ext_eua
	
	label var V378 "Total de alumnos extranjeros de Canada"
	
	rename V378 alum_ext_can
	
	label var V381 "Total de alumnos extranjeros de Centroamerica y el caribe"
	rename V381 alum_ext_ca
	label var V384 "Total de alumnos extranjeros de Sudamerica"
	rename V384 alum_ext_sa
	label var V387 "Total de alumnos extranjeros de Africa"
	rename V387 alum_ext_af
	label var V390 "Total de alumnos extranjeros de Asia"
	rename V390 alum_ext_as
	label var V393 "Total de alumnos extranjeros de Europa"
	rename V393 alum_ext_eu
	label var V396 "Total de alumnos extranjeros de Oceania"
	rename V396 alum_ext_oc
	gen alum_dis=V429-V423
		*Se omitieron los alumnos con capacidades sobresalientes, no se consideró adecuado incluirlos
	label var alum_dis "Total de alumnos con discapacidad"
	label var V405 "Total de alumnos con ceguera"
	rename V405 alum_dis_ce
	label var V408 "Total de alumnos con discapacidad visual"
	rename V408 alum_dis_vi
	label var V411 "Total de alumnos con sordera"
	rename V411 alum_dis_so
	label var V414 "Total de alumnos con discapacidad auditiva"
	rename V414 alum_dis_au
	label var V417 "Total de alumnos con discapacidad motriz"
	rename V417 alum_dis_m
	label var V420 "Total de alumnos con discapacidad intelectual"
	rename V420 alum_dis_in
	label var V423 "Total de alumnos con capacidades y aptitudes sobresalientes"
	rename V423 alum_sobr 
	label var V370 "Total de alumnos indígenas hombres"
	rename V370 alum_ind_h
	label var V371 "Total de alumnos indígenas mujeres"
	rename V371 alum_ind_m
	label var V372 "Total de alumnos indígenas"
	rename V372 alum_ind
	save "$basesD\PRIMGI0`j'_mod.dta", replace	
}

*Borramos las demás variables V*

foreach i of numlist 6/16{
	use "$basesD\PRIMGI0`i'_mod", clear
	drop V*	
	save "$basesD\PRIMGI0`i'_mod.dta", replace
}
*Realizamos el append 
use "$basesD\PRIMGI06_mod", clear
foreach i of numlist 7/16{
	append using "$basesD\PRIMGI0`i'_mod"	
}
save "$basesA\panel911_primaria_0616.dta", replace
	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
