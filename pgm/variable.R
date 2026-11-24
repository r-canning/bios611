library(readxl)

dict <- read_excel("work/rawdata/CollegeScorecardDataDictionary.xlsx",sheet = "Institution_Data_Dictionary")
map <- read_excel("work/rawdata/CollegeScorecardDataDictionary.xlsx",sheet = "Institution_Cohort_Map")

map_sub <- subset(map, map$`MERGED_2024-25 datafile` != "NA")
dict_sub <- subset(dict, dict$`VARIABLE NAME` %in% map_sub$`Variable Name`)

saveRDS(dict_sub, file = "work/data/dict_sub.RDS")
