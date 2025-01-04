FROM ruby:3.1-alpine

WORKDIR /app

RUN apk add --no-cache build-base

COPY Gemfile ./
RUN bundle install

COPY . .

EXPOSE 8080
CMD ["ruby", "app.rb"]
