defmodule Draw.MainChannel do
  use Phoenix.Channel
  alias Draw.{Presence, Drawing, Repo}

  def join("draw:" <> drawing_id, _params, socket) do
    drawing = Draw.Repo.get!(Drawing, drawing_id)
    socket = assign(socket, :drawing_id, drawing.id)

    send self(), :after_join

    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("point:updated", point, socket) do
    IO.inspect(point)

    broadcast! socket, "point:updated", %{
      user: socket.assigns.user,
      x: point["x"],
      y: point["y"],
      color: point["color"],
      timestamp: :os.system_time(:milli_seconds)
    }

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    {:noreply, socket}
  end

  intercept ["point:updated"]

  @doc """
  Prevent point update events going out to the same user who made them.
  """
  def handle_out("point:updated", message, socket) do
    unless socket.assigns[:user] == message.user do
      push socket, "point:updated", message
    end
    {:noreply, socket}
  end
end
