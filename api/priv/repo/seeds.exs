alias ElixirBench.{Benchmarks, Repos}

{:ok, repo} = Repos.create_repo(%{owner: "elixir-ecto", name: "ecto"})

mysql_plain = Benchmarks.get_or_create_benchmark!(repo.id, "insert_mysql/insert_plain")
mysql_changeset = Benchmarks.get_or_create_benchmark!(repo.id, "insert_mysql/insert_changeset")
pg_plain = Benchmarks.get_or_create_benchmark!(repo.id, "insert_pg/insert_plain")
pg_changeset = Benchmarks.get_or_create_benchmark!(repo.id, "insert_pg")

common_data = %{
  "collected_at" => DateTime.utc_now(),
  "commit_sha" => "207b2a0",
  "commit_message" => """
  Add elixirbench config file
  """,
  "commited_date" => DateTime.from_naive!(~N[2017-12-09T15:15:02Z], "Etc/UTC"),
  "commit_url" => "https://github.com/elixir-ecto/ecto/commit/207b2a0fb5407b7162a454a12bacf8f1a4c962c0",

  "elixir_version" => "1.5.2",
  "erlang_version" => "20.1",
  "dependency_versions" => %{},
  "cpu" => "Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz",
  "cpu_count" => 8,
  "memory" => 16384
}

{:ok, _} = Benchmarks.create_measurement(mysql_plain, Map.merge(common_data, %{
  "average" => 393.560253365004,
  "ips" => 2540.906993147397,
  "maximum" => 12453.0,
  "median" => 377.0,
  "minimum" => 306.0,
  "mode" => 369.0,
  "percentiles" => %{"50" => 377.0, "99" => 578.6900000000005},
  "sample_size" => 12630,
  "std_dev" => 209.33476197004862,
  "std_dev_ips" => 1351.5088377210595,
  "std_dev_ratio" => 0.5319001605985423,
  "run_times" => []
}))
{:ok, _} = Benchmarks.create_measurement(mysql_changeset, Map.merge(common_data, %{
  "average" => 450.2023723288664,
  "ips" => 2221.2233019276814,
  "maximum" => 32412.0,
  "median" => 397.0,
  "minimum" => 301.0,
  "mode" => 378.0,
  "percentiles" => %{"50" => 397.0, "99" => 1003.3999999999942},
  "sample_size" => 11044,
  "std_dev" => 573.9417528830307,
  "std_dev_ips" => 2831.732735787863,
  "std_dev_ratio" => 1.274852795453007,
  "run_times" => []
}))

{:ok, _} = Benchmarks.create_measurement(pg_plain, Map.merge(common_data, %{
  "average" => 473.0912894636744,
  "ips" => 2113.756947699591,
  "maximum" => 13241.0,
  "median" => 450.0,
  "minimum" => 338.0,
  "mode" => 442.0,
  "percentiles" => %{"50" => 450.0, "99" => 727.0},
  "sample_size" => 10516,
  "std_dev" => 273.63253429178945,
  "std_dev_ips" => 1222.5815257169884,
  "std_dev_ratio" => 0.5783926704759165,
  "run_times" => []
}))
{:ok, _} = Benchmarks.create_measurement(pg_changeset, Map.merge(common_data, %{
  "average" => 465.8669101807624,
  "ips" => 2146.5357984150173,
  "maximum" => 13092.0,
  "median" => 452.0,
  "minimum" => 338.0,
  "mode" => 440.0,
  "percentiles" => %{"50" => 452.0, "99" => 638.0},
  "sample_size" => 10677,
  "std_dev" => 199.60367678670747,
  "std_dev_ips" => 919.6970816229071,
  "std_dev_ratio" => 0.4284564377179282,
  "run_times" => []
}))
