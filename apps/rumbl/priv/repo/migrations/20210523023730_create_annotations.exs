defmodule Rumbl.Repo.Migrations.CreateAnnotations do
  use Ecto.Migration

  def change do
    create table(:annotations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :text, null: false
      add :at, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :video_id, references(:videos, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

    create index(:annotations, [:user_id])
    create index(:annotations, [:video_id])
  end
end
