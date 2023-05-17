# Chemical Compounds and The Age of Carpets Using SAS
Testing carpet samples for chemical compounds to determine their age using SAS. I use logistic regression in SAS Studio with a dataset from "Age Estimation of Old Carpets Based on Cystine and Cysteic Acid Content." 
### Getting Started

To begin the project, you'll need to download the following dataset: [Age Estimation of Old Carpets Based on Cystine and Cysteic Acid Content](https://users.stat.ufl.edu/~winner/data/carpet_age.txt). 

*Source: J. Csapo, Z. Csapo-Kiss, T.G. Martin, S. Folestad, O. Orwar,
 A. Tivesten, and S. Nemethy (1995). "Age Estimation of Old Carpets Based
on Cystine and Cysteic Acid Content," Analytica Chimica Acta, Vol. 300, 
pp. 313-320.*

### Prerequisites

You will need to download [SAS](https://www.sas.com/en_ca/learn/academic-programs/software.html) in order to run the code. 
More details on how to install SAS on a Windows machine are [here](https://kb.wisc.edu/msndata/page.php?id=114986).

### Creating the Q-Q Plot

Our covariates are the four organic compounds--Cysteic Acid, Cystine, Methionine, and Tyrosine. The first step I did was creating a QQ-plot in order to see if our residuals follow a normal pattern.

```
proc reg DATA=dg.carpet plots(only)=QQPLot;
model age=cys_acid cys met tyr;
ods select QQPlot;
run;

```
<img width="399" alt="Screenshot 2023-05-16 211755" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/5488c063-d041-4484-861d-2f952f134433">

Make sure to import the data file correctly before creating your Q-Q plot. The plot should look like this:

<img width="392" alt="Screenshot 2023-05-16 212054" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/8e5f7bd9-bbd2-4000-ad6e-22e3c6305d19">

### Plotting the Residuals

Although it is lightly tailed on both ends, the data seems to be normally distributed, which is what we want.
To further rectify that there is a linear relationship, we can plot the residuals, which are the differences between our observed and predicted values. Ideally, we want our plot of the residuals to look totally random, even if there are symmetrically distributed clouds of points.

```
data subset;
set dis2.carpet;
if age=. then delete;

option obs=1000;

```
```
proc corr data=subset plots=matrix;
var age cys_acid cys met tyr;

option obs=1000;

```

```
proc reg data=subset;
model age=cys_acid cys met tyr;
output out=dis2.carpet;

```
<img width="419" alt="Screenshot 2023-05-16 212748" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/ce99de20-6359-4233-8608-f9e0bbdf582b">


Your model should look like the image below:

<img width="530" alt="Screenshot 2023-05-16 212847" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/09af143b-e1d2-4976-94bc-d1330dc71809">

### Findings

In the case that there is a distinct pattern, outliers, or shape, we can further improve themodel. We can see in Figure 2, I’ve modelled the residual plots for each of our four covariates respectively. There doesn’t seem to be a distinct pattern so we can check off these assumptions: the variance must have a mean of and the variance of the error terms must be constant.

### Final Data Summary 

Doing a data summary, we can take note that cysteic acid has the smallest p-value and thus a minimal effect on the age of our wood samples. In any case for any of the four covariates, you would fail to reject a null hypothesis for alpha equals 0.01. All of the compounds have F-values less than 1%.

```
proc contents data = carpet;

```
```

proc reg data = carpet; 
model age = cys;

```
```
proc reg data = carpet;
model age = met;
```
Your output should look like this procedure for the regression of our model. Make sure to accompany the PROC REG statement with a MODEL statement to specify the regression models. 

<img width="311" alt="Screenshot 2023-05-16 213433" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/e558f164-05fc-4c17-8c5e-f5a6067572d2">

### Checking With A Log Transformation 

Our adjusted coefficient of determination is approximately 0.9946—implying that 99.46% of our Cysteic Acid, Cystine, Methionine, and Tyrosine’s variation can be explained by our linear model. Though it isn’t quite 1, the regression predictions almost perfectly fit the data, so we’re on the right track. I tried playing around and doing a logarithmic transformation on age but didn’t really see a difference (i.e, expecting a tighter QQ-plot for the data but instead getting Figure 3). For this
reason, I would suggest sticking to the first model since we would have a coefficient of determination closest to one and better results overall.

```
data work.transform;
set WORK.IMPORT;
log_age=log(age);
log_cys_acid=log(cys_acid);
log_cys=l0g(cys);
run;

```
<img width="234" alt="Screenshot 2023-05-16 214119" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/9d13462f-b519-4ce0-b11b-8a999e800b6e">

The Q-Q plot for the log transformed age category:

<img width="476" alt="Screenshot 2023-05-16 213944" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/04363919-39b0-43eb-8199-7c20428b467d">

We can assess the quality of the fit with the 'Fit Diagnostic' function. 

<img width="401" alt="Screenshot 2023-05-16 213959" src="https://github.com/AneesahG/-Chemical-Compounds-Age-SAS/assets/133827224/ac4bc1ab-01e4-4e38-bc74-94ba73d39bf1">

# Thank you for reading!
