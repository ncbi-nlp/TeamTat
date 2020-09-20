FROM ruby:2.5.5

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
  apt-get install -y  --no-install-recommends wait-for-it mariadb-client libmariadb-dev nodejs\
  graphicsmagick poppler-utils poppler-data ghostscript \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /app

RUN rm config/credentials.yml.enc
COPY config/master.key.sample config/master.key
COPY config/credentials.yml.enc.sample config/credentials.yml.enc
# COPY config/database.yml.docker config/database.yml

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x docker-entrypoint.sh
RUN ln -s usr/local/bin/entrypoint.sh /entrypoint.sh # backwards compat

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]