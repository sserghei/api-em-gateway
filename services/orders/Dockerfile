FROM ruby:3.1-alpine

WORKDIR /app

RUN apk add --no-cache build-base libgcc make

COPY Gemfile ./

RUN bundle install

COPY . .

EXPOSE 3000
CMD ["ruby", "app.rb"]
