library(readr)
raw <- read_csv("work/rawdata/MERGED2025_26_PP.csv")

table(raw$CCBASIC, raw$CCUGPROF)

cohort <- subset(raw, CCSIZSET %in% c(6:17) & MAIN == 1 & CURROPER == 1 & ICLEVEL == 1 & DISTANCEONLY == 0)

table(cohort$STABBR)
table(cohort$PREDDEG)
table(cohort$SCORECARD_SECTOR)

subset(cohort, select = c(INSTNM,LOCALE, SCORECARD_SECTOR), SCORECARD_SECTOR %in% c(7:12))


subset(cohort, select = INSTNM, PREDDEG==4)

summary(cohort$ADM_RATE)

subset(cohort, select = c(INSTNM, ADM_RATE), ADM_RATE<=.10)

# Start redirecting output to the file
writeLines(paste(cohort$UNITID[1:571], collapse = ","), "work/data/unitid1.txt")
writeLines(paste(cohort$UNITID[572:1142], collapse = ","), "work/data/unitid2.txt")
writeLines(paste(cohort$UNITID[1142:1712], collapse = ","), "work/data/unitid3.txt")
writeLines(paste(cohort$UNITID[1712:1996], collapse = ","), "work/data/unitid4.txt")

