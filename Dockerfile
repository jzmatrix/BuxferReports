FROM jzmatrix/debian-baseimage
################################################################################
RUN apt update && \
    apt -y install libyaml-tiny-perl liblwp-protocol-https-perl libjson-perl libdbd-mysql-perl libdbi-perl  libcryptx-perl libmime-lite-html-perl libmime-tools-perl libmail-imapclient-perl libdate-calc-perl curl
##
RUN  apt-get autoremove && \
     apt-get clean && \
     apt-get autoclean && \
     rm -rf /var/lib/apt/lists/* && \
     mkdir /opt/sslUpdate && \
     mkdir /var/run/sshd && \
     chmod 0755 /var/run/sshd && \
     mkdir /opt/buxfer
################################################################################
ADD config/authorized_keys /root/.ssh/authorized_keys
ADD config/startServices.sh /opt/startServices.sh
ADD config/bash_profile /root/.bash_profile
################################################################################
RUN chmod 0600 /root/.ssh/authorized_keys && \
    chmod 755 /opt/startServices.sh && \
    chmod 644 /root/.bash_profile
################################################################################
ADD files/budgetReport /opt/buxfer/budgetReport
ADD files/bankingReport /opt/buxfer/bankingReport
RUN chmod 755 /opt/buxfer/budgetReport
RUN chmod 755 /opt/buxfer/bankingReport
################################################################################
CMD ["/opt/buxfer/bankingReport"]   # Used when deployed
# CMD [ "/opt/startServices.sh" ] # Only used for dev and testing
