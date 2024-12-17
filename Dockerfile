# Step 1: Build the React app
FROM node:16 AS build

# Set the working directory
WORKDIR /app

# Copy only package.json and package-lock.json to leverage caching
COPY package*.json ./

# Install dependencies
RUN npm ci --omit=dev

# Copy the rest of the application
COPY . .

# Build the React application
RUN npm run build

# Step 2: Serve the React app using Nginx
FROM nginx:alpine

# Copy the built React app from the build stage to Nginx's public folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
