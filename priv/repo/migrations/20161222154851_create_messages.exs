defmodule Messages.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message_id, :string
      add :user_id, :string
      add :content, :binary
      add :timestamp, :utc_datetime
    end
  end
end
