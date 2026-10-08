# eng_log_file_analysis

Error analysis of mistral-small-3.2 on English (`eng_Latn`).

## Files

| File | What it is |
|---|---|
| `eng_log_file_analysis.Rmd` | Main R notebook. Sections 0–10: descriptive statistics from `summary.csv` merged with `Table_of_Languages.tab`. Section 11: 5 random English mistakes per task. Section 12: checks whether English mistakes come from the model or from scoring. |
| `MiSS Descriptive Statistics.Rmd` | Older copy of the notebook (sections 0–11, no section 12). |
| `eng/` | 13 log files, one per task: `result_eng_Latn_<task>_mistral-small-3.2.csv`. One row per test item: `input_key` (task parameters), `expected`, `model_output`, `is_correct`, `input_len`, `is_api_error`, etc. The input text itself is not stored. |
| `summary.csv` | Accuracy per language × model × task. |
| `Table_of_Languages.tab` | Ethnologue language table (family, EGIDS, DLS level, L1 users, …), joined on `ISO_639`. |
| `prompt_templates.md` | Prompt templates for the 13 tasks (copied from `prompts.py`, which is not in this folder). |
| `english_mistral_mistakes_diagnosed.csv` | Written by section 12.6: 5 random mistakes per task with a `diagnosis` label. |
| `english_mistral_mistakes.csv` | Written by section 11 when run (not currently in the folder). |
| `.Rhistory`, `.DS_Store` | RStudio history and macOS folder metadata. Not part of the analysis. |

## Whitespace mistakes (open for discussion)

**Observed (section 12.2):**

- 699 answers in the word tasks are marked wrong, but become identical to `expected` once runs of spaces are squeezed to one space: `word_deletion` 277, `word_insertion` 213, `word_substitution` 203, `word_swapping` 6.
- In these rows `model_output` contains two spaces where `expected` has one.
- `expected` never contains a double space. `model_output` often does.

**Not known:**

- The input text is not stored in the log files, so we cannot see whether the double spaces were in the input.

**Indirect evidence:**

- `input_len` (assumed to be the character count of the input text) is 1–2 characters longer than `expected` in exactly the `word_substitution` rows where the model output has a double space (12.2(c)). This suggests the input had the double spaces and `expected` did not.
- In some `word_deletion` rows the double space is where the model deleted a word (e.g. "out from␣␣the bushes" after deleting "behind"). These come from the model, not the input.

**Prompt (`prompt_templates.md`):**

- The prompts for the word tasks say nothing about spaces.
- The example sentences are short, single-spaced, and have no double spaces.
- The deletion examples remove the word together with one space ("the dog chased the cat under the tree" → "dog chased cat under tree").

**Possible reasons:**

1. The input had double spaces, the model copied them, and `expected` was built with single spaces. This would be a data or scoring problem, not a model problem.
2. The model added the double spaces itself. This would be a model problem.

To decide, we need the exact input text sent to the model, or the code that builds the input and `expected` (`prompts.py` and the data-preparation script).

## Punctuation mistakes (open for discussion)

"Punctuation only" (section 12.6 label, word tasks only) means `model_output` and `expected` differ only in punctuation. The counts below come from a separate check and are not produced by the notebook.

**Observed:** 520 such mistakes in the word tasks.

| What differs | Rows |
|---|---|
| Quote mark at the start or end: model **added** one | 202 |
| Quote mark at the start or end: model **omitted** one that is in `expected` | 64 |
| Quote mark at the start or end: same count, different style (`“` vs `"`) | 82 |
| Quote marks inside the passage | 57 |
| Other punctuation (comma added, `###` dropped, `did'nt` → `didn't`, …) | 115 |

Examples:

```
added:    expected      we be able to show you a flower which will make you smile!”
          model_output  "we be able to show you a flower which will make you smile!”
omitted:  expected      “Dearest frogs, I wonder if you could help me find ... great power!"
          model_output  Dearest frogs, I wonder if you could help me find ... great power!
style:    expected      “Thank you, I had better join you ... rumble!”
          model_output  "Thank you, I had better join you ... rumble!”
```

**Prompt (`prompt_templates.md`):**

- The system message says: `Output ONLY the answer. No explanation, no prefix, no surrounding text.`
- All example answers are wrapped in straight quotes: `Answer: "dog chased cat under tree"`.
- Example sentences contain no punctuation or quote marks.

**Scoring:** `is_correct` accepts answers wrapped in a matching pair of straight quotes (10,562 such rows are marked correct). This rule is inferred from the data; the scoring code is not in this folder.

**Possible reasons:**

1. Added (202): the model wraps its answer in quotes as the examples show. The passage already ends with its own quote mark, so the quotes do not form a matching pair and the answer is marked wrong. The word edit is correct. Reason: prompt format and scoring, not the model.
2. Omitted (64) and changed style (82): the model changed quote marks that belong to the passage. Model mistake, but the prompt is unclear on whether quote marks at the start or end of a passage are part of the answer or wrapping.
3. Inside the passage (57) and other punctuation (115): the model changed text it was not asked to change. Model mistake.

**Not known:** the input text is not stored in the log files, so we assume the quote marks in `expected` were also in the input.
