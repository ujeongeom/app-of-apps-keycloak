# Set the base image
FROM openjdk:11-jre-slim AS backend-build

# Set the working directory for the backend
WORKDIR /app/backend

# Copy the backend source code to the container
COPY backend/ .

# Build the backend application
RUN ./mvnw clean package -DskipTests

# Stage 2: Build Vue.js application
FROM node:14 AS frontend-build

# Set the working directory for the frontend
WORKDIR /app/frontend

# Copy the frontend source code to the container
COPY frontend/ .

# Install dependencies and build the frontend application
RUN npm install
RUN npm run build

# Stage 3: Create the final image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the built backend JAR file to the container
COPY --from=backend-build /app/backend/target/backend-*.jar app.jar

# Copy the built frontend files to the container
COPY --from=frontend-build /app/frontend/dist/ ./frontend

ENV TZ Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# Expose the port that the application will run on
# EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
