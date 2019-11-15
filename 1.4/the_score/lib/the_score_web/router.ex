defmodule TheScoreWeb.Router do
  use TheScoreWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TheScoreWeb do
    pipe_through(:browser)

    get("/", ScoreController, :index)
    post("/filter", ScoreController, :filter)
    post("/sort", ScoreController, :sort)
    get("/csv", CsvController, :export)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TheScoreWeb do
  #   pipe_through :api
  # end
end
