clear all
set more off
gl dir = "D:\Educacion\entrega BM"
*gl dir= "D:\Dropbox\CIE\pop\entrega BM"
gl dir2="$dir\source"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl basesD = "$dir\bases auxiliares\deleteMyFiles"

foreach lev in B{
	foreach anyo1 in  06 07 08 09 10 11 12 13 14 15 16 {
		capture confirm file "$basesO\`lev'`anyo1'.dta"
		if _rc==0 {
			use "$basesO\`lev'`anyo1'.dta"

			replace p_mat=. if p_mat<50
			replace p_esp=. if p_esp<50

			foreach vari in medmat sdmat medesp sdesp p_mat_std p_esp_std p_mat_perc p_esp_perc{
				cap drop `vari'
			}
			bysort grado: egen medmat=mean(p_mat)
			bysort grado: egen sdmat=sd(p_mat)
			bysort grado: egen medesp=mean(p_esp)
			bysort grado: egen sdesp=sd(p_esp)
			gen p_mat_std=(p_mat-medmat)/sdmat
			gen p_esp_std=(p_esp-medesp)/sdesp
			levels grado, local(grados)
			gen p_mat_perc=.
			gen p_esp_perc=.

			foreach grad in `grados'{
				foreach vari in p_mat p_esp{
					gen aux1=`vari' if grado==`grad'
					xtile aux2=aux1, nq(100)
					replace `vari'_perc=aux2 if grado==`grad'
					drop aux1 aux2
				}
			}

			drop medmat sdmat medesp sdesp
			save "$basesO\`lev'`anyo1'.dta", replace

		}
	}

}
