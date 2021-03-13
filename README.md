# Roost

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
[![Maintainability](https://api.codeclimate.com/v1/badges/d27492e9817263c1e9b3/maintainability)](https://codeclimate.com/github/Flockingbird/roost/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d27492e9817263c1e9b3/test_coverage)](https://codeclimate.com/github/Flockingbird/roost/test_coverage)


[Flockingbird](https://flockingbird.social) is a professional social network,
where you manage your business network. Decentralised, and privacy friendly.

*Roost* is the Proof of Concept server and webapp for Flockingbird.

More information:

* [Landing page](https://flockingbird.social) to be expanded homepage
* [Blog](https://fediverse.blog/~/Flockingbird/) updates with progress, concepts and explanations
* [Mastodon](https://fosstodon.org/@flockingbird) updates with newsflashes and feedback


## Contribute

If you want to help, the easiest and most effective thing to do is tell
others about us: spread the word!

Other than that, any help is welcome. From giving unsolicited advice,
via designing mockups, via improving this README, to writing code.

### Designs and Mockups

We are moving the designs from [our Figma](https://www.figma.com/file/CgDIaLgjwVLPzw1ggmrZzy/Flockingbird) to
the Open Source alternative [Penpot](https://penpot.app/). Please drop us an
email at hi@flockingbird.social if you want to be added as team member
on the Flockingbird team in penpot.

Anyone can [view the designs (WIP) on penpot](https://design.penpot.app/#/view/9fab0d70-81a0-11eb-8f95-3363e266841f/9fab0d71-81a0-11eb-8f95-3363e266841f?token=AWxAepQkPqT3aGGiAmOLqw)

### Ideas

Ideas are most welcome! Either add a [new
RFC](https://github.com/Flockingbird/roost/issues/new?assignees=&labels=rfc&template=rfc.md&title=RFC+%5Bdescription%5D)
or drop us a mail at hi@flockingbird or a toot at @flockingbird@fosstodon.org.

### Tasks and code

We are creating a list of tasks for various interests, and skills in
our issues (helping with this list is most welcome too!)

Use the labels to find something that fits for you. For example [tasks for frontend developers](https://github.com/Flockingbird/roost/issues?q=is%3Aissue+is%3Aopen+label%3Afrontend).


## Get started

Ensure you have Postgres and Ruby 2.3 or higher installed, then run the setup script:

```sh
make install
```

## Using the Application

Start the web server and processors (reactors and projectors):

```sh
make run
```

## Develop

We use [envent_sourcery](https://github.com/envato/event_sourcery) by
Envato. If unsure "where something goes", just ask, or read up on event
sourcing starting at event_sourcery README.

Make sure to add tests for any feature or bugfix.

Test with
```sh
make
```

This also enforces some code style guidelines once the tests pass.
