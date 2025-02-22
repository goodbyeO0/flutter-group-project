# Hospital Tracker Backend

Express.js server implementation for the Hospital Tracker Application. This backend service provides APIs for user authentication, hospital location management, and user location tracking.

## Features

- User Authentication (Register/Login/Edit/Delete)
- Hospital Location Management
- Real-time Location Tracking
- Nearby Hospitals Search (using Google Places API)
- User Location History Tracking

## Prerequisites

- Node.js (Latest LTS version recommended)
- MySQL Server
- Google Places API Key

## Setup Instructions

1. Install dependencies:

   ```bash
   npm install
   ```

2. Set up the MySQL database:

   - Create a new MySQL database
   - Run the SQL commands from `schema.sql`

3. Configure environment variables:

   - Create a `.env` file based on `.env.example`:

   ```
   # Database Configuration
   DB_HOST=localhost
   DB_USER=your_db_user
   DB_PASSWORD=your_db_password
   DB_NAME=flutter_hospital

   # Server Configuration
   PORT=3000

   # Google Places API
   GOOGLE_PLACES_API_KEY=your_api_key
   ```

4. Start the server:
   ```bash
   node api.js
   ```

## Database Schema

### Users Table

```sql
CREATE TABLE users (
  UserID INT PRIMARY KEY AUTO_INCREMENT,
  UserName VARCHAR(255) NOT NULL,
  UserEmail VARCHAR(255) NOT NULL UNIQUE,
  UserPassword VARCHAR(64) NOT NULL
);
```

### Location History Table

```sql
CREATE TABLE location_history (
  id INT PRIMARY KEY AUTO_INCREMENT,
  UserID INT,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  address TEXT,
  user_agent VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (UserID) REFERENCES users(UserID)
);
```

## API Documentation

### User Management

#### Login User

```
GET /api/CheckUser
Query params: UserEmail, UserPassword
Returns: User details or error message
```

#### Register User

```
GET /api/RegisterUser
Query params: UserName, UserEmail, UserPassword
Returns: New user details or error message
```

#### Edit User

```
GET /api/EditUser
Query params: UserID, UserName, UserEmail, UserPassword (optional)
Returns: Success message or error
```

#### Delete User

```
GET /api/DeleteUser
Query params: UserID
Returns: Success message or error
```

### Location Management

#### Get Nearby Hospitals

```
GET /api/getNearbyHospitals
Query params: latitude, longitude, radius
Returns: Array of nearest 15 hospitals with distances
```

#### Track User Location

```
POST /api/trackLocation
Query params: UserID, latitude, longitude, address, deviceInfo
Returns: Success message or error
```

#### View Location History

```
GET /api/getUserTracking
Returns: HTML table or JSON data of user location history
```

## Error Handling

The API uses standard HTTP status codes and returns responses in the following format:

```json
// Success Response
{
  "status": 200,
  "data": "..." // or object/array
}

// Error Response
{
  "status": 401/404/500,
  "error": "Error message"
}
```

## Security Features

- Password Hashing: SHA-256 encryption
- Input Validation: All user inputs are validated
- CORS Protection: Configurable origin restrictions
- Error Logging: Detailed server-side logging

## Monitoring

The server includes built-in request logging:

```javascript
${new Date().toISOString()} - ${req.method} ${req.url}
```

## Development

### Running in Development Mode

```bash
node api.js
```

### Testing the API

You can use tools like Postman or curl to test the endpoints. Example:

```bash
curl "http://localhost:3000/api/ViewAllLocation"
```

## Production Considerations

1. Secure the Google Places API key
2. Configure proper CORS settings
3. Use environment-specific .env files
4. Implement rate limiting
5. Set up proper logging
6. Use PM2 or similar for process management

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
