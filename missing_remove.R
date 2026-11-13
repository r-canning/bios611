library(tidyr)
library(dplyr)

ipeds_state <- readRDS("work/data/ipeds_state.RDS")

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
ipeds_state <- ipeds_state %>% select(-any_of(high)) %>% select(-any_of(state_cols))

#see missingness for each institution. 
ipeds_state$na_count <- rowSums(is.na(ipeds_state[]))
ipeds_state$na_pct <- with(ipeds_state, na_count/nrow(ipeds_state))

#not bad. 
summary(ipeds_state$na_pct)
hist(ipeds_state$na_pct)

#remove institutions with over 10% missing (N = 82);
ipeds_state<-subset(ipeds_state, na_pct < .10,)

saveRDS(ipeds_state, "work/data/ipeds_state_na_rm.RDS")
