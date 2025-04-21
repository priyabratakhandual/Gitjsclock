# Use the official Nginx image
FROM nginx:alpine

# Remove default nginx content and copy your files from src/
RUN rm -rf /usr/share/nginx/html/*

# Copy your static files into Nginx's web root
COPY ./src /usr/share/nginx/html

# Expose port 80
EXPOSE 80
