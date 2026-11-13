SHELL := /bin/bash -l

.PHONY: clean

clean:
	rm -f data/*

#create list of available variables
data/dict_sub.RDS: rawdata/CollegeScorecardDataDictionary.xlsx\
 variable.R
	Rscript variable.R
	
#use 2025 data to subset to institutions of interest
work/data/unitid1.txt work/data/unitid2.txt work/data/unitid3.txt work/data/unitid4.txt:\
 work/rawdata/MERGED2025_26_PP.csv\
 ids.R
	Rscript ids.R

#subset 2024 data to available variables
#calculate in/out of state totals and percentages
data/ipeds_state.RDS: work/rawdata/ipedsData_11-11-2026---1.csv\
 work/rawdata/ipedsData_11-11-2026---2.csv\
 work/rawdata/ipedsData_11-11-2026---3.csv\
 work/rawdata/ipedsData_11-11-2026---4.csv\
 work/rawdata/MERGED2024_25_PP.csv\
 work/data/dict_sub.RDS\
 in_out_state_calc.R
	Rscript in_out_state_calc.R
	
#remove institutions and variables with high missing
data/ipeds_state_na_rm.RDS: data/ipeds_state.RDS\
 missing_remove.R
	Rscript missing_remove.R

