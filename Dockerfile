FROM registry.access.redhat.com/ubi8/ubi:8.1


COPY ./docker-entrypoint.sh ./

# Add the userid with root group
ARG UNAME=testuser
ARG UID=1098

# Add user to the /etc/passwd
# Create the home directory if it does not exist
# with bash shell as the login shell
RUN useradd -m -u $UID -g 0 -s /bin/bash $UNAME


USER $UID

ENTRYPOINT ["/bin/bash", "./docker-entrypoint.sh"]
