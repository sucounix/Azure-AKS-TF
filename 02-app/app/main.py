from fastapi import FastAPI

app = FastAPI()


@app.get("/live")


def check_db_connection():
    import os
    import psycopg2
    from dotenv import load_dotenv
    from sys import stderr,stdout

    load_dotenv()

    """
    Check connection to PostgreSQL server, and print a proper message
    """

    try:
        connection = psycopg2.connect(host=os.environ.get('PG_HOST'),
                                port=os.environ.get('PG_PORT'),
                                user=os.environ.get('PG_USER'),
                                password=os.environ.get('PG_PASSWORD'),
                                dbname=os.environ.get('PG_DATABASE'))
        # db = connection.cursor()
    except:
        # print("Error while connecting to MySQL Server", file = stderr)
        return "Maintenance"
    # print("conneted successfully to MySql Database")
    return "Well done"