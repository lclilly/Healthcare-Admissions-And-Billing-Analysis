# 🏥 Healthcare Operations & Cost Driver Analytics — Power BI Dashboard

This project analyzes a synthetic healthcare dataset to uncover patterns in patient admissions, billing trends, and operational drivers within a hospital setting.

The objective was to simulate the work of a healthcare operations analyst by transforming raw patient-level data into actionable business insights using Power BI Desktop.

---

## 📂 Dataset

- **Source:** Synthetic Healthcare Dataset — [OpenDataBay](https://opendatabay.com)
- **Size:** ~1,000,000 patient records (703K retained after data quality filtering)
- **Columns:** 12 fields including Age, Gender, Blood Type, Medical Condition, Date of Admission, Discharge Date, Insurance Provider, Billing Amount, Room Number, Admission Type, and Test Results

---

## 🛠️ Tools Used

- **Microsoft Excel** — Initial data inspection (data types, date formatting, value alignment)
- **Power BI Desktop** — Data transformation (Power Query), DAX measures, and visualization
- **Power Query (M Language)** — Data cleaning and feature engineering
- **DAX** — Custom analytical measures

---

## 🔍 Data Cleaning & Preparation (Power Query)

Before building a single visual, the following data quality steps were performed:

- **Verified data types** across all 12 columns — corrected Admission Year to Whole Number, confirmed Date columns were properly formatted
- **Identified and removed negative Length of Stay records** — discharge dates preceding admission dates indicated data entry errors; these rows were filtered out using a column filter (Greater Than or Equal To 0)
- **Engineered Length of Stay column** using:
  ```
  Duration.Days([Discharge Date] - [Date of Admission])
  ```
- **Extracted Month Name** from Date of Admission for time-series trend analysis
- **Noted age range of 13–88** — rather than removing under-18 records, an "Under 18" bin was added to preserve data integrity and surface paediatric admission patterns

---

## 📐 DAX Measures

Six core measures were written from scratch to power all visuals:

```dax
Total Patients = COUNTROWS(Healthcare_Dataset)

Total Billing Amount = SUM(Healthcare_Dataset[Billing Amount])

Avg Billing per Patient = DIVIDE([Total Billing Amount], [Total Patients])

Avg Length of Stay = AVERAGE(Healthcare_Dataset[Length of Stay])

Emergency Admission Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Healthcare_Dataset), Healthcare_Dataset[Admission Type] = "Emergency"),
    [Total Patients]
)

Abnormal Test Rate =
DIVIDE(
    CALCULATE(COUNTROWS(Healthcare_Dataset), Healthcare_Dataset[Test Results] = "Abnormal"),
    [Total Patients]
)
```

An **Age Group calculated column** was also created using SWITCH(TRUE()) logic to segment patients into business-relevant cohorts:

```dax
Age Group =
SWITCH(
    TRUE(),
    Healthcare_Dataset[Age] < 18, "Under 18",
    Healthcare_Dataset[Age] >= 18 && Healthcare_Dataset[Age] <= 30, "18–30",
    Healthcare_Dataset[Age] >= 31 && Healthcare_Dataset[Age] <= 50, "31–50",
    Healthcare_Dataset[Age] >= 51 && Healthcare_Dataset[Age] <= 70, "51–70",
    Healthcare_Dataset[Age] > 70, "70+",
    "Unknown"
)
```

---

## 📊 Dashboard Structure

### Page 1 — Executive Overview

Designed for hospital leadership who need a fast, high-level snapshot.

**KPI Cards:**
- 703K Total Patients
- $17.78bn Total Billing Amount
- 37.02 days Avg Length of Stay
- 0.33 (33%) Emergency Admission Rate
- 0.33 (33%) Abnormal Test Rate

**Charts:**
- Which conditions cost the most? *(Avg Billing per Patient by Medical Condition)*
- How have admissions changed over time? *(Line chart by Month — split by Admission Type)*
- Which insurance provider is associated with the highest billing? *(Total Billing by Provider)*
- How are patients being admitted? *(Donut chart — Admission Type distribution)*

**Interactive Slicers:**
- Date of Admission (range slider)
- Insurance Provider (dropdown)
- Admission Type (button slicer)
- Gender (button slicer)

---

### Page 2 — Deep Dive: Cost Driver Analysis

Designed for operations and finance teams investigating what actually drives cost.

**Charts:**
- Do longer stays drive higher costs? *(Scatter plot — Avg Length of Stay vs Avg Billing per Patient, colored by Medical Condition)*
- Does a higher age group attract higher billing? *(Avg Billing per Patient by Age Group)*
- Do abnormal results mean longer stays? *(Avg Length of Stay by Test Results)*
- Does admission type affect billing? *(Avg Billing per Patient by Admission Type)*

---

## 📈 Key Findings

- **All six medical conditions (Cancer, Arthritis, Hypertension, Asthma, Diabetes, Obesity) show near-identical average billing (~$25K per patient)** — suggesting billing in this dataset is driven more by administrative and structural factors than by condition type alone
- **Admission type (Emergency, Elective, Urgent) has minimal impact on billing** — all three cluster around $25.3K, indicating standardised pricing across admission categories
- **Emergency admissions account for exactly 33% of total admissions** — perfectly balanced with Elective and Urgent, which is unusual in real-world settings and reflects the synthetic nature of the dataset
- **Abnormal, Normal, and Inconclusive test results all correspond to an identical average length of stay (37 days)** — no clinical outcome differentiation is present in billing or length of stay
- **Insurance provider billing is nearly uniform** — Cigna, Medicare, and UnitedHealthcare at ~$3.6bn vs Aetna and Blue Cross at ~$3.5bn; minimal variation
- **Younger age groups (18-30) show marginally higher billing** — inconsistent with real-world expectations of higher resource utilisation in older patients
- **Admissions decline across the year** — the line chart shows a consistent downward trend from March through June across all admission types

---

## 💡 Analyst Notes

This is a **synthetic dataset**, which explains why many metrics appear uniformly distributed. In a real-world hospital dataset, you would expect to see meaningful variation across conditions, admission types, and insurance providers. The value of this project lies in demonstrating the **analytical workflow** — not in the specific numbers.

The process demonstrated here — Excel inspection → Power Query cleaning → DAX measures → structured visualisation — is the same process applied to production healthcare data at hospital systems, insurance companies, and health analytics firms.

---

## 🗂️ Repository Structure

```
healthcare-powerbi-dashboard/
│
├── Healthcare_Dataset.csv          # Raw synthetic dataset
├── Healthcare_Analytics_Report.pbix # Power BI Desktop file
├── Healthcare_Dashboard_Page1.pdf  # Executive Overview export
├── Healthcare_Dashboard_Page2.pdf  # Deep Dive export
└── README.md
```

---

## 🚀 How to Run

1. Download Power BI Desktop (free) from [microsoft.com/power-bi](https://www.microsoft.com/en-us/power-bi/desktop)
2. Clone or download this repository
3. Open `Healthcare_Analytics_Report.pbix` in Power BI Desktop
4. If prompted to refresh the data source, point it to `Healthcare_Dataset.csv` in the same folder

---

## 👤 Lilian Cheuno -Author

Built as part of a structured data analytics portfolio — demonstrating end-to-end skills across data inspection, cleaning, transformation, DAX authoring, and dashboard design.

~ Numbers with purpose ~
