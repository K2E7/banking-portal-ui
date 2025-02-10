# Stage 1: Build the Angular application
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --unsafe-perm=true --allow-root

# Copy the rest of the application code
COPY . .

# Build the Angular application
RUN npm run build --prod

# Stage 2: Serve the Angular application with Node.js
FROM node:18-alpine

WORKDIR /app

# Create a non-root user and grant ownership
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN mkdir -p /app && chown -R appuser:appgroup /app

# Switch to the new non-root user
USER appuser

# Copy the built Angular application from the build stage
COPY --from=build /app/dist/banking-portal /app/dist/banking-portal

# Copy the server file
COPY server.js .

# Install Express with correct permissions
RUN npm install express --unsafe-perm=true --allow-root

# Expose port 8080
EXPOSE 8080

# Start the Node.js server
CMD ["node", "server.js"]
