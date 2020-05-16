defmodule Sorteio.Draw.State do
  @moduledoc false

  alias Sorteio.Draw

  defstruct participants: [],
            results: nil

  @type t :: %Sorteio.Draw.State{
          participants: list(Sorteio.Draw.Participant.t()),
          results: Sorteio.Draw.Results.t()
        }

  def new do
    %Sorteio.Draw.State{
      participants: [],
      results: nil
    }
  end

  @doc false
  def assign_results(
        %Sorteio.Draw.State{} = state,
        winners,
        losers
      ) do
    %Sorteio.Draw.State{state | results: Draw.Results.new(winners, losers)}
  end

  @spec subscribe_participant(Sorteio.Draw.State.t(), Sorteio.Draw.Participant.t()) ::
          Sorteio.Draw.State.t()
  def subscribe_participant(
        %Draw.State{participants: participants} = state,
        %Draw.Participant{} = participant
      ) do
    if subscribed?(state, participant) do
      update_participant(state, participant)
    else
      %Draw.State{participants: [participant | participants]}
    end
  end

  @doc false
  @spec remove_participant(Sorteio.Draw.State.t(), Sorteio.Draw.Participant.t()) ::
          Sorteio.Draw.State.t()
  def remove_participant(
        %Draw.State{participants: participants} = state,
        %Draw.Participant{email: participant_email}
      ) do
    %Draw.State{
      state
      | participants:
          Enum.reject(participants, fn %Draw.Participant{email: email} ->
            participant_email == email
          end)
    }
  end

  def update_participant(
        %Draw.State{participants: participants} = state,
        %Draw.Participant{email: email, name: name} = participant
      ) do
    index = Enum.find_index(participants, fn participant -> participant.email == email end)

    %Draw.State{
      state
      | participants:
          List.replace_at(participants, index, %Draw.Participant{participant | name: name})
    }
  end

  @doc false
  @spec count_participants(Draw.State.t()) :: integer()
  def count_participants(%Draw.State{participants: participants}) do
    length(participants)
  end

  @doc false
  @spec subscribed?(Sorteio.Draw.State.t(), Sorteio.Draw.Participant.t()) :: boolean
  def subscribed?(
        %Draw.State{participants: participants},
        %Draw.Participant{email: participant_email}
      ) do
    Enum.any?(participants, fn
      %Draw.Participant{email: email} -> participant_email == email
    end)
  end

  @doc false
  @spec new :: Sorteio.Draw.State.t()
  def new do
    %Sorteio.Draw.State{}
  end

  @doc false
  @spec draw(Sorteio.Draw.State.t(), integer()) :: Sorteio.Draw.State.t()
  def draw(%Draw.State{participants: participants} = state, count \\ 1) do
    winners = Enum.take_random(participants, count)

    %Draw.State{state | results: Draw.Results.new(participants, winners)}
  end
end
