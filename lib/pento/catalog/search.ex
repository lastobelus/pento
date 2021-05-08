defmodule Pento.Catalog.Search do
  @moduledoc """
  Schemaless struct to hold search query
  """

  defstruct [:query]

  @types %{query: :integer}

  alias Pento.Catalog.Search

  import Ecto.Changeset

  def changeset(%Search{} = search, attrs) do
    {search, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:query])
    |> validate_number(:query, greater_than: 999_999)
  end
end
