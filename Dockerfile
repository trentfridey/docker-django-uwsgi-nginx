FROM centos:latest

# configure repo list
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# install dev tools
RUN yum -y install epel-release
RUN yum -y install wget make gcc openssl-devel bzip2-devel mysql-devel git vim libffi-devel
RUN yum clean all

ARG app_base_path="/opt/myapp"
ARG gid=101
ARG gname="www-data"
ARG uid=101
ARG uname="www-data"

# user, group, assign membership
RUN set -exu; \
    groupadd -g ${gid} -o ${gname}; \
    useradd -l -u ${uid} -g ${gid} -o -s /bin/false ${uname}; \
    mkdir --parents ${app_base_path}; \
    chown ${uname}:${gname} ${app_base_path}; \
    chmod g+s ${app_base_path};

RUN set -exu; \
    install -v -d -o ${uname} -g ${gname} /var/run/supervisor/; \
    install -v -d -o ${uname} -g ${gname} /var/run/uwsgi/;

# python 3.8.10
WORKDIR /tmp/
RUN wget -O Python-3.8.10.tgz https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz
RUN tar xzf Python-3.8.10.tgz
WORKDIR /tmp/Python-3.8.10
RUN ./configure --enable-optimizations
RUN make altinstall
RUN ln -sfn /usr/local/bin/python3.8 /usr/bin/python3.8
RUN ln -sfn /usr/local/bin/pip3.8 /usr/bin/pip3.8
RUN python3.8 -m pip install --upgrade pip

# supervisord
RUN mkdir -p /var/log/supervisor/
RUN mkdir -p /var/run/supervisor
RUN mkdir -p /etc/supervisor/conf.d/
RUN mkdir -p /var/log/uwsgi
RUN pip3.8 install supervisor==4.2.2 
RUN pip3.8 install uwsgi
COPY ./supervisord.conf /etc/supervisord.conf
COPY ./uwsgi.ini /etc/supervisord.d/
COPY ./uwsgi.conf /etc/

# grant sudo for www-data for supervisor
COPY ./sudoers /etc/sudoers.d/
RUN set -exu; \
    chmod 0440 /etc/sudoers.d/sudoers;

# copy app src and install reqs
COPY ./myapp ${app_base_path}
RUN pip3.8 install -r ${app_base_path}/requirements.txt

# copy entrypoint
COPY ./entrypoint.sh /opt
RUN chmod 755 /opt/entrypoint.sh

ENV DJANGO_ENV=prod
ENV DOCKER_CONTAINER=1

EXPOSE 8000
EXPOSE 5678

WORKDIR /
ENTRYPOINT ["sh", "/opt/entrypoint.sh"]
