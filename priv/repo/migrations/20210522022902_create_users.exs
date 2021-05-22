defmodule Rumbl.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text, null: false
      add :username, :text, null: false
      add :password_hash, :text
      timestamps()
    end
    create unique_index(:users, [:username])
  end
end
