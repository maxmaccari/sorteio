defmodule Sorteio.Draw.DrawServer do
  use GenServer

  alias Sorteio.Draw

  # Public calls
  def start_link(_init) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def subscribe_participant(%Draw.Participant{} = participant) do
    GenServer.cast(__MODULE__, {:subscribe_participant, participant})
  end

  def remove_participant(%Draw.Participant{} = participant) do
    GenServer.cast(__MODULE__, {:remove_participant, participant})
  end

  def reset() do
    GenServer.cast(__MODULE__, :reset)
  end

  def clear_results() do
    GenServer.cast(__MODULE__, :clear_results)
  end

  def count_participants() do
    GenServer.call(__MODULE__, :count_participants)
  end

  def draw_participants(count \\ 1) do
    GenServer.call(__MODULE__, {:draw_participants, count})
  end

  def get_results() do
    GenServer.call(__MODULE__, :get_results)
  end

  # Private calls

  @impl true
  def init(nil) do
    {:ok, Draw.State.new()}
  end

  @impl true
  def handle_cast({:subscribe_participant, participant}, state) do
    state = Draw.State.subscribe_participant(state, participant)

    Draw.broadcast({
      :participant_subscribed,
      participant,
      Draw.State.count_participants(state)
    })

    {:noreply, state}
  end

  @impl true
  def handle_cast({:remove_participant, participant}, state) do
    state = Draw.State.remove_participant(state, participant)

    Draw.broadcast({
      :participant_removed,
      participant,
      Draw.State.count_participants(state)
    })

    {:noreply, state}
  end

  @impl true
  def handle_cast(:reset, _state) do
    Draw.broadcast(:reseted)

    {:noreply, Draw.State.new()}
  end

  @impl true
  def handle_cast(:clear_results, state) do
    Draw.broadcast(:results_cleared)

    {:noreply, Draw.State.clear_results(state)}
  end

  @impl true
  def handle_call(:count_participants, _from, state) do
    {:reply, Draw.State.count_participants(state), state}
  end

  def handle_call({:draw_participants, count}, _from, state) do
    %Draw.State{results: results} = state = Draw.State.draw(state, count)

    Draw.broadcast({:draw_performed, results})

    {:reply, results, state}
  end

  def handle_call(:get_results, _from, %{results: results} = state) do
    {:reply, results, state}
  end
end
