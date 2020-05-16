defmodule SorteioWeb.AdminLive.LoginComponent do
  use SorteioWeb, :live_component

  def render(assigns) do
    ~L"""
    <div class="login-component">
      <div class="columns">
        <form class="column is-half is-offset-one-quarter" phx-submit="signin">
          <h1 class="title is-3 is-spaced">
            <%= gettext "Please, enter your secret password to admin the draw." %>
          </h1>

          <div class="field">
            <label for="password" class="label sr-only"><%= gettext "Password" %></label>
            <input type="password" id="password" name="password" class="input" placeholder="<%= gettext "Your Password" %>" required>
          </div>

          <button class="button is-link" type="submit" phx-disable-with="<%= gettext "Signing in..." %>"><%= gettext "Login" %></button>
        </form>
      </div>

      <footer class="footer">
        <div class="content has-text-centered">
          <p><%= gettext "There are %{count} participants competing for the prize.", count: @participants_count %></p>
        </div>
      </footer>
    </div>
    """
  end
end
