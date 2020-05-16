defmodule Sorteio.Draw.Results do
  defstruct winners: [], losers: [], timestamp: nil

  @type t :: %Sorteio.Draw.Results{
          winners: list(Sorteio.Draw.Participant.t()),
          losers: list(Sorteio.Draw.Participant.t()),
          timestamp: NaiveDateTime.t()
        }

  def new(participants, winners) do
    %__MODULE__{
      winners: winners,
      losers: Enum.reject(participants, fn participant -> participant in winners end),
      timestamp: NaiveDateTime.utc_now()
    }
  end
end
