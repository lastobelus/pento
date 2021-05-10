defmodule PentoWeb.SurveyLive do
  @moduledoc """
  Live View which implements user survey (dempographics and product ratings)
  """

  use PentoWeb, :live_view
  alias Pento.Accounts

  def mount(_params, %{"user_token" => token}, socket) do
    {:ok,
     socket
     |> assign_user(token)}
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
end
