defmodule PentoWeb.SurveyLive do
  @moduledoc """
  Live View which implements user survey (dempographics and product ratings)
  """

  use PentoWeb, :live_view
  alias Pento.Accounts
  alias Pento.Survey

  def mount(_params, %{"user_token" => token}, socket) do
    {:ok,
     socket
     |> assign_user(token)
     |> assign_demographic}
  end

  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp assign_user(socket, token) do
    assign_new(
      socket,
      :current_user,
      fn ->
        Accounts.get_user_by_session_token(token)
      end
    )
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(
      socket,
      :demographic,
      Survey.get_demographic_by_user(current_user)
    )
  end
end
