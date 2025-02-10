# Stage 1: Build the Angular application
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the Angular application with Node.js
FROM node:18-alpine

WORKDIR /app

# Copy the built Angular application from the build stage
COPY --from=build /app/dist/banking-portal /app/dist/banking-portal

# Copy the server file
COPY server.js .

# Install Express
RUN npm install express

# Expose port 8080
EXPOSE 8080

# Start the Node.js server
CMD ["node", "server.js"]
