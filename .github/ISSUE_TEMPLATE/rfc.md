---
name: RFC
about: Feature Requests, Proposals, ideas and concepts are discussed by starting a new RFC
title: 'RFC [description]'
labels: 'rfc'
assignees: ''

---
## Summary

Brief explanation of the feature.

## Basic example

Preferably in the form of a story with a stakeholder (fictional person)

As a ...
When I ...
And I ...
Then I ...
So that I ...

## Motivation

Why are we doing this? What use cases does it support? What is the expected
outcome?

Please focus on explaining the motivation so that if this RFC is not accepted,
the motivation could be used to develop alternative solutions. In other words,
enumerate the constraints you are trying to solve without coupling them too
closely to the solution you have in mind.

## Detailed design

This is the bulk of the RFC. Explain the design in enough detail for
somebody familiar with the Fediverse and Flockingbird to understand, and
for somebody familiar with the implementation to implement. This should
get into specifics and corner-cases, and include examples of how the
feature is used. Any new terminology should be defined here.

Please reference [Domain
Model (TODO write)](https://github.com/Flockingbird/roost/wiki/DomainModel)
terminology for existing terms and usage.

## Drawbacks

Why should we *not* do this? Please consider:

- implementation cost, both in term of code size and complexity
- integration of this feature with other existing and planned features
- the impact on server admins, hosters and users
- whether the proposed feature can be implemented in a third party app
    or client instead

There are trade-offs to choosing any path. Attempt to identify them here.

## Alternatives

What other designs have been considered? What is the impact of not doing this?

## Adoption strategy

If we implement this proposal, how will server admins adopt it? Is
this a breaking change? Does it require coordination with third party
clients? Does it require coordination with other Fediverse projects?

## How we teach this

What names and terminology work best for these concepts and why?

## Unresolved questions

Optional, but suggested for first drafts. What parts of the design are still
TBD?

---
Footnotes and references

---
This RFC template is modified from the [React RFC
template](https://github.com/reactjs/rfcs/blob/master/0000-template.md)
