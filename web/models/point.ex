defmodule Draw.Point do
  use Draw.Web, :model

  schema "points" do
    field :x, :integer
    field :y, :integer
    field :color, :string
    belongs_to :drawing, Draw.Drawing

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:drawing_id, :x, :y, :color])
    |> validate_required([:drawing_id, :x, :y, :color])
  end
end
