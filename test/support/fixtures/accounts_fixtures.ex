defmodule Pento.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      username: unique_user_email() |> String.split("@") |> List.first(),
      password: valid_user_password(),
      password_confirmation: valid_user_password()
    })
  end

  def user_fixture(), do: user_fixture(%{}, confirmed: true)

  def user_fixture(attrs \\ %{}, confirmed: confirmed) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Pento.Accounts.register_user()

    if confirmed do
      user
      |> confirm_user_multi()
      |> Pento.Repo.transaction()
    end

    user
  end

  def extract_user_token(fun) do
    {:ok, captured} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token, _] = String.split(captured.text_body, "[TOKEN]")
    token
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, Pento.Accounts.User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(
      :tokens,
      Pento.Accounts.UserToken.user_and_contexts_query(user, ["confirm"])
    )
  end
end
