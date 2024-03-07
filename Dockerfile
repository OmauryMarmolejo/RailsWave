FROM --platform=linux/amd64 ruby:3.3.0

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs yarn && \
    gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle config --global frozen 1
RUN bundle config set without 'development test'
RUN bundle install

COPY . .

RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "3000"]