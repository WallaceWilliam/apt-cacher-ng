# syntax=docker/dockerfile:latest
# https://docs.docker.com/samples/apt-cacher-ng/
FROM ubuntu:22.04
ARG APT_PROXY
ARG PROXY_HOST
ARG PROXY_PORT
ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}

# Expose the cache directory for volume binding
VOLUME ["/var/cache/apt-cacher-ng"]

# Update apt-get cache
RUN --mount=type=cache,target=/var/cache/apt/archives --mount=type=cache,target=/var/lib/apt \
    if [ ! -z "${APT_PROXY}" ] ; then \
    apt update && apt install --no-install-recommends -yq netcat && \
    if nc -zv ${PROXY_HOST} ${PROXY_PORT} ; then (eval ${APT_PROXY:-};); fi && \
    apt purge -yq netcat && apt autoremove -yq; fi && \
    rm -rf /etc/apt/apt.conf.d/docker-clean && \
    apt update && apt install --no-install-recommends -yq apt-cacher-ng ca-certificates && \
    # Append PassThroughPattern config for SSL/TLS proxying (optional)
    sed -e 's|^[# ]*\(ForeGround:\).*|\1 1|' \
        -e 's|^[# ]*\(PassThroughPattern: \.\*\).*|\1|' \
        -e 's|^[# ]*\(AllowUserPorts:\).*|\1 80 443|' \
        -i /etc/apt-cacher-ng/acng.conf && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    (rm -f /var/cache/apt/* || true) && \
    true

# Expose the apt-cacher-ng port to be binded
EXPOSE 3142/tcp

# Set cache directory permissions
#CMD chmod 777 /var/cache/apt-cacher-ng /var/log/apt-cacher-ng && \
#        cat /etc/apt-cacher-ng/acng.conf && \
#        # Start the service
#        /etc/init.d/apt-cacher-ng start && \
#        # Output all logs of apt-cacher-ng
#        tail -f /var/log/apt-cacher-ng/*
#COPY entrypoint.sh /usr/local/sbin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
COPY entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["apt-cacher-ng","-c","/etc/apt-cacher-ng"]
#CMD ["/etc/init.d/apt-cacher-ng","start"]
