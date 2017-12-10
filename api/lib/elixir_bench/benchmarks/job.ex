defmodule ElixirBench.Benchmarks.Job do
  use Ecto.Schema

  import Ecto.Changeset

  alias ElixirBench.Benchmarks.{Runner, Job, Config}

  schema "jobs" do
    field :repo_id, :id

    belongs_to :claimant, Runner, foreign_key: :claimed_by
    field :claimed_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :log, :string

    field :branch_name, :string
    field :commit_message, :string
    field :commit_sha, :string
    field :commit_url, :string

    field :cpu, :string
    field :cpu_count, :integer
    field :dependency_versions, {:map, :string}
    field :elixir_version, :string
    field :erlang_version, :string
    field :memory_mb, :integer

    embeds_one :config, Config

    timestamps()
  end

  @submit_fields [
    :elixir_version,
    :erlang_version,
    :dependency_versions,
    :cpu,
    :cpu_count,
    # TODO: change to a string memory
    # :memory_mb,
    :log
  ]

  @create_fields [
    :branch_name,
    :commit_sha,
  ]

  def claim_changeset(%Job{} = job, claimed_by) do
    job
    |> change(claimed_by: claimed_by, claimed_at: DateTime.utc_now())
  end

  def create_changeset(%Job{} = job, attrs) do
    job
    |> cast(attrs, @create_fields)
    |> validate_required(@create_fields)
  end

  def submit_changeset(%Job{} = job, attrs) do
    job
    |> cast(attrs, @submit_fields)
    |> validate_required(@submit_fields)
    |> put_change(:completed_at, DateTime.utc_now())
  end
end
