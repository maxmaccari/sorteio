defmodule Sorteio.Draw do
  use GenServer

  alias Sorteio.Draw.{List, Participant}

  # Public calls
  def start_link(_init) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def participant_subscribe(%Participant{} = participant) do
    GenServer.cast(__MODULE__, {:participant_subscribe, participant})
  end

  def participant_giveup(%Participant{} = participant) do
    GenServer.cast(__MODULE__, {:participant_giveup, participant})
  end

  def participants_count() do
    GenServer.call(__MODULE__, :participants_count)
  end

  def draw_participants(count \\ 1) do
    GenServer.call(__MODULE__, {:draw_participants, count})
  end

  @topic "Sorteio.Draw"
  def subscribe() do
    Phoenix.PubSub.subscribe(Sorteio.PubSub, @topic)
  end

  # Private calls

  @impl true
  def init(nil) do
    {:ok, List.new()}
  end

  @impl true
  def handle_cast({:participant_subscribe, participant}, participants) do
    participants = List.subscribe(participants, participant)

    Phoenix.PubSub.broadcast(
      Sorteio.PubSub,
      @topic,
      {:participant_subscribe, participant, List.count(participants)}
    )

    {:noreply, participants}
  end

  @impl true
  def handle_cast({:participant_giveup, participant}, participants) do
    participants = List.giveup(participants, participant)

    Phoenix.PubSub.broadcast(
      Sorteio.PubSub,
      @topic,
      {:participant_giveup, participant, List.count(participants)}
    )

    {:noreply, participants}
  end

  @impl true
  def handle_call(:participants_count, _from, participants) do
    {:reply, List.count(participants), participants}
  end

  def handle_call({:draw_participants, count}, _from, participants) do
    {winners, losers} = List.draw(participants, count)

    Phoenix.PubSub.broadcast(
      Sorteio.PubSub,
      @topic,
      {:participant_draw, winners, losers}
    )

    {:reply, {winners, losers}, participants}
  end
end
