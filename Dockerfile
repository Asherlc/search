FROM ruby:latest 
RUN mkdir ./app 
ADD . /app
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install