# syntax=docker/dockerfile:1
FROM ruby:3.0.2

RUN curl https://deb.nodesource.com/setup_12.x | bash \
  && curl -s -L https://raw.githubusercontent.com/yarnpkg/releases/gh-pages/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client yarn

WORKDIR /task_manager
COPY Gemfile /task_manager/Gemfile
COPY Gemfile.lock /task_manager/Gemfile.lock
RUN bundle install

ADD package.json /task_manager/package.json
ADD yarn.lock /task_manager/yarn.lock
RUN yarn install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ADD . /oauth

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
