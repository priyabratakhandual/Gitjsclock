FROM nginx:alpine
COPY Gitjsclock/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
