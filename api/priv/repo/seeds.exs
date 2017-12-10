alias ElixirBench.{Benchmarks, Repos}

{:ok, runner} = Benchmarks.create_runner(%{name: "test-runner", api_key: "test"})
{:ok, repo} = Repos.create_repo(%{owner: "elixir-ecto", name: "ecto"})

{:ok, %{id: job_id}} = Benchmarks.create_job(repo.id, %{branch_name: "mm/benches", commit_sha: "207b2a0"})

{:ok, %{id: ^job_id} = job} = Benchmarks.claim_job(runner)

data = %{
  "elixir_version" => "1.5.2",
  "erlang_version" => "20.1",
  "dependency_versions" => %{},
  "cpu" => "Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz",
  "cpu_count" => 8,
  "memory_mb" => 16384,
  "log" => """
  [now] Oh how ward it was to run this benchmark!
  """,
  "measurements" => %{
    "insert_mysql/insert_plain" => %{
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
    },
    "insert_mysql/insert_changeset" => %{
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
    },
    "insert_pg/insert_plain" => %{
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
    },
    "insert_pg/insert_changeset" => %{
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
    }
  }
}

:ok = Benchmarks.submit_job(job, data)
