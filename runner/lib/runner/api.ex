defmodule ElixirBench.Runner.Api do

  defmodule Client do
    defstruct [:username, :password, base_url: "https://api.elixirbench.org/runner-api"]
  end

  def claim_job(client) do
    request(:post, client, "/jobs/claim", %{})
  end

  def submit_results(client, job, results) do
    request(:put, client, "/jobs/#{job.id}", %{job: results})
  end

  defp request(method, client, url, data) do
    headers = [{"accept", "application/json"}, {"content-type", "application/json"}]
    data = Antidote.encode!(data)
    full_url = client.base_url <> url
    auth = {client.username, client.password}
    case :hackney.request(method, full_url, headers, data, [:with_body, basic_auth: auth]) do
      {:ok, status, _headers, ""} when status in 200..299 ->
        {:ok, %{}}
      {:ok, status, _headers, body} when status in 200..299 ->
        {:ok, Antidote.decode!(body)}
      {:ok, 404, _headers, _body} ->
        {:error, :not_found}
      {:ok, status, _headers, body} ->
        {:error, {status, body}}
      {:error, error} ->
        {:error, error}
    end
  end
end
