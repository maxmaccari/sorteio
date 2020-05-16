defmodule SorteioWeb.AdminLive do
  use SorteioWeb, :live_view

  alias Sorteio.Draw

  @impl true
  def mount(_params, _session, socket) do
    Draw.subscribe()

    {:ok,
     assign(socket,
       authenticated: false,
       participants_count: Draw.count_participants(),
       count: 1,
       draw_results: Draw.get_results(),
       show_emails?: false
     )}
  end

  @impl true
  def handle_event("signin", %{"password" => password}, socket) do
    if password == secret() do
      {:noreply,
       socket
       |> clear_flash()
       |> assign(authenticated: true)
       |> put_flash(:sucess, "You're signed in succesfully.")}
    else
      {:noreply, put_flash(socket, :error, "The password is invalid!")}
    end
  end

  @impl true
  def handle_event("draw", %{"count" => count}, socket) do
    count = String.to_integer(count)

    if count > 0 do
      results = Draw.draw_participants(count)

      {:noreply,
       socket
       |> assign(draw_results: results)
       |> put_flash(:success, "The draw was performed succesfully.")}
    else
      {:noreply, put_flash(socket, :error, "The count is invalid!")}
    end
  end

  @impl true
  def handle_event("reset", _params, socket) do
    Draw.reset()

    {:noreply,
     assign(socket,
       participants_count: 0,
       count: 1,
       draw_results: Draw.get_results(),
       show_emails?: false
     )}
  end

  @impl true
  def handle_event("toggle_email", _params, socket) do
    {:noreply,
     assign(socket, show_emails?: !socket.assigns.show_emails?)}
  end

  @impl true
  def handle_info({:participant_subscribed, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info({:participant_removed, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp secret do
    System.get_env("SORTEIO_PASSWORD", "s3cr3t")
  end
end
