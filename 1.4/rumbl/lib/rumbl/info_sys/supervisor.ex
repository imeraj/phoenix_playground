defmodule Rumbl.InfoSys.Supervisor do
  use Supervisor

  alias Rumbl.InfoSys

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    children = [
      InfoSys.Cache
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end