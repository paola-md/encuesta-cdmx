
import excel "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\source\cpv_2010_00_xlsx\indicadores_00.xlsx", sheet("Valor") firstrow clear

//Por EDO. De 5-9, 10-14. 5-14
keep if id_indicador == 1002000088 |  id_indicador == 1002000061

//Por EDO. De 5-9, 10-14. 5-14
keep if id_indicador == 1002000001

//Poblacion total por municipio
keep entidad municipio H

export excel using "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\source\pob.xls", firstrow(variables) replace


//Por municipio
keep if id_indicador == 1005000012

gen menor = 0 if municipio < 10 
gen menor2 = 0 if municipio < 100

tostring municipio, replace
tostring menor, replace 
tostring entidad, replace

drop c_mun
gen c_mun = menor + municipio if menor == "0"
replace c_mun = municipio if menor == "."
replace c_mun = entidad + c_mun

//Unique values
duplicates tag c_mun, generate(tag)

save "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\CP\munPob.dta", replace

destring municipio, replace
rename municipio c_mnpio

destring entidad, replace
rename entidad c_estado

keep c_estado c_mnpio H
save "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\CP\munPobm.dta", replace
