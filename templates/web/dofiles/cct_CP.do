clear all
set more off
gl dir = "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\temp"
gl basesS = "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\temp\stata"

cd "C:\Users\pmeji\Dropbox\CIE\ProyectoENLACE\Mapas\Build\temp\stata"

import delimited "$dir\cct_dir_0_10000.csv", encoding(UTF-8) 
save "cct_1.dta", replace 

clear all
import delimited "$dir\cct_dir_10000_19456.csv", encoding(UTF-8) 
save "cct_2.dta", replace 

clear all
import delimited "$dir\cct_dir_19456_30000.csv", encoding(UTF-8) 
save "cct_3.dta", replace 

clear all
import delimited "$dir\cct_dir_30000_40000.csv", encoding(UTF-8) 
save "cct_4.dta", replace 

clear all
import delimited "$dir\cct_dir_40000_48895.csv", encoding(UTF-8) 
save "cct_5.dta", replace 

clear all
import delimited "$dir\cct_dir_48895_70000.csv", encoding(UTF-8) 
save "cct_6.dta", replace 

clear all
import delimited "$dir\cct_dir_70000_75748.csv", encoding(UTF-8) 
save "cct_7.dta", replace 

clear all
import delimited "$dir\cct_dir_75748_77700.csv", encoding(UTF-8) 
save "cct_8.dta", replace 

clear all
import delimited "$dir\cct_dir_77700_81259.csv", encoding(UTF-8) 
save "cct_9.dta", replace 

clear all
import delimited "$dir\cct_dir_86876_100000.csv", encoding(UTF-8) 
save "cct_10.dta", replace 

clear all
import delimited "$dir\cct_dir_100000_106148.csv", encoding(UTF-8) 
save "cct_11.dta", replace 

clear all
import delimited "$dir\cct_dir_106148_109310.csv", encoding(UTF-8) 
save "cct_12.dta", replace 

clear all
import delimited "$dir\cct_dir_109310_113070.csv", encoding(UTF-8) 
save "cct_13.dta", replace

//Faltan todos los intermedios. 
clear all
import delimited "$dir\cct_dir_113070_141833.csv", encoding(UTF-8) 
save "cct_14.dta", replace

clear all
import delimited "$dir\cct_dir_141833_153807.csv", encoding(UTF-8) 
save "cct_15.dta", replace

clear all
import delimited "$dir\cct_dir_153807_172083.csv", encoding(UTF-8) 
save "cct_16.dta", replace

clear all
import delimited "$dir\cct_dir_153807_172083.csv", encoding(UTF-8) 
save "cct_16.dta", replace

clear all
import delimited "$dir\cct_dir_172083_200000.csv", encoding(UTF-8) 
save "cct_17.dta", replace

clear all
import delimited "$dir\cct_dir_209003_210264.csv", encoding(UTF-8) 
save "cct_18.dta", replace

clear all
import delimited "$dir\cct_dir_210264_212038.csv", encoding(UTF-8) 
save "cct_19.dta", replace

clear all
import delimited "$dir\cct_dir_212038_223895.csv", encoding(UTF-8) 
save "cct_20.dta", replace

clear all
import delimited "$dir\cct_dir_223895_242051.csv", encoding(UTF-8) 
save "cct_21.dta", replace

clear all
import delimited "$dir\cct_dir_242051_270000.csv", encoding(UTF-8) 
save "cct_22.dta", replace

clear all
import delimited "$dir\cct_dir_270000_281800.csv", encoding(UTF-8) 
save "cct_23.dta", replace

clear all
import delimited "$dir\cct_dir_281800_283776.csv", encoding(UTF-8) 
save "cct_24.dta", replace

clear all
import delimited "$dir\cct_dir_283776_297273.csv", encoding(UTF-8) 
save "cct_25.dta", replace

clear all
import delimited "$dir\cct_dir_283776_297273.csv", encoding(UTF-8) 
save "cct_26.dta", replace

clear all
import delimited "$dir\cct_dir_297273_309293.csv", encoding(UTF-8) 
save "cct_27.dta", replace

clear all
import delimited "$dir\cct_dir_309293_350000.csv", encoding(UTF-8) 
save "cct_28.dta", replace

clear all
import delimited "$dir\cct_dir_350000_372846.csv", encoding(UTF-8) 
save "cct_29.dta", replace


clear all
import delimited "$dir\cct_dir_372846_395286.csv", encoding(UTF-8) 
save "cct_30.dta", replace

clear all
import delimited "$dir\cct_dir_395286_400000.csv", encoding(UTF-8) 
save "cct_31.dta", replace


clear all
import delimited "$dir\cct_dir_400000_422771.csv", encoding(UTF-8) 
save "cct_32.dta", replace


clear all
import delimited "$dir\cct_dir_422771_434597.csv", encoding(UTF-8) 
save "cct_33.dta", replace

clear all
import delimited "$dir\cct_dir_434597_444832.csv", encoding(UTF-8) 
save "cct_34.dta", replace

clear all
import delimited "$dir\cct_dir_444832_450000.csv", encoding(UTF-8) 
save "cct_35.dta", replace


clear all
import delimited "$dir\cct_dir_450000_462129.csv", encoding(UTF-8) 
save "cct_36.dta", replace

clear all
import delimited "$dir\cct_dir_462129_472115.csv", encoding(UTF-8) 
save "cct_37.dta", replace

clear all
import delimited "$dir\cct_dir_472115_472367.csv", encoding(UTF-8) 
save "cct_38.dta", replace

clear all
forvalues i = 1/38 {
	capture confirm file "$basesS/cct_`i'.dta"
	 if _rc==0 {
		append using "$basesS/cct_`i'.dta", force 
	}
}

save "cct_C.dta", replace

keep city district postalcode cct 

save "cct_C_min.dta", replace
