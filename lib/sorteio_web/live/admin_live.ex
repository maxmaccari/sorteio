defmodule SorteioWeb.AdminLive do
  use SorteioWeb, :live_view

  alias Sorteio.Draw

  @secret "s3cr3t"

  @impl true
  def mount(_params, _session, socket) do
    Draw.subscribe()

    {:ok,
     assign(socket,
       authenticated: false,
       error: nil,
       participants_count: Draw.participants_count(),
       count: 1,
       draw_results: nil,
       show_emails?: false
     )}
  end

  @impl true
  def handle_event("signin", %{"password" => password}, socket) do
    if password == @secret do
      {:noreply,
       socket
       |> assign(error: nil, authenticated: true)
       |> put_flash(:sucess, "You're signed in succesfully.")}
    else
      {:noreply, put_flash(socket, :error, "The password is invalid!")}
    end
  end

  @impl true
  def handle_event("draw", %{"count" => count}, socket) do
    count = String.to_integer(count)

    if count > 0 do
      {winners, _losers} = Draw.draw_participants(count)

      draw_results = %{
        winners: winners
      }

      {:noreply,
       socket
       |> assign(draw_results: draw_results)
       |> put_flash(:success, "The draw was performed succesfully.")}
    else
      {:noreply, put_flash(socket, :error, "The count is invalid!")}
    end
  end

  @impl true
  def handle_info({:participant_subscribe, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info({:participant_giveup, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end
end
