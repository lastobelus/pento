defmodule PentoWeb.UserRegistrationController do
  use PentoWeb, :controller

  alias Pento.Accounts
  alias Pento.Accounts.User
  alias PentoWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    IO.puts("user_params: #{inspect(user_params, pretty: true)}")
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :confirm, &1)
          )

        conn
        |> put_flash(
          :info,
          "User created successfully. Please check your email for confirmation instructions."
        )
        |> redirect(to: Routes.user_session_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
