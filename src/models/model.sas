* Variable selection for different rural-urban indicators ;
proc lifetest plots=s(test atrisk) notable data=los;
time length_of_stay*censor(1); 
test rucc age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code;
title "RUCC"
run;

proc lifetest plots=s(test atrisk) notable data=los;
time length_of_stay*censor(1); 
test nchs age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code;
title "NCHS"
run;

proc lifetest plots=s(test atrisk) notable data=los;
time length_of_stay*censor(1); 
test ruca age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code;
title "RUCA"
run;

proc lifetest plots=s(test atrisk) notable data=los;
time length_of_stay*censor(1); 
test density age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code;
title "Density"
run;



* Testing different rural-urban indicators ;
proc phreg data=los;
class age_group race insurance gender type_of_admission apr_medical_surgical_description;
model length_of_stay*censor(1)=rucc ruca age_group race apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender type_of_admission apr_medical_surgical_description;
title "RUCC"
run;

proc phreg data=los;
class age_group race insurance gender type_of_admission apr_medical_surgical_description;
model length_of_stay*censor(1)=nchs ruca age_group race apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender type_of_admission apr_medical_surgical_description;
title "NCHS"
run;

proc phreg data=los;
class age_group race ethnicity insurance gender type_of_admission apr_medical_surgical_description;
model length_of_stay*censor(1)=ruca age_group race ethnicity apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender type_of_admission apr_medical_surgical_description;
title "RUCA"
run;

proc phreg data=los;
class age_group race insurance gender type_of_admission apr_medical_surgical_description;
model length_of_stay*censor(1)=density ruca age_group race apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender type_of_admission apr_medical_surgical_description;
title "Density"
run;



* Survival curves ;
proc lifetest plots=s(test atrisk) notable data=los;
time length_of_stay*censor(1); 
strata ruca / adjust=tukey;
run;
 


* The candidate model ;
proc phreg data=los;
class age_group race ethnicity insurance gender type_of_admission apr_medical_surgical_description;
model length_of_stay*censor(1)=ruca age_group race ethnicity apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender type_of_admission apr_medical_surgical_description / rl;
hazardratio ruca / units=6;
run;



* Checking PH assumption of RUCA with LLS curves ;
proc lifetest data=los plots=(lls ls s) notable;
time length_of_stay*censor(1);
strata ruca;
title 'Checking the PH assumption using the log-log survival plots for LOS';
run;



* Checking PH assumption using time-dependent covariates ;
proc phreg data=los;
model length_of_stay*censor(1)=ruca age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code rucaLOS age_groupLOS raceLOS ethnicityLOS apr_risk_of_mortality_codeLOS apr_severity_of_illness_codeLOS insuranceLOS genderLOS type_of_admissionLOS apr_medical_surgical_LOS / rl;
rucaLOS=ruca*length_of_stay;
age_groupLOS=age_group_code*length_of_stay;
raceLOS=race_code*length_of_stay;
ethnicityLOS=ethnicity_code*length_of_stay;
apr_risk_of_mortality_codeLOS=apr_risk_of_mortality_code*length_of_stay;
apr_severity_of_illness_codeLOS=apr_severity_of_illness_code*length_of_stay;
insuranceLOS=insurance*length_of_stay;
genderLOS=gender_code*length_of_stay;
type_of_admissionLOS=type_of_admission_code*length_of_stay;
apr_medical_surgical_LOS=apr_medical_surgical_code*length_of_stay;
global_proportionality_test: test rucaLOS, age_groupLOS, raceLOS, ethnicityLOS, apr_risk_of_mortality_codeLOS, apr_severity_of_illness_codeLOS, insuranceLOS, genderLOS, type_of_admissionLOS, apr_medical_surgical_LOS;
run;



* Checking PH assumption using Schoenfeld residuals ;
* RUCA is unable to be assessed as it runs out of memory, perhaps due to RUCA having 7 different levels? ;
proc phreg data=los;
model length_of_stay*censor(1)=age_group_code race_code ethnicity_code apr_risk_of_mortality_code apr_severity_of_illness_code insurance gender_code type_of_admission_code apr_medical_surgical_code;
output out=sch ressch=schage_group schrace schethnicity schapr_risk_of_mortality_code schapr_severity_of_illness_code schinsurance schgender schtype_of_admission schapr_medical_surgical;

data schoenfeld;
set sch;
if censor=0;
ldays=log(length_of_stay);  
days2=length_of_stay**2;
proc rank out=ranked1 ties=mean; var ldays; ranks ldaysrank;
proc corr data=ranked1 nosimple;  
var schage_group schrace schethnicity schapr_risk_of_mortality_code schapr_severity_of_illness_code schinsurance schgender schtype_of_admission schapr_medical_surgical; with ldaysrank;
run;
