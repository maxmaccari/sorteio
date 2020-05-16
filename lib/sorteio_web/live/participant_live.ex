defmodule SorteioWeb.ParticipantLive do
  use SorteioWeb, :live_view

  alias Sorteio.Draw

  alias SorteioWeb.ParticipantLive.{
    WinComponent,
    WinnersComponent,
    LoseComponent,
    SignupComponent,
    WaitingComponent
  }

  @impl true
  def mount(_params, _session, socket) do
    Draw.subscribe()

    participant = load_participant(socket)

    socket =
      socket
      |> assign(
        competing: !!participant,
        participant: participant,
        participants_count: Draw.count_participants(),
        draw_results: nil
      )
      |> assign_results(Draw.get_results())

    {:ok, socket}
  end

  @impl true
  def handle_event("signup", %{"name" => name, "email" => email}, socket) do
    {:ok, participant} = Draw.add_participant(name, email)

    {:noreply, assign(socket, participant: participant, competing: true)}
  end

  @impl true
  def handle_event("giveup", _, socket) do
    Draw.remove_participant(socket.assigns.participant)

    {:noreply, assign(socket, competing: false)}
  end

  @impl true
  def handle_event("subscribe", _, socket) do
    Draw.subscribe_participant(socket.assigns.participant)

    {:noreply, assign(socket, competing: true)}
  end

  @impl true
  def handle_event("sign_out", _, socket) do
    {:noreply, assign(socket, participant: nil, competing: false)}
  end

  @impl true
  def handle_info(
        {:participant_subscribed, participant, count},
        %Phoenix.Socket{
          assigns: %{participant: %Draw.Participant{email: email}}
        } = socket
      ) do
    {:noreply,
     assign(socket,
       participants_count: count,
       participant:
         if(participant.email == email,
           do: participant,
           else: socket.assigns.participant
         ),
       competing: socket.assigns.competing || email == participant.email
     )}
  end

  @impl true
  def handle_info({:participant_subscribed, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info(
        {:participant_removed, participant, count},
        %Phoenix.Socket{
          assigns: %{participant: %Draw.Participant{email: email}}
        } = socket
      ) do
    {:noreply,
     assign(socket,
       participants_count: count,
       competing: socket.assigns.competing && email != participant.email
     )}
  end

  @impl true
  def handle_info({:participant_removed, _, count}, socket) do
    {:noreply, assign(socket, participants_count: count)}
  end

  @impl true
  def handle_info({:draw_performed, results}, socket) do
    {:noreply, assign_results(socket, results)}
  end

  @impl true
  def handle_info(:reseted, socket) do
    {:noreply,
     assign(socket,
       competing: false,
       participant: nil,
       participants_count: 0,
       draw_results: nil
     )}
  end

  @impl true
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp assign_results(socket, results) do
    if results do
      participant = socket.assigns.participant
      winner? = Enum.member?(results.winners, participant)

      other_winners =
        Enum.reject(results.winners, fn winner ->
          winner == participant
        end)

      assign(socket,
        draw_results: %{
          winner?: winner?,
          other_winners: other_winners,
          winners: results.winners
        }
      )
    else
      socket
    end
  end

  def load_participant(socket) do
    case get_connect_params(socket)["participant"] do
      %{"email" => email, "name" => name} ->
        {:ok, participant} = Draw.add_participant(name, email)

        participant

      _ ->
        nil
    end
  end
end
