# Roost

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Get started

Ensure you have Postgres and Ruby 2.3 or higher installed, then run the setup script:

```sh
$ ./script/setup
```

## Using the Application

Start the web server and processors (reactors and projectors):

```sh
$ foreman start
```

## Adding features

Generate a new aggregate, command and event:

```sh
$ eventsourcery generate:command recipe add
```

Generate a query and projection that subscribes to events:

```sh
$ eventsourcery generate:query active_recipes recipe_added
```

Generate a reactor that subscribes to events:

```sh
$ eventsourcery generate:reactor recipe_publisher recipe_added recipe_deleted
```
