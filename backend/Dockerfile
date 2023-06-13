FROM ruby:3.1.2
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
ENV RAILS_ENV production
RUN bundle install
COPY . /app
CMD rake db:migrate assets:precompile && rake db:seed && puma -C config/puma.rb && ["rails", "server", "-b", "0.0.0.0"]
