
 #                             CASE STUDY DATA ANALYTICS TEAM
 #-----           Organisation : NewGlobe

#-----Title: R test for the Measurement and Evaluation Data Analyst position( NewGlobe)

#------Author: Baudouin Gbessinou  ( Data scientist)
# Email address: baudouingbessinouh@gmail.com

#----Description : This  r script file  works on 1) data cleaning , 2) Calculation of key performance indicators (KPIs)
#3)descriptive analysis  and  4) impact evaluation

#Date:
  
  
  #Input: 			"${CASE_NEWGLOBE}/Datasets/ lesson completion_"
#{CASE_NEWGLOBE}/Datasets/ pupil attendance"
#${CASE_NEWGLOBE}/Datasets/ pupil scores"
#{CASE_NEWGLOBE}/Datasets/  school information"



#Analysis data:  {CASE_NEWGLOBE}/constructed_data/pupil_info1"
#Output:         see "${ Case_NewGobe}/output"






#-----------------INSTRUCTIONS*********************************
  
  
  #--- Once you open this R script kindly do the following actions 

# 1. Go to section "SETTING UP WORKING DIRECTORY" below and input 
#    project/working directory path

#  2.   Go and Open your project directory manually on your hard drive and 
# 2.1. Create the following folders as they will be need for 
#      
  #     "Datasets", " R script ", "constructed_data", "output"

# 3. Close this  R script , go into your working directory, copy the updated script  
#    and paste it into the folder named  " R script"

# 4. Copy the raw data files " lesson completion" , " pupil attendance" , " pupil score" and "school information"

#   paste them into folder "raw_data"

# 5. Go back into the R script  folder and open the  rhe R script 

# 6. Congratualiations!: You can now run the   R script  smoothly






 #--- section: 0 ------------------------------------------
  # ---------- setting up the working directory-----------------------#

    setwd("C:/Users/HP/CASE_STUDY_NEWGLOBE/Datasets")

#---------Let's uploading the nedded packages------------------------
library(dplyr)
library(tidyr)
library(ggplot2)
library( haven)
library(stargazer)

#--- let's import the data sets f+rom the stata files provided------------

lesson_completion= read_dta( "Lesson completion.dta")
Pupil_attendance= read_dta("Pupil attendance.dta")
Pupil_scores=read_dta("Pupil scores.dta")
school_info = read_dta( "School_information.dta")

#--- Section: 1-------------------------------------------

#----1) Data cleaning-------------------------

 
#------ Let's  reshape the  pupils_score data set
View(Pupil_scores)
attach(Pupil_scores)
dim(Pupil_scores) # gives the dimension of the data
str(Pupil_scores) # gives a description of the data 

#------ reshaping
reshap_student_level = Pupil_scores%>% 
  pivot_wider( names_from = subject,
               values_from = score,
               names_prefix = 'score_'
               
               )
View(reshap_student_level)

# let' s now write the reshaped version of the data in the current working direstory

write_dta( reshap_student_level, "reshaped_pupil_scores.dta")
#-- The reshaped file wile be saved in the repository provided in the above working directory

#---- Note: This file is the one I'm sharing  with the data analytics team 
#----- I will merge this data with other files  imported in setion 0 to get the  data ready for analysis

#----let's now merge the data sets


merge_data = left_join( reshap_student_level, school_info,by= "school_id")
View(merge_data)

merge1_data=left_join( merge_data,Pupil_attendance,by= "pupil_id")
View(merge1_data)

merge1_data =  merge1_data%>% select(-school_id.x)
 merge1_data=merge1_data%>%  rename( school_id=school_id.y)
View(merge1_data)

merge2_data=left_join( merge1_data, lesson_completion,by= "school_id",
                       relationship = "many-to-many")
View(merge2_data)




 merge2_data  = merge2_data%>% select( pupil_id, teacher_id,school_id,
                                      grade, attendance_records,
                                      present_records,
                                       everything())
 
 merge2_data= subset( merge2_data, select = -14)
 merge2_data=merge2_data%>%  rename( pupil_grade=grade.x)
 
 View(merge2_data)
 
 
 
 write_dta(  merge2_data, "pupil_info1.dta")
#---- We now got  a dataset  ready for analysis , this file is saved in the repository under the 
 # name " pupil_info1.dta"
 
 #--- 2) Key performance indicators construction 
 
 attach(merge2_data)
 # ---our KPI  is called percent_pupil_present in our data set 
 # -- Let's construct it For all the pupils at once . and we translate this into the data ( first approach)
 
  merge2_data$Percent_pupil_present=present_records/attendance_records
  View(merge2_data) 
 
  #---Note : "NWL_PPP1" stands for network level average percent pupil present
  
 NWL_PPP1=round(mean(merge2_data$Percent_pupil_present, na.rm = TRUE),2) # this gives the network level average percent pupils present
 

#-------- Let' s now compute this percent for all schools 
# Note : the pupil info1 file  which is called merge2_data in this code is not uniquely identified by
 # by the pupil_id  ( second approach)
 
pupil_attendance = merge2_data%>%group_by( pupil_id, school_id)%>%
  summarize( pupil_present_percent=mean(Percent_pupil_present,na.rm = TRUE))
dim(pupil_attendance)
View( pupil_attendance) # we aggregate the data then at the pupil level . This new data is then uniquely
# identified by pupil_id meaning each pupil has a unique row in the dataset 

#--- Let's now create an average at the school level

school_level_average_percent_present = pupil_attendance%>% group_by(school_id)%>% 
   summarize(average_presence =mean( pupil_present_percent, na.rm = TRUE))
View(school_level_average_percent_present)
dim( school_level_average_percent_present) # this aggregates the data at the school level 

 # the average pupil present now is as following 
NWL_PPP2=round(mean( school_level_average_percent_present$average_presence, na.rm = TRUE),2) 
 
# change in the interpretation between the two approcahes . 
# Comment: there is not change between the two approches because the two give us 76%
# Then it does not matter 



 #---- 3) Descriptive analysis


#-----  In this session we are reusing the pupil_info1 ( merge2_data)  file 
average_fluency_score_by_grade=merge2_data %>% group_by( pupil_grade)%>%
  summarize( n=n(),fluency_score=mean( score_Fluency ,na.rm = TRUE))
  View( average_fluency_score_by_grade) # this gives the average fluency score across grades
  
 
#---
average_fluency_score_by_region=merge2_data %>% group_by( region)%>%
  summarize( n=n(),fluency_score=mean( score_Fluency ,na.rm = TRUE))
View(average_fluency_score_by_region)
dim(average_fluency_score_by_region) # we have 31 regions in the data after we aggregated the 
# at the region level 

# We want to get now the regions that score the  highest and the lowest for  reading fluency
highest_lowest= average_fluency_score_by_region %>%
  filter( fluency_score  %in%c(max(fluency_score), min(fluency_score))) # gives us the the regions with the
# the highest and lowest average fluency score 
View(highest_lowest)


#--- Let's create the binary variable called fluency performance in merge2_data 
# we will translate this variable into the ( merge2_data) dataset 
# this variable takes 1 when a pupil reads at 10 or lower and takes 0 otherwise 
merge2_data$fluency_performance = ifelse( score_Fluency <= 10, 1, 0)
View(merge2_data)


#----- Let's generate the average performance across grades as well as the bar chart

unique_pupil=merge2_data %>% group_by( pupil_id, pupil_grade)%>%
  summarize( fluency_performance=mean( fluency_performance ,na.rm = TRUE) )
  View(unique_pupil)
  summary( unique_pupil$fluency_performance)

share_by_grade= unique_pupil %>% group_by(pupil_grade) %>%
     summarize( n=n(), share_by_grade_performance= mean(fluency_performance, na.rm = TRUE))
View( share_by_grade) # this gives the average fluency performance across grades

 ggplot( share_by_grade, aes( x=pupil_grade,
                              
                      y= share_by_grade_performance , fill= pupil_grade))+
   geom_bar(  stat="identity")+
   scale_fill_manual(values= c( "blue", "red", "green", "orange", "purple"))+
   labs( title = "share of pupils that reads  at 10 or lower ",
         
         x= "grades", y=" share of pupils")
 # comment:
 
 #------------------ let's now get the school that has the highest share of grade 3 pupils who reads 
 # at 10 or lower 
    grade_3 =merge2_data%>%  filter( pupil_grade=="Grade 3")
    View( grade_3)
    #-----
    
    performance_pupil_uniq = grade_3%>%  group_by( pupil_id, school_id)%>% 
      summarize( per_school_performance= mean(  fluency_performance , na.rm = TRUE))
     View(performance_pupil_uniq)
    dim( performance_pupil_uniq)
    
    performance_per_school= performance_pupil_uniq%>% group_by( school_id)%>%
      summarize( school_performance= mean( per_school_performance , na.rm = TRUE))
    View(performance_per_school)
    dim( performance_per_school)

    highest__school_grade3=performance_per_school%>%
      arrange( desc( school_performance))
      View(highest__school_grade3)
      highest_grade3_school= highest__school_grade3%>% slice(1)
      View(highest_grade3_school) # this gives us the  school with the highest share of 
      # grade 3 pupils that read at 10 and lower in the data 
      
       
       
#----4) --------Impact evaluation
      
       #-- we will use the pupil_info1 data ( merge2_data)
      # since the randomization was at the school level we will bring the data at the school level
        # before we run any regressions to get the estimates for the average  treatement effect 
        # of the tutoring program 
         
        # our main  outcomes that we  are measuring  are the test scores such as the scores in math , Kiswawili and in reading 
        # fluency 
       
       school_level_program= merge2_data%>% group_by( school_id, tutoring_program)%>%
         summarize( score_Fluency_average=mean(score_Fluency,na.rm = TRUE),
                  score_Kiswahili_average=mean( score_Kiswahili, na.rm = TRUE),
                  score_Math_average=mean(score_Math, na.rm = TRUE),
                  lesson_completion_rate_average=mean(lesson_completion_rate,na.rm = TRUE)
                      
                      
                      )
       View( school_level_program)
         write_dta( school_level_program, "school_randomization")
        
        # this gives us  another file that is school randomization that will be using in the regressions 
        
 attach(school_level_program) 
         
impact_evaluation_1= lm ( score_Fluency_average~  tutoring_program  , data = school_level_program)
summary(impact_evaluation_1)
  
impact_evaluation_2= lm ( score_Math_average~  tutoring_program  , data = school_level_program)
summary(impact_evaluation_2)


impact_evaluation_3= lm ( score_Kiswahili_average~  tutoring_program  , data = school_level_program)
summary(impact_evaluation_3)


##---- comment:
#-----
stargazer( impact_evaluation_1, impact_evaluation_2, impact_evaluation_3, type = "text")




#---- Let's check the hypothesis 
# let's control for the variable lesson completion rate

# Since the anedocte reported that teacher who  were in the treatment group showed high motivation
# and completed their lesson at a faster we will control for the completion rate in measuring 
# the impact of the program on our test scores . This is crucial because we want evidence to say 
# that our program has a causal impact on our learning outcomes

#-----  We want see whether  that  motivation was driven by the tutoring program in our data 
#--- 
effec_0= lm( lesson_completion_rate_average~  tutoring_program , data = school_level_program)
summary(effec_0)

#----comment : 

#--- we don't see any statistically significant evidence from the above regression thus we could 
# infere that the program  did not drive this motivation in the teachers in the treatment group

# Now let's see whether lesson completion rates impacts our outcome variables( test_scores) in the data 

effects_on_1= lm( score_Kiswahili_average~  tutoring_program + lesson_completion_rate_average, data = school_level_program)
summary(effects_on_1)

effects_on_2= lm( score_Fluency_average~  tutoring_program + lesson_completion_rate_average, data = school_level_program)
summary(effects_on_2)

effects_on_3= lm( score_Math_average~  tutoring_program + lesson_completion_rate_average, data = school_level_program)
summary(effects_on_3)
# comments: We can infere from the  point estimates of the average treatment effect of the 
# program on the test scores  that our tutoring program does has significant effect on test scores
# However , when we control for the lesson completion rates we see that there is no a significant 
 # impact of the lesson completion rate on fluency and Kiswahili therefore we could tell the 
# academic officer that our  tutoring program has a causal impact on Kiswahili and reading but the 
# result is different for score in mathematics meaning that we don't have evidence of causal relationship
# between math scores and our program


stargazer( effec_0, type = "text")
stargazer( effects_on_1, effects_on_2, effects_on_3, type ="text")

