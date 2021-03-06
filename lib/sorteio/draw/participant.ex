defmodule Sorteio.Draw.Participant do
  @moduledoc false

  defstruct name: nil, email: nil

  @type t :: %Sorteio.Draw.Participant{
          name: String.t(),
          email: String.t()
        }

  @doc false
  @spec new(String.t(), String.t()) :: Sorteio.Draw.Participant.t()
  def new(name, email) do
    %Sorteio.Draw.Participant{
      name: name,
      email: email
    }
  end
end
