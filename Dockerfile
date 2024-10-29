ARG RUBY_VERSION=3.3.5
FROM docker.io/library/ruby:$RUBY_VERSION

# Throws errors if the Gemfile has been modified since Gemfile.lock was created.
RUN bundle config --global frozen 1

# Rails app lives here
WORKDIR /rails

ENV RAILS_ENV="development"

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

EXPOSE 3000
CMD ["./bin/rails", "server"]