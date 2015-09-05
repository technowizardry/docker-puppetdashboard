FROM ubuntu:15.04

RUN /usr/bin/apt-get update \
   && /usr/bin/apt-get install -qy --no-install-recommends ruby ruby-dev bundler libmysqlclient-dev libpq-dev nodejs make g++ \
   && gem install --no-ri --no-rdoc unicorn
ADD puppet-dashboard /puppet-dashboard
WORKDIR /puppet-dashboard
RUN /bin/bash -c -l 'bundle install --without development test postgresql'
ADD config/database.yml /puppet-dashboard/config/database.yml
ADD config/settings.yml /puppet-dashboard/config/settings.yml
ADD unicorn-config.rb /config/unicorn-config.rb
ADD init-settings.rb /scripts/init-settings.rb
RUN /usr/bin/ruby /scripts/init-settings.rb \
   && EXECJS_RUNTIME=Node /usr/bin/ruby /usr/bin/bundle exec /usr/local/bin/rake assets:precompile
EXPOSE 8080
CMD ["/usr/bin/ruby", "/usr/bin/bundle", "exec", "/usr/local/bin/unicorn", "-E", "production", "-c", "/config/unicorn-config.rb", "/puppet-dashboard/config.ru"]
