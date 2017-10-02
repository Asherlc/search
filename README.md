Installation
===

1. Download Docker: [https://www.docker.com](https://www.docker.com)
2. Run `$ docker build -t search .` to build the image
3. Run `$ docker run search bin/search <data source: organizations|users|tickets> <attribute>:<value>`
  i.e. `$ docker run search bin/search organizations _id:101`

If you have Ruby installed locally (this project assumes >2.4) and would prefer to run in your local Ruby, you can do the following:
1. `$ bundle install`
2. `$ bin/search <data source: organizations|users|tickets> <attribute>:<value>`

Running tests:
===

1. Run `$ docker run search bundle exec rspec`
