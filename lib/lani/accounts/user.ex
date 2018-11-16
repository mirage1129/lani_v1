defmodule Lani.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lani.Accounts.Credential

  schema "users" do
    field :name, :string
    field :username, :string
    field :role, :string
    has_one :credential, Credential
    timestamps()
  end

  @optional_fields ~w(role)

  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username])
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
  end

end
