defmodule GithubLiveviewWeb.GithubDeployView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <div>
          <button phx-click="github_deploy">Deploy to GitHub</button>
        </div>
        Status: <%= @deploy_step %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

  def handle_event("github_deploy", _value, socket) do
    # start deploy
    :timer.sleep(1000)
    send(self(), :create_org)
    {:noreply, assign(socket, deploy_step: "Starting deploy...")}
  end

  def handle_info(:create_org, socket) do
    # create org
    :timer.sleep(1000)
    send(self(), :create_repo)
    {:noreply, assign(socket, deploy_step: "Creating GitHub org...")}
  end

  def handle_info(:create_repo, socket) do
    # create repo
    :timer.sleep(1000)
    send(self(), :push_contents)
    {:noreply, assign(socket, deploy_step: "Creating GitHub repo...")}
  end

  def handle_info(:push_contents, socket) do
    # push to repo
    :timer.sleep(1000)
    send(self(), :done)
    {:noreply, assign(socket, deploy_step: "Pushing to repo...")}
  end

  def handle_info(:done, socket) do
    :timer.sleep(1000)
    {:noreply, assign(socket, deploy_step: "Done!")}
  end
end
