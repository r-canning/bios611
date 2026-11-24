SHELL := /bin/bash -l

.PHONY: clean

clean:
	rm -f data/*

#create list of available variables
data/dict_sub.RDS: rawdata/CollegeScorecardDataDictionary.xlsx\
 work/pgm/variable.R
	Rscript work/pgm/variable.R
	
#use 2025 data to subset to institutions of interest
work/data/unitid1.txt work/data/unitid2.txt work/data/unitid3.txt work/data/unitid4.txt:\
 work/rawdata/MERGED2025_26_PP.csv\
 work/pgm/ids.R
	Rscript work/pgm/ids.R

#subset 2024 data to available variables
#calculate in/out of state totals and percentages
data/ipeds_state.RDS: work/rawdata/ipedsData_11-11-2026---1.csv\
 work/rawdata/ipedsData_11-11-2026---2.csv\
 work/rawdata/ipedsData_11-11-2026---3.csv\
 work/rawdata/ipedsData_11-11-2026---4.csv\
 work/rawdata/MERGED2024_25_PP.csv\
 work/data/dict_sub.RDS\
 work/pgm/in_out_state_calc.R
	Rscript work/pgm/in_out_state_calc.R
	
#remove institutions and variables with high missing
data/ipeds_state_na_rm.RDS work/data/dict_sub2.RDS: data/ipeds_state.RDS\
 work/pgm/missing_remove.R
	Rscript work/pgm/missing_remove.R

