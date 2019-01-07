defmodule FirebaseAdminEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :firebase_admin_ex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.4", override: true},
      {:jason, "~> 1.1.0"},
      {:mock, "~> 0.3.0", only: :test},
      {:goth, "~> 0.11.0"}
    ]
  end
end
