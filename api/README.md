# 🌿 Pantry Pal API
An API developed with Node.js utilizing MongoDB.

[![Website shields.io](https://img.shields.io/website-up-down-green-red/http/shields.io.svg)](http://testing.hasty.cc/api)

## 🌟 Goals of this project
*   To create an effective and secure application.
*   Demonstrate mastery of object oreinted design.
*   Show use of good design principles.

## 🔨 Development
| Technology          | Version | Description                                                                                                                                            |
|---------------------|---------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| bcrypt              | 5.0.1   | A library to help hash passwords.                                                                                                                      |
| cors                | 2.8.5   | Node.js CORS middleware                                                                                                                                |
| dotenv              | 8.2.0   | Loads environment variables from .env file.                                                                                                            |
| express             | 4.17.1  | Fast, unopinionated, minimalist web framework.                                                                                                         |
| express-winston     | 4.1.0   | Winston middleware for express.js                                                                                                                      |
| google-auth-library | 7.0.2   | Google APIs Authentication Client Library for Node.js                                                                                                  |
| jsonwebtoken        | 8.5.1   | JSON Web Token implementation (symmetric and asymmetric).                                                                                              |
| mongoose            | 6.11.18 | Mongoose MongoDB ODM.                                                                                                                                  |
| multer              | 1.4.2   | Middleware for handling multipart/form-data.                                                                                                           |
| nodemailer          | 6.5.0   | Easy as cake e-mail sending from your Node.js applications.                                                                                            |
| winston             | 3.0.0   | A logger for just about anything                                                                                                                       |

## 🏃 Installing and running the API

### Requirements
* Node.js version 14.16.0 or greater preferred
* NPM or some other package manager
* An SMTP server for email functionality
* A MongoDB server
* A writable storage medium if allowing image uploads
* A domain or some host with SSL to utilize SSL

**Setup**
1. Download the api from git with `git clone -b live https://github.com/SPVTNIK-ONLINE/Pantry-Pal.git`
    * For the stable version, get from the live branch: `git clone -b live https://github.com/SPVTNIK-ONLINE/Pantry-Pal.git`
    * For the experimental version, get from the development branch: `git clone -b development https://github.com/SPVTNIK-ONLINE/Pantry-Pal.git`
2. Navigate into the cloned repository folder, and into the API folder
3. Download the dependencies with `npm install`
4. Initialize the API configuration by running `npm run-script setup`
5. Configure the API by editing the .env file that has been created.
6. Start the server with either `npm start` or `npm run-script start-background`
    * If using `start-background`, you will need to install nodemon and concurrently with `npm install -g nodemon concurrently`

## 🗨️ Usage
Once the API has been setup, it is possible to connect to it. To verify that you can, navigate to the API. By default configuration, this can be found at [http://localhost:3001/api](http://localhost:3001/api).