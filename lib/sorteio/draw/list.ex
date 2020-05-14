defmodule Sorteio.Draw.List do
  defstruct participants: []

  @type t :: %Sorteio.Draw.List{
          participants: list(%Sorteio.Draw.Participant{})
        }

  alias Sorteio.Draw.{List, Participant}

  @spec subscribe(Sorteio.Draw.List.t(), Sorteio.Draw.Participant.t()) :: Sorteio.Draw.List.t()
  def subscribe(%List{participants: participants} = list, %Participant{} = participant) do
    if subscribed?(list, participant) do
      list
    else
      %List{participants: [participant | participants]}
    end
  end

  @spec giveup(Sorteio.Draw.List.t(), Sorteio.Draw.Participant.t()) :: Sorteio.Draw.List.t()
  def giveup(%List{participants: participants}, %Participant{email: participant_email}) do
    %List{
      participants:
        Enum.reject(participants, fn %Participant{email: email} ->
          participant_email == email
        end)
    }
  end

  @spec count(Sorteio.Draw.List.t()) :: integer()
  def count(%List{participants: participants}) do
    length(participants)
  end

  @spec subscribed?(Sorteio.Draw.List.t(), Sorteio.Draw.Participant.t()) :: boolean
  def subscribed?(%List{participants: participants}, %Participant{email: participant_email}) do
    Enum.any?(participants, fn %Participant{email: email} -> participant_email == email end)
  end

  @spec new :: Sorteio.Draw.List.t()
  def new do
    %Sorteio.Draw.List{}
  end

  def draw(%List{participants: participants}, count \\ 1) do
    winners = Enum.take_random(participants, count)
    losers = Enum.reject(participants, fn participant -> participant in winners end)

    {winners, losers}
  end
end
