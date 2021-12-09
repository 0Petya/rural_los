* Written by R;
*  write.foreign(., datafile = "../../data/processed/hospitalization.csv",  ;

DATA  rdata ;
LENGTH
 fst3 $ 3
 hospital_service_area $ 15
 hospital_county $ 11
 operating_certificate_number $ 7
 permanent_facility_id $ 6
 facility_name $ 79
 age_group $ 8
 gender $ 1
 race $ 22
 ethnicity $ 17
 type_of_admission $ 9
 patient_disposition $ 37
 ccs_diagnosis_code $ 4
 ccs_diagnosis_description $ 114
 ccs_procedure_code $ 3
 ccs_procedure_description $ 23
 apr_drg_code $ 3
 apr_drg_description $ 89
 apr_mdc_code $ 2
 apr_mdc_description $ 100
 apr_severity_description $ 8
 apr_risk_of_mortality $ 8
 apr_medical_surgical_description $ 8
 payment_typology_1 $ 25
 payment_typology_2 $ 25
 payment_typology_3 $ 25
 birth_weight $ 5
 abortion_edit_indicator $ 1
 emergency_department_indicator $ 1
;

INFILE  "/home/u59144282/rural_los/hospitalization.csv" 
     DSD 
     LRECL= 668 ;
INPUT
 fst3
 population
 area
 density
 hospital_service_area
 hospital_county
 operating_certificate_number
 permanent_facility_id
 facility_name
 age_group
 gender
 race
 ethnicity
 length_of_stay
 type_of_admission
 patient_disposition
 discharge_year
 ccs_diagnosis_code
 ccs_diagnosis_description
 ccs_procedure_code
 ccs_procedure_description
 apr_drg_code
 apr_drg_description
 apr_mdc_code
 apr_mdc_description
 apr_severity_of_illness_code
 apr_severity_description
 apr_risk_of_mortality
 apr_medical_surgical_description
 payment_typology_1
 payment_typology_2
 payment_typology_3
 birth_weight
 abortion_edit_indicator
 emergency_department_indicator
 total_charges
 total_costs
 censor
 insurance
 rucc
 nchs
 ruca
;
RUN;

data los;
set rdata;

if apr_risk_of_mortality = 'Minor' then apr_risk_of_mortality_code = 1;
if apr_risk_of_mortality = 'Moderate' then apr_risk_of_mortality_code = 2;
if apr_risk_of_mortality = 'Major' then apr_risk_of_mortality_code = 3;
if apr_risk_of_mortality = 'Extreme' then apr_risk_of_mortality_code = 4;

if age_group = '0 to 17' then age_group_code = 1;
if age_group = '18 to 29' then age_group_code = 2;
if age_group = '30 to 49' then age_group_code = 3;
if age_group = '50 to 69' then age_group_code = 4;
if age_group = '70+' then age_group_code = 5;

if race = 'Black/African American' then race_code = 1;
if race = 'Multi-racial' then race_code = 2;
if race = 'Other Race' then race_code = 3;
if race = 'White' then race_code = 4;

if ethnicity = 'Multi-ethnic' then ethnicity_code = 1;
if ethnicity = 'Not Span/Hispanic' then ethnicity_code = 2;
if ethnicity = 'Spanish/Hispanic' then ethnicity_code = 3;
if ethnicity = 'Unknown' then ethnicity_code = 4;

if gender = 'F' then gender_code = 1;
if gender = 'M' then gender_code = 2;

if type_of_admission = 'Elective' then type_of_admission_code = 1;
if type_of_admission = 'Emergency' then type_of_admission_code = 2;
if type_of_admission = 'Newborn' then type_of_admission_code = 3;
if type_of_admission = 'Not Available' then type_of_admission_code = 4;
if type_of_admission = 'Trauma' then type_of_admission_code = 5;
if type_of_admission = 'Urgent' then type_of_admission_code = 6;

if apr_medical_surgical_description = 'Medical' then apr_medical_surgical_code = 1;
if apr_medical_surgical_description = 'Surgical' then apr_medical_surgical_code = 2;
if apr_medical_surgical_description = 'Not Applicable' then apr_medical_surgical_code = 3;

run;