//==============================================================================
//F911 EXTENDIDO
* se eliminan las variables extras, se cambia el nombre de las variables. 
//==============================================================================
gl f911 = "$cie\source\911 BASICA\"
gl dir = "E:\Proy_Paola_Salo\Educacion\entrega BM"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"
gl basesA= "$dir\bases auxiliares"

gl cie = "E:\Proy_Paola_Salo\Educacion\hechosNotables\"
gl basesAS = "$cie\basesAuxiliares\"
gl basesD = "$cie\basesAuxiliares\deleteMyFiles\"
gl source = "$cie\source\"
gl resultados= "$cie\resultados\"

clear all 
set more off 

//===========================================
//  F 9 1 1
//===========================================
if 1==2{
foreach i of numlist 5/6 { 
	local j = `i'+ 1
	foreach letra in C G I{
		import dbase using "$f911\BD_911_200`i'-200`j'\Inicio\PRIM_`letra'.DBF", clear
		save "$basesD\200`j'_`letra'.dta", replace	
	}
}

foreach i in 7 8 { 
	local j = `i'+ 1
	foreach letra in C G I{
		import dbase using "$f911\BD_911_200`i'-200`j'\Inicio\PRIM`letra'I0`i'.DBF", clear
		save "$basesD\200`j'_`letra'.dta", replace	
	}
}

//2009
foreach letra in C G I{
	local i = 9
	local j = `i'+ 1
	import dbase using "$f911\BD_911_200`i'-20`j'\Inicio\PRIM`letra'NAL.DBF", clear
	save "$basesD\200`j'_`letra'.dta", replace	
}

foreach i in 10 11 12 { 
	local j = `i'+ 1
	foreach letra in C G I{
		import dbase using "$f911\BD_911_20`i'-20`j'\Inicio\PRIM`letra'I`i'.DBF", clear
		save "$basesD\20`j'_`letra'.dta", replace	
	}
}


*primarias generales 
foreach ind of numlist 6/13 {
	if `ind' < 10 { 
		use "$basesD\200`ind'_G.dta", clear
		gen anyo =200`ind'
	}
	else{
		use "$basesD\20`ind'_G.dta", clear
		gen anyo =20`ind'
	}

	gen primaria=1
	gen general = 1
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// S T U D E T S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//Edad promedio por año. Suponer menos de 6 como 5, 15 años y más como 15
	//Primero de primaria
	gen suma = 0
	local age = 5
	foreach var of varlist V47-V57{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_1 = suma/V58
	drop suma

	//Segundo de primaria
	gen suma = 0
	local age = 6
	foreach var of varlist V104-V113{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_6-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_2 = suma/V114
	drop suma

	//Tercero de primaria
	gen suma = 0
	local age = 7
	foreach var of varlist V156-V164{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_7-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_3 = suma/V165
	drop suma

	//Cuarto de primaria
	gen suma = 0
	local age = 8
	foreach var of varlist V203-V210{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 8
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_4 = suma/V211
	drop suma

	//Quinto de primaria
	gen suma = 0
	local age = 9
	foreach var of varlist V245-V251{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 9
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_5 = suma/V252
	drop suma

	//Sexto de primaria
	gen suma = 0
	local age = 10
	foreach var of varlist V282-V287{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 10
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_6 = suma/V288
	drop suma

	//Edad primaria
	gen suma = 0
	local age = 5
	foreach var of varlist V336-V346{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 5
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	rename V347 totalAlum
	gen meanAge_prim = suma/totalAlum
	drop suma

	//Class size 
	gen classSize_1 = V58/V59
	gen classSize_2 = V114/V115
	gen classSize_3 = V165/V166
	gen classSize_4 = V211/V212
	gen classSize_5 = V252/V253
	gen classSize_6 = V288/V289

	gen classSize_prim = (classSize_1 + classSize_2 + classSize_3 + classSize_4 + classSize_5 +classSize_6 )/6

	//Ratio mujeres-hombre (male/female)
	gen totalGirls =(V324+V335)
	gen totalBoys =(V301+V312)
	gen sexRatio_students = totalBoys/totalGirls

	//Ratio repetidores (repetidores/total)
	gen repeatersRatio = (V335+V312)/totalAlum

	//preschool attendance (1 year or more)
	rename V58 students1
	gen preschoolAttendance = V369/students1

	//average preschool years
	gen meanPreschoolYears = ((V351+V354)+2*(V357+V360)+3*(V363+V366))/students1
	gen meanPreschoolYears_girls = ((V350+V353)+2*(V356+V359)+3*(V362+V365))/ (V35 + V46)
	gen meanPreschoolYears_boys = ((V349+V352)+2*(V355+V358)+3*(V361+V364))/ (V12 + V23)

	//indigenous students
	gen indigenousStudents = V372/totalAlum
	gen indigenousStudents_girls = V371 /totalGirls
	gen indigenousStudents_boys = V370 /totalGirls

	//foreign students
	gen foreignStudents = V399/totalAlum
	gen foreignStudents_girls = V398 /totalGirls
	gen foreignStudents_boys = V397 /totalGirls

	gen foreignStudents_usa = V375/totalAlum
	gen foreignStudents_canada = V378/totalAlum
	gen foreignStudents_centralA = V381/totalAlum
	gen foreignStudents_southA = V384/totalAlum
	gen foreignStudents_africa = V387/totalAlum
	gen foreignStudents_asia = V390/totalAlum
	gen foreignStudents_europe = V393/totalAlum
	gen foreignStudents_oceania = V396/totalAlum


	//USAER students
	gen usaerStudents = V402/totalAlum
	gen usaerStudents_girls = V401 /totalGirls
	gen usaerStudents_boys = V400 /totalGirls


	//sudents with disabilities
	gen disabilitiesStudents = V429/totalAlum
	gen disabilitiesStudents_girls = V428 /totalGirls
	gen disabilitiesStudents_boys = V427 /totalGirls

	gen disabilitiesStudents_blindness = V405/totalAlum
	gen disabilitiesStudents_vision = V408/totalAlum
	gen disabilitiesStudents_deaf = V411/totalAlum
	gen disabilitiesStudents_hearing = V414/totalAlum
	gen disabilitiesStudents_mobility = V417/totalAlum
	gen disabilitiesStudents_intelectual = V420/totalAlum
	gen disabilitiesStudents_genius = V423/totalAlum

	//sudents with special needs
	gen specialStudents = V432/totalAlum
	gen specialStudents_girls = V431 /totalGirls
	gen specialStudents_boys = V430 /totalGirls


	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// T E A C H E R S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//Student teacher ratio (students / personal docente)
	gen totalTeachers=(V824+V825)
	gen studentTeacherRatio = totalAlum / totalTeachers
	gen sexRatio_teachers = V824/V825
	gen normalTeachers = ((V549+V550)+ (V581+V581)+ (V613+V614)+(V565+V566)+ ///
	(V597+V598)+ (V629+V630)+ (V645+V646))/ totalTeachers
	// Primaria incompleta = 3, secundaria incompleta = 7,maestria incompleta=17
	//  profesional tecnico 12, pasante =titulado
	gen meanSchoolYears_teachers = (3*(V437+V438) + 6*(V453+V454) ///
	+ 7*(V469+V470) + 9*(V485+V486) + 10*(V517+V518) +12*(V533+V534) ///
	+12*(V501+V502) + 14*( (V549+V550) + (V581+V581)+ (V613+V614))  ///
	+16*((V565+V566)+(V597+V598)+ (V629+V630)+ (V645+V646))  ///
	+14*(V661+V662)+16*((V677+V678)+(V693+V694)) ///
	+17*(V709+V710)+18*(V725+V726)+19*(V741+V742) + 22*(V757+V758))/totalTeachers

	gen graduateTeachers =  ((V565+V566)+(V597+V598)+ (V629+V630)+ ///
	(V645+V646)+(V677+V678)+(V693+V694)+(V709+V710)+(V725+V726)+(V741+V742) +(V757+V758))/ totalTeachers

	//personal directivo con grupo 
	gen directivesTeachers = (V820+V821)/((V820+V821)+(V822+V823))
	gen sexRatio_directives=(V820+V822)/(V821+V823)

	//DoceteEspecial
	gen sexRatio_PE=V826/V827
	gen sexRatio_art=V828/V829
	gen sexRatio_techno=V830/V831
	gen sexRatio_lang =V832/V833

	rename V836 totalStaff
	gen specialTeachers=((V826+V827)+(V828+V829)+(V830+V831)+(V832+V833))/totalStaff
	gen adminStaff = (V834+V835)/totalStaff


	gen studentStaffRatio = totalAlum /totalStaff
	gen studentTeacher_PE =  totalAlum /(V826+V827)
	gen studentTeacher_art =  totalAlum /(V828+V829)
	gen studentTeacher_techno =  totalAlum /(V830+V831)
	gen studentTeacher_lang =  totalAlum /(V832+V833)

	//horas que trabaja profesr
	rename V872 hoursPE
	rename V873 hoursArt
	rename V874 hoursTechno
	rename V875 hoursLang

	//Carrerea Magisterial
	gen carrMagisterial = V876/totalStaff
	gen nivelCarrMagis_1V =(1*V877+2*V878+3*V879+4*V880+5*V881+6*V882)/totalTeachers
	gen nivelCarrMagis =(1*(V877+V883+V889)+2*(V878+V884+V890)+ ///  
	3*(V879+V885+V891)+4*(V880+V886+V892)+5*(V881+V887+V893)+6*(V882+V888+V894))/V876

	//Aulas 
	gen classroomInUse  = V903/V895
	gen studentClassroom=totalAlum/V903
	gen adaptedClassrooms =V911/V903

	//Spendings
	gen schoolCost= V912+V913+V914
	gen privateTuition  = V915+V916*V917+V920*V921
	gen transportCost = V920*V921

	drop V*

	//Indigenas
	gen indigena = 0
	gen escuelaAlbergue = 0
	gen primIndigena =0

	gen mt_languageTeachers = 0
	gen mt_speakTeachers = 0
	gen mt_readTeachers = 0
	gen mt_writeTeachers = 0

	gen mt_speakStaff = 0
	gen mt_readStaff = 0
	gen mt_writeStaff = 0

	gen promoters = 0
	gen studentPromotersRatio =0


	//COMUNITATIO
	gen comunitario = 0
	gen cursosComunitarios = 0
	gen paepi =0
	gen paepiam = 0
	gen aulasCompartidas= 0

	save "$basesD\PRIMGI_`ind'.dta", replace 	 
}

* primarias indigenas 
foreach ind of numlist 6/13 { 

	if `ind' < 10 { 
		use "$basesD\200`ind'_I.dta", clear
		gen anyo =200`ind'
	}
	else{
		use "$basesD\20`ind'_I.dta", clear
		gen anyo =20`ind'
	}
	
	gen primaria=1
	gen indigena = 1
	gen escuelaAlbergue = V1=="X"
	gen primIndigena = V2=="X"

	gen general = 0
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// S T U D E N T S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//Edad promedio por año. Suponer menos de 6 como 5, 15 años y más como 15
	//Primero de primaria
	gen suma = 0
	local age = 5
	foreach var of varlist V50-V60{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_1 = suma/V61
	drop suma

	//Segundo de primaria
	gen suma = 0
	local age = 6
	foreach var of varlist V106-V115{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_6-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_2 = suma/V116
	drop suma

	//Tercero de primaria
	gen suma = 0
	local age = 7
	foreach var of varlist V157-V165{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_7-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_3 = suma/V166
	drop suma

	//Cuarto de primaria
	gen suma = 0
	local age = 8
	foreach var of varlist V203-V210{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 8
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_4 = suma/V211
	drop suma

	//Quinto de primaria
	gen suma = 0
	local age = 9
	foreach var of varlist V244-V250{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 9
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_5 = suma/V251
	drop suma

	//Sexto de primaria
	gen suma = 0
	local age = 10
	foreach var of varlist V280-V285{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 10
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_6 = suma/V286
	drop suma

	//Edad primaria
	gen suma = 0
	local age = 5
	foreach var of varlist V333-V343{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 5
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	rename V344 totalAlum
	gen meanAge_prim = suma/totalAlum
	drop suma

	//Class size 
	//Class size 
	gen classSize_1 = V61/V394
	gen classSize_2 = V116/V395
	gen classSize_3 = V166/V396
	gen classSize_4 = V211/V397
	gen classSize_5 = V251/V398
	gen classSize_6 = V286/V399

	gen classSize_prim = (classSize_1 + classSize_2 + classSize_3 + classSize_4 + classSize_5 +classSize_6 )/6


	//Ratio mujeres-hombre (male/female)
	gen totalGirls =(V321+V332)
	gen totalBoys =(V398+V309)
	gen sexRatio_students = totalBoys/totalGirls

	//Ratio repetidores (repetidores/total)
	gen repeatersRatio = (V332+V309)/totalAlum

	//preschool attendance (1 year or more)
	rename V61 students1
	gen preschoolAttendance = V393/students1

	//average preschool years
	gen meanPreschoolYears = ((V377+V380)+2*(V383+V386)+3*(V389+V392))/students1
	gen meanPreschoolYears_girls = ((V376+V379)+2*(V382+V385)+3*(V388+V391))/ (V38 + V49)
	gen meanPreschoolYears_boys = ((V375+V378)+2*(V381+V384)+3*(V387+V390))/ (V15 + V26)

	//indigenous students
	gen indigenousStudents = 1
	gen indigenousStudents_girls = 1
	gen indigenousStudents_boys = 1

	//foreign students
	gen foreignStudents =0
	gen foreignStudents_girls = 0
	gen foreignStudents_boys = 0

	gen foreignStudents_usa = 0
	gen foreignStudents_canada = 0
	gen foreignStudents_centralA = 0
	gen foreignStudents_southA = 0
	gen foreignStudents_africa = 0
	gen foreignStudents_asia = 0
	gen foreignStudents_europe = 0
	gen foreignStudents_oceania = 0


	//USAER students
	gen usaerStudents = 0
	gen usaerStudents_girls = 0
	gen usaerStudents_boys = 0


	//sudents with disabilities
	gen disabilitiesStudents = V371/totalAlum
	gen disabilitiesStudents_girls = V370 /totalGirls
	gen disabilitiesStudents_boys = V369 /totalGirls

	gen disabilitiesStudents_blindness = V347/totalAlum
	gen disabilitiesStudents_vision = V350/totalAlum
	gen disabilitiesStudents_deaf = V353/totalAlum
	gen disabilitiesStudents_hearing = V356/totalAlum
	gen disabilitiesStudents_mobility = V359/totalAlum
	gen disabilitiesStudents_intelectual = V362/totalAlum
	gen disabilitiesStudents_genius = V368/totalAlum

	//sudents with special needs
	gen specialStudents = V374/totalAlum
	gen specialStudents_girls = V373 /totalGirls
	gen specialStudents_boys = V372 /totalGirls


	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// T E A C H E R S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	gen totalTeachers = (V691+V692)
	gen mt_languageTeachers = (V411+V414+V417+V420 )/ (V691+V692)
	gen mt_speakTeachers = (V435)/totalTeachers
	gen mt_readTeachers = (V436)/totalTeachers
	gen mt_writeTeachers = (V437)/totalTeachers

	gen mt_speakStaff = (V435)/V697
	gen mt_readStaff = (V436)/V697
	gen mt_writeStaff = (V437)/V697

	//Student teacher ratio (students / personal docente)
	gen studentTeacherRatio = totalAlum / totalTeachers
	gen sexRatio_teachers = V691/V692

	//maestros de la normal
	gen suma = 0
	local offset = 518
	forvalues i = 1/7{
		local next = `offset'+1
		gen norm_`i' = V`offset' + V`next'
		local offset= `offset'+10
	}

	forvalues i = 1/7{
		replace suma =suma+norm_`i'
	}
	drop norm_*
	gen normalTeachers  = suma/totalTeachers
	drop suma

	//schoolYearsTeachers 
	gen suma = 0
	local offset = 448
	foreach i in 3 6 7 9 12 10 12 14 16 14 16 14 16 16 14 16 16 17 18 19 22{
		local next = `offset'+1
		gen est_`offset' = V`offset' + V`next'
		replace est_`offset' = est_`offset' *`i' 
		local offset= `offset'+10
		di `offset'
	}

	local offset = 448
	foreach var of varlist est_448-est_648{
		replace suma =suma+`var'
	}
	drop est_*
	gen meanSchoolYears_teachers  = suma/totalTeachers
	drop suma

	//graduateTeachers 
	gen suma = 0
	local offset = 528
	foreach i in 20 30 30 10 10 10 10 10{
		local next = `offset'+1
		gen est_`offset' = V`offset' + V`next'
		di `offset'
		local offset= `offset'+`i'
	}

	local offset = 528
	foreach var of varlist est_528-est_648{
		replace suma =suma+`var'
	}
	drop est_*
	gen graduateTeachers  = suma/totalTeachers
	drop suma

	//personal directivo con grupo 

	gen directivesTeachers = (V687+V688)/((V687+V688)+(V689+V690))
	gen sexRatio_directives=(V687+V689)/(V688+V690)

	//DoceteEspecial
	gen sexRatio_PE=0
	gen sexRatio_art=0
	gen sexRatio_techno=0
	gen sexRatio_lang =0

	rename V697 totalStaff
	gen specialTeachers=0
	gen adminStaff = (V695+V696)/totalStaff
	gen promoters= (V693+V694)/totalStaff

	gen studentStaffRatio = totalAlum /totalStaff
	gen studentPromotersRatio = totalAlum /(V693+V694)

	gen studentTeacher_PE =  0
	gen studentTeacher_art =  0
	gen studentTeacher_techno =  0
	gen studentTeacher_lang =  0

	//horas que trabaja profesr
	gen hoursPE=0
	gen hoursArt=0
	gen hoursTechno=0
	gen hoursLang=0

	//Carrerea Magisterial
	gen carrMagisterial = V698/totalStaff

	//nivelCarrMagis_1V
	gen suma = 0
	local i=1
	foreach var of varlist V699-V704{
		gen mag_`i' = `var' *`i'
		di `var'
		local i= `i'+1
	}

	forvalue i = 1/6{
		replace suma =suma+ mag_`i'
	}
	drop mag_*
	gen nivelCarrMagis_1V  = suma/totalTeachers
	drop suma


	//nivelCarrMagis
	local offset = 699
	local i=1
	forvalues i =1/6{
		local next_2 = `offset'+6
		local next_3 = `offset'+12
		gen mag_`i' = V`offset' + V`next_2' + V`next_3'
		replace mag_`i' = mag_`i'*`i'
		di `offset'
		local offset= `offset'+1
	}
	gen suma = 0
	forvalue i = 1/6{
		replace suma =suma+ mag_`i'
	}
	drop mag_*
	gen nivelCarrMagis  = suma/totalStaff
	drop suma


	//Aulas 
	gen classroomInUse  = V725/V717
	gen studentClassroom=totalAlum/V725
	gen adaptedClassrooms =V733/V725

	//Spendings
	gen schoolCost= 0
	gen privateTuition  = 0
	gen transportCost = 0

	drop V*


	//COMUNITATIO
	gen comunitario = 0
	gen cursosComunitarios = 0
	gen paepi =0
	gen paepiam = 0
	gen aulasCompartidas= 0

	save "$basesD\PRIMII_`ind'.dta", replace 
}

* primarias comunitarias	
foreach ind of numlist 6/13 { 
	if `ind' < 10 { 
		use "$basesD\200`ind'_C.dta", clear
		gen anyo =200`ind'
	}
	else{
		use "$basesD\20`ind'_C.dta", clear
		gen anyo =20`ind'
	}
	
	gen primaria=1
	gen comunitario = 1
	gen cursosComunitarios = V1=="X"
	gen paepi = V2=="X"
	gen paepiam = V3=="X"
	gen aulasCompartidas= V410=="X"

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// S T U D E N T S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//Edad promedio por año. Suponer menos de 6 como 5, 15 años y más como 15
	//Primero de primaria (primer nivel, primer ciclo)
	gen suma = 0
	local age = 5
	local inicial = 28
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_1 = suma/V`total_a'
	drop suma

	//Segundo de primaria
	gen suma = 0
	local age = 5
	local inicial = 64
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_2 = suma/V`total_a'
	drop suma

	//Tercero de primaria
	gen suma = 0
	local age = 5
	local inicial = 136
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_3 = suma/V`total_a'
	drop suma

	//Cuarto de primaria
	gen suma = 0
	local age = 5
	local inicial = 172
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_4 = suma/V`total_a'
	drop suma

	//Quinto de primaria
	gen suma = 0
	local age = 5
	local inicial =244
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_5 = suma/V`total_a'
	drop suma

	//Sexto de primaria
	gen suma = 0
	local age = 5
	local inicial =280
	local final = `inicial'+10
	local total_a = `final'+1
	foreach var of varlist V`inicial'-V`final'{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	foreach var of varlist prim_5-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	gen meanAge_6 = suma/V`total_a'
	drop suma

	//Edad primaria
	gen suma = 0
	local age = 5
	foreach var of varlist V352-V362{
		gen prim_`age' = `var'*`age'
		local age = `age'+1
	}
	local age = 5
	foreach var of varlist prim_`age'-prim_15{
		replace suma =suma+`var'
	}
	drop prim_*
	rename V363 totalAlum
	gen meanAge_prim = suma/totalAlum
	drop suma

	//Class size 
	//gen classSize_1 
	local offset = 39
	local cte = 36

	local next = `offset' +`cte'
	local nextnext = `next' +`cte'
	gen classSize_1  = V`offset'+V`next'+V`next'
	gen classSize_2 =  classSize_1 if NIVEL2 ==1

	//gen classSize_3 
	local offset = 147
	local cte = 36
	local next = `offset' +`cte'
	local nextnext = `next' +`cte'
	gen classSize_3  = V`offset'+V`next'+V`next'
	gen classSize_4 =  classSize_3  if NIVEL4 ==1

	//gen classSize_5 
	local offset = 255
	local cte = 36
	local next = `offset' +`cte'
	local nextnext = `next' +`cte'
	gen classSize_5  = V`offset'+V`next'+V`next'
	gen classSize_6 =  classSize_5 if  NIVEL6 ==1

	gen classSize_prim = (classSize_1 + classSize_2 + classSize_3 + classSize_4 + classSize_5 +classSize_6 )/6


	//Ratio mujeres-hombre (male/female)
	gen totalGirls =V351
	gen totalBoys =V339
	gen sexRatio_students = totalBoys/totalGirls

	//Ratio repetidores (repetidores/total)
	gen repeatersRatio = (V111+V219+V327)/totalAlum

	//preschool attendance (1 year or more)
	gen students1= classSize_1 
	gen preschoolAttendance = V375/students1

	//average preschool years
	gen meanPreschoolYears = ((V366)+2*(V368)+3*(V372))/students1
	gen meanPreschoolYears_girls = ((V365)+2*(V368)+3*(V371))/ (V27+V63+V99)
	gen meanPreschoolYears_boys = ((V364)+2*(V367)+3*(V370))/ (V15+V51+V87)

	//indigenous students
	gen indigenousStudents = paepi==1
	gen indigenousStudents_girls = paepi==1
	gen indigenousStudents_boys =paepi==1

	//foreign students
	gen foreignStudents =0
	gen foreignStudents_girls = 0
	gen foreignStudents_boys = 0

	gen foreignStudents_usa = 0
	gen foreignStudents_canada = 0
	gen foreignStudents_centralA = paepiam==1
	gen foreignStudents_southA = 0
	gen foreignStudents_africa = 0
	gen foreignStudents_asia = 0
	gen foreignStudents_europe = 0
	gen foreignStudents_oceania = 0


	//USAER students
	gen usaerStudents = 0
	gen usaerStudents_girls = 0
	gen usaerStudents_boys = 0


	//sudents with disabilities
	gen disabilitiesStudents = V402/totalAlum
	gen disabilitiesStudents_girls = V401 /totalGirls
	gen disabilitiesStudents_boys = V400 /totalGirls

	gen disabilitiesStudents_blindness = V378/totalAlum
	gen disabilitiesStudents_vision = V381/totalAlum
	gen disabilitiesStudents_deaf = V384/totalAlum
	gen disabilitiesStudents_hearing = V387/totalAlum
	gen disabilitiesStudents_mobility = V390/totalAlum
	gen disabilitiesStudents_intelectual = V393/totalAlum
	gen disabilitiesStudents_genius = V396/totalAlum

	//sudents with special needs
	gen specialStudents = V405/totalAlum
	gen specialStudents_girls = V404 /totalGirls
	gen specialStudents_boys = V403 /totalGirls

	rename V408 totalTeachers 

	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	// T E A C H E R S
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//Student teacher ratio (students / personal docente)
	gen studentTeacherRatio = totalAlum / totalTeachers
	gen sexRatio_teachers = V406/V407

	gen normalTeachers  = .
	gen meanSchoolYears_teachers  = 12.146 //la jornada
	gen graduateTeachers  = 0.05 //la jornada

	//personal directivo con grupo 
	gen directivesTeachers = 0
	gen sexRatio_directives=.

	//DoceteEspecial
	gen sexRatio_PE=0
	gen sexRatio_art=0
	gen sexRatio_techno=0
	gen sexRatio_lang =0

	gen totalStaff = totalTeachers
	gen specialTeachers=0
	gen adminStaff = 0
	gen promoters= 0

	gen studentStaffRatio = 0
	gen studentPromotersRatio = 0

	gen studentTeacher_PE =  0
	gen studentTeacher_art =  0
	gen studentTeacher_techno =  0
	gen studentTeacher_lang =  0

	//horas que trabaja profesr
	gen hoursPE=0
	gen hoursArt=0
	gen hoursTechno=0
	gen hoursLang=0

	//Carrerea Magisterial
	gen carrMagisterial =0

	//nivelCarrMagis_1V
	gen nivelCarrMagis_1V  =0
	gen nivelCarrMagis  = 0


	//Aulas 
	gen classroomInUse  = NIVEL1+NIVEL2+NIVEL3+NIVEL4+NIVEL5+NIVEL6
	gen studentClassroom=totalAlum/classroomInUse
	gen adaptedClassrooms =0

	//Spendings
	gen schoolCost= 0
	gen privateTuition  = 0


	//Indigenas
	gen indigena = 0
	gen escuelaAlbergue = 0
	gen primIndigena =0

	gen mt_languageTeachers = 0
	gen mt_speakTeachers = 0
	gen mt_readTeachers = 0
	gen mt_writeTeachers = 0

	gen mt_speakStaff = 0
	gen mt_readStaff = 0
	gen mt_writeStaff = 0

	//generales
	gen general = 0
	gen transportCost = 0

	drop NIVEL*
	drop V*

	save "$basesD\PRIMCI_`ind'.dta", replace 
	
}
	
***** append de los tres diferentes tipos de primarias
use "$basesD\PRIMGI_6.dta",clear
append using "$basesD\PRIMCI_6.dta",force
append using "$basesD\PRIMII_6.dta",force

foreach i of numlist 7/13 { 	
	append using  "$basesD\PRIMGI_`i'.dta",force
	append using  "$basesD\PRIMCI_`i'.dta",force
	append using  "$basesD\PRIMII_`i'.dta",force
}

gen privada = substr(CLAVECCT,3,1)=="P"
save "$basesA\panel911_extendido3.dta",replace	

destring TURNO,replace
destring RENGLON,replace
destring SERVICIO,replace
destring SOSTENIMIE,replace

drop ESCUELA
keep CLAVECCT TURNO SERVICIO SOSTENIMIE RENGLON students1- privada
rename CLAVECCT cct
duplicates drop  cct anyo,force
save "$basesA\panel911_extendidoLimpio.dta",replace	
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

//===========================================
//  Panel Long
//===========================================

use "$basesA\panel_fuzzy.dta",clear
keep if grado < 7
collapse p_mat_std p_esp_std , by(cct anyo)
merge 1:1 cct anyo using "$basesA\panel911_extendidoLimpio.dta"
keep if _merge == 3
drop _merge
save "$basesA\panel911_long.dta",replace	

