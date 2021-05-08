defmodule PentoWeb.ProductLive.Search do
  @moduledoc """
  Search products by sku
  """

  use PentoWeb, :live_view
  alias Pento.Catalog
  alias Pento.Catalog.Search

  def mount(_params, _session, socket) do
    {:ok, setup(socket)}
  end

  def handle_event(
        "validate",
        %{"search" => search_params},
        %{assigns: %{search: search}} = socket
      ) do
    changeset =
      search
      |> Catalog.change_search(search_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end

  def handle_event(
        "save",
        %{"search" => search_params},
        %{assigns: %{search: search}} = socket
      ) do
    perform_search(socket, search, search_params)
  end

  defp perform_search(socket, search, search_params) do
    case Catalog.search_products(search, search_params) do
      {:ok, changeset, products} ->
        {:noreply,
         socket
         |> assign(:products, products)
         |> assign(:changeset, changeset)}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:products, [])
         |> assign(:changeset, changeset)}
    end
  end

  defp assign_search(socket) do
    socket
    |> assign(:search, %Search{})
  end

  defp assign_changeset(%{assigns: %{search: search}} = socket) do
    socket
    |> assign(:changeset, Catalog.change_search(search))
  end

  defp setup(socket) do
    socket
    |> assign_search()
    |> assign_changeset()
    |> assign(:products, [])
  end
end
