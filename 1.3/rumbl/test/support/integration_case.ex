defmodule RumblWeb.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use RumblWeb.ConnCase
      use PhoenixIntegration
      import RumblWeb.TestHelpers
    end
  end
end
