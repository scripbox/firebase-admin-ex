# Firebase Admin Elixir SDK

[![Build Status](https://travis-ci.org/scripbox/firebase-admin-ex.svg?branch=master)](https://travis-ci.org/scripbox/firebase-admin-ex)

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
      {:firebase_admin_ex, "~> 0.1.0"}
    ]
  end
end
```

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
the path to the key file. Alternatively you may configure goth (the
the authentication ssyas described at
https://github.com/peburrows/goth#installation

For example:

```sh
$ export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service_account.json
```

If you are deploying to App Engine, Compute Engine, or Container Engine, your
credentials will be available by default.

### Usage

#### Messaging

* Sending a `WebMessage`

```ex
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
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, message)
```

* Sending a `AndroidMessage`

```ex
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
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, message)
```

* Sending a `APNSMessage`

```ex
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
{:ok, response} = FirebaseAdminEx.Messaging.send(project_id, message)
```

#### Authentication Management

The `FirebaseAdminEx.Auth` module allows for some limited management of the
Firebase Autentication system. It currently supports getting, deleting and creating users.

* Getting a user by `uid`:

```ex
iex(1)> FirebaseAdminEx.Auth.get_user("hYQIfs35Rfa4UMeDaf8lhcmUeTE2")
{:ok,
 "{\n  \"kind\": \"identitytoolkit#GetAccountInfoResponse\",\n  \"users\": [\n    {\n      \"localId\": \"hYQIfs35Rfa4UMeDaf8lhcmUeTE2\",\n      \"providerUserInfo\": [\n        {\n          \"providerId\": \"phone\",\n          \"rawId\": \"+61400000111\",\n          \"phoneNumber\": \"+61400000111\"\n        }\n      ],\n      \"lastLoginAt\": \"1543976568000\",\n      \"createdAt\": \"1543976568000\",\n      \"phoneNumber\": \"+61400000111\"\n    }\n  ]\n}\n"}
```

* Getting a user by phone number

```ex
iex(1)> FirebaseAdminEx.Auth.get_user_by_phone_number("+61400000111")
{:ok,
 "{\n  \"kind\": \"identitytoolkit#GetAccountInfoResponse\",\n  \"users\": [\n    {\n      \"localId\": \"hYQIfs35Rfa4UMeDaf8lhcmUeTE2\",\n      \"providerUserInfo\": [\n        {\n          \"providerId\": \"phone\",\n          \"rawId\": \"+61400000111\",\n          \"phoneNumber\": \"+61400000111\"\n        }\n      ],\n      \"lastLoginAt\": \"1543976568000\",\n      \"createdAt\": \"1543976568000\",\n      \"phoneNumber\": \"+61400000111\"\n    }\n  ]\n}\n"}
```

* Getting a user by email address

```ex
iex(1)> FirebaseAdminEx.Auth.get_user_by_email("user@example.com")
{:ok,
 "{\n  \"kind\": \"identitytoolkit#GetAccountInfoResponse\",\n  \"users\": [\n    {\n      \"localId\": \"hYQIfs35Rfa4UMeDaf8lhcmUeTE2\",\n      \"providerUserInfo\": [\n        {\n          \"providerId\": \"phone\",\n          \"rawId\": \"+61400000111\",\n          \"phoneNumber\": \"+61400000111\"\n        \"email\": \"user@example.com\"\n      }\n      ],\n      \"lastLoginAt\": \"1543976568000\",\n      \"createdAt\": \"1543976568000\",\n      \"phoneNumber\": \"+61400000111\"\n    }\n  ]\n}\n"}
```

* Deleting a user

```ex
iex(4)> FirebaseAdminEx.Auth.delete_user("hYQIfs35Rfa4UMeDaf8lhcmUeTE2")
{:ok, "{\n  \"kind\": \"identitytoolkit#DeleteAccountResponse\"\n}\n"}
```

* Creating a user

```ex
iex(4)> FirebaseAdminEx.Auth.create_email_password_user(%{"email" => "user@email.com", "password" => "hYQIfs35Rfa4UMeDaf8lhcmUeTE2"})
{:ok,
 "{\n  \"kind\": \"identitytoolkit#SignupNewUserResponse\",\n  \"email\": \"user@email.com\",\n  \"localId\": \"s5dggHJyr3fgdgJkLe234G6h6y\"\n}\n"}
```

* Generating the email action link for sign-in flows

```ex
# Define ActionCodeSettings
action_code_settings = 
  FirebaseAdminEx.Auth.ActionCodeSettings.new(
    %{
      requestType: "EMAIL_SIGNIN",
      email: "user@email.com",
      returnOobLink: true,
      continueUrl: "www.test.com/sign-in",
      canHandleCodeInApp: false,
      dynamicLinkDomain: "",
      androidPackageName: "",
      androidMinimumVersion: "",
      androidInstallApp: false,
      iOSBundleId: ""
    }
  )
client_email = "YOUR-FIREBASE-CLIENT-EMAIL"
project_id = "YOUR-FIREBASE-PROJECT-ID"
iex(4)> FirebaseAdminEx.Auth.generate_sign_in_with_email_link(action_code_settings, client_email, project_id)
{:ok,
 "{\n  \"kind\": \"identitytoolkit#GetOobConfirmationCodeResponse\",\n  \"email\": \"user@email.com\",\n  \"oobLink\": \"https://YOUR-FIREBASE-CLIENT.firebaseapp.com/__/auth/action?mode=signIn&oobCode=xcdwelFRvfbtghHjswvw2f3g46hh6j8&apiKey=Fgae35h6j78_vbsddgs34th6h6hhekj97gfj&lang=en&continueUrl=www.test.com/sign-in\"\n}\n"}
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
