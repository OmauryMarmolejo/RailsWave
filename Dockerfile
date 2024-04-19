FROM ruby:3.3.0

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs yarn vim && \
    gem install bundler 

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000