defmodule Pento.Support.FAQ do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :answer, :string
    field :question, :string
    field :vote_count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer, :vote_count])
    |> validate_required([:question, :answer])
    |> validate_number(:vote_count, greater_than: -5)
  end
end
