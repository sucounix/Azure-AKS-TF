# Database Connaction Test API
This project provides a RESTful API for 

Endpoints definitions are in [endpoints](./ENDPOINTS.md).

## Running the project
To run the project you will need:
- Python 3.10 or newer

Install `psycopg2` dependencies:
```
sudo apt update
sudo apt install python3-dev libpq-dev gcc
```

Once you have those installed you should:
- Install dependencies
    ```
    pip install psycopg2
    pip install fastapi
    pip install uvicorn
    ```
- Run the server:
    ```
    uvicorn --host=0.0.0.0 --port=8000 main:app
    ```

# POC
`connection to Database is Successful`:
```
curl http://a3753841b4f244ca292c04f47484c2c8-1029656911.us-east-2.elb.amazonaws.com:8000/live

"Well done"%
```

`In case of an issue in connection to Database`:
```
curl http://a3753841b4f244ca292c04f47484c2c8-1029656911.us-east-2.elb.amazonaws.com:8000/live

"Maintenance"%
```