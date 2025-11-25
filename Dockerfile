FROM nginx:latest
COPY build/html5 /usr/share/nginx/html
EXPOSE 80