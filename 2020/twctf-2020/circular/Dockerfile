FROM ruby:2.7

WORKDIR /app

COPY keygen.rb .
RUN ruby keygen.rb

COPY . .
RUN gem install --no-document bundler && bundle config --local frozen true && bundle install
# This is for GCP deployment, not releated to the challenge.
RUN wget https://github.com/nomeaning777/exec-with-secret/releases/download/v0.1.2/exec-with-secret-amd64 -O /bin/exec-with-secret && chmod +x /bin/exec-with-secret

USER nobody:nogroup
ENTRYPOINT [ "/bin/exec-with-secret", "bundle", "exec", "functions-framework-ruby", "-t", "index" ]