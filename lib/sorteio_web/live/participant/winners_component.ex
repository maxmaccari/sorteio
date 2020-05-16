defmodule SorteioWeb.ParticipantLive.WinnersComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="winners-component content">
      <h3 class="title is-5 is-spaced"><%= gettext "The winners are:" %></h3>

      <ul>
        <%= for winner <- @draw_results.winners do %>
          <li><%= winner.name %></li>
        <% end %>
      </ul>
    </div>
    """
  end
end
