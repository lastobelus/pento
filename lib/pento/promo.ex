defmodule Pento.Promo do
  @moduledoc """
  Promo context
  """

  alias Pento.Promo
  alias Pento.Promo.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  @doc """
  send email to promo recipient
  """
  def send_promo(recipient, attrs) do
    changeset = Promo.change_recipient(recipient, attrs)

    cond do
      changeset.valid? ->
        IO.puts("===== Would send email here ====")
        {:ok, recipient}

      true ->
        {:error, changeset}
    end
  end
end
