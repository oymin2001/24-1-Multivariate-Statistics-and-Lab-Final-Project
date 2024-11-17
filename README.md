# 🎓 Multivariate Statistics and Lab - Final Project 📊

## 📚 Table of Contents

- [🔍 Project Overview](#project-overview)
- [📁 Dataset](#dataset)
- [🧪 Analysis Methods](#analysis-methods)
- [📈 Results](#results)
- [📂 File Structure](#file-structure)
- [⚙️ Setup](#setup)
- [🚀 Usage](#usage)
- [👥 Contributors](#contributors)
- [📝 License](#license)

## 🔍 Project Overview

This project involves predicting the admission chances for U.S. graduate schools based on multiple variables, using data obtained from Kaggle. The primary goal is to build a predictive model that helps identify the most significant factors influencing graduate school admissions.

### 🎯 Objectives
1. Develop a predictive model for U.S. graduate school admission probabilities.
2. Analyze the impact of various factors such as GRE scores, TOEFL scores, and GPA on the admission chances.
3. Provide actionable insights for prospective students to enhance their profiles.

## 📁 Dataset

The dataset used in this project is sourced from the **2019 IEEE International Conference on Data Science**. The dataset contains 400 entries with the following variables:

- **GRE Score**: Graduate Record Examination score (out of 340).
- **TOEFL Score**: Test of English as a Foreign Language score (out of 120).
- **University Rating**: Rating of the applicant's university (out of 5).
- **SOP**: Statement of Purpose strength (out of 5).
- **LOR**: Strength of Letters of Recommendation (out of 5).
- **CGPA**: Undergraduate GPA (out of 10).
- **Research**: Research experience (1 = yes, 0 = no).
- **Chance of Admit**: The predicted probability of admission.

The dataset can be found in the `data/` directory of this repository. 📊

## 🧪 Analysis Methods

The project employs both R and Python for data analysis, visualization, and predictive modeling. Several statistical and machine learning techniques are utilized, including:

- 📊 Exploratory Data Analysis (EDA)
- 📉 Multiple Regression Analysis
- 🧩 Ridge Regression
- 🔍 Principal Component Analysis (PCA)
- 🧪 Factor Analysis
- 📐 Partial Least Squares (PLS)
- 📏 Factor Score Regression

Python libraries such as `pandas`, `scikit-learn`, `matplotlib`, and `seaborn` are used for the analysis, alongside R for statistical validation.

## 📈 Results

The final predictive model uses a two-factor score regression approach, considering both quantitative and qualitative variables. The selected model offers interpretability while maintaining high predictive accuracy. Key findings include:

- **GRE, TOEFL, and CGPA** have the strongest impact on admission chances.
- The model provides actionable insights by evaluating both the quantitative (GRE, TOEFL, CGPA) and qualitative (SOP, LOR, University Rating) components of a candidate's profile.

For detailed results and visualizations, please refer to the report in the `report/` directory. 📑

## 📂 File Structure

```
📦 Project Folder
├── 📁 data/
│   └── Admission_Predict.csv         # Dataset used for analysis
│   └── train.csv                     # Dataset used for model training and model seleciton
│   └── test.csv                      # Dataset used for model test
├── 📁 code/
│   ├── EDA.R                         # R scripts for data analysis
│   └── Admission_Prediction.ipynb    # Python scripts for data analysis
├── 📄 final_report.pdf               # Detailed project report
└── 📄 README.md                      # Project documentation
```

## 👥 Contributors

- **오영민**
- **육현정**
- **최상진**
