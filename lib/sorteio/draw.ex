defmodule Sorteio.Draw do
  alias Sorteio.Draw.{DrawServer, Participant}

  defdelegate subscribe_participant(participant), to: DrawServer
  defdelegate remove_participant(participant), to: DrawServer
  defdelegate count_participants, to: DrawServer
  defdelegate draw_participants(count), to: DrawServer
  defdelegate get_results, to: DrawServer
  defdelegate reset, to: DrawServer

  @spec add_participant(String.t(), String.t()) :: {:ok, Participant.t()}
  def add_participant(name, email) do
    participant = Participant.new(name, email)

    DrawServer.subscribe_participant(participant)

    {:ok, participant}
  end

  @topic "Sorteio.Draw"

  def subscribe() do
    Phoenix.PubSub.subscribe(Sorteio.PubSub, @topic)
  end

  def broadcast(event) do
    Phoenix.PubSub.broadcast(Sorteio.PubSub, @topic, event)
  end
end
