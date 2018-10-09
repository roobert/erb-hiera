FROM library/ruby:2.5-alpine3.7

RUN gem install --pre erb-hiera -v 0.5.0.pre.rc6
