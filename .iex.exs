alias Pento.{
  Repo,
  Accounts
}

import_if_available Ecto.Query

import_if_available Ecto.Changeset

import_if_available Pento.CustomFunctions

defmodule H do
  def update(schema, changes) do
    schema
    |> Ecto.Changeset.change(changes)
    |> Repo.update
  end

  def load_user(email) when is_binary(email) do
    Repo.get_by(Accounts.User, email: email)
  end
end
