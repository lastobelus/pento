defmodule Pento.Promo.Recipient do
  @moduledoc """
  Schemaless struct to hold recipients for the promo.
  """

  defstruct [:first_name, :email]

  @types %{first_name: :string, email: :string}

  alias Pento.Promo.Recipient

  import Ecto.Changeset

  def changeset(%Recipient{} = user, attrs) do
    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
