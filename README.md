# Firebase Admin Elixir SDK

## Overview

The Firebase Admin Elixir SDK enables access to Firebase services from privileged environments
(such as servers or cloud) in Elixir.

For more information, visit the
[Firebase Admin SDK setup guide](https://firebase.google.com/docs/admin/setup/).

## Installation

* Add `firebase_admin_ex` to your list of dependencies in `mix.exs`:

```ex
defmodule YourApplication.Mixfile do
  use Mix.Project

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:firebase_admin_ex, "~> 0.1.0"},
      {:goth, "~> 0.8.0"}
    ]
  end
end
```

> Note the [goth][goth] package, which handles Google Authentication, is also
> required.

Next, run `mix deps.get` to pull down the dependencies:

```sh
$ mix deps.get
```

Now you can make an API call by obtaining an access token and using the
generated modules.

### Obtaining an Access Token
Authentication is typically done through [Application Default Credentials][adc]
which means you do not have to change the code to authenticate as long as
your environment has credentials.

Start by creating a [Service Account key file][service_account_key_file].
This file can be used to authenticate to Google Cloud Platform services from any environment.
To use the file, set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to
the path to the key file.
For example:

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service_account.json
```

If you are deploying to App Engine, Compute Engine, or Container Engine, your
credentials will be available by default.

### Usage

* Sending a `WebMessage`

```ex
# Obtain an access token using goth
firebase_messaging_scope = "https://www.googleapis.com/auth/firebase.messaging"
{:ok, token} = Goth.Token.for_scope(firebase_messaging_scope)
oauth_token = token.token

# Get your device registration token
registration_token = "user-device-token"

# Define message payload attributes
message = FirebaseAdminEx.Messaging.Message.new(%{
  data: %{},
  token: registration_token,
  webpush: FirebaseAdminEx.Messaging.WebMessage.Config.new(%{
    headers: %{},
    data: %{},
    title: "notification title",
    body:  "notification body",
    icon:  "https://icon.png"
  })
})

# Call the Firebase messaging V1 send API
project_id = "YOUR-FIREBASE-PROJECT-ID"
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, oauth_token, message)
```

* Sending a `AndroidMessage`

```ex
# Obtain an access token using goth
firebase_messaging_scope = "https://www.googleapis.com/auth/firebase.messaging"
{:ok, token} = Goth.Token.for_scope(firebase_messaging_scope)
oauth_token = token.token

# Get your device registration token
registration_token = "user-device-token"

# Define message payload attributes
message = FirebaseAdminEx.Messaging.Message.new(%{
  data: %{},
  token: registration_token,
  android: FirebaseAdminEx.Messaging.AndroidMessage.Config.new(%{
    headers: %{},
    data: %{},
    title: "notification title",
    body:  "notification body",
    icon:  "https://icon.png"
  })
})

# Call the Firebase messaging V1 send API
project_id = "YOUR-FIREBASE-PROJECT-ID"
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, oauth_token, message)
```

* Sending a `APNSMessage`

```ex
# Obtain an access token using goth
firebase_messaging_scope = "https://www.googleapis.com/auth/firebase.messaging"
{:ok, token} = Goth.Token.for_scope(firebase_messaging_scope)
oauth_token = token.token

# Get your device registration token
registration_token = "user-device-token"

# Define message payload attributes
message = FirebaseAdminEx.Messaging.Message.new(%{
  data: %{},
  token: registration_token,
  apns: FirebaseAdminEx.Messaging.APNSMessage.Config.new(%{
    headers: %{},
    payload: %{
      aps: %{
        alert: %{
          title: "Message Title",
          body: "Message Body"
        },
        sound: "default",
        "content-available": 1
      },
      custom_data: %{}
    }
  })
})

# Call the Firebase messaging V1 send API
project_id = "YOUR-FIREBASE-PROJECT-ID"
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, oauth_token, message)
```

## Firebase Documentation

* [Setup Guide](https://firebase.google.com/docs/admin/setup/)
* [Authentication Guide](https://firebase.google.com/docs/auth/admin/)
* [Cloud Messaging Guide](https://firebase.google.com/docs/cloud-messaging/admin/)

## License and Terms

Your use of Firebase is governed by the
[Terms of Service for Firebase Services](https://firebase.google.com/terms/).

## Disclaimer

This is not an officially supported Google product.

[adc]: https://cloud.google.com/docs/authentication#getting_credentials_for_server-centric_flow
[service_account_key_file]: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount
[hex_pm]: https://hex.pm/users/google-cloud
[goth]: https://hex.pm/packages/goth
