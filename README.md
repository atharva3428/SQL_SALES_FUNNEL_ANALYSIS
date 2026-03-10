# SQL Sales Funnel Analysis

## Overview
This project analyzes an e-commerce sales funnel using SQL (Snowflake) to track user behavior across five stages — from page view to purchase — over a 90-day window. It identifies drop-off points, compares traffic source performance, measures time-to-conversion, and summarizes revenue metrics.

## Files
| File | Description |
|------|-------------|
| `Sales_Funnel_Analysis.sql` | All SQL queries for funnel analysis |
| `user_events.csv` | Raw event-level dataset used for analysis |
| `Final_recommendations.jpg` | Visual summary of findings and recommendations |

## Funnel Stages
```
Page View → Add to Cart → Checkout Start → Payment Info → Purchase
```

## Analysis Breakdown

### 1. Overall Funnel Conversion
Counts distinct users at each stage and calculates step-by-step conversion rates plus the overall view-to-purchase rate.

### 2. Funnel by Traffic Source
Breaks down funnel performance by traffic source (e.g. organic, paid, social) to identify which channels drive the most purchases and have the highest conversion rates.

### 3. Time to Conversion
Measures the average time (in minutes) users take to move through the funnel — from view to cart, cart to purchase, and the full journey — limited to users who completed a purchase.

### 4. Revenue Funnel
Calculates total revenue, total orders, average order value, and revenue per buyer over a 60-day window.

## Tech Stack
- **Database:** Snowflake
- **Language:** SQL
- **Schema:** `SALES_FUNNEL_DB.ANALYTICS`
- **Source Table:** `FUNNEL_EVENTS`
