# Accounting for the life history structure of fitness in tests for adaptive reproductive acceleration

**Stacy Rosenbaum** (Department of Anthropology, University of Michigan) and **Anup Malani** (University of Chicago Law School & National Bureau of Economic Research)

This repository contains the manuscript, supplementary materials, and analysis data for a paper on tests of the reproductive acceleration hypothesis in wild female baboons. The paper uses an accounting model of lifetime reproductive success together with a life history optimization model to derive the mathematical form that empirical tests of the hypothesis should take, then applies these tests to data from the Amboseli Baboon Research Project.

## Repository contents

| File / Folder | Description |
|---|---|
| `manuscript.Rmd` | Main manuscript |
| `supplement.Rmd` | Supplementary materials |
| `references.bib` | Bibliography |
| `build_merged_data.R` | Script that builds `data/merged_analysis_data.csv` from the three anonymized input files |
| `data/` | Analysis data (see below) |
| `figures/` | Output directory for figures (populated when knitting) |

### Data files

| File | Description |
|---|---|
| `data/weibel_first_birth.csv` | Anonymized version of Weibel et al. 2020's first-birth data, containing only the variables used in our analyses |
| `data/weibel_all_other_analyses.csv` | Anonymized version of Weibel et al. 2020's "all other analyses" data, containing only the variables used in our analyses |
| `data/rainfall_data.csv` | Anonymized first-year rainfall data provided by the Amboseli Baboon Research Project; only the rainfall variable and anonymized ID are retained |
| `data/merged_analysis_data.csv` | Merged analysis dataset; produced by `build_merged_data.R` |

## Reproducing the analysis

You will need R (with `tidyverse`, `knitr`, `modelsummary`, `kableExtra`, and `bookdown`) and a TeX distribution capable of producing PDFs (e.g., TinyTeX or MacTeX). The supplement uses XeLaTeX.

To regenerate the merged dataset from the three input CSVs (run from the repo root):

```r
Rscript build_merged_data.R
```

To knit the manuscript and supplement to PDF (from the repo root):

```r
rmarkdown::render("manuscript.Rmd")
rmarkdown::render("supplement.Rmd")
```

## Data sources and provenance

The three input files in `data/` are derived from:

- **Weibel et al. 2020** (*PNAS* 117:24909–24919): two of their published data files (`initial_analysis_2_first_birth.csv` and `all_other_analyses.csv`). We retain only the columns used in our analyses and the anonymized subject ID (`anon_sname`).
- **Amboseli Baboon Research Project** (Alberts & Altmann 2012, *Long-Term Field Studies of Primates*): continuous first-year rainfall data, used here with permission. We share only the rainfall column and the anonymized ID; other columns from the original ABRP rainfall file are not redistributed.

The anonymization key linking real subject IDs to `anon_sname` is not part of this repository. The pre-processing step that converts the proprietary inputs into the three anonymized CSVs above is also kept private.

## Variable transformations

`pop_growth_two_years` (population growth rate during the subject's infancy) is stored in `merged_analysis_data.csv` in its raw form (~0.0001–0.0017). The setup chunks in `manuscript.Rmd` and `supplement.Rmd` rescale it by a factor of 1000 so regression coefficients are human-readable. This rescaling does not affect statistical significance or model fit; it is purely for interpretation. The variable only appears in the supplement's control-variable comparison, not in main-text models.

## Citation

[Citation will be added upon publication.]

## Contact

Stacy Rosenbaum: stacylrosen@gmail.com
