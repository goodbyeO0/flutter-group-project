require("dotenv").config();

const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");
const crypto = require("crypto");
const axios = require("axios");

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

// Add this before your routes to log all requests
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

// MySQL Connection
const db = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

db.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
    return;
  }
  console.log("Connected to MySQL database");

  // Test the connection
  db.query("SELECT 1", (err, results) => {
    if (err) {
      console.error("Error testing connection:", err);
      return;
    }
    console.log("Database connection test successful");
  });
});

// Helper function to hash passwords
const hashPassword = (password) => {
  return crypto.createHash("sha256").update(password).digest("hex");
};

// User Authentication APIs
app.get("/api/CheckUser", (req, res) => {
  const { UserEmail, UserPassword } = req.query;
  const hashedPassword = hashPassword(UserPassword);

  db.query(
    "SELECT UserID, UserName, UserEmail FROM users WHERE UserEmail = ? AND UserPassword = ?",
    [UserEmail.toLowerCase(), hashedPassword],
    (err, results) => {
      if (err) {
        return res.json({
          status: 500,
          error: `Database error: ${err.message}`,
        });
      }

      if (results.length === 0) {
        return res.json({
          status: 402,
          error: "Email or password incorrect",
        });
      }

      res.json({
        status: 200,
        message: "Login successful",
        data: results[0],
      });
    }
  );
});

app.get("/api/RegisterUser", (req, res) => {
  console.log("Received registration request:", req.query);

  const { UserName, UserEmail, UserPassword } = req.query;

  if (!UserName || !UserEmail || !UserPassword) {
    console.log("Missing required fields:", {
      UserName,
      UserEmail,
      UserPassword,
    });
    return res.status(400).json({
      status: 400,
      error: "Missing required fields",
    });
  }

  const hashedPassword = hashPassword(UserPassword);

  db.query(
    "INSERT INTO users (UserName, UserEmail, UserPassword) VALUES (?, ?, ?)",
    [UserName, UserEmail.toLowerCase(), hashedPassword],
    (err, result) => {
      if (err) {
        console.error("Database error:", err);
        if (err.code === "ER_DUP_ENTRY") {
          return res.status(400).json({
            status: 400,
            error: "Email already exists",
          });
        }
        return res.status(500).json({
          status: 500,
          error: `Database error: ${err.message}`,
        });
      }

      console.log("Registration successful:", result);
      res.status(200).json({
        status: 200,
        message: "Registration successful",
        data: {
          UserID: result.insertId,
          UserName,
          UserEmail: UserEmail.toLowerCase(),
        },
      });
    }
  );
});

app.get("/api/DeleteUser", (req, res) => {
  const { UserID } = req.query;

  db.query("DELETE FROM users WHERE UserID = ?", [UserID], (err, result) => {
    if (err) {
      return res.json({
        status: 401,
        error: `Database error: ${err.message}`,
      });
    }

    if (result.affectedRows === 0) {
      return res.json({
        status: 404,
        error: "User not found",
      });
    }

    res.json({
      status: 200,
      data: "Data deleted Successfully",
    });
  });
});

app.get("/api/EditUser", (req, res) => {
  const { UserID, UserName, UserEmail, UserPassword } = req.query;

  let updateFields = {
    UserName,
    UserEmail: UserEmail.toLowerCase(),
  };

  if (UserPassword) {
    updateFields.UserPassword = hashPassword(UserPassword);
  }

  const query = "UPDATE users SET ? WHERE UserID = ?";

  db.query(query, [updateFields, UserID], (err, result) => {
    if (err) {
      return res.json({
        status: 500,
        error: `Database error: ${err.message}`,
      });
    }

    if (result.affectedRows === 0) {
      return res.json({
        status: 404,
        error: "User not found",
      });
    }

    res.json({
      status: 200,
      data: "Data updated successfully",
    });
  });
});

app.get("/api/GetUserData", (req, res) => {
  const { UserID } = req.query;

  db.query(
    "SELECT UserID, UserName, UserEmail FROM users WHERE UserID = ?",
    [UserID],
    (err, results) => {
      if (err) {
        return res.json({
          status: 500,
          error: `Database error: ${err.message}`,
        });
      }

      if (results.length === 0) {
        return res.json({
          status: 404,
          error: "User not found",
        });
      }

      res.json({
        status: 200,
        data: results[0],
      });
    }
  );
});

// Location APIs
app.get("/api/RegisterLocation", (req, res) => {
  const { HospitalName, HospitalLang, HospitalLong, HospitalAddress } =
    req.query;

  db.query(
    "INSERT INTO locations (HospitalName, HospitalLang, HospitalLong, HospitalAddress) VALUES (?, ?, ?, ?)",
    [HospitalName, HospitalLang, HospitalLong, HospitalAddress],
    (err, result) => {
      if (err) {
        return res.json({
          status: 401,
          error: `Database error: ${err.message}`,
        });
      }

      res.json({
        status: 200,
        data: "Data Inserted Successfully",
      });
    }
  );
});

app.get("/api/ViewAllLocation", (req, res) => {
  console.log("Fetching all locations");

  db.query("SELECT * FROM locations", (err, results) => {
    if (err) {
      console.error("Database error:", err);
      return res.status(500).json({
        status: 500,
        error: `Database error: ${err.message}`,
      });
    }

    console.log("Found locations:", results.length);
    res.status(200).json(results);
  });
});

app.get("/api/DeleteLocation", (req, res) => {
  const { LocationID } = req.query;

  db.query(
    "DELETE FROM locations WHERE LocationID = ?",
    [LocationID],
    (err, result) => {
      if (err) {
        return res.json({
          status: 401,
          error: `Database error: ${err.message}`,
        });
      }

      res.json({
        status: 200,
        data: "Location Deleted Successfully",
      });
    }
  );
});

app.get("/api/updateLocation", (req, res) => {
  const {
    LocationID,
    HospitalName,
    HospitalLang,
    HospitalLong,
    HospitalAddress,
  } = req.query;

  db.query(
    "UPDATE locations SET HospitalName = ?, HospitalLang = ?, HospitalLong = ?, HospitalAddress = ? WHERE LocationID = ?",
    [HospitalName, HospitalLang, HospitalLong, HospitalAddress, LocationID],
    (err, result) => {
      if (err) {
        return res.json({
          status: 401,
          error: `Database error: ${err.message}`,
        });
      }

      res.json({
        status: 200,
        data: "Data updated successfully",
      });
    }
  );
});

// Add this with your other environment variables
const GOOGLE_PLACES_API_KEY = process.env.GOOGLE_PLACES_API_KEY;

app.get("/api/getNearbyHospitals", async (req, res) => {
  const { latitude, longitude, radius } = req.query;

  try {
    // Call Google Places API to get nearby hospitals
    const response = await axios.get(
      `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=${radius}&type=hospital&key=${GOOGLE_PLACES_API_KEY}`
    );

    const hospitals = response.data.results.map((place) => ({
      LocationID: place.place_id,
      HospitalName: place.name,
      HospitalLang: place.geometry.location.lat,
      HospitalLong: place.geometry.location.lng,
      HospitalAddress: place.vicinity,
      Distance: calculateDistance(
        latitude,
        longitude,
        place.geometry.location.lat,
        place.geometry.location.lng
      ),
    }));

    // Sort by distance and limit to 15 results
    hospitals.sort((a, b) => a.Distance - b.Distance);
    const nearestHospitals = hospitals.slice(0, 15);

    res.json(nearestHospitals);
  } catch (error) {
    console.error("Error fetching nearby hospitals:", error);
    res.status(500).json({
      status: 500,
      error: "Failed to fetch nearby hospitals",
    });
  }
});

// Helper function to calculate distance between two points
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of the earth in km
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) *
      Math.cos(deg2rad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // Distance in km
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}

app.post("/api/trackLocation", async (req, res) => {
  const { UserID, latitude, longitude, address, deviceInfo } = req.query;
  const userAgent = deviceInfo || req.headers["user-agent"];

  try {
    // Log the tracking request
    console.log(`
      New location update:
      User ID: ${UserID}
      Location: ${latitude}, ${longitude}
      Address: ${address}
      Device: ${userAgent}
      Time: ${new Date().toLocaleString()}
    `);

    db.query(
      "INSERT INTO location_history (UserID, latitude, longitude, address, user_agent) VALUES (?, ?, ?, ?, ?)",
      [UserID, latitude, longitude, address, userAgent],
      (err, result) => {
        if (err) {
          console.error("Database error:", err);
          return res.status(500).json({
            status: 500,
            error: `Database error: ${err.message}`,
          });
        }

        res.status(200).json({
          status: 200,
          message: "Location tracked successfully",
        });
      }
    );
  } catch (error) {
    console.error("Error tracking location:", error);
    res.status(500).json({
      status: 500,
      error: "Failed to track location",
    });
  }
});

// Add this new endpoint
app.get("/api/getUserTracking", (req, res) => {
  const query = `
    SELECT 
      users.UserName,
      location_history.latitude,
      location_history.longitude,
      location_history.address,
      location_history.user_agent,
      location_history.timestamp
    FROM location_history
    JOIN users ON location_history.UserID = users.UserID
    ORDER BY location_history.timestamp DESC
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.error("Database error:", err);
      return res.status(500).json({
        status: 500,
        error: `Database error: ${err.message}`,
      });
    }

    // Format the data for display
    const formattedResults = results.map((record) => ({
      userName: record.UserName,
      location: {
        latitude: record.latitude,
        longitude: record.longitude,
        address: record.address,
      },
      deviceInfo: record.user_agent,
      reportedAt: record.timestamp,
    }));

    // If it's a browser request, send HTML
    if (req.headers.accept.includes("text/html")) {
      const html = `
        <!DOCTYPE html>
        <html>
        <head>
          <title>User Location Tracking</title>
          <style>
            table { border-collapse: collapse; width: 100%; }
            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
            th { background-color: #4CAF50; color: white; }
            tr:nth-child(even) { background-color: #f2f2f2; }
          </style>
        </head>
        <body>
          <h1>User Location Tracking</h1>
          <table>
            <tr>
              <th>User Name</th>
              <th>Location</th>
              <th>Device Info</th>
              <th>Reported At</th>
            </tr>
            ${formattedResults
              .map(
                (record) => `
              <tr>
                <td>${record.userName}</td>
                <td>
                  Lat: ${record.location.latitude}<br>
                  Long: ${record.location.longitude}<br>
                  Address: ${record.location.address}
                </td>
                <td>${record.deviceInfo}</td>
                <td>${new Date(record.reportedAt).toLocaleString()}</td>
              </tr>
            `
              )
              .join("")}
          </table>
        </body>
        </html>
      `;
      res.send(html);
    } else {
      // If it's an API request, send JSON
      res.json(formattedResults);
    }
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});
