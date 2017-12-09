defmodule ElixirBench.ReposTest do
  use ElixirBench.DataCase

  alias ElixirBench.Repos

  describe "repos" do
    alias ElixirBench.Repos.Repo

    @valid_attrs %{name: "some name", owner: "some owner"}
    @update_attrs %{name: "some updated name", owner: "some updated owner"}
    @invalid_attrs %{name: nil, owner: nil}

    def repo_fixture(attrs \\ %{}) do
      {:ok, repo} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Repos.create_repo()

      repo
    end

    test "list_repos/0 returns all repos" do
      repo = repo_fixture()
      assert Repos.list_repos() == [repo]
    end

    test "get_repo!/1 returns the repo with given id" do
      repo = repo_fixture()
      assert Repos.get_repo!(repo.id) == repo
    end

    test "create_repo/1 with valid data creates a repo" do
      assert {:ok, %Repo{} = repo} = Repos.create_repo(@valid_attrs)
      assert repo.name == "some name"
      assert repo.owner == "some owner"
    end

    test "create_repo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repos.create_repo(@invalid_attrs)
    end

    test "update_repo/2 with valid data updates the repo" do
      repo = repo_fixture()
      assert {:ok, repo} = Repos.update_repo(repo, @update_attrs)
      assert %Repo{} = repo
      assert repo.name == "some updated name"
      assert repo.owner == "some updated owner"
    end

    test "update_repo/2 with invalid data returns error changeset" do
      repo = repo_fixture()
      assert {:error, %Ecto.Changeset{}} = Repos.update_repo(repo, @invalid_attrs)
      assert repo == Repos.get_repo!(repo.id)
    end

    test "delete_repo/1 deletes the repo" do
      repo = repo_fixture()
      assert {:ok, %Repo{}} = Repos.delete_repo(repo)
      assert_raise Ecto.NoResultsError, fn -> Repos.get_repo!(repo.id) end
    end

    test "change_repo/1 returns a repo changeset" do
      repo = repo_fixture()
      assert %Ecto.Changeset{} = Repos.change_repo(repo)
    end
  end
end
