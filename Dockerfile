FROM ruby:2.5.0

RUN apt-get update

RUN mkdir -p /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
COPY paychex_api.gemspec /usr/src/app/
COPY /lib/paychex_api/version.rb /usr/src/app/lib/paychex_api/

WORKDIR /usr/src/app
RUN bundle install --system

COPY . /usr/src/app/
