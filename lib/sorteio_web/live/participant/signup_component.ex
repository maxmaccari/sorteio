defmodule SorteioWeb.ParticipantLive.SignupComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="signup-component">
      <div class="columns">
        <form class="signup column is-half is-offset-one-quarter" phx-hook="ParticipantSignup" phx-submit="signup">
          <h1 class="title is-3 is-spaced">
            <%= gettext "Please, enter your name and your email to participate in the draw." %>
          </h1>

          <div class="field">
            <label for="name" class="label sr-only"><%= gettext "Your name" %></label>
            <div class="control">
              <input class="input" id="name" name="name" placeholder="<%= gettext "Your name" %>" required autofocus>
            </div>
          </div>

          <div class="field">
            <label for="email" class="label sr-only"><%= gettext "Your email" %></label>
            <div class="control">
              <input class="input" type="email" id="email" name="email" placeholder="<%= gettext "Your email" %>" required>
            </div>
          </div>

          <button class="button is-link" type="submit" phx-disable-with="<%= gettext "Signing up..." %>"><%= gettext "Sign up" %></button>
        </form>
      </div>

      <footer class="footer">
        <div class="content has-text-centered">
          <p>
            <%= gettext "There are %{count} participants are competing for the prize.", count: @participants_count %>
          </p>
        </div>
      </footer>
    </div>
    """
  end
end
