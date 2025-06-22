# Helmo
A collection of template helpers to work with Helm.

![Helmo](helmo.png)

The goal is to have a centralized place for helpers and templates that have been created following best practices, or at least some logic, to be used once and again.

Nowadays, all of these have been created by myself while learning Helm and ArgoCD at home, I published them to do not repeat myself (DRY) at work and be able to use them everywhere. Everyone is invited to use them and collaborate.


| Helpers <-(Sub Charts Templates)-> Values Options
|  *.tpl  <-      auto.yaml       -> values.yaml

* Helpers:
  * They are immutable (a minimal updates when need to be extended).
  * This code is the one to be used once and again.
* Templates:
  * They work as binding.
  * Could be always the same "auto.yaml" that reads a structured "values.yaml".
  * Could be a custom "include" for more flexibility.
* Values:
  * The mutable part, here is where an application is defined.
  * Dict were used so it is easier to reference and overwrite.
  * Global is used as main defaults.
  * Remember that it is possible to create a new values-xyz.yaml overwriting all past definitions. Almost a requirement for multiples instances over a variety of clusters and environments.

