defmodule Lazada.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lazada.Accounts.User
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> unique_constraint(:email)
    |> validate_required([:email, :password])
    |> update_change(:password, &Bcrypt.hashpwsalt/1)
  end
end
