defmodule ElixirBench.Github.Client do
  alias ElixirBench.Github.Client

  defstruct [:base_url, ssl_options: []]

  def get_plain(%Client{} = client, url, params \\ []) do
    get(client, url(client, url, params), [{"accept", "text/plain"}], fn data ->
      data
    end)
  end

  def get_json(%Client{} = client, url, params \\ []) do
    get(client, url(client, url, params), [{"accept", "application/json"}], fn data ->
      Antidote.decode(data)
    end)
  end

  def get_yaml(%Client{} = client, url, params \\ []) do
    get(client, url(client, url, params), [{"accept", "application/yaml"}], fn data ->
      case :yamerl.decode(data, [:str_node_as_binary, map_node_format: :map]) do
        [parsed] -> {:ok, parsed}
        _ -> {:error, :invalid}
      end
    end)
  end

  defp get(client, url, headers, cb) do
    ssl_options = client.ssl_options
    options = [:with_body, ssl_options: ssl_options]

    case :hackney.get(url, headers, <<>>, options) do
      {:ok, 200, _headers, data} ->
        cb.(data)
      {:ok, status, _headers, data} ->
        {:error, {status, data}}
      {:error, error} ->
        {:error, error}
    end
  end

  defp url(%{base_url: base}, url, params) do
    Path.join(base, url) <> "?" <> URI.encode_query(params)
  end
end
