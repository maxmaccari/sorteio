defmodule SorteioWeb.Router do
  use SorteioWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SorteioWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug BasicAuth, use_config: {:sorteio, :dashboard_auth}
  end

  scope "/", SorteioWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/admin", AdminLive, :index
  end

  scope "/" do
    if Mix.env() in [:dev, :test] do
      pipe_through :browser
    else
      pipe_through [:browser, :auth]
    end

    live_dashboard "/dashboard", metrics: SorteioWeb.Telemetry
  end
end
