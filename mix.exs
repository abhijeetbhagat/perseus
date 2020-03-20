defmodule Perseus.MixProject do
  use Mix.Project

  def project do
    [
      app: :perseus,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description,
      package: package,
      deps: deps()
    ]
  end

  defp description() do
    """
    An ISO-BMFF file parsing library.
    """
  end

  defp package() do
    [
      files: ["config", "lib", "mix.exs", "README.md"],
      maintainers: ["abhi"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/abhijeetbhagat/perseus",
        "Docs" => "https://hexdocs.pm/perseus"
      }
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
      {:ex_doc, "~> 0.21.3", only: :dev},
      {:earmark, "~> 1.4.3", only: :dev}
    ]
  end
end
