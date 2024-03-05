FROM ruby:3.3.0

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y nodejs yarn && \
    gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]