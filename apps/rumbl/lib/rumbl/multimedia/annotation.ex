defmodule Rumbl.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "annotations" do
    field :at, :integer
    field :body, :string

    belongs_to :user, Rumbl.Accounts.User
    belongs_to :video, Rumbl.Multimedia.Video

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
