defmodule ElixirBenchWeb.JobView do
  use ElixirBenchWeb, :view
  alias ElixirBenchWeb.JobView

  def render("index.json", %{jobs: jobs, repo: repo}) do
    %{data: render_many(jobs, JobView, "job.json", repo: repo)}
  end

  def render("show.json", %{job: job, repo: repo}) do
    %{data: render_one(job, JobView, "job.json", repo: repo)}
  end

  def render("job.json", %{job: %{config: config} = job, repo: repo}) do
    %{
      id: job.uuid,
      repo_slug: "#{repo.owner}/#{repo.name}",
      branch_name: job.branch_name,
      commit_sha: job.commit_sha,
      config: %{
        elixir_version: config.elixir,
        erlang_version: config.erlang,
        environment_variables: config.environment,
        deps: %{
          docker: render_docker(config.deps)
        }
      }
    }
  end

  defp render_docker(%{docker: docker}) when is_list(docker) do
    Enum.map(docker, &render_each_docker/1)
  end
  defp render_docker(nil), do: []

  def render_each_docker(docker) do
    %{
      image: docker.image,
      environment: docker.environment,
      container_name: docker.container_name
    }
  end
end
