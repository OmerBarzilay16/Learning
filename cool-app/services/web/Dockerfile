FROM nginx:1.27-alpine
# Optional custom config if you need stricter caching / routes
# COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY static/ /usr/share/nginx/html/
EXPOSE 80