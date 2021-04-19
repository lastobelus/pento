defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> validate_number(:unit_price, greater_than: 0.0)
    |> unique_constraint(:sku)
  end

  def markdown_price_changeset(
        %Product{unit_price: old_amt} = product,
        %{unit_price: new_amt} = attrs
      )
      when old_amt != nil
      when new_amt != nil do
    cond do
      new_amt < old_amt ->
        product
        |> cast(attrs, [:unit_price])
        |> validate_number(:unit_price, greater_than: 0.0)

      true ->
        change(product)
        |> add_error(
          :unit_price,
          "new amount (#{inspect(new_amt)} is greater than old amount (#{inspect(old_amt)}"
        )
    end
  end
end
