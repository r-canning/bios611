library(tidyr)
library(dplyr)

ipeds_state <- readRDS("work/data/ipeds_state.RDS")
dict_sub <- readRDS("~/work/data/dict_sub.RDS")


state_cols <- colnames(ipeds_state)[27:77]

#see missingness in available variables
missing_table <- ipeds_state %>% select(-any_of(state_cols)) %>%
  summarise(across(
    everything(),
    list(
      count = ~sum(is.na(.)),
      percent = ~mean(is.na(.)) * 100
    )
  )) %>%
  pivot_longer(
    everything(),
    names_to = c("variable", ".value"),
    names_pattern = "(.*)_(count|percent)"
  ) %>%
  arrange(desc(percent))


summary(missing_table$percent)
hist(missing_table$percent)

#exclude variables with over 75% missing and exclude state enrollment
#decided I don't think I need those anymore. 
high <- subset(missing_table, percent >= 75)$variable

#update dict_sub
dict_sub2 <- subset(dict_sub, !(`VARIABLE NAME` %in% high))
saveRDS(dict_sub2, "work/data/dict_sub2.RDS")


ipeds_state <- ipeds_state %>% select(-any_of(high)) %>% select(-any_of(state_cols))

#see missingness for each institution. 
ipeds_state$na_count <- rowSums(is.na(ipeds_state[]))
ipeds_state$na_pct <- with(ipeds_state, na_count/nrow(ipeds_state))

#not bad. 
summary(ipeds_state$na_pct)
hist(ipeds_state$na_pct)

#remove institutions with over 10% missing (N = 82)
#also ensure the primary degree is bachelors degrees
ipeds_state<-subset(ipeds_state, na_pct < .10 & PREDDEG == 3)

#see distribution of total enrollment
summary(ipeds_state$total)
hist(ipeds_state$total)

subset(ipeds_state, select = c(UnitID, Institution_Name, CITY, STABBR, ADM_RATE,total,out_state_pct), total >8000)
subset(ipeds_state, select = c(UnitID, Institution_Name, CITY, STABBR, PREDDEG,HIGHDEG,ADM_RATE,total), total <100)

#consider removing those with less than 100 enrollment, it doesn't seem to be colleges I'm interested in
 
ipeds_state<-subset(ipeds_state, total > 100)


saveRDS(ipeds_state, "work/data/ipeds_state_na_rm.RDS")
