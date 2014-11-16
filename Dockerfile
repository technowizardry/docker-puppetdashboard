FROM ubuntu:14.04

RUN /usr/bin/apt-get update
RUN /usr/bin/apt-get install -qy --no-install-recommends wget unzip ruby1.9.1 bundler thin libmysqlclient-dev libpq-dev nodejs ruby1.9.1-dev make gcc g++
ADD puppet-dashboard /puppet-dashboard
WORKDIR puppet-dashboard
RUN /bin/bash -c -l 'bundle install --without development test postgresql'
COPY config/database.yml /puppet-dashboard/config/database.yml
COPY config/settings.yml /puppet-dashboard/config/settings.yml
RUN EXECJS_RUNTIME=Node ruby `which rake` assets:precompile
CMD thin -R config.ru -e production -s $NUM_SERVERS -P /tmp/thin.pid -S /var/run/thin/puppet_dashboard.sock -u www-data -g www-data start && while ps -p `cat /tmp/thin.0.pid` > /dev/null; do sleep 30; done
