🏋️ Fitly Data Analytics Project
📌 Project Overview

Fitly is an end-to-end data analytics project focused on analyzing user engagement, churn behavior, and customer support performance for a subscription-based fitness platform.

The objective of this project was to identify key drivers of user churn, uncover behavioral patterns in engagement data, and provide data-driven recommendations to improve customer retention and operational efficiency.

This project demonstrates the full analytics lifecycle:

Data cleaning

Feature engineering

Exploratory data analysis (EDA)

KPI development

Visualization

Business insight generation

🎯 Business Problem

Subscription-based platforms rely heavily on user engagement and customer experience. High churn rates can significantly impact revenue and long-term growth.

This project answers:

What behavioral patterns lead to churn?

How does engagement level impact retention?

Does customer support performance influence churn?

How can early churn detection be implemented?

📊 Dataset Description

The analysis includes structured datasets representing:

User profiles

Subscription data

Workout/activity engagement logs

Customer support tickets

Total records analyzed: 100,000+ rows

⚙️ Tech Stack / Environment

Programming & Analysis

Python 3.x

Pandas

NumPy

SQL

Visualization

Matplotlib

Pandas plotting

Development Environment

Jupyter Notebook

Google Colab

VS Code

Version Control

Git

GitHub

🛠 Data Preparation & Feature Engineering

Cleaned and standardized raw data (missing values, timestamps, categorical inconsistencies)

Engineered:

Churn flag (binary indicator)

Engagement quartiles

Subscription tenure

Support resolution time KPIs

Created aggregated user-level datasets for retention analysis

📈 Key Analysis & Insights
🔹 Churn & Engagement

Users in the lowest engagement segment had 2–3× higher churn rates than highly active users.

Engagement drop-off patterns strongly predicted churn risk.

🔹 Customer Support Impact

Users experiencing longer support resolution times showed ~25–30% higher churn probability.

Support delays correlated with subscription cancellation within short time windows.

🔹 Behavioral Trends

Reduced workout frequency and declining session consistency preceded churn events.

New users were more sensitive to early negative experiences.

📊 Visualizations Created

Churn rate by engagement level

Distribution of engagement segments

Support resolution time vs churn comparison

Retention trends over time

All visuals were designed to clearly communicate insights to non-technical stakeholders.

💡 Business Recommendations

Implement early churn detection using engagement drop thresholds.

Trigger automated re-engagement campaigns for low-activity users.

Improve customer support SLA adherence to reduce churn risk.

Monitor engagement consistency instead of total activity alone.

Projected churn reduction impact: 10–15% improvement among high-risk users

🚀 What This Project Demonstrates

Ability to work with multi-source structured data

Strong data cleaning and transformation skills

KPI creation aligned with business objectives

Translating technical analysis into business recommendations

End-to-end analytics ownership

📎 How to Run the Project

Clone the repository

Install required libraries:

pip install pandas numpy matplotlib

Open the notebook in Jupyter or upload to Google Colab

Run cells sequentially
