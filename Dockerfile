FROM ruby:2.6.3

# Install apt based dependencies required to run Rails 
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs

# Set the working directory where the commands will be executed 
RUN mkdir /shop 
WORKDIR /shop

# Copy the Gemfile and the Gemfile.lock
# This is a separate step so the dependencies will be
# cached unless changes to one of those two files are made.
COPY Gemfile Gemfile.lock ./ 

# Install RubyGems
RUN gem install bundler && bundle install

# Copy the application in the current directory
COPY . ./

# Expose port 3000 to the Docker host, so we can access it from the outside
# EXPOSE 3000

# The main command to run when the container starts
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
