defmodule SourceSpaceWeb.Router do
  use SourceSpaceWeb.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :admin_browser_auth do
    plug Guardian.Plug.VerifySession, key: :admin
    plug Guardian.Plug.LoadResource, key: :admin
  end

  scope "/", SourceSpaceWeb do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index

    get "/login", AuthController, :login

    resources "/users", UserController
    resources "/authorizations", AuthorizationController
    resources "/tokens", TokenController
    resources "/profile", ProfileController
  end

  scope "/auth", SourceSpaceWeb do
    pipe_through [:browser, :browser_auth]

    get "/logout", AuthController, :logout
    get "/:identity", AuthController, :request
    get "/:identity/callback", AuthController, :callback
    post "/:identity/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SourceSpaceWeb do
  #   pipe_through :api
  # end
end
