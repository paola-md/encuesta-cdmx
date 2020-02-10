//=====================================================================
* Main Do File
* Runs all the other do files
//=====================================================================


clear all

gl dofile = "D:\Educacion\entrega BM\do files"
*gl dir= "D:\Dropbox\CIE\pop\entrega BM\do files"

//*********************************************************************
*cleans the original data bases generates a master data base per year
*containing each student and their school, schoolyear and grades.
//********************************************************************
do "$dofile\masterdb.do"

do "$dofile\Standardize.do"


//*********************************************************************
* creates panel with 18-digitcurp match (panel_exacto18) and fuzzy panel
* that removes special characters from curp and matches the first 16 digist
//********************************************************************

do "$dofile\panel.do" 


//*********************************************************************
* Analysis and graphs
//********************************************************************
do "$dofile\DBQualityMatches.do" // genera figura 1

do "$dofile\seguimiento.do" // genera figura 2 y 3 

do "$dofile\asistencia.do" // genera tabla 6 y 7

do "$do\asistenciaPorEscuela.do" //genera figura 4 y 5: Variación de resultados entre años consecutivos

do "$do\porcentajeCambiosResultados.do" // genera figura 6 y 7: Variación de resultados entre años consecutivos

do "$do\regresion.do" // genera tabla 8

do "$do\escuelas cierran.do" //genera tabla 9 y 12

do "$do\abren cierran pri.do" // genera tabla 10, 11, 13 y 14

