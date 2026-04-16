# Smart Resume Analyzer

A Java-based web application that compares resume skills against job description requirements and calculates a match score using Apache OpenNLP for intelligent text tokenization.

---

## Features

- Submit resume skills and job requirements via a web form
- Intelligent skill tokenization using Apache OpenNLP
- Stop word filtering for accurate skill matching
- Percentage-based match score calculation
- Matched vs missing skills breakdown
- Persists results to a MySQL database
- Clean, responsive JSP frontend

---

## Tech Stack

| Technology | Version | Role |
|---|---|---|
| Java | 17+ | Core language |
| Jakarta Servlet | 6.0 | HTTP request handling |
| Apache Tomcat | 10.1.x | Web server / servlet container |
| Apache OpenNLP | 2.5.8 | NLP tokenizer |
| MySQL | 8.x | Database |
| JSP | 3.1 | Frontend templating |
| SLF4J | 2.0.9 | Logging (required by OpenNLP) |
| Eclipse IDE | 2024+ | Development environment |

---

## Project Structure

```
SmartResumeAnalyzer/
├── src/
│   └── com/smartresumeanalyzer/
│       ├── DBConnection.java        # JDBC connection utility
│       ├── Resume.java              # Data model (POJO)
│       ├── ResumeDAO.java           # Database operations
│       ├── ResumeServlet.java       # HTTP controller (@WebServlet /analyze)
│       ├── SimilarityService.java   # OpenNLP matching logic
│       └── MainApp.java             # Optional standalone runner
└── src/main/webapp/
    ├── META-INF/
    │   └── MANIFEST.MF
    ├── WEB-INF/
    │   ├── lib/                     # All JAR dependencies go here
    │   └── web.xml                  # App deployment descriptor
    └── index.jsp                    # Frontend form
```

---

## Prerequisites

Before running this project, make sure you have the following installed:

- **Java JDK 17+** — [Download](https://www.oracle.com/java/technologies/downloads/)
- **Eclipse IDE for Enterprise Java** — [Download](https://www.eclipse.org/downloads/)
- **Apache Tomcat 10.1** — [Download](https://tomcat.apache.org/download-10.cgi)
- **MySQL Server 8.x** — [Download](https://dev.mysql.com/downloads/mysql/)
- **MySQL Connector/J** — [Download](https://dev.mysql.com/downloads/connector/j/)

---

## Installation & Setup

### Step 1 — Download Required JAR Files

Download the following JARs and save them somewhere accessible:

| JAR | Download From |
|---|---|
| `opennlp-tools-2.5.8.jar` | https://opennlp.apache.org/download.html → 2.x Series → bin.zip → extract `lib/` |
| `slf4j-api-2.0.9.jar` | https://mvnrepository.com → search `slf4j api` → version 2.0.9 → jar |
| `slf4j-simple-2.0.9.jar` | https://mvnrepository.com → search `slf4j simple` → version 2.0.9 → jar |
| `mysql-connector-j-8.x.jar` | https://dev.mysql.com/downloads/connector/j/ |

---

### Step 2 — Set Up the Database

Open MySQL and run the following:

```sql
CREATE DATABASE resumedb;

USE resumedb;

CREATE TABLE resumes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    skills TEXT,
    score DOUBLE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

### Step 3 — Configure DBConnection.java

Open `DBConnection.java` and update the credentials to match your MySQL setup:

```java
private static final String URL  = "jdbc:mysql://localhost:3306/resumedb";
private static final String USER = "root";          // your MySQL username
private static final String PASS = "yourpassword";  // your MySQL password
```

---

### Step 4 — Import the Project into Eclipse

1. Open **Eclipse IDE for Enterprise Java Developers**
2. Go to **File → Import → General → Existing Projects into Workspace**
3. Select the root folder of this project
4. Click **Finish**

---

### Step 5 — Add JAR Dependencies

1. Copy all downloaded JARs into `src/main/webapp/WEB-INF/lib/`
2. Right-click the project → **Properties**
3. Go to **Java Build Path → Libraries tab**
4. Click **Add External JARs...**
5. Select all 4 JARs from `WEB-INF/lib/`
6. Click **Apply and Close**

---

### Step 6 — Configure Deployment Assembly

This is a critical step — without it Tomcat cannot find your servlet class.

1. Right-click project → **Properties**
2. Click **Deployment Assembly**
3. Ensure these two mappings exist:

| Source | Deploy Path |
|---|---|
| `src/main/webapp` | `/` |
| `src` | `WEB-INF/classes` |

4. If either is missing, click **Add → Folder** and add it
5. Click **Apply and Close**

---

### Step 7 — Add Tomcat Server in Eclipse

1. Go to **Window → Show View → Servers**
2. Right-click in the Servers panel → **New → Server**
3. Select **Apache → Tomcat v10.1**
4. Set the Tomcat installation directory
5. Click **Finish**

---

### Step 8 — Run the Application

1. Right-click the project → **Run As → Run on Server**
2. Select your Tomcat server → click **Finish**
3. Eclipse will deploy the app and open a browser

Navigate to:
```
http://localhost:8080/SmartResumeAnalyzer/
```

---

## Usage

1. Open the app in your browser at `http://localhost:8080/SmartResumeAnalyzer/`
2. Enter your **name**
3. Paste your **resume skills** (e.g. `Java, Python, SQL, Spring Boot, Git`)
4. Paste the **job required skills** (e.g. `Python, Docker, SQL, Kubernetes`)
5. Click **Analyze match**
6. View your match score, matched skills (green), and missing skills (red)

---

## How the Score is Calculated

```
1. Tokenize both skill strings using OpenNLP SimpleTokenizer
2. Convert to lowercase, filter stop words and punctuation
3. Store in HashSets to remove duplicates
4. Find intersection: skills in both resume AND job sets
5. Score = (matched count / total job skills) × 100
```

**Example:**

| | Skills |
|---|---|
| Resume | java, python, sql, spring boot, git |
| Job | python, sql, docker, kubernetes, git |
| Matched | python, sql, git |
| **Score** | **3 / 5 × 100 = 60.0%** |

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `404 Not Found` on `/analyze` | Check Deployment Assembly — `src` must map to `WEB-INF/classes` |
| `500 Internal Server Error` | Check Console for missing JARs — likely SLF4J not added |
| `ClassNotFoundException` for MySQL | Add `mysql-connector-j.jar` to `WEB-INF/lib/` and build path |
| Tomcat won't start | Check port 8080 is not in use — change port in Tomcat settings if needed |
| Score always 0% | Skills may have no common tokens after stop word filtering — try more specific terms |

---

## Dependencies

All JARs must be placed in `WEB-INF/lib/` and added to the Eclipse Java Build Path:

```
WEB-INF/lib/
├── opennlp-tools-2.5.8.jar
├── slf4j-api-2.0.9.jar
├── slf4j-simple-2.0.9.jar
└── mysql-connector-j-8.x.jar
```

---

## License

This project was built for educational purposes.