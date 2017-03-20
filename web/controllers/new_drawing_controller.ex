defmodule Draw.NewDrawingController do
  use Draw.Web, :controller

  alias Draw.{Drawing, Repo}

  def index(conn, %{"drawing" => drawing_params}) do
    changeset = Drawing.changeset(%Drawing{}, drawing_params)

    case Repo.insert(changeset) do
      {:ok, drawing} ->
        conn
        |> put_flash(:info, "Drawing created successfully")
        |> redirect(to: "/drawing/" <> drawing.id)
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating a drawing")
        |> redirect(to: "/")
    end
  end
end