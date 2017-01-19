defmodule Messages.Message do
  use Ecto.Schema

  schema "messages" do
    field :message_id, :string
    field :channel_id, :string
    field :user_id, :string
    field :content, :binary
    field :timestamp, :utc_datetime
  end
end