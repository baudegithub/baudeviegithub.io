                        Executive summary
Host Organisation : BCG X
Client : PowerCo

1)	Setting the business situation and background

The Energy Market has experienced a lot change  in recent years and there are more options than ever  for customers to choose from. A major gas and electricity suplier called powerCO  that supplies gas and electricity utility to small and medium sized entreprizes is concerned about their customers leaving for better offers from other energy providers. This business scenario has become a big issue for powerCO . They then reached out to  BCG X to help them diagnose the reason why their custormers are churning.

2)	Problem
 After we the data scientist team investigated the  business situation we believed that the main concern   of our client is that ;PowerCO is experiencing churning and wants to know what  are the key  reasons behind ?

3)	Hypothesis and data 
 As a data scientist team   after  looking at the business  probem  through the lense of a data scientist we came to an hypothesis  like Customer churning may be caused by  customer’s price sensitivity and many other related factors

In order to test whether churn is driven by customer’s price sensitivity we modeled churn probabilities of customers.
In order to build our model  the Data scientist team required the following data  from PowerCO.
a)Customer  historical data  which includes characteristics of each client, for example industry, historical electricity and gas consumption, date joined as customer etc …
b)churn data which should indicate if a customer has churned
c) historical price data which includes the price the company charges for both electricity  and gas at granualr  time intervals.



4)	Our findings
After careful  Exploration of the data we found some insigths that we believe  may be of  interest for  PowerCO stakeholders


![image](https://github.com/user-attachments/assets/513bd9c7-282c-4192-9045-797cbb84fd45)


 
This graph above is simply showing us the churning status of the company
We found that neary 10% of  PowerCO’s  clients has churned. 

 ![image](https://github.com/user-attachments/assets/1d0ce88e-4391-4153-bb2f-d1f46d7414b2)



This gragh  above shows us the churning rates across  the type of contract of a customer meaning whether or not  they  have signed for gas service  at PowerCO. What we found is that nearly 10% of  non gas  customers churned compared to 8% of  gas customers. The key take away here is that on average   a non gas customer is 2% more likely to churn than a gas customer.




![image](https://github.com/user-attachments/assets/d4df2ffe-146b-41b3-9e50-4270b6187525)

 



This chart above shows how antiquity of a customer could infuence their decision of leaving. We see that clients  with only  1 year of age  do not churn whereas after    2 years of being PowerCO’s client  roughly 70% of them  stayed and this retention rate went   back up  all the to the 9th year and  declined afterwards.



Note on Key metrics
In order  to make sure that our model perform well and  inform business decision for our client the data scientist team managed to build some  key metrics to increase the predictive power of the   model. This step involved a lot of  engeneering skills  as well as a deep  understanding of the needs of our cient.
The metrics that we though are relevant and that improved the predictive power of the model are the following : 
1)	Difference between off prices in december and  preceding January

2)	The average prices changes across individuals periods

3)	Maximum price change between months and time periods

4)	Cient tenure( Which captures the number of month  a company has been a client for PowerCO

5)	Consumption ,net margin and others.


 ![image](https://github.com/user-attachments/assets/33db1714-d162-4bae-ae66-4aed6301f529)



This table above shows the tenures and the churning rates that correspond to  each.
For  instance 12% of  companies with 4 months tenure  churned  against 8%  of companies with 5 months tenure. The key insight from  the table is that highest churning rates between ordered tenure  is observed  from companies with 4 months to 5 month tenure . This suggest that keeping a client  till after 4 months is a huge milestone for PowerCO compared to keeping them for    longer term.
Note on metrics importance : After evaluating our metrics we  found that the metrics that drive the prediction power of our model ,interestingly  are not  price metrics  but rather  consumption history , net margin and  others.


Model summary
Within  the data  as we saw earlier 10% of companies churned . Out of 3286 non churning companies  our model accurately predicted 3282. Within the churning companies our model accurately predicted 18 out 366 churning companies . This means that  our model is much better  at predicting non churning companies  than it can predict churning ones.

Recommendations
PowerCO  stakeholders should then focus more  on  client  RETENTION rather than on client churn because of   the  predictive power of our model regarding client retention rates.





