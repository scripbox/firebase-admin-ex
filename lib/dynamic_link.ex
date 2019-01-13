defmodule FirebaseAdminEx.DynamicLink do
  alias FirebaseAdminEx.{Request, Response, Errors}

  @short_link_endpoint "https://firebasedynamiclinks.googleapis.com/v1/shortLinks"
  @auth_scope "https://www.googleapis.com/auth/firebase"

  @type suffix_type :: :short | :unguessable

  @doc """
  Generate a short dynamic link based on the supplied parameters or long link.
  See https://firebase.google.com/docs/reference/dynamic-links/link-shortener
  for the full list of supported parameters.

  Examples:

      iex(1)> FirebaseAdminEx.DynamicLink.get_short_link("https://example.page.link/?link=https://example.com/someresource&apn=com.example.android&amv=3&ibi=com.example.ios&isi=1234567&ius=exampleapp", :short)
      {:ok,
        "{\n  \"shortLink\": \"https://example.page.link/M5Jz\",\n  \"previewLink\": \"https://example.page.link/M5Jz?d=1\"\n}\n"}


      iex(2)> p = %{"domainUriPrefix" => "https://example.page.link", "link" => "https://example.com/abcdef", "iosInfo" => %{"iosBundleId" => "com.exampleco.example", "iosAppStoreId" => "123456789"}}
      %{
        "domainUriPrefix" => "https://example.page.link",
        "iosInfo" => %{
          "iosAppStoreId" => "123456789",
          "iosBundleId" => "com.exampleco.example"
        },
        "link" => "https://example.com/abcdef"
      }
      iex(3)> FirebaseAdminEx.DynamicLink.get_short_link(p, :unguessable)
      {:ok,
       "{\n  \"shortLink\": \"https://example.page.link/uH877tctFJ7mctBF6\",\n  \"warning\": [\n    {\n      \"warningCode\": \"UNRECOGNIZED_PARAM\",\n      \"warningMessage\": \"Android app 'com.example' lacks SHA256. AppLinks is not enabled for the app. [https://firebase.google.com/docs/dynamic-links/debug#android-sha256-absent]\"\n    }\n  ],\n  \"previewLink\": \"https://example.page.link/uH877tctFJ7mctBF6?d=1\"\n}\n"}
  """

  @spec short_link(map() | String.t(), suffix_type, String.t() | nil) :: tuple()
  def short_link(params, type \\ :unguessable, client_email \\ nil) do
    payload = build_payload(params, type)
    with {:ok, response} <-
           Request.request(
             :post,
             @short_link_endpoint,
             payload,
             auth_header(client_email)
           ),
         {:ok, body} <- Response.parse(response),
         {:ok, result} <- Jason.decode(body) do
      {:ok, result}
    else
      {:error, error} -> raise Errors.ApiError, Kernel.inspect(error)
    end
  end

  defp build_payload(long_link, type) when is_binary(long_link) do
    %{
      "longDynamicLink" => long_link,
      "suffix" => %{"option" => option(type)}
    }
  end

  defp build_payload(params, type) when is_map(params)do
    %{
      "dynamicLinkInfo" => params,
      "suffix" => %{"option" => option(type)}
    }
  end

  defp option(:short), do: "SHORT"
  defp option(:unguessable), do: "UNGUESSABLE"

  defp auth_header(nil) do
    {:ok, token} = Goth.Token.for_scope(@auth_scope)

    do_auth_header(token.token)
  end

  defp auth_header(client_email) do
    {:ok, token} = Goth.Token.for_scope({client_email, @auth_scope})

    do_auth_header(token.token)
  end

  defp do_auth_header(token) do
    %{"Authorization" => "Bearer #{token}"}
  end
end
