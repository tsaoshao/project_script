# OPEN SCIENCE ANALYSIS SCRIPT

# LOAD PACKAGES -----------------------------------------------------------

library(DescTools)
library(dplyr)
library(tidyr)
library(ggtext)
library(gmodels)
library(ggplot2)
library(car)
library(lsr)
library(haven)

# LOAD DATA ---------------------------------------------------------------

data_raw <- read_spss("01_OpenScience_RawData.sav")

# DESCRIPTIVE FREQUENCIES -------------------------------------------------

# Create labeled version for descriptive tables
data_labels <- as_factor(data_raw)

# Frequency per journal
table(data_labels$A02_Title_Journal)
table(data_labels$A05_OpenAccess)

# RQ1: FREQUENCIES --------------------------------------------------------

table(data_labels$TOP1_2)
table(data_labels$TOP_3)
table(data_labels$TOP_4Materials_1)
table(data_labels$TOP_4Materials_2)
table(data_labels$TOP_4Materials_3)
table(data_labels$TOP_4Materials_4)
table(data_labels$TOP_4Materials_5)
table(data_labels$TOP_4Materials_6)
table(data_labels$TOP_4Materials_9)
table(data_labels$TOP_4Materials_7)
table(data_labels$TOP_4Materials_8)
table(data_labels$TOP4_Survey)
table(data_labels$TOP4_Stimuli)
table(data_labels$TOP4_Codebook)
table(data_labels$TOP4_Interview)
table(data_labels$TOP4_Scripts)
table(data_labels$TOP4_searchstring)
table(data_labels$TOP4_Observat)
table(data_labels$TOP4_OtherMat)
table(data_labels$Data_TOP5)
table(data_labels$TOP5_notshared)
table(data_labels$TOP5_shared)
table(data_labels$TOP6_AnalyticCode)

# RQ1: PERCENTAGES --------------------------------------------------------

prop.table(table(data_labels$TOP1_2)) * 100
prop.table(table(data_labels$TOP_3)) * 100
prop.table(table(data_labels$TOP_4Materials_1)) * 100
prop.table(table(data_labels$TOP_4Materials_2)) * 100
prop.table(table(data_labels$TOP_4Materials_3)) * 100
prop.table(table(data_labels$TOP_4Materials_4)) * 100
prop.table(table(data_labels$TOP_4Materials_5)) * 100
prop.table(table(data_labels$TOP_4Materials_6)) * 100
prop.table(table(data_labels$TOP_4Materials_9)) * 100
prop.table(table(data_labels$TOP_4Materials_7)) * 100
prop.table(table(data_labels$TOP_4Materials_8)) * 100
prop.table(table(data_labels$TOP4_Survey)) * 100
prop.table(table(data_labels$TOP4_Stimuli)) * 100
prop.table(table(data_labels$TOP4_Codebook)) * 100
prop.table(table(data_labels$TOP4_Interview)) * 100
prop.table(table(data_labels$TOP4_Scripts)) * 100
prop.table(table(data_labels$TOP4_searchstring)) * 100
prop.table(table(data_labels$TOP4_Observat)) * 100
prop.table(table(data_labels$TOP4_OtherMat)) * 100
prop.table(table(data_labels$Data_TOP5)) * 100
prop.table(table(data_labels$TOP5_notshared)) * 100
prop.table(table(data_labels$TOP5_shared)) * 100
prop.table(table(data_labels$TOP6_AnalyticCode)) * 100


# RECODE TOP GUIDELINES TO DICHOTOMY FOR COMPOSITE TOP SCORE --------------
# 
# COMPOSITE TOP SCORE METHODOLOGY:
# - 6 research practices coded into dichotomous measures (0 = not transparent, 1 = transparent)
# - Score of 1 assigned if genuine effort made to (pre)register or share information per TOP guidelines
# - Composite score ranges from 0 (no practices met) to 6 (all practices met)
#
# SCORING BREAKDOWN:
# - TOP 1 & 2 (citation + data transparency): Combined item, scores 0 or 2
# - TOP 3, 5, 6: Each scores 0 or 1
# - TOP 4 (materials transparency): Proportional scoring 0-1
#   Example: Study using stimuli + questionnaire, only stimuli shared = 0.5 points (1/2 materials)


# TOP 1 and 2: Citation and Data Transparency (combined, 0 or 2) ----------

data_raw$TOP1_and_2_dich <- car::recode(data_raw$TOP1_2, "c(1,4)=2; c(2,3)=0")

# TOP 3: Preregistration (0 or 1) -----------------------------------------

data_raw$TOP_3_dich <- car::recode(data_raw$TOP_3, "c(3,4)=0; 5=1")

# TOP 4: Materials Transparency (proportional 0-1) ------------------------

# Recode each material type to dichotomous (1 = shared, 0 = not shared)
data_raw$TOP4_survey_dich <- car::recode(data_raw$TOP4_Survey, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_stimuli_dich <- car::recode(data_raw$TOP4_Stimuli, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_codebook_dich <- car::recode(data_raw$TOP4_Codebook, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_interview_dich <- car::recode(data_raw$TOP4_Interview, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_scripts_dich <- car::recode(data_raw$TOP4_Scripts, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_searchstring_dich <- car::recode(data_raw$TOP4_searchstring, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_observational_dich <- car::recode(data_raw$TOP4_Observat, "c(1,6,7)=1; c(2,3,4,5)=0")
data_raw$TOP4_othermaterial_dich <- car::recode(data_raw$TOP4_OtherMat, "c(1,6,7)=1; c(2,3,4,5)=0")

# Sum of materials shared (numerator)
data_raw$TOP4SumMaterials <- rowSums(data_raw[, c("TOP4_survey_dich", "TOP4_stimuli_dich", 
                                                  "TOP4_codebook_dich", "TOP4_scripts_dich", 
                                                  "TOP4_interview_dich", "TOP4_searchstring_dich", 
                                                  "TOP4_observational_dich", "TOP4_othermaterial_dich")], na.rm = TRUE)

# Total materials used in study
data_raw$Materialsused <- rowSums(data_raw[, c("TOP_4Materials_1", "TOP_4Materials_2", 
                                               "TOP_4Materials_3", "TOP_4Materials_4", 
                                               "TOP_4Materials_5", "TOP_4Materials_6", 
                                               "TOP_4Materials_9", "TOP_4Materials_7")], na.rm = TRUE)

# Proportional transparency score (shared / total used)
data_raw$TOP4_Transparency <- data_raw$TOP4SumMaterials / data_raw$Materialsused

# Verify range: 0 = nothing disclosed, 1 = all materials disclosed
min(data_raw$TOP4_Transparency, na.rm = TRUE)
max(data_raw$TOP4_Transparency, na.rm = TRUE)

# TOP 5: Data Sharing (0 or 1) --------------------------------------------

data_raw$TOP5_dich <- car::recode(data_raw$Data_TOP5, "1=1; 11=0")

# TOP 6: Analytic Code Sharing (0 or 1) -----------------------------------

data_raw$TOP6_dich <- car::recode(data_raw$TOP6_AnalyticCode, "c(1,4,5)=1; c(2,3,6,7,9)=0")

# CREATE COMPOSITE TOP SCORE (range: 0-6) ---------------------------------

data_raw$CompositeTOP_Score_withMaterials <- rowSums(data_raw[, c("TOP1_and_2_dich", "TOP_3_dich", 
                                                                  "TOP5_dich", "TOP6_dich", 
                                                                  "TOP4_Transparency")], na.rm = TRUE)

# Descriptive statistics
mean(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
median(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
Mode(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
sd(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
min(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
max(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)

# Re-sync data_labels after all new variables are computed
data_labels <- as_factor(data_raw)

# Summary table
summary_table_compositesc <- data.frame(
  Dataset = "data_raw",
  N = sum(!is.na(data_raw$CompositeTOP_Score_withMaterials)),
  Mean = mean(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE),
  Median = median(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE),
  Mode = Mode(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE),
  SD = sd(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE),
  Min = min(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE),
  Max = max(data_raw$CompositeTOP_Score_withMaterials, na.rm = TRUE)
)

summary_table_compositesc

# Disclosure frequency per study
table(data_raw$CompositeTOP_Score_withMaterials)
prop.table(table(data_raw$CompositeTOP_Score_withMaterials)) * 100

# RQ3: TOP RESEARCH PRACTICES ACROSS RESEARCH METHODS ---------------------

# Use data_labels for grouping (labels available), but CompositeTOP is numeric and synced
rq3_summary <- data_labels %>%
  group_by(A04_Method) %>%
  summarise(
    Mean = mean(CompositeTOP_Score_withMaterials, na.rm = TRUE),
    Count = n(),
    SD = sd(CompositeTOP_Score_withMaterials, na.rm = TRUE),
    Min = min(CompositeTOP_Score_withMaterials, na.rm = TRUE),
    Max = max(CompositeTOP_Score_withMaterials, na.rm = TRUE)
  )

print(rq3_summary)

# RQ3: Visualization ------------------------------------------------------

# Recode long SPSS labels to shorter display names for the plot
rq3_summary <- rq3_summary %>%
  mutate(A04_Method_Short = dplyr::recode(
    as.character(A04_Method),
    "Experiment (various types of experiments fall under this category, including longitudinal experiments)" = "Experiment",
    "Content analysis (quantitative or computational)" = "Quantitative content analysis",
    "Meta-analysis/ meta assessment" = "Meta-analysis",
    "Interview/Focus group" = "Interview or Focus group",
    "Other, please specify \u2026" = "Other (specified separately)",
    "Mixed methods qualitative" = "Mixed methods qualitative",
    "Mixed methods quantitative" = "Mixed methods quantitative",
    "Mixed methods qual/quan" = "Mixed methods qual/quan",
    .default = as.character(A04_Method)
  )) %>%
  filter(!is.na(A04_Method)) %>%
  # Use the short name, not the original long SPSS label
  mutate(A04_Method_label = paste0(A04_Method_Short, "<br>(*n* = ", Count, ")"))

ggplot(rq3_summary, aes(x = Mean, y = reorder(A04_Method_label, Mean))) +
  geom_col(fill = "grey50", width = 0.7) +
  labs(
    x = "Average Transparency and Openness Score",
    y = "Method"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.y = element_markdown(size = 10),
    axis.text.x = element_text(size = 10),
    axis.title = element_text(size = 11, face = "bold"),
    panel.grid.major.y = element_blank()
  ) +
  scale_x_continuous(limits = c(0, 6), expand = expansion(mult = c(0, 0.05)))

ggsave("TOPscoreXmethods_plotRQ3.png", 
       width = 10, height = 6, dpi = 900)

# RQ3: Visualization with Standard Error ----------------------------------

ggplot(rq3_summary, aes(x = Mean, y = reorder(A04_Method_label, Mean))) +
  geom_col(fill = "grey50", width = 0.7) +
  geom_errorbarh(aes(xmin = Mean - SD/sqrt(Count), xmax = Mean + SD/sqrt(Count)), 
                 height = 0.3) +
  labs(
    x = "Average Transparency and Openness Score",
    y = "Method"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.text.y = element_markdown(size = 10),
    axis.text.x = element_text(size = 10),
    axis.title = element_text(size = 11, face = "bold"),
    panel.grid.major.y = element_blank()
  ) +
  scale_x_continuous(limits = c(0, 6), expand = expansion(mult = c(0, 0.05)))

ggsave("TOPscoreXmethods_plotRQ3+SE.png", 
       width = 10, height = 6, dpi = 900)

# RQ4: TRANSPARENCY IN RESEARCH MATERIALS REPORTING -----------------------

table(data_labels$TOP4_Survey)
table(data_labels$TOP4_Stimuli)
table(data_labels$TOP4_Codebook)
table(data_labels$TOP4_Interview)
table(data_labels$TOP4_Scripts)
table(data_labels$TOP4_searchstring)
table(data_labels$TOP4_Observat)
table(data_labels$TOP4_OtherMat)

# RQ4: Data Preparation ---------------------------------------------------

# Material availability codes (numeric from SPSS):
# 1 = Yes, link provided
# 2 = Yes, statement (claimed but not retrievable)
# 3 = No, with justification
# 4 = No, without justification or mention
# 5 = Only upon request
# 6 = Yes, within article/appendix
# 7 = Partly available

survey_pct <- prop.table(table(data_raw$TOP4_Survey)) * 100
stimuli_pct <- prop.table(table(data_raw$TOP4_Stimuli)) * 100
codebook_pct <- prop.table(table(data_raw$TOP4_Codebook)) * 100
interview_pct <- prop.table(table(data_raw$TOP4_Interview)) * 100
scripts_pct <- prop.table(table(data_raw$TOP4_Scripts)) * 100
searchstring_pct <- prop.table(table(data_raw$TOP4_searchstring)) * 100
observat_pct <- prop.table(table(data_raw$TOP4_Observat)) * 100
othermat_pct <- prop.table(table(data_raw$TOP4_OtherMat)) * 100

# Helper function to safely extract percentage by numeric code (returns 0 if code not present)
get_pct <- function(pct_table, code) {
  val <- pct_table[as.character(code)]
  if (is.na(val)) return(0) else return(as.numeric(val))
}

rq4_summary <- data.frame(
  Material = c("Questionnaire", "Stimulus material", "Codebook", 
               "Interview or focus group protocol / guide", 
               "Scripts, data dictionary or prompts", "Search string", 
               "Observation protocol"),
  n = c(
    sum(!is.na(data_raw$TOP4_Survey)),
    sum(!is.na(data_raw$TOP4_Stimuli)),
    sum(!is.na(data_raw$TOP4_Codebook)),
    sum(!is.na(data_raw$TOP4_Interview)),
    sum(!is.na(data_raw$TOP4_Scripts)),
    sum(!is.na(data_raw$TOP4_searchstring)),
    sum(!is.na(data_raw$TOP4_Observat))
  ),
  External_platform = c(
    get_pct(survey_pct, 1),
    get_pct(stimuli_pct, 1),
    get_pct(codebook_pct, 1),
    get_pct(interview_pct, 1),
    get_pct(scripts_pct, 1),
    get_pct(searchstring_pct, 1),
    get_pct(observat_pct, 1)
  ),
  Within_article = c(
    get_pct(survey_pct, 6),
    get_pct(stimuli_pct, 6),
    get_pct(codebook_pct, 6),
    get_pct(interview_pct, 6),
    get_pct(scripts_pct, 6),
    get_pct(searchstring_pct, 6),
    get_pct(observat_pct, 6)
  ),
  Partly_available = c(
    get_pct(survey_pct, 7),
    get_pct(stimuli_pct, 7),
    get_pct(codebook_pct, 7),
    get_pct(interview_pct, 7),
    get_pct(scripts_pct, 7),
    get_pct(searchstring_pct, 7),
    get_pct(observat_pct, 7)
  ),
  Not_available_with_justification = c(
    get_pct(survey_pct, 3),
    get_pct(stimuli_pct, 3),
    get_pct(codebook_pct, 3),
    get_pct(interview_pct, 3),
    get_pct(scripts_pct, 3),
    get_pct(searchstring_pct, 3),
    get_pct(observat_pct, 3)
  ),
  Not_available_no_justification = c(
    get_pct(survey_pct, 4),
    get_pct(stimuli_pct, 4),
    get_pct(codebook_pct, 4),
    get_pct(interview_pct, 4),
    get_pct(scripts_pct, 4),
    get_pct(searchstring_pct, 4),
    get_pct(observat_pct, 4)
  ),
  Only_upon_request = c(
    get_pct(survey_pct, 5),
    get_pct(stimuli_pct, 5),
    get_pct(codebook_pct, 5),
    get_pct(interview_pct, 5),
    get_pct(scripts_pct, 5),
    get_pct(searchstring_pct, 5),
    get_pct(observat_pct, 5)
  ),
  Claimed_but_not_retrievable = c(
    get_pct(survey_pct, 2),
    get_pct(stimuli_pct, 2),
    get_pct(codebook_pct, 2),
    get_pct(interview_pct, 2),
    get_pct(scripts_pct, 2),
    get_pct(searchstring_pct, 2),
    get_pct(observat_pct, 2)
  )
)

# RQ4: Visualization ------------------------------------------------------

# Reshape data to long format
data_long_rq4 <- rq4_summary %>%
  pivot_longer(
    cols = c(External_platform, Within_article, Partly_available, 
             Not_available_with_justification, Not_available_no_justification, 
             Only_upon_request, Claimed_but_not_retrievable),
    names_to = "Availability_Category",
    values_to = "Percentage"
  )

data_long_rq4$Percentage[is.na(data_long_rq4$Percentage)] <- 0

# Add sample size to labels
data_long_rq4 <- data_long_rq4 %>%
  mutate(Material_label = paste0(Material, " (*n* = ", n, ")"))

# Set factor levels for consistent ordering
data_long_rq4$Availability_Category <- factor(data_long_rq4$Availability_Category, 
                                              levels = c("External_platform", "Within_article", "Partly_available", 
                                                         "Not_available_with_justification", "Not_available_no_justification", 
                                                         "Only_upon_request", "Claimed_but_not_retrievable"))

ggplot(data_long_rq4, aes(x = Percentage, y = Material_label, fill = Availability_Category)) +
  geom_bar(stat = "identity", width = 0.7, color = "black", linewidth = 0.2, 
           position = position_stack(reverse = TRUE)) +
  scale_fill_manual(
    values = c(
      "External_platform" = "#009E73",
      "Within_article" = "#0072B2",              
      "Partly_available" = "#F0E442",
      "Not_available_with_justification" = "#E69F00",
      "Not_available_no_justification" = "#D55E00",             
      "Only_upon_request" = "#999999",         
      "Claimed_but_not_retrievable" = "#CC79A7"
    ),
    labels = c(
      "External_platform" = "External platform",
      "Within_article" = "Within article/appendix",
      "Partly_available" = "Partly available",
      "Not_available_with_justification" = "Not available with justification",
      "Not_available_no_justification" = "Not available without justification",
      "Only_upon_request" = "Only upon request",
      "Claimed_but_not_retrievable" = "Claimed but not retrievable"
    )
  ) +
  labs(
    x = "Percentage",
    y = expression(bold("Material ")~bolditalic("(n)")),
    fill = "Material availability"
  ) +
  theme_minimal() +
  theme(
    axis.text.y = element_markdown(size = 10),
    axis.text.x = element_text(size = 10),
    axis.title = element_text(size = 11, face = "bold"),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    panel.grid.major.y = element_blank()
  ) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 100)) +
  guides(fill = guide_legend(nrow = 2))

ggsave("materials_transparency_barFig2RQ4.png", 
       width = 12, height = 7, dpi = 900)

# RQ5: DEVIATIONS FROM PREREGISTRATION -----------------------------------

table(data_labels$DevPrereg)
table(data_labels$DevPrereg_5_TEXT)

# ADDITIONAL ANALYSES -----------------------------------------------------

# Compare Composite Score: Qualitative vs Quantitative Methods ------------

# Mixed qual/quan (11) and Other (6) excluded due to small n and special nature
# Recode: 1 = quantitative (1-5), 0 = qualitative (7-10), NA = excluded (6, 11)
data_raw$Method_qualVSquan <- car::recode(data_raw$A04_Method, "c(1,2,3,4,5)=1; c(7,8,9,10)=0; c(6,11)=NA")

data_raw %>%
  group_by(Method_qualVSquan) %>%
  summarise(
    Mean = mean(CompositeTOP_Score_withMaterials, na.rm = TRUE),
    SD = sd(CompositeTOP_Score_withMaterials, na.rm = TRUE),
    N = sum(!is.na(CompositeTOP_Score_withMaterials))
  )

# Independent samples t-test (equal variances assumed)
t.test(CompositeTOP_Score_withMaterials ~ Method_qualVSquan, data = data_raw, var.equal = TRUE)

# Levene's test for equality of variances
leveneTest(CompositeTOP_Score_withMaterials ~ as.factor(Method_qualVSquan), data = data_raw)

# Relationship: TOP 1/2 and TOP 3 -----------------------------------------
# Use data_labels for CrossTable (readable labels), data_raw for statistical tests (numeric)

CrossTable(data_labels$TOP1_2, data_labels$TOP_3, expected = TRUE, 
           prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE, chisq = TRUE)
chisq.test(data_raw$TOP1_2, data_raw$TOP_3)
cramersV(table(data_raw$TOP1_2, data_raw$TOP_3))

# Relationship: TOP 5 and TOP 6 -------------------------------------------

CrossTable(data_labels$Data_TOP5, data_labels$TOP6_AnalyticCode, expected = TRUE, 
           prop.r = FALSE, prop.t = FALSE, prop.chisq = FALSE, chisq = TRUE)
chisq.test(data_raw$Data_TOP5, data_raw$TOP6_AnalyticCode)
cramersV(table(data_raw$Data_TOP5, data_raw$TOP6_AnalyticCode))
