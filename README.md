# Clinical profile and predictors of outcomes of hospitalized patients with laboratory confirmed severe acute respiratory syndrome coronavirus 2 in Nigeria: A retrospective analysis of the 13 high burden states

## Directory Tree

<code>
.
├── data
│   ├── analysis
│   ├── archive
│   ├── cleaned
│   ├── gis
│   │   ├── nga
│   │   └── tiles
│   │       ├── CartoV
│   │       ├── CartoVNL
│   │       └── Stamen.TonerLite
│   ├── merged
│   ├── merged-2
│   ├── processed
│   └── raw
├── docs
│   └── results_files
│       └── figure-latex
├── graphics
├── models
├── reports
├── resources
└── scripts
    ├── models
    └── processing
</code>

## Output Generation

1. To generate the statistics for report output, source the following files from the `scripts` folder in this order: `01-process-data.R` > `02-clean-the-data.R` > `03-recode.R` > `04-descriptive-statistics.R`.
2. Scripts for the regression models are in the `models` folder.
3. The `Rmarkdown` file for the statistics report is in the `docs` folder.
