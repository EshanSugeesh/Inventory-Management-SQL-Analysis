# Inventory-Management-SQL-Analysis
SQL-based inventory management analytics project for Urban Retail Co. analyzing stockouts, overstocking, demand forecasting, and turnover 

## 📋 Project Overview

This project addresses inventory management challenges faced by **Urban Retail Co.**, a mid-sized retail chain managing over 5,000 SKUs across online and offline stores. The analysis focuses on:

- ❌ Frequent stockouts of high-demand products
- 📦 Overstocking of slow-moving items
- 📊 Lack of real-time SKU-level visibility
- 🎯 Absence of data-driven decision-making

## 👨‍💻 Author

**Eshan Sugeesh**  
Engineering Physics, IIT (BHU) Varanasi  
*Project completed for Consulting Analytics Club, IIT Guwahati*

## 🛠️ Technologies Used

- **Database**: MySQL
- **Visualization**: Tableau
- **Analysis**: SQL (Window Functions, CTEs, Joins, Aggregations)

## 📊 Key Insights

### Missed Sales Opportunities
- Products like **P0066** and **P0126** in South and West regions consistently failed to meet forecasted demand
- Significant revenue loss during seasonal spikes and promotional periods
- Root cause: Inadequate replenishment planning and slow reaction time

### Inventory Turnover
- **Clothing category**: Highest turnover rate
- **Top performing stores**: S001 (East) and S003 (West)
- Implemented 3-day buffer stock system for optimal inventory levels

### Overstocking Analysis
- **Product P0125**: 126+ units exceeding demand projections
- Multiple products with 87+ overstock units
- Tying up working capital unnecessarily

## 🎯 Recommendations

### I. Reduce Stockouts
- Implement automated reorder alerts based on historical sales
- Maintain minimum stock thresholds (3× average daily sales)
- Integrate demand forecasting into replenishment plans

### II. Address Overstocking
- Use SQL analytics to identify slow-movers
- Apply dynamic pricing/discounts to clear excess stock
- Reassess reorder cycles

### III. Optimize Turnover
- Prioritize procurement of high-turnover SKUs
- Build category-wise and store-wise benchmarks

### IV. Improve Forecast Accuracy
- Implement time series methods (rolling averages, exponential smoothing)
- Factor in seasonality and weather patterns
- Retrain models quarterly

### V. Enhance Visibility
- Replicate practices from top-performing stores
- Reallocate stock based on regional demand

## 📁 Repository Structure

```
Inventory-Management-SQL-Analysis/
│
├── inventory-analysis.sql      # Complete SQL script with all queries
├── README.md                   # Project documentation
└── docs/                       # Additional documentation
    ├── Executive-Summary.pdf   # Project summary and findings
    ├── Dashboard.pdf          # Tableau dashboard visualizations
    └── ERD.pdf                # Entity Relationship Diagram
```

## 🔍 SQL Analysis Features

### Database Design
- Normalized data structure with dimension tables (products, stores, dates)
- Fact table for inventory transactions
- Proper indexing for query optimization

### Key Queries Include
1. **Inventory Health Checks**
   - Low inventory alerts
   - Reorder point calculations
   - Overstocking detection

2. **Performance Metrics**
   - Inventory turnover ratios
   - Category-wise and store-wise analysis
   - Demand forecast accuracy

3. **Advanced Analytics**
   - Rolling 7-day sales trends
   - Regional performance ranking
   - Holiday promotion impact analysis

## 📈 Results

By adopting these recommendations, Urban Retail Co. can:
- ✅ Reduce missed revenue opportunities
- ✅ Unlock working capital from overstocked items
- ✅ Enhance customer satisfaction through better availability
- ✅ Enable data-driven inventory planning

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/EshanSugeesh/Inventory-Management-SQL-Analysis.git
   ```

2. **Set up MySQL database**
   ```sql
   source inventory-analysis.sql
   ```

3. **Load your inventory data**
   - Prepare CSV file with required schema
   - Update file path in LOAD DATA INFILE statement
   - Execute the script

## 📞 Contact

For questions or collaboration opportunities, feel free to reach out!

---

⭐ If you found this project helpful, please consider giving it a star!optimization using MySQL and Tableau dashboards.
