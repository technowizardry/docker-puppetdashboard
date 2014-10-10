FROM ubuntu:14.04

RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install -qy wget unzip
RUN /usr/bin/apt-get install -qy ruby1.9.1 bundler thin
RUN /usr/bin/apt-get install -qy libmysqlclient-dev libpq-dev
#RUN wget https://github.com/sodabrew/puppet-dashboard/archive/master.zip
#RUN unzip master.zip
#WORKDIR puppet-dashboard-master/
ADD puppet-dashboard /puppet-dashboard
WORKDIR puppet-dashboard
RUN /bin/bash -c -l 'bundle install --without development test postgresql'
RUN gem install therubyracer --no-ri --no-rdoc
COPY config/database.yml /puppet-dashboard/config/database.yml
COPY config/settings.yml /puppet-dashboard/config/settings.yml
RUN ruby -rtherubyracer `which rake` assets:precompile
CMD thin -R config.ru -e production -S /var/run/thin/puppet_dashboard.$SERVER_ID.sock start
