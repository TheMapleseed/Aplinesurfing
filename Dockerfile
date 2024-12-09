# Start with Alpine and Go base image
FROM golang:1.20-alpine as build

# Install necessary dependencies for Go, GCC, musl-dev, git, OpenJDK, and other utilities
RUN apk add --no-cache gcc musl-dev git openjdk11 bash

# Set up Go workspace
WORKDIR /app
COPY . .

# Build the Go application
RUN go build -o myapp

# Create the final image with only the binary, and include Java Runtime and necessary packages
FROM alpine:latest

# Install OpenJDK for Java Runtime Environment (JRE)
RUN apk add --no-cache openjdk11

# Install other necessary dependencies for running Windsurf and your app
RUN apk add --no-cache bash

# Set up the working directory
WORKDIR /root/

# Copy the Go binary from the build stage
COPY --from=build /app/myapp .

# Expose the port your app will run on
EXPOSE 8080

# Add Windsurf installation instructions here if needed
# This could involve downloading and installing Windsurf from the appropriate source, 
# or using a prebuilt binary compatible with Alpine

# Set entrypoint for your app
CMD ["./myapp"]
