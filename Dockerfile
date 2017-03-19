FROM alpine:3.5
MAINTAINER Uri Savelchev <alterrebe@gmail.com>

# Packages: update
RUN apk -U add postfix ca-certificates libsasl py-pip supervisor rsyslog && \
    pip install j2cli

# Add files
COPY conf /root/conf
COPY conf/rsyslog.conf /etc/rsyslog.conf
RUN mkfifo /var/spool/postfix/public/pickup \
    && ln -s /etc/postfix/aliases /etc/aliases

# Configure: supervisor
COPY bin/dfg.sh /usr/local/bin/
COPY conf/supervisor-all.ini /etc/supervisor.d/

# Runner
COPY run.sh /root/run.sh
RUN chmod +x /root/run.sh

# Declare
EXPOSE 25

CMD ["/root/run.sh"]
