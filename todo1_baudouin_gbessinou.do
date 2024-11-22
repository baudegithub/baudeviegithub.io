/*
QDA24 __ TODO1

Names: Baudouin Gbessinou


Note: Label all the variables that you will use accordingly
*/

*Let's load the data set
 use "C:\Users\HP\Desktop\QDA_course\afro_r7_todo1.dta", clear
 
 des /* This command gives a descrition of the data set*/
 
* A little bit of data cleaning

isid RESPNO /* the repondent number5RESPNO) uniquelly 	and fully indentifies the data */

encode RESPNO , gen( RESPNO_num)/*we encode the repondent number variable*/

duplicates drop /* Let's check for duplicated observation in the data set*/
des 
 /* Let's label the variables trust , age , corruption, living area, sex,access to social media 
  in the data set
 
 */
 
 // Define locals for variable names and labels
local varlist "Q114 Q1 Q43A Q44A"
local labellist "respondent's sex respondent's age Trust in the government corruption in the government's office"

// Split the locals into lists
local i = 1
foreach var of local varlist {
    local label : word `i' of `labellist'
    label variable `var' "`label'"
    local ++i
}

 codebook Q1 Q44A Q43A Q114
 
 
 
// Number of respondent by country
 
collapse (count) RESPNO_num ,by(COUNTRY)

* There are 1200 respondents in Benin, Burina faso , Mali ; Niger and Togo
*There are 2400 respondents in Ghana and 1600 respondents in Nigeria


// Number of women repondent by country
* The variable Q114 represents the resondent's gender
collapse (count) RESPNO_num  ,by(COUNTRY Q114) 

/* There are 666 female respondents in Benin 
There  are 701 female respondents in Burkina faso 
There are 1106 female respondents in Ghana 
There are 600 female respondents in  Mali
There are 536 female respondents in Niger 
There are 850 female respondents in Nigeria
*/


// Average age of respondent



// Generate a variable = average age per country

* In the data Q1 stands for the age of the respondents

collapse egen average_age_per_country= mean(Q1) ,by(COUNTRY)  

// Average age of respondent by country

collapse (mean) Q1 ,by(COUNTRY)  

/*The average age of respondents in Benin, Burkina faso and Togo is 37
The average age of repondents in Mali and Niger is 39
The average age of respondents in Ghana is 38 and it's 33 i Nigeria*/

// Rescale different ways the variables that measure: Trust, Corruption
// Let's rescale the variables that measure trust and corruption in the data set

tabulate Q43A
recode Q43A ( 0=3) (1=4) (2=5) ( 3=6) (8=-1) (9=-5) ,generate(trust_rescaled)
tabulate trust_rescale





*The variables measuring trust and corruption are Q43 and Q44 respectively in the data set


/* Test for (1) ALL COUNTRIES, (2) NIGERIA, (3) BENIN, (4) TOGO and 
	(5) GHANA, the relationship between: 
*/
cor( Q1

//	Area of living and the Sex of the repondent

	*NIGERIA
	
collapse (mean)  ,by(COUNTRY) 
	*BENIN
	

	*TOGO
	

	*GHANA
	

	*NIGERIA & BENIN & TOGO & GHANA

	

//	Area of living and the Use of social medias


	*NIGERIA
	

	*BENIN
	

	*TOGO
	

	*GHANA
	

	*NIGERIA & BENIN & TOGO & GHANA

	

///	Sex and the Use of social medias
 
 by COUNTRY : tabulate Q43A Q44A
 by COUNTRY : cor Q43A Q44A
 

collapse (count) RESPNO_num , by( COUNTRY Q12E Q114)

	*NIGERIA
	

	*BENIN
	

	*TOGO
	

	*GHANA
	

	*NIGERIA & BENIN & TOGO & GHANA

	


//	Trust in president and Corruption in the office of the president

collapse (count) RESPNO_num , by( COUNTRY Q43A Q44A)
	*NIGERIA
	

	*BENIN
	

	*TOGO
	

	*GHANA
	

	*NIGERIA & BENIN & TOGO & GHANA

	











