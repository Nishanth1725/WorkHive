# WorkHive: Bridging the Gap Between Talent and Opportunity
WorkHive is a streamlined, full-stack career platform designed to simplify the job search process. Built with a focus on speed and reliability, it provides a centralized hub where seekers can discover opportunities and track their career journey in real-time.

## Experience It Live
Don't just take our word for it—explore the live environment here:

**[Launch WorkHive](https://workhive-production-89c6.up.railway.app/)**

## The Vision
In an era of complex job boards, WorkHive was created to provide a clean, no-nonsense interface for developers and job seekers. The project demonstrates a robust implementation of the Model-View-Controller (MVC) architecture, proving that powerful enterprise tools can be lightweight and user-friendly.

## The Engine (Tech Stack)
We chose a stack that balances industry-standard reliability with modern cloud flexibility:
**The Brain:** Java Servlets & JSP for high-performance backend processing.
**The Memory:** MySQL (Cloud-hosted via Railway) for secure, structured data storage.
**The Skeleton:** Maven for seamless dependency management.
**The Cloud:** Dockerized containers deployed on Railway for 99.9% uptime.

## What WorkHive Does Best
**Secure Entry:** A dedicated authentication gate ensures user data and applications remain private.
**Live Marketplace:** A dynamic dashboard that pulls the latest job postings directly from our cloud database.
**Application Management:** Transition from "Searching" to "Applied" with a single click, keeping your career hunt organized.
**Modern Aesthetics:** A responsive CSS framework that looks just as good on a mobile browser as it does on a desktop.
## Inside the Repository
* 'src/main/java': The powerhouse containing our Servlets (Controllers) and Database Utilities.
* 'src/main/webapp': The "Face" of the app, containing JSP views and styling.
* 'Dockerfile': The instructions that allow WorkHive to run perfectly in any cloud environment.

## Setting Up Your Own Hive
Want to run WorkHive locally? Follow these steps:

**Clone the Hive:**
Bash
git clone https://github.com/Nishanth1725/WorkHive.git
Import: Open your favorite IDE (IntelliJ or Eclipse) and import as a Maven Project.
Plug in the Database: Update DatabaseConnection.java with your local MySQL credentials.
Ignition: Deploy onto a Tomcat (9.0+) server and visit localhost:8080.

Developed by Nishanth Revannagari Computer Science Student @ Amrita Vishwa Vidyapeetham
