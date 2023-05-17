libname dis2 '/folders/myfolders/';
proc import datafile = '/folders/myfolders/carpet_age.csv'
out = carpets
dbms = csv;

proc contents data = carpet;

proc reg data = carpet;
model age= csv;

proc reg data =carpet;
model age = met;

proc reg DATA=dg.carpet plots(only)=QQPLot;
model age=cys_acid cys met tyr;
ods select QQPlot;
run;

data subset;
set dis2.carpet;
if age=. then delete;

option obs=1000;

proc corr data=subset plots=matrix;
var age cys_acid cys met tyr;

option obs=1000;

proc reg data=subset;
model age=cys_acid cys met tyr;
output out=dis2.carpet;

proc contents data = carpet;

proc reg data = carpet; 
model age = cys;

proc reg data = carpet;
model age = met;

# For the logarithmic transformation on age.

data work.transform;
  set WORK.IMPORT;
  log_age=log(age);
  log_cys_acid=log(cys_acid);
  log_cys=l0g(cys);
run;

