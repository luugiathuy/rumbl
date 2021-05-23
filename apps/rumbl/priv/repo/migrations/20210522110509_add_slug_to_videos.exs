defmodule Rumbl.Repo.Migrations.AddSlugToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :slug, :text
    end
  end
end
