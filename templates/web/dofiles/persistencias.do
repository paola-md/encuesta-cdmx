clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"
gl basesR = "$dir\resultados"

use "$basesD\panel_fuzzy"

gen auxi=_n
bysort cct: egen cct2=min(auxi)
bysort curp: egen curp2=min(auxi)

gen p_mat_std3=p_mat_std if grado==3
gen p_esp_std3=p_esp_std if grado==3
gen p_mat_std6=p_mat_std if grado==6
gen p_esp_std6=p_mat_std if grado==6

bysort curp2: egen  p_mat_std3ro=max( p_mat_std3)
bysort curp2: egen  p_esp_std3ro=max( p_esp_std3)
bysort curp2: egen  p_mat_std6to=max( p_mat_std6)
bysort curp2: egen  p_esp_std6to=max( p_esp_std6)

gen cct6=cct2 if grado==6
bysort curp2: egen cct6to=max(cct6)
gen cct4=cct2 if grado==4
bysort curp2: egen cct4to=max(cct4)

eststo clear
cap drop avg_3ro
gen avg_3ro=.
label var avg_3ro "Performance in 3rd grade"


foreach mate in mat esp{
local suj="Spanish"
if "`mate'"=="mat"{
local suj="math"
}

replace avg_3ro=p_`mate'_std3ro
label var p_`mate'_std6to "Performance in 6th grade (`suj')"

eststo: reg p_`mate'_std6to avg_3ro if grado==3  
estadd scalar r3=e(r2)
sum  p_`mate'_std6to   if e(sample)
estadd scalar DepMean=r(mean)


}

esttab using "$dir\resultados\Persistence.tex", star(* 0.1 ** 0.05 *** 0.01) /*
*/ scalars("r3 R-sq" "DepMean Dependent Var Mean"  ) /*
*/ se nogaps replace label


