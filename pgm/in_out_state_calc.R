library(readr)
library(dplyr)
ipeds1 <- read_csv("work/rawdata/ipedsData_11-11-2026---1.csv")
ipeds2 <- read_csv("work/rawdata/ipedsData_11-11-2026---2.csv")
ipeds3 <- read_csv("work/rawdata/ipedsData_11-11-2026---3.csv")
ipeds4 <- read_csv("work/rawdata/ipedsData_11-11-2026---4.csv")
raw <- read_csv("work/rawdata/MERGED2024_25_PP.csv")
dict_sub <- readRDS("work/data/dict_sub.RDS")

ipeds <- rbind(ipeds1,ipeds2)
ipeds <- rbind(ipeds,ipeds3)
ipeds <- rbind(ipeds,ipeds4)

names(ipeds)[33:84] <- sub(".*\\((.*)\\).*", "\\1", names(ipeds)[33:84])
names(ipeds)[33:84] <-gsub(" ", "_",gsub("-", "_",sub("\\s*\\([^()]*\\)$", "", names(ipeds)[33:84])))

names(ipeds)[15:19] <- sub(".*\\((.*)\\).*", "\\1", names(ipeds)[15:19])
names(ipeds)[15:19] <-gsub(" ", "_",gsub("-", "_",sub("\\s*\\([^()]*\\)$", "", names(ipeds)[15:19])))

names(ipeds)[2:14] <- gsub(" ", "_",gsub("-", "_",sub("\\s*\\([^()]*\\)$", "", names(ipeds)[2:14])))
names(ipeds)[20:32] <- gsub(" ", "_",gsub("-", "_",sub("\\s*\\([^()]*\\)$", "", names(ipeds)[20:32])))


ipeds <- subset(ipeds, select = -c(Students_from_the_full_time_adjusted_fall_2023_cohort_enrolled_in_fall_2024, 
                                   Students_from_the_part_time_adjusted_fall_2023_cohort_enrolled_in_fall_2024,
                                   Inclusions_to_the_part_time_fall_2023_cohort,
                                   Exclusions_from_part_time_fall_2023_cohort,
                                   Inclusions_to_the_full_time_fall_2023_cohort,
                                   Exclusions_from_full_time_fall_2023_cohort))


raw_sub <- subset(raw, select = dict_sub$`VARIABLE NAME`)
                               
all <- merge(ipeds, raw_sub, by.x="UnitID", by.y="UNITID", all.x = TRUE)  
all <- subset(all, !(STABBR %in% c("AS","GU","MP","PR","FM","VI","MH")))

state <- all[,c(1,27:77,84)]

state_cols <- c(
  "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL",
  "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME",
  "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH",
  "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI",
  "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI",
  "WY"
)

colnames(state)[2:52]<-state_cols


state_count <- state %>%
  rowwise() %>%
  mutate(
    in_state = get(STABBR),
    out_state = rowSums(across(all_of(state_cols)), na.rm = TRUE) - in_state,
    total = in_state+out_state,
    in_state_pct = in_state/total,
    out_state_pct = out_state/total
  ) %>%
  ungroup()


all2 <- merge(all, state_count[,c(1,54:58)], by="UnitID", all.x = TRUE)


saveRDS(all2, "work/data/ipeds_state.RDS")
