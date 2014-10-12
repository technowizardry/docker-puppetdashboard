FROM ubuntu:14.04

RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install -qy wget unzip
RUN /usr/bin/apt-get install -qy ruby1.9.1 bundler thin
RUN /usr/bin/apt-get install -qy libmysqlclient-dev libpq-dev
RUN /usr/bin/apt-get install -qy nodejs
ADD puppet-dashboard /puppet-dashboard
WORKDIR puppet-dashboard
RUN /bin/bash -c -l 'bundle install --without development test postgresql'
COPY config/database.yml /puppet-dashboard/config/database.yml
COPY config/settings.yml /puppet-dashboard/config/settings.yml
RUN EXECJS_RUNTIME=Node ruby `which rake` assets:precompile
CMD thin -R config.ru -e production -S /var/run/thin/puppet_dashboard.$SERVER_ID.sock start
