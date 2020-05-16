defmodule SorteioWeb.AdminLive.DashboardComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="dashboard-component">
      <div class="content">
        <h1 class="title is-3 is-spaced">
          <%= gettext "Hello, admin." %>
        </h1>

        <%= if @draw_results do %>
          <h3 class="title is-5 is-spaced">
            <%= gettext "The draw was performed." %>
          </h3>

          <p><%= gettext "There was %{count} participants competing for the prize.", count: @participants_count %></p>

          <button class="button is-info" phx-click="toggle_email" phx-disable-with="Reseting...">
            <%= gettext "Toggle Email" %>
          </button>

          <div class="content">
            <%= gettext "The winners are:" %>

            <ul>
              <%= for winner <- @draw_results.winners do %>
                <li>
                  <%= winner.name %>

                  <%= if @show_emails? do %>
                    - <%= winner.email %>
                  <% end %>
                </li>
              <% end %>
            </ul>
          </div>

          <button class="button is-danger" phx-click="reset" phx-disable-with="<%= gettext "Reseting...." %>"><%= gettext "Reset" %></button>
          <button class="button is-danger" phx-click="clear_results" phx-disable-with="<%= gettext "Undoing draw...." %>"><%= gettext "Undo draw" %></button>
      </div>
      <% else %>
        <p><%= gettext "There are %{count} participants competing for the prize.", count: @participants_count %></p>

        <p><%= gettext "To make the draw, enter the desired number of winners and press the button:" %></p>

        <form class="signup columns" phx-submit="draw">
          <div class="column is-1">
            <label for="count" class="label sr-only"><%= gettext "Participants count" %></label>
          </div>
          <div class="column is-1">
            <input type="number" id="count" name="count" class="input" value="<%= @count %>" required>
          </div>

          <div class="column is-2">
            <button class="button is-danger" type="submit" phx-disable-with="<%= gettext "Drawing..." %>"><%= gettext "Draw" %></button>
          </div>
        </form>
      <% end %>
    </div>
    """
  end
end
