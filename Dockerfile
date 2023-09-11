FROM ruby:3.0.0

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev yarn nodejs dos2unix

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

RUN dos2unix bin/rails
ENV BUNDLE_PATH /gems

ENTRYPOINT ["bin/rails"]
CMD ["rails", "s", "-b", "0.0.0.0"]

EXPOSE 3000