defmodule PentoWeb.PromoLive do
  @moduledoc """
  Interface for send code to friend promo
  """

  use PentoWeb, :live_view
  alias Pento.Promo
  alias Pento.Promo.Recipient

  def mount(_params, _session, socket) do
    {:ok, setup(socket)}
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient
      |> Promo.change_recipient(recipient_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event(
        "save",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    send_promo(socket, recipient, recipient_params)
  end

  def send_promo(socket, recipient, recipient_params) do
    case Promo.send_promo(recipient, recipient_params) do
      {:ok, _changeset} ->
        {:noreply,
         socket
         |> put_flash(:info, "Promo sent!")
         |> push_redirect(to: Routes.live_path(socket, PentoWeb.PromoLive))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp assign_recipient(socket) do
    socket
    |> assign(:recipient, %Recipient{})
  end

  defp assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
    socket
    |> assign(:changeset, Promo.change_recipient(recipient))
  end

  defp setup(socket) do
    socket
    |> assign_recipient()
    |> assign_changeset()
  end
end
