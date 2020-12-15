FROM registry.access.redhat.com/ubi8/ubi:8.1


COPY ./docker-entrypoint.sh ./

# Add the userid and group
ARG UNAME=testuser
ARG UID=1098
#ARG GID=1098

#RUN groupadd -g $GID $UNAME \
#    && useradd -m -u $UID -g $GID -s /bin/bash $UNAME

RUN useradd -m -u $UID -g 0 -s /bin/bash $UNAME


USER $UID

ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]
