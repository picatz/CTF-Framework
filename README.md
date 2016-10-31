# Picat's Capture the Flag Framework

This web application framework is meant to provide a very simple, easy to configure CTF application based mostly off of one simple YAML configuration file.

## Screen Shot
![Screen Shot](http://i.imgur.com/lxGIn2c.jpg)

#### Todo

* Command-Line Configuration
* Command-Line Deployment
* Docker or Vagrant something something
* Web Administration Panel
* Command-Line Administration Interface
* Statistic information
* Black list options?
* Ban user option?
* Do a complete audit of the code.
* Probably refactoring
* Go over inline documentation to make sure it all makes sense

## Installation

Installation is thought of with OSX and Debian in mind. Provided with this application is a "config.yaml" file and in the ssl directory, a "gen_self_signed_cert" shell script to help with the generation of a self signed SSL certificate for the lols.

### Ruby Gems

In this application is a `Gemfile` and a `Gemfile.lock` -- and if I've done everything correctly you should be able to use bundler to install the needed Ruby gems:

```
$ bundle install
```

Otherwise, if you'd like to install the gems manually, well, that's fine too.

```
$ (sudo) gem install sinatra rack-protection rack-ssl rack-ssl-enforcer thin trollop colorize b crypt pry
```

I need to check all this out better. But, I've been able to get it to work. lolololol

## Running the Application

To run this application, a command-line wrapper has been implemented.

### Start

Depending on your platform and the port you want to run your application on, you may have to use sudo.

```
$ (sudo) ruby app.rb -r
```
### Other Options

Running the application without any flags default to a help menu which helps details the other options available.

```
CTF FRAMEWORK
  -r, --run        Run the application
  -e, --edit       Edit configuration file
  -v, --version    Print version and exit
  -h, --help       Show this message
```
#### Note

This application is still developing new features. The `--edit` option is an example of this.

## Logging

Current logging is just going to stdout. But, this will be modified soon.

Logging will be split into two separate files stored in the `log` directory of the application: the `access.log` containing the normal web logs ( think, like, an apache log file ); and an `error.log` which will populate with any errors.

## SSL

Like any secure application, self-signed certs for the win! Something more secure would be preferable.

### Generate Self-Signed Cert Script

Provided in the `ssl` directory of this application is a simple shell script to generate the appropriate ssl certs for this application. Totally. ;)

#### No, but seriously, I turned it off for now.

Because who wants that crap when you're doing local test? Sniff my web app traffic, I dare you. Unless you do, in which case, no. Don't. Stop. Hackers!

## YAML Configuration

This will turn into a command-line flag in future. But, for now the "config.yaml" file drives all the main configurations for this application including password and email restrictions, the capture the flag's customize name, ssl options, the logo and basically everything.
