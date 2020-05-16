defmodule SorteioWeb.ParticipantLive.WinComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="participant-win">
      <h2 class="title is-4 is-spaced"><%= gettext "Congratulations!! You won the prize." %></h2>

      <img src="https://media.giphy.com/media/W2bgEn3HXO2v4I1Gvs/giphy.gif" alt="Winner gif">

      <%= if Enum.any?(@draw_results.other_winners) do %>
        <div class="content">
          <h3 class="title is-5 is-spaced"><%= gettext "With you, the winners are:" %></h3>

          <ul>
            <%= for winner <- @draw_results.other_winners do %>
              <li><%= winner.name %></li>
            <% end %>
          </ul>

        </div>
      <% end %>

      <p><%= gettext "So, the draw is done. Thank you for participating. :)" %></p>
    </div>
    """
  end
end
