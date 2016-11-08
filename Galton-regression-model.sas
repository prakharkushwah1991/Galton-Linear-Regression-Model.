/*Create a working directory*/
libname wd "/folders/myfolders";

/*Import the Galton dataset*/
data WD.galton;
infile '/folders/myfolders/learning/galton.txt' delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2 ;
	informat Family $4. ;
	informat Father best32. ;
	informat Mother best32. ;
	informat Gender $1. ;
	informat Height best32. ;
	informat Kids best32. ;
	format Family $4. ;
	format Father best12. ;
	format Mother best12. ;
	format Gender $1. ;
	format Height best12. ;
	format Kids best12. ;
	input
	Family $	
	Father
	Mother
	Gender $
	Height
	Kids
	;
run;

*total mean = 66.76, Fbar = 64.11, Mbar = 69.23;
data wd.galton_0;
	set wd.galton;
	Parent_avg_M = (Father + Mother) / 2;
	if Gender = 'F' then Y_bar_Gender_M = 64.11;
	else Y_bar_Gender_M = 69.23;
	Y_bar_M = 66.76;
run;

data wd.galton_0;
	set wd.galton_0;
	SSE_1 = (Height - Parent_avg_M) ** 2;
	SSE_2 = (Height - Y_bar_Gender_M) ** 2;
	SSE_3 = (Height - Y_bar_M) ** 2;
run;

proc print data = wd.galton_0;
	var SSE_1 SSE_2 SSE_3;
	sum SSE_1 SSE_2 SSE_3;
run;

proc reg data = wd.galton;
	model Height = Father;
run;

data wd.galton_0;
	set wd.galton_0;
	Father_reg = 39.11039 + 0.39938 * Father;
	SSE_4 = (Height - Father_reg) ** 2;
run;

proc print data = wd.galton_0;
	var SSE_1 SSE_2 SSE_3 SSE_4;
	sum SSE_1 SSE_2 SSE_3 SSE_4;
run;

/*Galton data*/
/*EDA - Initial*/
proc contents data = wd.galton;
run;

proc print data = wd.galton;
	var Father Mother Height;
run;

proc corr data = wd.galton;
run;

proc insight data = wd.galton;
	scatter Height * Father Mother Kids;
run; 

data wd.galton_1;
	set wd.galton;
	Parents = (Father + Mother) / 2;
	if Gender = 'F' then Gender_F = 1;
	else Gender_F = 0;
run;

proc corr data = wd.galton_1;
run;

proc gplot data = wd.galton_1;
	plot Height * Parents;
run;

proc gplot data = wd.galton_1;
	plot Height * Gender_F;
run;

proc means data = wd.galton;
	class Gender;
	var Height;
run;

proc freq data = wd.galton;
	table Gender;
run;

proc univariate data = wd.galton;
	var Height;
	histogram / cfill = gray;
run;

proc univariate data = wd.galton;
  var Height;
  histogram / cfill=gray normal;
run;

proc univariate data = wd.galton;
  var Height;
  histogram / cfill=gray normal kernel;
run;

proc univariate data = wd.galton;
  var Height;
  qqplot / normal;
run;


*Simple Linear Regression;
proc reg data = wd.galton_1;
	model Height = Parents;
run;

proc reg data = wd.galton_1;
	model Height = Parents;
	plot Height * Parents;
run;

proc reg data = wd.galton_1;
	model Height = Parents;
	plot Height * Parents / pred;
run;

proc reg data = wd.galton_1;
	model Height = Parents;
	plot residual. * predicted.;
run;

proc reg data = wd.galton_1;
	model Height = Parents;
	plot rstudent. * predicted.;
run;

*Multiple Linear Regression;
proc reg data = wd.galton_1;
	model Height = Parents Gender_F Kids;
	output out = wd.galton_2(drop = Father Mother)
		rstudent=r h=lev cookd=cd dffits=dffit;
run;
quit;

proc reg data = wd.galton_1;
	model Height = Parents Gender_F Kids;
run;

proc reg data = wd.galton_1;
	model Height = Parents Gender_F Kids;
	test_Parents: test Parents;
run;
                                                                                                                                                                                                                                                                                                         





