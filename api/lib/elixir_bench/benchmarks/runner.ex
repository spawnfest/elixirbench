defmodule ElixirBench.Benchmarks.Runner do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirBench.Benchmarks.Runner

  schema "runners" do
    field :api_key, :string, virtual: true
    field :api_key_hash, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Runner{} = runners, attrs) do
    runners
    |> cast(attrs, [:name, :api_key])
    |> validate_required([:name, :api_key])
    |> hash_api_key()
  end

  def verify_api_key(%Runner{api_key_hash: key_hash}, key) do
    Bcrypt.verify_pass(key, key_hash)
  end

  defp hash_api_key(changeset) do
    if api_key = get_change(changeset, :api_key) do
      change(changeset, api_key_hash: Bcrypt.hash_pwd_salt(api_key))
    else
      changeset
    end
  end
end
