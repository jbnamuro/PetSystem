🐾 PetSystem
A robust role-based pet adoption platform built to bridge the gap between animal lovers and their future companions. This full-stack application features a dynamic inventory system, secure user roles, and a seamless checkout experience.

✨ Technologies
Flask (Python)

MySQL 8

Jinja2

Custom CSS

Stored Procedures

🚀 Features
Smart Filtering: Browse pets by species, rarity, maintenance level, and price.

Role-Based Access: Specialized dashboards for Customers, Staff, and Admins.

Secure Checkout: Integrated shopping cart with automatic 13% tax calculation.

Inventory Management: Full CRUD operations for Staff to maintain the catalog.

Admin Oversight: High-level tools to manage user accounts and global order history.

📍 The Process
Our team's goal was to build a system where complex logic lived directly in the database for maximum performance. By using MySQL Stored Procedures, we offloaded the heavy lifting—like transaction-safe checkouts and complex filtering—away from the Python layer. The biggest challenge was designing a relational schema that handled multiple pet statuses while keeping the user experience simple. We focused on a clean, dashboard-centric UI to ensure that whether you're a customer adopting a dog or an admin managing the fleet, the workflow remains intuitive.

🚦 Running the Project
Clone the repository

Initialize Database: mysql -u root -p < database/petsystem.sql

Install dependencies: pip install -r requirements.txt

Set Environment Vars: Configure MYSQL_USER and MYSQL_PASSWORD

Run app: python app.py

👥 The Team

Built by Jabari Namuro, Haydar Beydoun, Raad Islam, and Zakaria Hussein.
