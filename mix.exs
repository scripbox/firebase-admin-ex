defmodule FirebaseAdminEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :firebase_admin_ex,
      version: "0.2.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/scripbox/firebase-admin-ex",
      homepage_url: "https://github.com/scripbox/firebase-admin-ex"
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
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:mock, "~> 0.3.3", only: :test},
      {:goth, "~> 1.1"},
      {:ex_doc, "~> 0.21.2", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "The Firebase Admin Elixir SDK"
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/scripbox/firebase-admin-ex"}
    ]
  end
end
