defmodule ElixirBenchWeb.JobView do
  use ElixirBenchWeb, :view
  alias ElixirBenchWeb.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: %{config: config} = job}) do
    %{
      id: job.id,
      branch_name: job.branch_name,
      commit_sha: job.commit_sha,
      config: %{
        elixir_version: config.elixir,
        erlang_version: config.erlang,
        environment_variables: config.environment,
        deps: %{
          docker: Enum.map(config.deps.docker, &render_docker/1)
        }
      }
    }
  end

  def render_docker(docker) do
    %{
      image: docker.image,
      environment: docker.environment,
      container_name: docker.container_name
    }
  end
end
