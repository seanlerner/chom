# Chom

Chom is a command line utility that alters the permissions of your current directory and its subdirectories to work properly with your
web server.

Specifically, it executes:

    $ chown -R g+w .
    $ chmod -R <username>:<system www group> .

## Installation

Install it from the command line:

    $ gem install chom

## Usage

From the command line, go into the directory you'd like to alter the permissions of, and execute:

    $ chom

If permissions weren't able to be altered properly, chom will exit and suggest you attempt with sudo:

    $ sudo chom

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.com/seanlerner/chom. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

