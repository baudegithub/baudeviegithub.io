


**----
clear all 
set more off

cd "C:/Users/HP/palu_project/Nouveau dossier/data"
log using log_file.txt , text replace 
**------
 use "donnees.data" , clear 
 **-----
 des 
 **-------
 tab Country 
 
 tab Years 
 
 *--------
 label variable Palu " paludisme"
 label  variable Temp " temperature"
 label  variable Prec " precipitation"
 label variable PIBh " le PIB du pays"
 
 **--------

 global $ylist Palu 
  global $xlist Temp PIBh Prec    
  
 **------
 sum $list $xlist 
 bysort Country :sum $ylist $xlist
 *-----
 bysort Years :sum $xlist $ylist  
 
 
*---------
  kdensity Palu  if Country=="Benin"
  

  
*-------
sort Country 
xi , prefix(), i.Country
*------------
****------
correl $ylist $xlist


graph  twoway (scatter Palu Temp )( lfit Palu Temp)
graph twoway ( scatter Palu Prec )(lfit Palu Prec)
graph twoway ( scatter Palu PIBh)(lfit Palu PIBh)

***-----

***-----
reg Palu Temp, robust 
reg Palu PIBh ,  robust 
reg Palu Prec, robust 
*-------------
ttest Temp==0
ttest Prec==0
ttest PIBh==0
ttest Temp==Prec
 *--------
reg $ylist $xlist , robust 

*-----------------
xi: reg $ylist $xlist i.Country


log  close 
