clear all
set more off
gl dir = "D:\Educacion\entrega BM"
gl basesA= "$dir\bases auxiliares"
gl basesO= "$dir\bases originales\"
gl dir2="$basesO"
gl basesD = "$dir\bases auxiliares\deleteMyFiles\"


if 0==0{
	foreach lev in M B{
		foreach anyo1 in  06 07 08 09 10 11 12 13 14 15 16 {
			capture confirm file "$dir2\`lev'`anyo1'.dta"
			if _rc==0 {
				use "$dir2\`lev'`anyo1'.dta", clear
				keep if substr(curp, 1, 1)=="G"
				gen curp16=substr(curp, 1, 16)
				bysort curp: drop if _n>1
				*drop if strlen(curp)<16
				save "$basesD\`lev'`anyo1'_matchable.dta", replace
			}
		}

	}
}

cap postclose chances
postfile chances anyo1 anyo2 count matches purity str3 level1 str3 level2  using "$basesA\matches.dta", replace

foreach anyo1 in  07 08 09 10 11 12 13 14 15 16{
		foreach lev in B M{
		capture confirm file "$basesD\`lev'`anyo1'_matchable.dta"
		if _rc==0 {
		 
			post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("M")
			post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("M")
			post chances (`anyo1') (`anyo1') (1) (1) (2) ("`lev'")  ("B")
			post chances (`anyo1') (`anyo1') (1) (1) (1) ("`lev'")  ("B")


			foreach anyo2 in 06 07 08 09 10 11 12 13 14 15 16{
				if `anyo2'<`anyo1'{
					use "$basesD\`lev'`anyo1'_matchable.dta", clear
					count
					local count=`r(N)'
					if `count'>0{
					capture confirm file "$basesD\B`anyo2'_matchable.dta"
					 if _rc==0 {
						gen grado2=grado-(`anyo1'-`anyo2')
						rename apellido_nombre apellido_nombre_master
						merge 1:1 curp using "$basesD\B`anyo2'_matchable.dta"
						bysort anyo grado: gen bueno=(_N>15000)
						replace bueno=0 if anyo!=2000+`anyo2'
						replace grado2=grado if missing(grado2)
						bysort grado2: egen bueno2=max(bueno)
						keep if anyo==2000+`anyo2' | bueno2==1
						count if anyo==2000+`anyo1'
						*dsfdsfd
						local count=r(N)
						if r(N)>100{
							count if _m==3
							local matches=`r(N)'
							post chances (`anyo1') (`anyo2') (`count') (`matches') (1) ("`lev'") ("B")
							drop if _m==3
							bysort curp16 anyo: drop if _N>1
							bysort curp16: gen match=_N==2
							count if match==1 & anyo==2000+`anyo1'
							local matches=`r(N)'+`matches'
							post chances (`anyo1') (`anyo2') (`count') (`matches') (2) ("`lev'") ("B")
						}

						}

					}

				}

			}

		}

	}

}

postclose chances

use "$basesA\matches.dta", clear
gen porc = matches/count
replace anyo1=2000+anyo1
replace anyo2=2000+anyo2
levels anyo1, local(levels)
bysort anyo1 anyo2 level2: gen aux1=_N
bysort anyo1 anyo2 : gen aux2=_N
gen aux3=(aux1==aux2)

foreach puri in 1 2{
	local bosc=0
	local med=0
	local tit="Match for exact curp (18 digits)"
	if `puri'==2{
		local tit="Match for exact curp (16 digits for unfound with 18 digits)"
	}
	 
	local twoway
	local labelsin
	local num=1
	foreach anyo in `levels'{
		foreach niv1 in B M{
			count if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo'
				if r(N)>1{
				local r1 =round(uniform()*255)
				local r2 =round(uniform()*255)
				local r3 =round(uniform()*255)
				if "`niv1'"=="B" & `bosc'==0{
					local labelsin `labelsin' `num' "Elementary and middle school"
					local bosc=1
				}
				if "`niv1'"=="M" & `med'==0{
					local labelsin `labelsin' `num' "High school"
					local med=1
				}
				local color="62 150 81"
				if "`niv1'"=="B"{
					local color="218 124 41"
				}
				local twoway `twoway' (line porc anyo2 if purity==`puri' & level1=="`niv1'" & (level2=="B" | aux3==1) & anyo1==`anyo' & porc>0.2, legend(order(`labelsin')) lcolor("`color'") ytitle("Match (%)") xtitle("Year") title("`tit'") ylabel(0(0.2)1) ytick(0(0.1)1) lwidth(0.5) graphregion(color(white)) )
				local num=`num'+1
			}
		}
	}

	twoway `twoway' 
	graph export  "$dir\resultados\matches_`puri'.pdf", replace
}

