defmodule ElixirBench.BenchmarksTest do
  use ElixirBench.DataCase

  alias ElixirBench.Benchmarks

  describe "measurements" do
    alias ElixirBench.Benchmarks.Measurement

    @valid_attrs %{collected_at: "2010-04-17 14:00:00.000000Z"}
    @update_attrs %{collected_at: "2011-05-18 15:01:01.000000Z"}
    @invalid_attrs %{collected_at: nil}

    def measurement_fixture(attrs \\ %{}) do
      {:ok, measurement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Benchmarks.create_measurement()

      measurement
    end

    test "list_measurements/0 returns all measurements" do
      measurement = measurement_fixture()
      assert Benchmarks.list_measurements() == [measurement]
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = measurement_fixture()
      assert Benchmarks.get_measurement!(measurement.id) == measurement
    end

    test "create_measurement/1 with valid data creates a measurement" do
      assert {:ok, %Measurement{} = measurement} = Benchmarks.create_measurement(@valid_attrs)
      assert measurement.collected_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Benchmarks.create_measurement(@invalid_attrs)
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = measurement_fixture()
      assert {:ok, measurement} = Benchmarks.update_measurement(measurement, @update_attrs)
      assert %Measurement{} = measurement
      assert measurement.collected_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = measurement_fixture()
      assert {:error, %Ecto.Changeset{}} = Benchmarks.update_measurement(measurement, @invalid_attrs)
      assert measurement == Benchmarks.get_measurement!(measurement.id)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = measurement_fixture()
      assert {:ok, %Measurement{}} = Benchmarks.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Benchmarks.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = measurement_fixture()
      assert %Ecto.Changeset{} = Benchmarks.change_measurement(measurement)
    end
  end
end
