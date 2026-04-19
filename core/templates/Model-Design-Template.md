---
type: ml-design
title: <% tp.system.prompt("Model name / purpose") %>
status: <% tp.system.prompt("Status (Design / Training / Evaluation / Production)", "Design") %>
created: <% tp.date.now("YYYY-MM-DD") %>
updated: <% tp.date.now("YYYY-MM-DD") %>
tags: [ml, model-design]
---

# <% tp.frontmatter.title %>

## Problem Statement
[What are we predicting/classifying/clustering? What business question does this answer?]

## Approach
[Algorithm/model type and why it was chosen.]

## Features
| Feature | Source | Type | Rationale |
|---------|--------|------|-----------|
| [feature name] | [table.column] | numeric/categorical/text | [why this feature matters] |

## Training Data
- **Source:** [where the data comes from]
- **Volume:** [approximate size]
- **Label:** [target variable, if supervised]
- **Split:** [train/val/test ratios]
- **Known Biases:** [any skew or gaps in the data]

## Evaluation Criteria
- **Primary Metric:** [accuracy, F1, RMSE, etc.]
- **Threshold:** [what score is "good enough" for production]
- **Baseline:** [current method's performance, or naive model]

## Preprocessing
[Feature engineering, normalization, encoding, missing value handling.]

## Infrastructure
[Where does training run? Where does inference run? Batch or real-time?]

## Risks & Limitations
- [What could go wrong]
- [Where the model will fail]
