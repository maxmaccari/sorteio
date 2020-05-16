defmodule SorteioWeb.ParticipantLive.WaitingComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="waiting-component">
      <%= if @competing do %>
        <div class="level">
          <p class="is-large"><%= gettext "You're subscribed to participate of the draw. When it happens, you will be notified." %></p>
        </div>

        <div class="level">
          <p class="is-medium"><%= gettext "With you, other %{count} participants are competing for the prize.", count: @participants_count %></p>
        </div>

        <button class="button is-danger" phx-click="giveup" phx-disable-with="<%= gettext "Giving up..." %>">
          <%= gettext "I don't want the prize." %>
        </button>
      <% else %>
        <div class="level">
          <p class="is-large"><%= gettext "There are %{count} people are competing for the prize.", count: @participants_count %></p>
        </div>

        <button class="button is-primary" phx-click="subscribe" phx-disable-with="<%= gettext "Subscribing..." %>">
          <%= gettext "I want the prize too." %>
        </button>
      <% end %>

      <button class="button is-danger" phx-hook="SignOut" phx-click="sign_out" phx-disable-with="<%= gettext "Signing out..." %>">
          <%= gettext "Sign out" %>
        </button>
    </div>
    """
  end
end
