# Electronics Shop Database

This project is a compact database system for managing an electronics store: products, customers, orders and reviews. It’s designed for quick SQL exploration and a small Python demo against PostgreSQL.

## Project Files

**SQL Files**  
- `schema.sql` — creates tables and constraints  
- `testdata.sql` — inserts sample data  
- `queries.sql` — basic example queries used by the app

**Python Files**  
- `database.py` — database connection setup  
- `queries.py` — functions that run the project queries  
- `main.py` — demo runner that prints query results

**Other Files**  
- `requirements.txt` — Python dependencies list  
- `.env` — local database credentials (you create this)  
- `.gitignore` — excludes secrets and build artifacts

## Requirements

**Software:** Python 3.8+ and PostgreSQL 12+  
**Libraries:** SQLAlchemy, psycopg2-binary, python-dotenv (installed from `requirements.txt`)

## Installation and setup

Download or clone the project to your computer.  
Open a terminal in the project folder.

Create a virtual environment for the project and activate it.  
- Windows: `venv\Scripts\activate`  
- Mac/Linux: `source venv/bin/activate`

Install the Python dependencies from the requirements file.

Create a `.env` file in the project root and add your database connection values (host, port, database name, user and password).

Create the database (if it does not exist) and load the schema and sample data using your preferred tool (pgAdmin, psql, or a VS Code PostgreSQL extension). Run the schema file first, then the testdata file. After the data is loaded, run the Python demo (`main.py`) to see example outputs.

## Create database and add data

Use pgAdmin, psql, or VS Code with a PostgreSQL extension.  
1. Run `schema.sql` to create tables and constraints.  
2. Run `testdata.sql` to populate tables.  
3. Run the Python demo to verify results.

## How to use

With the virtual environment active, run the Python demo. The program prints results from several queries, for example: all products, filtered product lists, orders by year, pending orders, product brand summaries, customer order history, top spending customers, and product ratings. Exact outputs depend on the queries included in the project.

## Running SQL files

You can run SQL files directly in your database tool:  
- **pgAdmin** — open Query Tool, load a file and execute it  
- **psql** — run SQL files against the target database  
- **VS Code** — use a PostgreSQL extension to run files against a selected database

Start with `queries.sql` for basic examples.

## Troubleshooting

- **Virtual environment:** ensure it is activated and you are in the project folder. On some systems use `python3` if needed.  
- **Missing modules:** activate venv and install dependencies from `requirements.txt`.  
- **Database connection:** check that `.env` exists and contains correct values; confirm PostgreSQL is running and credentials match. Try `127.0.0.1` if `localhost` fails.  
- **SQL errors:** run the schema file before the testdata file and confirm the target database exists.

## Contributing and license

Open an issue or submit a pull request with a clear description of changes. Add a license file (for example MIT) in the repository root if you plan to publish the project.
