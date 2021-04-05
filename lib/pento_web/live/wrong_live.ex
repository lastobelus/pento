defmodule PentoWeb.WrongLive do
  @moduledoc false

  use PentoWeb, :live_view

  @start_message "Guess a number."
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(
        user: Pento.Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
      |> setup_game()

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>
      Your score: <%= @score %>
    </h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= if @finished do %>
        <%= live_patch(to: Routes.live_path(@socket, PentoWeb.WrongLive, restart: true), replace: true) do %>
        <button>Restart!</button>
        <% end %>
      <% else %>
        <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number="<%= n %>">
          <%= n %>
        </a>
        <% end %>
      <% end %>
    </h2>
    <pre>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end

  def choose_actual() do
    :rand.uniform(10)
  end

  def handle_params(params, _uri, socket) do
    IO.puts("params: #{inspect(params)}")

    socket =
      case(params["restart"]) do
        "true" -> setup_game(socket)
        _ -> socket
      end

    {:noreply, socket}
  end

  defp setup_game(socket) do
    assign(socket,
      score: 0,
      actual: choose_actual(),
      finished: false,
      message: @start_message,
      time: time()
    )
  end

  @spec handle_event(<<_::40>>, map, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_event("guess", %{"number" => guess} = data, socket) do
    IO.puts("guess->data: #{inspect(data)}")

    IO.puts("actual: #{inspect(socket.assigns[:actual])}")
    IO.puts("guess: #{inspect(String.to_integer(guess))}")

    socket =
      case String.to_integer(guess) == socket.assigns[:actual] do
        true ->
          assign(socket,
            actual: choose_actual(),
            score: socket.assigns.score + 1,
            message: "Correct! #{guess} was right. Let's play again...",
            finished: true
          )

        false ->
          assign(socket,
            score: socket.assigns.score - 1,
            message: "Your guess: #{guess}. Wrong. Guess again."
          )
      end

    socket =
      assign(
        socket,
        time: time()
      )

    IO.puts("socket: #{inspect(socket)}")
    IO.puts("-----")
    {:noreply, socket}
  end
end
