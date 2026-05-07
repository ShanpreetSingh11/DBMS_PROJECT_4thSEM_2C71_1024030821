# 🎓 Placement Management System

A full-stack web application designed to manage student placements efficiently.  
This system allows administrators to add students, manage companies, assign placements, and view real-time placement statistics.

---

## 🚀 Tech Stack

- Frontend: HTML, CSS, JavaScript  
- Backend: Node.js (HTTP module)  
- Database: MySQL  
- Database Features: Stored Procedures, Triggers, Transactions  

---

## ✨ Features

- 📊 Dashboard with live placement statistics  
- 👨‍🎓 Add, view, and manage students  
- 🏢 Add and manage companies  
- 🔗 Assign companies to students (placement system)  
- 📈 View placed and unplaced students separately  
- 🔄 Real-time updates using REST APIs  
- 🧠 Data validation using triggers and constraints  
- 🔐 Transaction support (COMMIT, ROLLBACK, SAVEPOINT)  

---

## 🧩 System Architecture

Frontend (HTML/JS)         ↓ Node.js Backend (API)         ↓ MySQL Database

---

## ⚙️ Setup Instructions

### 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/placement-management-system.git cd placement-management-system

---

### 2. Setup MySQL Database

- Open MySQL Workbench  
- Open the file:
    PlacementCellManagement_database.sql  
- Execute the script (⚡ button)

This will:
- Create database: placement_db
- Create tables and relationships
- Add stored procedures and triggers

---

### 3. Configure Backend

Open server.js and update your MySQL password:

js const db = mysql.createConnection({   host: 'localhost',   user: 'root',   password: 'YOUR_PASSWORD',   database: 'placement_db' }); 

---

### 4. Install Dependencies

npm install

---

### 5. Run the Server

node server.js

---

### 6. Run the Frontend

Use Live Server (VS Code) or any static server to open:

index.html

---

## 🧪 Sample Functional Flow

1. Add a new student  
2. Add a company  
3. Assign the company to the student  
4. View updated placement status in dashboard  

---

## 🧠 Key Concepts Used

- Transactions: Ensures atomic operations (COMMIT, ROLLBACK, SAVEPOINT)  
- Triggers: Enforces business logic and validation  
- Stored Procedures: Encapsulates database operations  
- Joins: Used for combining student and company data  

---

## 📌 Important Note

The .sql file is used only to initialize the database.  
All runtime data (inserts, updates, deletes) is stored inside MySQL and does not reflect automatically in the SQL file.

---

## 📷 (Optional) Screenshots

Add screenshots of your dashboard, student list, etc. here.

---

## 👨‍💻 Author

Shaanpreet Singh
1024030821
Computer Engineering Student

Mansher Singh
1024030980
Computer Engineering Student

---

## 📄 License

This project is for academic and learning purpo
