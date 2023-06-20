FROM nginx:stable-alpine

ARG archer_daemon_gid=102
ARG archer_daemon_gname="archer_daemon_web_access"
ARG archer_daemon_uid=102
ARG archer_daemon_uname="archer_daemon"

# Security updates and patching
RUN set -exu; \
    apk update; \
    apk add --no-cache --upgrade \
        "curl>7.83.1" \
        "libxml2>2.9.14" \
        "openssl>1.1.1q" \
        pcre2>10.40 \
        xz>5.2.5;

# Register archer_daemon:archer_daemon_web_access so that nginx can read job files (for X-Accel-Redirect)
RUN set -exu; \
    addgroup -g ${archer_daemon_gid} ${archer_daemon_gname}; \
    adduser -D -u ${archer_daemon_uid} ${archer_daemon_uname} -G ${archer_daemon_gname}; \
    addgroup nginx ${archer_daemon_gname}; \
    mkdir -p /etc/nginx/include_templates;

# nginx
RUN mkdir -p /etc/nginx/sites-enabled
COPY ./myapp_nginx.conf ./etc/nginx/sites-available/
COPY ./myapp_nginx.conf /etc/nginx/conf.d/
COPY ./uwsgi_params /etc/nginx/uwsgi_params
RUN ln -s /etc/nginx/sites-available/myapp_nginx.conf /etc/nginx/sites-enabled/
RUN rm /etc/nginx/conf.d/default.conf

EXPOSE 80 443