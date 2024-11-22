/////*DRC INFORMAL TAX PROJECT*//////

//*Load data
*cd "C:\Users\G\Dropbox\Post Doc\6. ICTD\DRC informal tax and statebuilding\4. Data\3_2018 survey_data\3_Data"

use "${clean_data}", clear

//*Clean variables

** Section 3: Methods and research design
*** Demographics 
*>> need to clean tribe [can leave tribe for now]

** Create summary stats table of respondents:
*	Location
tab locale, mi
tab locale, mi nol

label define local_define 0 "Urban" 1 "Rural" -99 "Don't know", modify // To be reviewed


recode locale (-99 = .d) (0 = 0) (1 = 1), gen(locale_new)
*label list
label define locale_new 0 "Urban" 1 "Rural" .d "Don't know" 
label values locale_new locale_new

tab locale, mi // We may look at the towns and confirm with people from DRC whether they were urban or rural
tab locale, mi nol

tab locale_new, mi // We may look at the towns and confirm with people from DRC whether they were urban or rural
tab locale_new, mi nol


*** Province

tab province, mi
encode province, gen(province_new)



*estpost summary locale religion province_new
*esttab, cell(colpct(fmt(2))) unstack noobs modelwidth(15) ///
*varlabels(`e(labels)') eqlabels(`e(eqlabels)')



*tabout locale religion using demographics_stats.rtf, ///
*c(mean price mean mpg) f(2) layout(rtf) replace

*tabout locale religion province using "${tables}/demographics_stats.rtf", replace ///
* font(italic) c(col row) h3(nil) ///
*f(1) npos(both) nlab(Obs) layout(cb)

*estpost summarize age
*esttab using "${tables}/demographics_stats.rtf", replace title(Summary Statistics) ///
*cells("mean sd min max p50 n") label

*estpost tabstat age if treatment_status == 0, c(stat) stat(mean sd p50 n)

*est store village0

*	esttab using  "${tables}/control_stats_vea_steps.rtf", replace /// 
*	refcat(vea_step4_complete_endl "\emph{Village}", nolabel) /// 
*	cells("mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) p50(fmt(%13.2fc)) count(fmt(%12.0f))") /// 
*	nonumb noobs label booktabs nomtitle compress nonote ///
*	collabels("Mean" "SD" "Median" "N")  ///
*	title("{\cf Control group descriptive statistics on VEA steps completion} \line \cf")

*	Tribe
tab tribu, mi // Very long list of tribes. Reach out to DRC team to figure out how they can be group and streamlined

*	Religion
tab religion, mi

encode religion, gen(religion_new)

tab religion_new, mi
tab religion_new, mi nol

recode religion_new (2 = 0) (1 = 1) (3 = 2) (4 = 3) (5 = 4) (6 = 5) (7 = 6) (8 = 7) (9 = 8)

label define religion_new  0 "None" 1 "Anglican" 2 "Catholic" 3 "Kimbanguist" 4 "Methodist" 5 "Muslim" 6 "Protestant" 7 "Jehovah Witness" 8 "Other", modify
tab1 religion religion_new, mi


*	Age
tab age, mi
tab age, mi nol

label define age_define -88 "Refused", modify

*	Education level
tab1 education education_autre, mi // look at other education later

label var education "Education level"


** To be looked into
*Breveté  à  l'école normale
*Doctorat
*Sciences infirmierea2
*École normale

**To be turned into missing
*Chauffeur
*Femme de menage
*Secrétaire de direction

*	Migrant status (Q25 “were you born in this chiefdom/ sector/ village/ city”)
tab1 naissance, mi
label var naissance "Birth (Migrant Status)"
*tab1 chefferie chiefferie_other village, mi 

*	Type of work of HoH Q42
tab1 travail travail_autre, mi

gen travail_new = travail

replace travail_new = "12" if travail_new == "business"
replace travail_new = "13" if travail_new == "prive"
replace travail_new = "14" if travail_new == "prive_informel"
replace travail_new = "15" if travail_new == "public"
replace travail_new = "16" if travail_new == "public_informel"
replace travail_new = "17" if travail_new == "chefferie"
replace travail_new = "18" if travail_new == "chefferie_informelle"
replace travail_new = "-66" if travail_new == "autre"

tab travail_new, mi
destring travail_new, replace
tab travail_new, mi

label define travail 1 "Own farming (e.g., agriculture, livestock, fishing)" 2 "Temporary work (agricultural, livestock, fishing, non-agricultural)" 3 "Artisanal exploitation" 4 "Hunting" 5 "Housekeeping work and/or childcare" 6 "Product sales (e.g., agricultural products, small trade)" 7 "Remittances (external aid)" 8 "Retired" 9 "Student/pupil" 10 "Unemployed but looking for job" 11 "Unemployed and not looking for job" 12 "Own business" 13 "Paid employee/salaried in the private sector" 14 "Informal employee in the private sector" 15 "Paid employee/salaried in the public sector" 16 "Informal employee in the public sector" 17 "Employee of the chieftaincy administration" 18 "Informal employee of the chieftaincy administration" -66 "Other" -88 "Refused"


label values travail_new travail

tab travail_new, mi
tab travail, mi

label var travail "Work of HH Head"
label var travail_new "Work of HH Head"



*	Most important source of income for HH
tab1 travail_principal 
*travail_principal_autre business_principal business_principal_autre, mi

gen travail_principal_new = travail_principal

replace travail_principal_new = "12" if travail_principal_new == "business"
replace travail_principal_new = "13" if travail_principal_new == "prive"
replace travail_principal_new = "14" if travail_principal_new == "prive_informel"
replace travail_principal_new = "15" if travail_principal_new == "public"
replace travail_principal_new = "16" if travail_principal_new == "public_informel"
replace travail_principal_new = "17" if travail_principal_new == "chefferie"
replace travail_principal_new = "18" if travail_principal_new == "chefferie_informelle"
replace travail_principal_new = "-66" if travail_principal_new == "autre"


tab travail_principal_new, mi
destring travail_principal_new, replace
tab travail_principal_new, mi

label define travail_principal 1 "Own farming (e.g., agriculture, livestock, fishing)" 2 "Temporary work (agricultural, livestock, fishing, non-agricultural)" 3 "Artisanal exploitation" 4 "Hunting" 5 "Housekeeping work and/or childcare" 6 "Product sales (e.g., agricultural products, small trade)" 7 "Remittances (external aid)" 8 "Retired" 9 "Student/pupil" 10 "Unemployed but looking for job" 11 "Unemployed and not looking for job" 12 "Own business" 13 "Paid employee/salaried in the private sector" 14 "Informal employee in the private sector" 15 "Paid employee/salaried in the public sector" 16 "Informal employee in the public sector" 17 "Employee of the chieftaincy administration" 18 "Informal employee of the chieftaincy administration" -66 "Other" -88 "Refused"


label values travail_principal_new travail_principal

tab travail_principal_new, mi
tab travail_principal, mi

label var travail_principal "Most important source of income for HH"
label var travail_principal_new "Most important source of income for HH"


*	Type of water source (income proxy) Q122
tab source_eau, mi
label var source_eau "HH primary water source"

replace source_eau = "-66" if source_eau == "autre"

destring source_eau, replace

label define source_eau 1 "Private tap inside the house" 2 "Private tap in the yard/garden, etc." 3 "Public tap/standpipe" 4 "Neighbor's/friend's tap" 5 "Protected well/borehole" 6 "Unprotected well" 7 "Mechanical well" 8 "River/lake/stream" 9 "Rainwater" 10 "Water vendor" 11 "Bottled/canned water" -66 "Other" -88 "Refused"

label values source_eau source_eau

tab source_eau, mi



*	Type of toilet (income proxy) Q123
tab toilette , mi

label var toilette "Type of toilet (income proxy)"
replace toilette = "-66" if toilette == "autre"

destring toilette, replace

label define toilette 1 "None, bush/river" 2 "Shared pit (communal pot)" 3 "Shared latrine/pit" 4 "Private latrine/pit on a plot of land" 5 "Shared flush toilet" 6 "Private flush toilet inside the house" -66 "Other (Specify)" -88 "Refused"

label values toilette toilette

tab toilette, mi


*	Type of roof (income proxy) Q522
tab1 toit toit_autre, mi // the main variable does not have labels. Get them from the survey form

label var toit "Type of roof (income proxy)"

replace toit = "-66" if toit == "autre"

destring toit, replace

label define toit 1 "No roof" 2 "Tarpaulin" 3 "Thatch/palm leaf/straw/grass" 4 "Mud and grass/bamboo/stone mixture" 5 "Plastic sheeting/polyethylene sheet/cover" 6 "Cardboard" 7 "Cane/palm/bamboo" 8 "Rough wood planks/wood/plywood" 9 "Unbaked bricks" 10 "Stone" 11 "Metal/tin/zinc roofing" 12 "Finished wood" 13 "Cement/concrete/asbestos-cement" 14 "Asbestos sheets" 15 "Tile roofing" 16 "Rock" 17 "Baked bricks" -66 "Refused"

label values toit toit
tab toit, mi




*	HH experience of conflict Q519
gen conflit_experience_other_specify = v3597 // A naming issue occurred in the form/data

tab conflit_experience, mi 

label var conflit_experience_1 "HH conflict experience: Displacement"
label var conflit_experience_2 "HH conflict experience: Injury"
label var conflit_experience_3 "HH conflict experience: Kidnapping of a child/household member"
label var conflit_experience_4 "HH conflict experience: House burned/destroyed" 
label var conflit_experience_5 "HH conflict experience: Death"
label var conflit_experience_6 "HH conflict experience: Sexual assault"
label var conflit_experience_7 "HH conflict experience: Theft/looting"
label var conflit_experience_0 "HH conflict experience: None of the above" 
label var conflit_experience_autre "HH conflict experience: Other conflict experience" 
label var conflit_experience__88 "HH conflict experience: Refused to answer"

label define yesno 1 "Yes" 0 "No"

forvalues i = 0/7{
label values conflit_experience_`i' yesno
}

label values conflit_experience_autre yesno
label values conflit_experience__88 yesno





tab1 conflit_experience_1 conflit_experience_2 conflit_experience_3 conflit_experience_4 conflit_experience_5 conflit_experience_6 conflit_experience_7 conflit_experience_0 conflit_experience_autre conflit_experience__88, mi

*conflit_experience_1 conflit_experience_2 conflit_experience_3 conflit_experience_4 conflit_experience_5 conflit_experience_6 conflit_experience_7 conflit_experience_0 conflit_experience_autre conflit_experience__88 conflit_experience_other_specify, mi



*** Tables
*-------------------------------------------------------------------------------
tabout locale religion_new age education naissance travail_new travail_principal_new source_eau toilette toit conflit_experience_1 conflit_experience_2 conflit_experience_3 conflit_experience_4 conflit_experience_5 conflit_experience_6 conflit_experience_7 conflit_experience_0 conflit_experience_autre conflit_experience__88 province using "${tables}/demographics_stats.docx", replace ///
c(freq col) f(0c 1) style(docx) font(bold) twidth(13) ///
title(Table 1: Demographics) /// 
npos(both) nlab(Obs)


tabout locale religion_new age education naissance travail_new travail_principal_new source_eau toilette toit province using "${tables}/demographics_stats1.docx", replace ///
c(freq col) f(0c 1) style(docx) font(bold) twidth(13) ///
title(Table 1: Demographics) /// 
npos(both) nlab(Obs)
*-------------------------------------------------------------------------------


*** Graphs
*-------------------------------------------------------------------------------

levelsof locale 
* storing sample size by category

foreach f in `r(levels)' {

    quietly count if locale == `f'

	local n_`f' = r(N)
	disp "`n_`f''"

}

graph hbar (percent),  /// basic command for percentages
over(locale, gap(*.7) relabel(1 "Urban (N = `n_0')" 2 "Rural (N = `n_1')") sort(order)) /// identify the "over" variable; specify distance between bars (here)
blabel(bar, color(black) format(%4.0f) size(small)) /// format bar labels
ylab(, glcolor(gs15) glstyle(solid)) /// add light gray, solid horizontal lines
bar(1, fcolor(midblue%85) fintensity(inten100) lcolor(cyan) lwidth(vthin)) /// format look of bars
scheme(white_jet) /// specify scheme
title("Respondent's Location") /// x-axis title
ytitle(Percent) /// title y-axis
graphregion(margin(large)) /// small margin between plot and outer edge of graph
xsize(6.5) ysize(4.5) // specify graph dimensions in inches

local nb=`.Graph.plotregion1.barlabels.arrnels'
qui forval i=1/`nb' {
  .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]'%"
}
.Graph.drawgraph
graph save "${graphs}/location.gph", replace
graph export "${graphs}/location.png", replace



*****
label list religion_new

*sort wp_type_ordered
levelsof religion_new 
* storing sample size by category

foreach f in `r(levels)' {

    quietly count if religion_new == `f'

	local n_`f' = r(N)

}

graph hbar (percent),  /// basic command for percentages
over(religion_new, gap(*.7) relabel(1 "Anglican (N = `n_1')" 2 "None (N = `n_2')" 3 "Catholic (N = `n_3')" 4 "Kimbanguist (N = `n_4')" 5 "Methodist (N = `n_5')" 6 "Muslim (N = `n_6')" 7 "Protestant (N = `n_7')" 8 "Jehovah Witness (N = `n_8')" 9 "Other") sort(order)) /// identify the "over" variable; specify distance between bars (here)
blabel(bar, color(black) format(%4.0f) size(small)) /// format bar labels
ylab(, glcolor(gs15) glstyle(solid)) /// add light gray, solid horizontal lines
bar(1, fcolor(midblue%85) fintensity(inten100) lcolor(cyan) lwidth(vthin)) /// format look of bars
scheme(white_jet) /// specify scheme
title("Respondent's Religion") /// x-axis title
ytitle(Percent) /// title y-axis
graphregion(margin(medsmall)) /// small margin between plot and outer edge of graph
xsize(6.5) ysize(4.5) // specify graph dimensions in inches

local nb=`.Graph.plotregion1.barlabels.arrnels'
qui forval i=1/`nb' {
  .Graph.plotregion1.barlabels[`i'].text[1]="`.Graph.plotregion1.barlabels[`i'].text[1]'%"
}
.Graph.drawgraph
graph save "${graphs}/religion.gph", replace
graph export "${graphs}/religion.png", replace
*-------------------------------------------------------------------------------


*** Section 4: Informal fiscal realities in Kinshasa and North Kivu


* For all payments below, will report separately for Kinshasa and Kivu (not aiming for perfect comparison, but cannot conflate the two and need to be reported separately)

* Formal taxes
/*
impots_payer impots_central impots_central_autre impots_central_multiple impots_central_multiple_1 impots_central_multiple_2 impots_central_multiple_3 impots_central_multiple_4 impots_central_multiple_5 impots_central_multiple_6 impots_central_multiple_7 impots_central_multiple_8 impots_central_multiple_9 impots_central_multiple_10 impots_central_multiple_11 impots_central_multiple_12 impots_central_multiple_13 impots_central_multiple_14 impots_central_multiple_15 impots_central_multiple_autre impots_central_multiple__88 v3085 impots_central_nonpaiement impots_central_nonpaiement_autre impots_central_others impots_central_others_autre impots_central_others_multiple impots_central_others_multiple_1 impots_central_others_multiple_2 impots_central_others_multiple_3 impots_central_others_multiple_4 impots_central_others_multiple_5 impots_central_others_multiple_6 impots_central_others_multiple_7 impots_central_others_multiple_8 impots_central_others_multiple_9 v3100 v3101 v3102 v3103 v3104 v3105 impots_central_others_multiple_a impots_central_others_multiple__v3108 impots_local_payer impots_local impots_local_autre impots_local_multiple impots_local_multiple_1 impots_local_multiple_2 impots_local_multiple_3 impots_local_multiple_4 impots_local_multiple_5 impots_local_multiple_6 impots_local_multiple_7 impots_local_multiple_8 impots_local_multiple_9 impots_local_multiple_10 impots_local_multiple_11 impots_local_multiple_12 impots_local_multiple_13 impots_local_multiple_14 impots_local_multiple_15 impots_local_multiple_autre impots_local_multiple__88 v3130 impots_local_nonpaiement impots_local_nonpaiement_autre impots_local_others impots_local_others_autre impots_local_others_multiple impots_local_others_multiple_1 impots_local_others_multiple_2 impots_local_others_multiple_3 impots_local_others_multiple_4 impots_local_others_multiple_5 impots_local_others_multiple_6 impots_local_others_multiple_7 impots_local_others_multiple_8 impots_local_others_multiple_9 impots_local_others_multiple_10 impots_local_others_multiple_11 impots_local_others_multiple_12 impots_local_others_multiple_13 impots_local_others_multiple_14 impots_local_others_multiple_15 impots_local_others_multiple_aut impots_local_others_multiple__88 v3153
*/

* Incidence of payments by contribution type
/*
armes_paiements_1 armes_paiements_1_1 armes_paiements_2_1 armes_paiements_3_1 armes_paiements_4_1 armes_paiements_autre_1 armes_paiements__88_1 v728 armes_paiements_2 armes_paiements_1_2 armes_paiements_2_2 armes_paiements_3_2 armes_paiements_4_2 armes_paiements_autre_2 armes_paiements__88_2 v740 armes_paiements_3 armes_paiements_1_3 armes_paiements_2_3 armes_paiements_3_3 armes_paiements_4_3 armes_paiements_autre_3 armes_paiements__88_3 v752 armes_paiements_4 armes_paiements_1_4 armes_paiements_2_4 armes_paiements_3_4 armes_paiements_4_4 armes_paiements_autre_4 armes_paiements__88_4 v764 armes_paiements_5 armes_paiements_1_5 armes_paiements_2_5 armes_paiements_3_5 armes_paiements_4_5 armes_paiements_autre_5 armes_paiements__88_5 v776 armes_paiements_6 armes_paiements_1_6 armes_paiements_2_6 armes_paiements_3_6 armes_paiements_4_6 armes_paiements_autre_6 armes_paiements__88_6 v788 armes_paiements_7 armes_paiements_1_7 armes_paiements_2_7 armes_paiements_3_7 armes_paiements_4_7 armes_paiements_autre_7 armes_paiements__88_7 v800 armes_paiements_8 armes_paiements_1_8 armes_paiements_2_8 armes_paiements_3_8 armes_paiements_4_8 armes_paiements_autre_8 armes_paiements__88_8 v812 armes_paiements_9 armes_paiements_1_9 armes_paiements_2_9 armes_paiements_3_9 armes_paiements_4_9 armes_paiements_autre_9 armes_paiements__88_9 v824 eau_paiements eau_paiements_quels eau_paiements_quels_1 eau_paiements_quels_2 eau_paiements_quels_3 eau_paiements_quels_4 eau_paiements_quels_autre eau_paiements_quels__88 v2776 eau_non_paiement eau_non_paiement_1 eau_non_paiement_2 eau_non_paiement_3 eau_non_paiement_4 eau_non_paiement_5 eau_non_paiement_autre eau_non_paiement__88 v2785 primaire_paiements primaire_paiements_quels primaire_paiements_quels_1 primaire_paiements_quels_2 primaire_paiements_quels_3 primaire_paiements_quels_4 primaire_paiements_quels_5 primaire_paiements_quels_6 primaire_paiements_quels_7 primaire_paiements_quels_8 primaire_paiements_quels_9 primaire_paiements_quels_autre primaire_paiements_quels__88 secondaire_paiements secondaire_paiements_quels secondaire_paiements_quels_1 secondaire_paiements_quels_2 secondaire_paiements_quels_3 secondaire_paiements_quels_4 secondaire_paiements_quels_5 secondaire_paiements_quels_6 secondaire_paiements_quels_7 secondaire_paiements_quels_8 secondaire_paiements_quels_9 secondaire_paiements_quels_autre secondaire_paiements_quels__88 v2826 v2835 sante_paiements sante_paiements_quels sante_paiements_quels_1 sante_paiements_quels_2 sante_paiements_quels_3 sante_paiements_quels_4 sante_paiements_quels_5 sante_paiements_quels_6 sante_paiements_quels_autre sante_paiements_quels__88 v2866 resolution_paiements resolution_paiements_quels resolution_paiements_quels_1 resolution_paiements_quels_2 resolution_paiements_quels_3 resolution_paiements_quels_4 resolution_paiements_quels_autre resolution_paiements_quels__88 v2892 centre_paiements centre_paiements_quels centre_paiements_quels_1 centre_paiements_quels_2 centre_paiements_quels_3 centre_paiements_quels_autre centre_paiements_quels__88 v2911 marche_paiements marche_paiements_quels marche_paiements_quels_1 marche_paiements_quels_2 marche_paiements_quels_3 marche_paiements_quels_4 marche_paiements_quels_5 marche_paiements_quels_6 marche_paiements_quels_autre marche_paiements_quels__88 v2933 plancher_paiements plancher_paiements_quels plancher_paiements_quels_1 plancher_paiements_quels_2 plancher_paiements_quels_3 plancher_paiements_quels_4 plancher_paiements_quels_autre plancher_paiements_quels__88 v2953 protection_comm_paiements protection_comm_paiements_quels protection_comm_paiements_quels_v2968 v2969 v2970 v2971 v2972 v2973 police_paiements police_paiements_quels police_paiements_quels_1 police_paiements_quels_2 police_paiements_quels_3 police_paiements_quels_autre police_paiements_quels__88 v2992 dechets_paiements dechets_paiements_quels dechets_paiements_quels_1 dechets_paiements_quels_2 dechets_paiements_quels_3 dechets_paiements_quels_4 dechets_paiements_quels_5 dechets_paiements_quels_autre dechets_paiements_quels__88 v3013 services_autre_paiements services_autre_paiements_quels services_autre_paiements_quels_1 services_autre_paiements_quels_2 services_autre_paiements_quels_a services_autre_paiements_quels__v3032 services_autre2_paiements services_autre2_paiements_quels services_autre2_paiements_quels_v3048 v3049 v3050 v3051
*/

* (a)	Overall percent of respondents making at least one formal tax (Kinshasa/ North Kivu separately)

* (b)	Table with descriptive statistics for incidence of payment for each payment separately, and for each of the following umbrella categories

*	Impots taxes au government central Q418
tab impots_payer, mi

label var impots_payer "Pay taxes to central government"

label define yesnoref 0 "No" 1 "Yes" -88 "Refuse to answer"
label values impots_payer yesnoref

tab impots_payer, mi

*impots_central impots_central_autre impots_central_multiple impots_central_multiple_autre impots_central_others impots_central_others_autre impots_central_others_multiple impots_central_others_multiple_autre 

*	Impots aux autorites locales Q424
tab impots_local_payer, mi

label var impots_local_payer "Pay taxes to local authorities"

label values impots_local_payer yesnoref

tab impots_local_payer, mi

*impots_local impots_local_autre impots_local_multiple impots_local_multiple_1 impots_local_multiple_2 impots_local_multiple_3 impots_local_multiple_4 impots_local_multiple_5 impots_local_multiple_6 impots_local_multiple_7 impots_local_multiple_8 impots_local_multiple_9 impots_local_multiple_10 impots_local_multiple_11 impots_local_multiple_12 impots_local_multiple_13 impots_local_multiple_14 impots_local_multiple_15 impots_local_multiple_autre impots_local_multiple__88 v3130 impots_local_others impots_local_others_autre impots_local_others_multiple impots_local_others_multiple_1 impots_local_others_multiple_2 impots_local_others_multiple_3 impots_local_others_multiple_4 impots_local_others_multiple_5 impots_local_others_multiple_6 impots_local_others_multiple_7 impots_local_others_multiple_8 impots_local_others_multiple_9 impots_local_others_multiple_10 impots_local_others_multiple_11 impots_local_others_multiple_12 impots_local_others_multiple_13 impots_local_others_multiple_14 impots_local_others_multiple_15 impots_local_others_multiple_aut impots_local_others_multiple__88 v3153


***** Informal taxes
** Incidence of payment by contribution type

*contributions_generales contributions_generales_nonpaiem v446 v447 v448 v449 v450 v451 v452 v453 contributions_generales_frequenc v455 contributions_generales_cdf contributions_generales_travail contributions_generales_biens contributions_generales_particip v460 v461 contributions_generales_conseque v463 v464 v465 v466 v467 v468 v469 v470 v471 v472 v473 contributions_generales_organisa v475 contributions_festivals contributions_festivals_nonpaiem v478 v479 v480 v481 v482 v483 v484 v485 contributions_festivals_frequenc v487 contributions_festivals_cdf contributions_festivals_travail contributions_festivals_biens contributions_festivals_particip v492 v493 contributions_festivals_conseque v495 v496 v497 v498 v499 v500 v501 v502 v503 v504 v505 contributions_festivals_organisa v507 contributions_coutumieres_autre contributions_coutumieres_autre_assoc_femmes_contributions assoc_jeunes_contributions assoc_marche_contributions groupes_religieux_contributions groupe_social_contributions assoc_parents_contributions assoc_autre_contributions

** First, we will report whether or not the respond paid the following payments (incidence of payments).

** (c)	Overall percent of respondents making at least one informal payment (Kinshasa/ North Kivu separately)

** (d)	Table with descriptive statistics for incidence of payment for each payment separately, and for each of the following umbrella categories (Kinshasa/ North Kivu separately)

**	Customary contributions (“contributions aux chefs”), which includes:
*	Contributions générales Q333
tab contributions_generales, mi

label var contributions_generales "Pay customary contributions"

label define yesno_customary 1 "Yes" 0 "No, others contributed/this exists, but we did not contribute" 2 "No, no one else contributed/this does not exist" 3 "No, don’t know if others contributed" -88 "Refused to answer"

label values contributions_generales yesno_customary

tab contributions_generales, mi

*contributions_generales_nonpaiem v446 v447 v448 v449 v450 v451 v452 v453 contributions_generales_frequenc v455 contributions_generales_cdf contributions_generales_travail contributions_generales_biens contributions_generales_particip v460 v461 contributions_generales_conseque v463 v464 v465 v466 v467 v468 v469 v470 v471 v472 v473 contributions_generales_organisa v475

*	Contributions au chef pour des évènements festives Q 343
tab contributions_festivals, mi

label var contributions_festivals "Pay customary contributions for celebrations"

label values contributions_festivals yesno_customary

tab contributions_festivals, mi

*contributions_festivals_nonpaiem v478 v479 v480 v481 v482 v483 v484 v485 contributions_festivals_frequenc v487 contributions_festivals_cdf contributions_festivals_travail contributions_festivals_biens contributions_festivals_particip v492 v493 contributions_festivals_conseque v495 v496 v497 v498 v499 v500 v501 v502 v503 v504 v505 contributions_festivals_organisa v507

 

*	Contributions par le travail fourni aux chefs pour soutenir ses activités Q353
tab travail_chef, mi

label var travail_chef "Pay customary contributions working for chiefs"

label values travail_chef yesno_customary

tab travail_chef, mi
 
*travail_chef_nonpaiement travail_chef_nonpaiement_1 travail_chef_nonpaiement_2 travail_chef_nonpaiement_3 travail_chef_nonpaiement_4 travail_chef_nonpaiement_5 travail_chef_nonpaiement_autre travail_chef_nonpaiement__88 v517 travail_chef_frequence travail_chef_frequence_autre travail_chef_cdf travail_chef_travail travail_chef_biens travail_chef_participants travail_chef_participants_autre travail_chef_participation travail_chef_consequences travail_chef_consequences_1 travail_chef_consequences_2 travail_chef_consequences_3 travail_chef_consequences_4 travail_chef_consequences_5 travail_chef_consequences_6 travail_chef_consequences_7 travail_chef_consequences_8 travail_chef_consequences_autre travail_chef_consequences__88 v537 travail_chef_organisateur travail_chef_organisateur_autre


*	Contributions aux project communautaires coordonnés par le chef Q363
tab projets_chef, mi

label var projets_chef "Pay customary contributions for chiefs community projects"

label values projets_chef yesno_customary

tab projets_chef, mi
*projets_chef_nonpaiement projets_chef_nonpaiement_1 projets_chef_nonpaiement_2 projets_chef_nonpaiement_3 projets_chef_nonpaiement_4 projets_chef_nonpaiement_5 projets_chef_nonpaiement_autre projets_chef_nonpaiement__88 v549 projets_chef_frequence projets_chef_frequence_autre projets_chef_cdf projets_chef_travail projets_chef_biens projets_chef_participants projets_chef_participants_autre projets_chef_participation projets_chef_consequences projets_chef_consequences_1 projets_chef_consequences_2 projets_chef_consequences_3 projets_chef_consequences_4 projets_chef_consequences_5 projets_chef_consequences_6 projets_chef_consequences_7 projets_chef_consequences_8 projets_chef_consequences_autre projets_chef_consequences__88 v569 projets_chef_organisateur projets_chef_organisateur_autre

*	Amendes aux chefs Q373
tab amendes_chef, mi

label var amendes_chef "Pay customary fine to the chiefs"

label values amendes_chef yesno_customary

tab amendes_chef, mi



*amendes_chef_nonpaiement amendes_chef_nonpaiement_1 amendes_chef_nonpaiement_2 amendes_chef_nonpaiement_3 amendes_chef_nonpaiement_4 amendes_chef_nonpaiement_5 amendes_chef_nonpaiement_autre amendes_chef_nonpaiement__88 v581 amendes_chef_frequence amendes_chef_frequence_autre amendes_chef_cdf amendes_chef_travail amendes_chef_biens amendes_chef_participants amendes_chef_participants_autre amendes_chef_participation amendes_chef_consequences amendes_chef_consequences_1 amendes_chef_consequences_2 amendes_chef_consequences_3 amendes_chef_consequences_4 amendes_chef_consequences_5 amendes_chef_consequences_6 amendes_chef_consequences_7 amendes_chef_consequences_8 amendes_chef_consequences_autre amendes_chef_consequences__88 v601 amendes_chef_organisateur amendes_chef_organisateur_autre

*	Paiements contributions pour accéder à la terre/ autorisation du chef Q383
tab permis_chef, mi

label var permis_chef "Pay customary contribution for land access"

label values permis_chef yesno_customary

tab permis_chef, mi


*permis_chef_nonpaiement permis_chef_nonpaiement_1 permis_chef_nonpaiement_2 permis_chef_nonpaiement_3 permis_chef_nonpaiement_4 permis_chef_nonpaiement_5 permis_chef_nonpaiement_autre permis_chef_nonpaiement__88 v613 permis_chef_frequence permis_chef_frequence_autre permis_chef_cdf permis_chef_travail permis_chef_biens permis_chef_participants permis_chef_participants_autre permis_chef_participation permis_chef_consequences permis_chef_consequences_1 permis_chef_consequences_2 permis_chef_consequences_3 permis_chef_consequences_4 permis_chef_consequences_5 permis_chef_consequences_6 permis_chef_consequences_7 permis_chef_consequences_8 permis_chef_consequences_autre permis_chef_consequences__88 v633 permis_chef_organisateur permis_chef_organisateur_autre

*	Paiement pour des services spécifiques du chef Q393
tab services_chef, mi

label var services_chef "Pay customary contribution for chief's specific service"

label values services_chef yesno_customary

tab services_chef, mi
*services_chef_autre services_chef_nonpaiement services_chef_nonpaiement_1 services_chef_nonpaiement_2 services_chef_nonpaiement_3 services_chef_nonpaiement_4 services_chef_nonpaiement_5 services_chef_nonpaiement_autre services_chef_nonpaiement__88 v646 services_chef_frequence services_chef_frequence_autre services_chef_cdf services_chef_travail services_chef_biens services_chef_participants services_chef_participants_autre services_chef_participation services_chef_consequences services_chef_consequences_1 services_chef_consequences_2 services_chef_consequences_3 services_chef_consequences_4 services_chef_consequences_5 services_chef_consequences_6 services_chef_consequences_7 services_chef_consequences_8 services_chef_consequences_autre services_chef_consequences__88 v666 services_chef_organisateur services_chef_organisateur_autre

/*	Autres prélèvements faits par le chef Q403
tab services_chef_autre, mi

label var services_chef_autre "Pay customary other contribution requested by chiefs"

label values services_chef_autre yesno_customary

tab services_chef_autre, mi
*/

*chef_autre chef_autre_autre chef_autre_nonpaiement chef_autre_nonpaiement_1 chef_autre_nonpaiement_2 chef_autre_nonpaiement_3 chef_autre_nonpaiement_4 chef_autre_nonpaiement_5 chef_autre_nonpaiement_autre chef_autre_nonpaiement__88 v679 chef_autre_frequence chef_autre_frequence_autre chef_autre_cdf chef_autre_travail chef_autre_biens chef_autre_participants chef_autre_participants_autre chef_autre_participation chef_autre_consequences chef_autre_consequences_1 chef_autre_consequences_2 chef_autre_consequences_3 chef_autre_consequences_4 chef_autre_consequences_5 chef_autre_consequences_6 chef_autre_consequences_7 chef_autre_consequences_8 chef_autre_consequences_autre chef_autre_consequences__88 v699 chef_autre_organisateur chef_autre_organisateur_autre


**	Community contributions
*	Salongo Q124
tab salongo, mi

label var salongo "Community contributions: Salongo"

label define yesno_autoassist 1 "Oui" 0 "No, no such thing" 2 "No, such thing exist, but we did not contribute" -88 "Refused to answer"

label values salongo yesno_autoassist

tab salongo, mi


*	Nettoage de la ville Q140
tab nettoyage, mi

label var nettoyage "Contributed to cleaning of the town"

label values nettoyage yesno_autoassist

tab nettoyage, mi

*nettoyage_frequence nettoyage_frequence_autre nettoyage_cdf nettoyage_travail nettoyage_biens


*	Un comité d'entraide de mutuel/ aider quelqu'un de la communaut´e pour recouvrir le toit de la maison ou construire une maison (ou a reçu d'aide de quelqu'u) (non-membre du ménage) Q156
tab entraidemutuelle, mi

label var entraidemutuelle "Contributed in community mutual aid"
label values entraidemutuelle yesno_autoassist
tab entraidemutuelle, mi

*entraidemutuelle_frequence entraidemutuelle_frequence_autre entraidemutuelle_cdf entraidemutuelle_travail entraidemutuelle_biens


*	Un projet de développement de la commaunauté Q172
tab projetdeveloppement, mi

label var projetdeveloppement "Contributed to development project"
label values projetdeveloppement yesno_autoassist
tab projetdeveloppement, mi

* projetdeveloppement_frequence projetdeveloppement_frequence_au projetdeveloppement_cdf projetdeveloppement_travail projetdeveloppement_biens projetdeveloppement_participants v1281

*	Pour soutenir l'entretien/réparation des installations communautaires Q268
tab reparation, mi 

label var reparation "Contributed to maintain or repair insfrastructure"
label values reparation yesno_autoassist
tab reparation, mi
*reparation_frequence reparation_frequence_autre reparation_cdf reparation_travail reparation_biens

*	Autre projets d’auto-assistance Q316
tab auto_autre, mi 

label var auto_autre "Contributed to other auto-assistance projects"
label values auto_autre yesno_autoassist
tab auto_autre, mi

*auto_autre_autre auto_autre_frequence auto_autre_frequence_autre auto_autre_cdf auto_autre_travail

**	Informal user fees
*	Aux enseignants de la communauté (à part des frais d'études) Q204
tab enseignants, mi 

label var enseignants "Contributed to support teachers in the community"
label values enseignants yesno_autoassist
tab enseignants, mi


*enseignants_frequence enseignants_frequence_autre enseignants_cdf enseignants_travail enseignants_biens

*	Aux comités/ groupes/ gardiens de gestion des puits d'eau Q220
tab gestion_eau, mi 

label var gestion_eau "Participated in or contributed to water point management committee"
label values gestion_eau yesno_autoassist
tab gestion_eau, mi

*gestion_eau_frequence gestion_eau_frequence_autre gestion_eau_cdf gestion_eau_travail gestion_eau_biens gestion_eau_participants gestion_eau_participants_autre

*	Pour achat des câbles d'électricité et frais de motivations des agents de la snel pour dépanner des cabines électriques Q300
tab snel, mi 

label var snel "Contributed to buy electric cables and motivation of SNEL agents"
label values snel yesno_autoassist
tab snel, mi


*snel_frequence snel_frequence_autre snel_cdf snel_travail snel_biens snel_participants snel_participants_autre

**	Security payments:
*	Armed group (“GA”, for groups armées) contributions Q414
tab armes, mi 

label var armes "Made paiement to armed groups (state actors or not)"
label values armes yesno_autoassist
tab armes, mi


*armes_acteurs armes_acteurs_1 armes_acteurs_2 armes_acteurs_3 armes_acteurs_4 armes_acteurs_5 armes_acteurs_6 armes_acteurs_7 armes_acteurs_8 armes_acteurs_9 armes_acteurs_50 armes_acteurs__88 armes_acteurs_autre armes_acteurs_repeat_count armes_acteurs_id_1 armes_acteurs_name_1

*	Protection ou sécurité de la communauté Q188
tab protection, mi

label var protection "Participated or contributed to protection or security of the community"
label values protection yesno_autoassist
tab protection, mi

*protection_frequence protection_frequence_autre protection_cdf protection_travail protection_biens protection_participants

*	Payments to une groupe de protection non-étatique Q95
tab protection_comm, mi

label var protection_comm "Contributed to non-state protection group"
label values protection_comm yesno_autoassist
tab protection_comm, mi


* protection_comm_paiements protection_comm_paiements_quels protection_comm_paiements_quels_v2968 v2969 v2970 v2971 v2972 v2973

*	SERVICES DE POLICE OU DE PROTECTION Q100
tab police, mi 

label var police "Contributed to police or protection services"
label values police yesno_autoassist
tab police, mi


*police_paiements police_paiements_quels police_paiements_quels_1 police_paiements_quels_2 police_paiements_quels_3 police_paiements_quels_autre police_paiements_quels__88 v2992


*** Tables
*-------------------------------------------------------------------------------
tabout contributions_generales contributions_festivals travail_chef projets_chef amendes_chef permis_chef services_chef salongo nettoyage entraidemutuelle projetdeveloppement reparation auto_autre enseignants gestion_eau snel armes protection protection_comm police province using "${tables}/Informal_fiscal_realities_stats.docx", replace ///
c(freq col) f(0c 1) style(docx) font(bold) twidth(13) ///
title(Table 2: Informal fiscal realities in Kinshasa and North Kivu) /// 
npos(both) nlab(Obs)
exit 
/*
tabout locale religion_new age education naissance travail_new travail_principal_new source_eau toilette toit province using "${tables}/demographics_stats1.docx", replace ///
c(freq col) f(0c 1) style(docx) font(bold) twidth(13) ///
title(Table 1: Demographics) /// 
npos(both) nlab(Obs)
*/
*-------------------------------------------------------------------------------
exit



***** Section 5: Stealing nicely: Taxpayer perceptions of formal and informal tax

*** Perceptions of taxation

*** Tax morale

**	Agreement with statements about tax evasion/ tax payment Q431
tab declarations, mi 
*declarations1 declarations2 declarations4 declarations_accord

**	Primary reason why others evade tax Q433
tab1 evasion_fiscale evasion_fiscale_autre, mi

**	Table: comparison of views around tax evasion to different actors Q434-445
*	Central government 
*jugement1 jugement1_pourquoi jugement1_pourquoi_1 jugement1_pourquoi_2 jugement1_pourquoi_3 jugement1_pourquoi_4 jugement1_pourquoi_autre jugement1_pourquoi__88 v3184

*	Local government
* jugement3 jugement3_pourquoi jugement3_pourquoi_1 jugement3_pourquoi_2 jugement3_pourquoi_3 jugement3_pourquoi_4 jugement3_pourquoi_autre jugement3_pourquoi__88 v3193

*	Local chief
* jugement5 jugement5_pourquoi jugement5_pourquoi_1 jugement5_pourquoi_2 jugement5_pourquoi_3 jugement5_pourquoi_4 jugement5_pourquoi_autre jugement5_pourquoi__88 v3202

*	Salongo
* jugement6 jugement6_pourquoi jugement6_pourquoi_1 jugement6_pourquoi_2 jugement6_pourquoi_3 jugement6_pourquoi_4 jugement6_pourquoi_autre jugement6_pourquoi__88 v3211

*	Self-help
* jugement7 jugement7_pourquoi jugement7_pourquoi_1 jugement7_pourquoi_2 jugement7_pourquoi_3 jugement7_pourquoi_4 jugement7_pourquoi_autre jugement7_pourquoi__88 v3220

*	Religious contributions
* jugement8 jugement8_pourquoi jugement8_pourquoi_1 jugement8_pourquoi_2 jugement8_pourquoi_3 jugement8_pourquoi_4 jugement8_pourquoi_autre jugement8_pourquoi__88 v3229

**	What would make you more likely to pay tax Q515
tab volonte_payer, mi
* volonte_payer_1 volonte_payer_2 volonte_payer_3 volonte_payer_4 volonte_payer_5 volonte_payer_6 volonte_payer_7 volonte_payer_8 volonte_payer_9 volonte_payer_autre volonte_payer__88 v3552


***** Section 6: Relationship between formal and informal institutions

*** Legitimacy of public authority (descriptive)
*** Unconditional tax morale/ state legitimacy

**	Table comparing different taxing actors: 
*	Who always has the right to collect tax Q430
tab droiddecollecter_labels, mi

*** Preferences for actors
**	Who should NGO go through to do development project Q454

**	Who is the best actor to respond to the challenges of your community Q517
tab1 autorite autorite_autre, mi

**	Table: comparison of actors: How effective different actors to respond to security issues Q518
tab conflit_labels, mi 
*conflit_central conflit_parlement conflit_provincial conflit_chefferie conflit_ville conflit_chefsecteur conflit_chefvillage conflit_mwami conflit_sages conflit_associations conflits_secretes conflits_religeux conflits_un conflits_ongis conflits_ongls conflits_cs


***** Relationship between tax and statebuilding

*** Correlational analysis: 
**	Payment of different categories of formal taxes (central, local) and categories of informal payments (contributions to chief, community contributions, informal user fees, security payments) 
**	Agreement that the state always has the right to pay taxes

*** Regression: Determinants of view that state always has the right to pay tax
**	Payment of different categories of formal taxes (central, local) and categories of informal payments (contributions to chief, community contributions, informal user fees, security payments) (Binary)
**	Payment of different categories of formal/ informal payments (number)
**	Amount of payment of different categories of payment
**	Controls:
*	Experience of conflict 
*	Income proxy
*	Tribe
*	Province)
*	Other controls [to discuss]






save "2. Dataset\rdc_enquete_menage_quant_clean.dta", replace

