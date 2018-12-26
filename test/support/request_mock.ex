defmodule FirebaseAdminEx.RequestMock do
  # Public API
  def post(_url, %{message: _message}, _headers) do
    {:ok, successful_response()}
  end

  # Private API
  defp successful_response do
    %HTTPoison.Response{
      body:
        "{\n  \"name\": \"projects/YOUR-FIREBASE-PROJECT-ID/messages/0:1523208634968690%cc9b4facf9fd7ecd\"\n}\n",
      headers: [
        {"Content-Type", "application/json; charset=UTF-8"},
        {"Vary", "X-Origin"},
        {"Vary", "Referer"},
        {"Date", "Sun, 08 Apr 2018 17:30:34 GMT"},
        {"Server", "ESF"},
        {"Cache-Control", "private"},
        {"X-XSS-Protection", "1; mode=block"},
        {"X-Frame-Options", "SAMEORIGIN"},
        {"X-Content-Type-Options", "nosniff"},
        {"Alt-Svc",
         "hq=\":443\"; ma=2592000; quic=51303432; quic=51303431; quic=51303339; quic=51303335,quic=\":443\"; ma=2592000; v=\"42,41,39,35\""},
        {"Accept-Ranges", "none"},
        {"Vary", "Origin,Accept-Encoding"},
        {"Transfer-Encoding", "chunked"}
      ],
      request_url:
        "https://fcm.googleapis.com/v1/projects/YOUR-FIREBASE-PROJECT-ID/messages:send",
      status_code: 200
    }
  end
end
