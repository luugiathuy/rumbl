defmodule Rumbl.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :url, :text, null: false
      add :title, :text, null: false
      add :description, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false

      timestamps()
    end

    create index(:videos, [:user_id])
  end
end
