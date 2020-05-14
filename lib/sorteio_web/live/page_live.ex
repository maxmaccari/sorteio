defmodule SorteioWeb.PageLive do
  use SorteioWeb, :live_view

  alias Sorteio.Draw

  @impl true
  def mount(_params, _session, socket) do
    Draw.subscribe()

    {:ok,
     assign(socket,
       competing: false,
       participant: nil,
       participants_count: Draw.participants_count(),
       draw_results: nil
     )}
  end

  @impl true
  def handle_event("signup", %{"name" => name, "email" => email}, socket) do
    participant = Draw.Participant.new(name, email)

    Draw.participant_subscribe(participant)

    {:noreply, assign(socket, participant: participant, competing: true)}
  end

  @impl true
  def handle_event("giveup", _, socket) do
    Draw.participant_giveup(socket.assigns.participant)

    {:noreply, assign(socket, competing: false)}
  end

  @impl true
  def handle_event("subscribe", _, socket) do
    Draw.participant_subscribe(socket.assigns.participant)

    {:noreply, assign(socket, competing: true)}
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
  def handle_info({:participant_draw, winners, _}, socket) do
    participant = socket.assigns.participant
    winner? = Enum.member?(winners, participant)

    other_winners =
      Enum.reject(winners, fn winner ->
        winner == participant
      end)

    IO.inspect(other_winners)

    {:noreply,
     assign(socket,
       draw_results: %{
         winner?: winner?,
         other_winners: other_winners,
         winners: winners
       }
     )}
  end
end
