# services/web/Dockerfile
FROM nginx:1.27.5-alpine

# hadolint ignore=DL3018  # upgrading security fixes from distro repo; exact pin can be brittle
RUN apk --no-cache upgrade libxml2

COPY nginx.conf /etc/nginx/nginx.conf
COPY static/ /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
