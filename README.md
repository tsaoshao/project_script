# Examples – Wenyuan Yang

A selection of data analysis projects from my studies in Communication Science.

## 1. Digital Traces (YouTube) — `digital traces (YouTube)/`
Digital citizen science study on donated YouTube watch-history data (JSON) combined with survey data: does openness to experience predict the diversity (entropy) of the content people watch? Covers data donation parsing, sample tracking, reliability checks, OLS regression and diagnostics.
- **Language:** Python (Jupyter Notebook)
- **Packages:** pandas, numpy, statsmodels, pingouin, seaborn, matplotlib

## 2. A/B Test (Apple TV) — `ABtest (appletv).ipynb`
A/B test on whether cross-platform availability messaging increases ad click-through for Apple TV among non-Apple device users. Covers data cleaning, balance checks, chi-square test, logistic regression, predictive evaluation and LIME explanations.
- **Language:** Python (Jupyter Notebook)
- **Packages:** pandas, numpy, scipy, statsmodels, scikit-learn, lime, seaborn, matplotlib

## 3. AlcoholData — `AlcoholData/`
Group project: tidying a relational, multi-table social media dataset (users, posts, comments, likes, logins, surveys) following tidy data principles (primary keys, duplicates, missing values) with an interactive HTML report.

Individual part (at the end): Visualisations.

- **Language:** R (Quarto)
- **Packages:** tidyverse, DT, htmltools, DiagrammeR

## 4. [Invisible Language](https://github.com/invisibleinfo/invisibleinfo.github.io) — `invisible language/`
Evaluation of how well LLMs handle text in low-resource languages and scripts.
- `T1_copy_back_v1.ipynb`: copy-back experiment. LLMs are prompted (zero-shot, via an OpenAI-compatible API) to reproduce GlotLID texts exactly, scored with character error rate (CER), followed by error category analysis.
  - **Language:** Python (Jupyter Notebook)
  - **Packages:** openai, datasets (Hugging Face), pandas, editdistance, python-dotenv
- `eng_log_file_analysis/`: descriptive analysis of model accuracy across 13 tasks by language vitality (EGIDS), digital language support, family, script and speaker count, plus a diagnosis of English errors (model mistake vs. scoring/prompt artefact).
  - **Language:** R (R Markdown)
  - **Packages:** tidyverse, ggplot2, jsonlite

## 5. Open Science Analysis — `open science analysis/`
Content analysis of transparency and open science practices (TOP guidelines) in published research: composite transparency score, comparisons across research methods, materials sharing and preregistration deviations.
- **Language:** R
- **Packages:** dplyr, tidyr, ggplot2, ggtext, haven, DescTools, gmodels, car, lsr
