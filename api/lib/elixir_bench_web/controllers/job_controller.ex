defmodule ElixirBenchWeb.JobController do
  use ElixirBenchWeb, :controller

  alias ElixirBench.{Benchmarks, Repos, Benchmarks.Job}

  action_fallback ElixirBenchWeb.FallbackController

  def claim(conn, _params) do
    with {:ok, %Job{} = job} <- Benchmarks.claim_job(conn.assigns.runner),
         {:ok, %Repos.Repo{} = repo} <- Repos.fetch_repo(job.repo_id) do
      conn
      |> render("show.json", job: job, repo: repo)
    end
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    with {:ok, %Job{} = job} <- Benchmarks.fetch_job(id),
         :ok <- Benchmarks.submit_job(job, job_params) do
      conn
      |> send_resp(:no_content, "")
    end
  end
end
