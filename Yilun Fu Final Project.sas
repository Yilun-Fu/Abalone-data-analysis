/* The following options are described in HomeworkOptionsAnnotated.sas in compass.
   Please refer to that file to determine which settings you wish to use or modify
   for your report.
*/
*ods html close;
*options nodate nonumber leftmargin=1in rightmargin=1in;
*title;
*ods escapechar="~";
*ods graphics on / width=4in height=3in;
*ods rtf file='FileNameWithFullPath.rtf'
        nogtitle startpage=no;
*ods noproctitle;

/* The raw data in abalone.data is from

   https://archive.ics.uci.edu/ml/datasets/abalone

   from the UCI Machine Learning Repository. 

   Dua, D. and Graff, C. (2019). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. 
   Irvine, CA: University of California, School of Information and Computer Science. 
*/
options nodate nonumber leftmargin=1in rightmargin=1in;
title "Final Project";
ods escapechar="~";
ods graphics on / width=4in height=3in;
ods rtf file='/home/u60757443/STAT448/Yilun Fu FinalProject.rtf'
        nogtitle startpage=no;
ods noproctitle;

data abalone;
	infile '/home/u60757443/STAT448/abalone.data' dlm=',';
	input sex $ length diameter height whole_weight meat_weight gut_weight shell_weight rings;
run;

*Introduction;
ods text="Introduction";
ods text="~n";
ods text="The data is based on the abalone data set from UCI’s Machine Learning Database with totally 4177 rows. It contains some physical measurements about abalone like
'Sex', 'Length', 'Diameter', 'Height', 'whole_weight', 'meat_weight', 'gut_weight' and 'shell_weight'. There is also one variable named 'Rings' which
+1.5 gives the age in years. 'Rings' is a integer and 'Sex' is a nominal variable, the rest are all continuous variables.";
 
ods startpage=now;
ods text="Question 1";
ods text="~n";
ods text="This is a general descriptive overview of the sizes and weights of abalone by sex.";

proc sgscatter data=abalone;
matrix Length Diameter  Height  / group=sex diagonal=(histogram kernel);
run;
ods text="It is easy to notice that infant has minimum length, diameter and height compared to female or male.";

proc sgplot data=abalone;
    vbox Length / category=sex;
run;

ods text="From this box plot of variable 'length', there is no such big difference bewtween male and female. However, infant
 has noticeable relatively low length.";

proc sgplot data=abalone;
    vbox Diameter/ category=sex;
run;
ods text="As for diameter, just like length and there is no such big difference bewtween male and female. Maybe the diameter of female is slightly
 than that of male. But infant has noticeable relatively low diameter compared to female or male.";

proc sgplot data=abalone;
    vbox Height / category=sex;
run;

ods text="Similar conclusion for height ,there is no such big difference bewtween male and female. But infant has noticeable relatively low height compared to female or male.";

ods text="~n";

ods text="We can conclude that noticeable difference in sizes between infant and female or male can be observed. While there is nearly no difference bewtween
female and male.";

proc sgscatter data=abalone;
matrix whole_weight meat_weight  gut_weight shell_weight / group=sex diagonal=(histogram kernel);
run;
ods text="It can be noticed that infant has minimum weights compared to female or male.";

proc sgplot data=abalone;
    vbox whole_weight/ category=sex;
run;
ods text="From the boxplot of whole_weight, infant has the lowest height while difference between female and male can not be easily detected.";

proc sgplot data=abalone;
    vbox meat_weight/ category=sex;
run;
ods text="It can be noticed that infant has lower meat weight compared to female or male.";
proc sgplot data=abalone;
    vbox gut_weight/ category=sex;
run;
ods text="It can be noticed that infant has lower gut weight compared to female or male. Male abalones have some extreme large values.";

proc sgplot data=abalone;
    vbox shell_weight/ category=sex;
run;

ods text="Just like other weights, infant has lower shell weight compared to female or male.";

ods text="In conclusion, there are noticeable differences in sizes (e.g. lengths, widths, heights) and weights for the three sexes (female, male and infant).";

ods startpage=now;
ods text="Question 2";
ods text="~n";

ods text="In this part, the goal is to identify female abalone by using trained models. As indicated from the question, the wholesaler’s supplier wants
to identify females based on measurable quantities that can be quickly obtained without hurting the abalone. 
So length, diameter, height and whole weight will be our possible predictors.";

ods text="At the first stage, we do not consider separate infants and adults. Therefore, this is a classification problem with 'sex' as response variable.";

ods text="Let's do the Discriminant Analysis first. Here use the proportional priors.";
proc discrim data=abalone crossvalidate crosslisterr manova pool=test;
	class sex;
	var length--whole_weight;
	priors prop;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;
ods text="Since the hypothesis test reveals that the variances in each group are not equal, we will use QDA rather than LDA.
 The subsequent statistics, e.g., Wilk's Lambda, and their p-values suggest that some amount of discrimination will 
be possible by some of the independent variables";

ods text="The cross-validation predictions match the female pretty bad with probability 0.8217. 57.54 percent of females classified into 
males. The total error rate is 0.4642.";

proc discrim data=abalone crossvalidate crosslisterr manova pool=test;
	class sex;
	var length--whole_weight;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;

ods text="Use equal prior probability 0.333333 instead and the result looks like a little better with ovarall error rate 0.4626. However, the 
misclassification rate of female is still high with 0.7399 percentage.";
ods text="~n";
ods text="Since we do not need to separate male and infant, so we can consider modeling adults only since
 the supplier believes they can keep infants and adults separate.";
ods text="~n";
ods text="As before, try Discriminant Analysis with proportional priors.";


proc discrim data=abalone crossvalidate crosslisterr manova pool=test;
	class sex;
	var length--whole_weight;
	where sex ='M' or sex = 'F';
	priors prop;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;

ods text="Since the hypothesis test reveals that the variances in each group are not equal, we will use QDA rather than LDA.
 The subsequent statistics, e.g., Wilk's Lambda, and their p-values suggest that some amount of discrimination will 
be possible by some of the independent variables";

ods text="~n";
ods text="The misclassification rate of female still very high with value 0.8202, over 80 percent are wrongly classified into male.";
ods text="~n";
ods text="Consider to use stepwise discrimination to determine the best predictors for a discriminant analysis based 
on variables in the data set.";
ods text="~n";

proc stepdisc data=abalone;
	class sex;
	var length--whole_weight;
	where sex ='M' or sex = 'F';
	ods select Summary;
run;

ods text="After the stepwise procedure, we only need to keep diameter, whole_weight and height to effectively classify abalones between female and 
male";

proc discrim data=abalone crossvalidate crosslisterr manova pool=test;
	class sex;
	var diameter whole_weight height;
	where sex ='M' or sex = 'F';
	priors prop;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;

ods text="We still use the QDA rather than LDA to perform the Discriminant Analysis. With one variable less, the error rate doesn't look better.";
ods text="~n";
ods text="Let's try logistic model instead to check if that model performs better.";

proc logistic data=abalone ;
	class sex;
	model sex = length--whole_weight;
	where sex ='M' or sex = 'F';
	ods select ModelInfo ConvergenceStatus ParameterEstimates;
run;
ods text="As we have seen before, the parameter length is not significant with p value 0.6408. Let's use stepwise selection with default significance levels to choose the best set of explanatory 
variables for predicting the probability of female.";

proc logistic data=abalone ;
	class sex;
	model sex = length--whole_weight/selection=stepwise;;
	where sex ='M' or sex = 'F';
	ods select ModelInfo ModelBuildingSummary ParameterEstimates OddsRatios;
run;

ods text="Diameter, whole_weight and height are kept based on their p values are all significant and indicating the coeffients are 
different from 0 at a .05 level.";
ods text="~n";
ods text="We can also note that the parameters of diameter and height are positive, 
so increases in any of these two predictors will increase the log odds (and consequently increase the odds) 
 of being female. On the other hand, decreasing whole_weight will lead to decrease the log odds of being female.";

ods text="~n";
ods text="As for the odds ratios, the confidence intervals are pretty wide for diameter and height. 
Specifically, an increase of 1 of diameter would correspond to an expected multiplicative increase of 572.784 in the odds of being female with a 
95% confidence interval of (43.500, >999.999), a unit increase in height would 
correspond to an expected multiplicative increase of 181.617 with a 95% confidence interval of (2.512, >999.999
), and an increase of whole_weight would correspond to an expected 
multiplicative increase of 0.354 with a 95% confidence interval of (0.226, 0.556).";



* use the final model to predict probabilities;
proc logistic data=abalone noprint;
	model sex = diameter height whole_weight;
	where sex ='M' or sex = 'F';
    output predicted=pred out=abalone_out1;
run;

ods text="~n";
ods text="In addition to the default results for the final model, diagnostic plots are included here.";

* plot final model selected with residual diagnostics;
proc logistic data=abalone plots = effect;
	model sex = diameter height whole_weight;
	where sex ='M' or sex = 'F';
run;

ods text="~n";
ods text="With binary logistic regression, the females are underestimated by the model and the males overestimated. 
And Cbar in the next table of plots is also a rough analog of Cook’s distances for logistic models.";
ods text="~n";
ods text="What's more, the predicted probability plot shows the predicted function for the probability along with confidence bands and the 
original data.";

* use the final model to see model performance by 
inspecting individual probabilities;
proc logistic data=abalone noprint;
	model sex = diameter height whole_weight;
	where sex ='M' or sex = 'F';
    output predprobs=individual out=abalone_out2;
run;

* compare levels observed with levels predicted;
proc freq data=abalone_out2;
    tables sex*_into_/ nocol;
	where sex ='M' or sex = 'F';
run;
ods text="~n";
ods text="A frequency table is useful here to compare the observed sex values to the predicted groups and the _INTO_ values 
which represent the category the observation would have been placed into based on the model. Only 29.38 percent of females are 
corectly classified in to female. 70.62 percent of females are wrongly classified into male. Therefore, the 
model does not classify very well for the intended purpose.";

ods startpage=now;
ods text="Question 3";
ods text="~n";

ods text="The wholesaler believes that the infant abalone are very different in size and weight characteristics from female 
and male abalone, but that female and male abalone are not very different in size and weight.";
ods text="~n";
ods text="In this part we want to distinguish between the three sexes based on dimensions and weights. Lat's try PCA first.";

* Try PCA;
ods text="Perform a correlation-based principal components analysis.";

proc princomp data=abalone;
    ods select Screeplot Eigenvalues Eigenvectors;
run;

ods text="To retain 80% of the variation in the original variables, we would need to keep the first 1 principal component. The average eigenvalue 
is 1, so we would also choose 1 component based on the average eigenvalue criterion. The scree plot becomes fairly flat 
after the third component, so we would choose 3 based on this criterion. A case could also be made for one 
component based on the scree plot given the large drop from the first to the second component and then much 
smaller drop from the second to the third. We choose to have 1 component.";

ods text="~n";
ods text="Looking at the first component, all of the coefficients are positive. All parameters in size and weight are around
 0.36 or 0.37, so this is basically a weighted average of the measurements. The measurements with largest 
coefficients have the most impact, but all have a positive relationship.";

ods text="~n";
ods text="In this case, PCA will not help us to distinguish between the three sexes.";

* stepwise discriminant analysis;
ods text="~n";
ods text="Let's try stepwise discriminant analysis.";

proc stepdisc data=abalone sle=.05 sls=.05;
   	class sex;
   	var length--shell_weight;
	ods select Summary;
run;

ods text="The stepwise procedure keep the predictors of diameter, gut_weight, meat_weight, height, length and whole_weight. Only remove
 Shell weight.";

proc discrim data=abalone crossvalidate crosslisterr manova pool=test;
	class sex;
	var length--gut_weight;
	priors prop;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;

ods text="Based on the Test of Homogeneity of Within Covariance Matrices, we use QDA in this case.";
ods text="23.79 percent of females are correctly classified. 86.59 percent of infants are correctly classified which is a pretty high rate.
 49.61 percent of the males are correctly classified, not that bad. As we can see, the error rate of infants is the lowest, and it's much better hard
  to well classify female or male. Among the three, females classification performs the worst.";

ods startpage=now;
ods text="Question 4";
ods text="~n";

ods text="In this part, we want to understand how final meat weight is related to dimensions, whole weight, age(rings), and sex.";

ods text="Let's try general linear model first.";

/* get cell means and counts for sex */
proc tabulate data=abalone;
	class sex;
	var length diameter height whole_weight rings;
	table sex,
		(length diameter height whole_weight rings)*(mean n);
run;

ods text="From the table above, clearly, there is quite a bit of variation in the cell means. However, we only have one categorical predictor, so we
 can still the normal means(cell means) rather than least squares means.";

proc glm data=abalone  plots=diagnostics;
	class sex;
	model meat_weight=length diameter height whole_weight rings sex ;
	output out=diagnostics_glm cookd= cd;
run;
ods text="~n";
ods text="This model works great with a very small p value based on F statistic and R Square is 0.955808, which is pretty good. All of the predictors
we considered perform great with small p value based on both of the Type I and Type III error.";

ods text="As for the fit diagnostics plots. It looks like the residuals start to spread out as predicted value increases. 
Therefore the constant variance assumption may be violated. It's possible that a log-transformation or square root of meat weight would 
reduce the heteroscedasticity.";
ods text="~n";
ods text="As for the leverage plot, there is one point that has large leverage. So we can consider to remove that specific data point. 
Also, we notice there is one point with a large cooks distance. All other points look great. The quantile plot is not too far from straight except some
 points at the two sides and the histogram is not too far from bell-shaped, so the normality assumption should be fine.";

ods text="~n";

* look at points with Cook distance greater than 1;
proc print data=diagnostics_glm;
	where cd > 1;
run;
ods text="We get to know that observation 2052 is a high influential point. Remove that and re-try the model.";

* re-fit the model;
proc glm data=diagnostics_glm  plots=diagnostics;
	class sex;
	where cd<1;
	model meat_weight=length diameter height whole_weight rings sex ;
run;
ods text="R square is a little bit higher with 0.956126. But the predictor of diameter becomes not significant. So remove this predictor and re-fit
 the model.";
 
 * remove diameter;
proc glm data=diagnostics_glm;
	class sex;
	where cd<1;
	model meat_weight=length height whole_weight rings sex/ solution ;
run;

ods text="~n";
ods text="Now all of the predictors look great with high significance. And the R square is 0.956100.";
ods text="The expected meat weight will increase 0.17 if length increases 1 unit and 0.456 if whole_weight increases 1 unit. 
But the expected meat weight decreases -.297 for 1 unit increase in height and -.0098 for 1 unit increase in rings. As for sex, 
the expected meat weight will decrease -.0091 of being female than male. And decrease -.0041 of being infant than male for abalones.";

ods text="~n";
ods text="Let's consider gamma model with log link. And check if that model works better.";
proc genmod data=abalone plots=(stdreschi stdresdev);
	class sex;
	model meat_weight=length diameter height whole_weight rings sex/ dist=gamma link=log type1 type3;
	output out = gammares pred = predbp stdresdev = sdevres;
run;

ods text="As we mentioned, this is a gamma model with log link. The Scaled Deviance is roughly 1 so no need to consider overdispersion problem. 
The type 1 and type 3 analyses tell us that the length, diameter, height, whole_weight, rings and sex all have a significant relationship with
 meat weight. Since all six predictors are significant, this is the final model.";

ods text="~n";
ods text="Specifically, we would expect meat weight to be multiplied by exp(4.5453) if length increase 1 unit. And 
meat weight to be multiplied by exp(2.5323) if diameter increase 1 unit. And meat weight to be multiplied by exp(1.5853) if 
height increase 1 unit. But the expected meat weight will increase exp(-0.0682) which is less than 1 if whole_weight increases 1 unit. And increase
 exp(-0.0159) if rings increases 1 unit. What's more, we would expect meat weight to increase exp(-0.0252) of being female than male. And exp(-0.0318)
  of being female compared to male.";
ods text="However, we will still use the general linear model since it has lower AIC and BIC.";

ods startpage=now;
ods text="Question 5";
ods text="~n";

ods text="For this part, we want to group abalone based on size and weight characteristics and check whether 
those groups are consistent with the sexes in some way. Also, we can consider using subsets or transformations of the 
possible predictors to improve grouping if necessary.";

ods text="To do cluster analysis, let's use univariate analysis to identify extreme observations first.";

* use univariate analysis to identify extreme observations;
proc univariate data=abalone;
  var length--shell_weight;
  ods select ExtremeObs;
run;

ods text="There are 2052 observations have extreme value 1.130 in height. So these data definitly should be moved. As for whole_weight, 
there are 237 extreme observations with value 0.0020 which should be also removed. And we also got 164 extreme observations 
with value 1.005 for shell_weight.";

*remove extreme observations in height, whole_weight and shell_weight;
data abalone_cleaned;
  set abalone;
  if height < 0.6 and whole_weight > 0.002 and shell_weight < 1;
run;

ods text="After removing the extreme observations, we can start to do clustering analysis. Since all three sizes measurements are labeled in
 mm, but in grams for four weight measurements. So standardize these measurements would be a good idea. 
 Let's use complete linkage and obtain ccc values for number of clusters here.";

* variables are on very different scales, so standardize measurements;
* get ccc and pseudo t^2 and F stats and diagnostic plots for average linkage case;

proc cluster data=abalone_cleaned method=average ccc pseudo print=15 outtree=abalone_average plots=all;
	var length diameter height whole_weight meat_weight gut_weight shell_weight;
   	copy sex;
	ods select ClusterHistory Dendrogram CccPsfAndPsTSqPlot;
run;

ods text="From the CCC, and pseudo F and t-squared plots, 3 looks like a good choice for the number of clusters based on 
each criterion. We see peaks at clusters for the CCC and pseudo F statistics, and we see a pretty big jump from 2 
clusters to 3 clusters for the pseudo t-squared statistic.";

proc tree data=abalone_average ncl=3 out=outs noprint;
   copy sex length -- shell_weight;
run;

proc sort data=outs;
	by cluster;
run;

proc means data=outs;
	var length -- shell_weight;
	by cluster;
run;

ods text="Comparing the clusters, cluster1 has the smallest mean value of length, diameter and height. Cluster3 has all of these three size measurements
with the largest value. The same conclusions can be made for weights, that cluster3 has the largest mean values and then cluster2 and cluster1 the least.";

proc freq data=outs;
	tables cluster*sex/ norow;
run;

ods text="We can see most of the females(63.30 percent) are in cluster1. 81.06 percent of infants are in cluster1, 18.57 percent in cluster2 and
 nearly none of them are in cluster3. As for males, 25.33 percent are in cluster1, 61.65 percent in cluster2 and 13.02 percent in cluster3. So cluster3
  has simular number of females and males.";


ods text="From the previous analysis. All the three measurements in size do not perform that obvious difference among clusters. So let's take 
the exponential transformation of these three predictors.";

data abalone_exp;
	set abalone_cleaned;
	exp_length = exp(length);
	exp_diameter = exp(diameter);
	exp_height = exp(height);
	whole_weight = whole_weight;
	gut_weight = gut_weight;
	shell_weight = shell_weight;
	meat_weight = meat_weight;
run;

* variables are on very different scales, so standardize measurements;
* get ccc and pseudo t^2 and F stats and diagnostic plots for average linkage case;

proc cluster data=abalone_exp method=average ccc pseudo print=15 outtree=abalone_exp_average plots=all;
	var exp_length exp_diameter exp_height whole_weight meat_weight gut_weight shell_weight;
   	copy sex;
	ods select ClusterHistory Dendrogram CccPsfAndPsTSqPlot;
run;

ods text="From the CCC, and pseudo F and t-squared plots, 5 looks like a good choice for the number of clusters based on 
each criterion.";

proc tree data=abalone_exp_average ncl=5 out=outs_exp noprint;
   copy sex exp_length exp_diameter exp_height whole_weight meat_weight gut_weight shell_weight;
run;

proc sort data=outs_exp;
	by cluster;
run;

proc means data=outs_exp;
	var exp_length exp_diameter exp_height whole_weight meat_weight gut_weight shell_weight;
	by cluster;
run;

ods text="exp_length and exp_diameter perform much better and become easier to distinguish, but the differences in exp_height are still small among 5
 clusters. Just like the previous clustering version, all of our predictors tend to have larger mean value from cluster1 to cluster5 one by one.";

proc freq data=outs_exp;
	tables cluster*sex/ norow;
run;

ods text="35.56 and 43.45 percent of females are grouped into cluster2 and cluster3 respectively. 69.35 percent of infants are grouped into cluster1.
 36.78 and 38.02 percent of males are grouped into cluster2 and cluster3. Also remember they have larger values of measurements if they are 
 in a group with larger cluster number. However, it seems like using the exponential transformation for 3 predictors in 
 size does not improve the clustering.";





























































