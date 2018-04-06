# Firebase Admin Elixir SDK

## Overview

The Firebase Admin Elixir SDK enables access to Firebase services from privileged environments
(such as servers or cloud) in Elixir.

For more information, visit the
[Firebase Admin SDK setup guide](https://firebase.google.com/docs/admin/setup/).

## Installation

1. Add `firebase_admin_ex` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:firebase_admin_ex, "~> 0.1.0"}]
  end
  ```

2. Ensure `firebase_admin_ex` is started before your application:

  ```elixir
  def application do
    [applications: [:firebase_admin_ex]]
  end
  ```

## Configuration

## Usage

## Firebase Documentation

* [Setup Guide](https://firebase.google.com/docs/admin/setup/)
* [Authentication Guide](https://firebase.google.com/docs/auth/admin/)
* [Cloud Messaging Guide](https://firebase.google.com/docs/cloud-messaging/admin/)

## License and Terms

Your use of Firebase is governed by the
[Terms of Service for Firebase Services](https://firebase.google.com/terms/).
