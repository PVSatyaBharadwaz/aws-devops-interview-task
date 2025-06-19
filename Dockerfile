#I am using a lightweight Nginx web server image
FROM nginx:alpine

#my dockerfile

#Copying our webpage into the web server's public folder
COPY index.html /usr/share/nginx/html
