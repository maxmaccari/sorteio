defmodule SorteioWeb.ParticipantLive.LoseComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="lose-component">
      <h2 class="title is-4 is-spaced"><%= gettext "Sorry!! The draw is done and you didn't win the prize. :(" %></h2>

      <img src="https://media1.tenor.com/images/701a53f5ed5bb4df3af074b0e2c02ce5/tenor.gif?itemid=7556577" alt="Sad Gif">
    </div>
    """
  end
end
