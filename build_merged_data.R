# build_merged_data.R
#
# Builds `data/merged_analysis_data.csv` — the analysis dataset used by
# `manuscript.Rmd` and `supplement.Rmd` — from three anonymized
# input files in `data/`.
#
# Inputs (all anonymized; safe to redistribute):
#   data/weibel_first_birth.csv         — derived from Weibel et al. (2020)
#   data/weibel_all_other_analyses.csv  — derived from Weibel et al. (2020)
#   data/rainfall_data.csv              — anonymized rainfall (Amboseli Baboon
#                                          Research Project, used with permission)
#
# Output:
#   data/merged_analysis_data.csv

library(tidyverse)

data_dir <- "data"

# ---- load inputs ----------------------------------------------------------
fb   <- read.csv(file.path(data_dir, "weibel_first_birth.csv"))
main <- read.csv(file.path(data_dir, "weibel_all_other_analyses.csv"))
rain <- read.csv(file.path(data_dir, "rainfall_data.csv"))

# ---- prepare each input for the merge -------------------------------------

# From first_birth: keep ID, age at first birth, controls, adversity.
# Rename cumulative_adversity_three_plus and group_size_females_first_birth
# to shorter names used in the analysis.
fb_clean <- fb %>%
  select(
    anon_sname,
    age_first_birth,
    cumulative_adversity = cumulative_adversity_three_plus,
    pop_growth_two_years,
    group_size           = group_size_females_first_birth
  )

# From all_other_analyses: convert log(IBI) (in days) into IBI in years,
# then keep what we need.
main_clean <- main %>%
  mutate(ibi_years = exp(avg_log_ibi) / 365.25) %>%
  select(anon_sname, lifespan_years, ibi_years, lrs)

# ---- merge ----------------------------------------------------------------
# Start with the first_birth sample (largest n; includes adversity controls)
# and left-join LRS/IBI/lifespan from all_other_analyses, then rainfall.
out <- fb_clean %>%
  left_join(main_clean, by = "anon_sname") %>%
  left_join(rain,       by = "anon_sname") %>%
  arrange(anon_sname)

# ---- write & summarize ----------------------------------------------------
write.csv(out, file.path(data_dir, "merged_analysis_data.csv"), row.names = FALSE)

cat("Wrote", nrow(out), "rows to", file.path(data_dir, "merged_analysis_data.csv"), "\n\n")
cat("Non-missing counts by column:\n")
for (col in names(out)) cat("  ", col, ":", sum(!is.na(out[[col]])), "\n")
