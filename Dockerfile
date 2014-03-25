FROM hbouvier/precise-chef
MAINTAINER henri bouvier

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN apt-get -y update
ADD . /chef

# Small trick to Install fuse(libreoffice dependency) because of container permission issue in DOCKER.
RUN apt-get -y install fuse || true
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get -y install fuse

RUN cd /chef && /opt/chef/embedded/bin/berks install --path /chef/cookbooks
RUN chef-solo -c /chef/solo.rb -j /chef/solo.json

EXPOSE 9200 9300

CMD cd /usr/local/elasticsearch && bin/elasticsearch -f
