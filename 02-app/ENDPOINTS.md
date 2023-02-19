# Endpoints

## 📌 Live

### 🔵 `GET /live`  (Public)
#### Description
This endpoint should return the list of DB_status.

#### Response
Status `200`: OK

In case of connection to Database is Successful
```json
{
"Well done"
}
```

#### Response
Status `200`: OK

In case of connection to Database is Connection issue.
```json
{
"Maintenance"
}
```