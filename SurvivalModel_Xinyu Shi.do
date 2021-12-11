log using "C:\Users\xinyushi\OneDrive - The University of Chicago\STATAPPPROJ.log",replace
infile v1 account_length international_plan voice_mail_plan number_vmail_messages total_day_minutes total_day_calls total_day_charge total_eve_minutes total_eve_calls total_eve_charge total_night_minutes total_night_calls total_night_charge total_intl_minutes total_intl_calls total_intl_charge number_customer_service_calls churn using "C:\Users\xinyushi\OneDrive - The University of Chicago\churn.csv", clear

summarize

*** change floating numbers into integers 
*gen int y3 = round(x)
gen int total_day_minute = round(total_day_minutes)
gen int total_day_charges = round(total_day_charge)

gen int total_night_minute = round(total_night_minutes)
gen int total_night_charges = round(total_night_charge)

gen int total_eve_minute = round(total_eve_minutes)
gen int total_eve_charges = round(total_eve_charge)

gen int total_intl_minute = round(total_intl_minutes)
gen int total_intl_charges = round(total_intl_charge)

describe

**** final model comparison ****** 
 * Proportional and non-proportional 
cloglog churn account_length international_plan voice_mail_plan ///
		total_day_charges ///
		total_eve_charges  ///
		total_night_charges  ///
		total_intl_charges total_intl_calls ///
		number_customer_service_calls,
estimates store M1
. estat ic		  


** Non-proportional 
cloglog churn account_length international_plan voice_mail_plan ///
		total_day_charges ///
		total_eve_charges  ///
		total_night_charges  ///
		total_intl_charges total_intl_calls ///
		number_customer_service_calls ///
		c.account_length#international_plan c.account_length#voice_mail_plan
estimates store M2
. estat ic
lrtest M1 M2


* Proportional and non-proportional (mixed effect )
mecloglog churn account_length international_plan voice_mail_plan ///
		total_day_charges ///
		total_eve_charges  ///
		total_night_charges  ///
		total_intl_charges total_intl_calls ///
		number_customer_service_calls || stateid: ,
estimates store M3
. estat ic

** Non-proportional 
mecloglog churn account_length international_plan voice_mail_plan ///
		total_day_charges ///
		total_eve_charges  ///
		total_night_charges  ///
		total_intl_charges total_intl_calls ///
		number_customer_service_calls ///
		c.account_length#international_plan c.account_length#voice_mail_plan || stateid: 
estimates store M4
. estat ic

lrtest M3 M4
est stats M1 M2 M3 M4

log close 