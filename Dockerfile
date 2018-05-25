FROM library/ruby:2.5-slim-stretch

RUN gem install --pre erb-hiera -v 0.5.0.pre.rc1
