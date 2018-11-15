defmodule Lani.EventsTest do
  use Lani.DataCase

  alias Lani.Events

  describe "guides" do
    alias Lani.Events.Guide

    @valid_attrs %{bring: "some bring", cost: "some cost", description: "some description", image_url: "some image_url", intensity: "some intensity", map_link: "some map_link", name: "some name", starting_location: "some starting_location"}
    @update_attrs %{bring: "some updated bring", cost: "some updated cost", description: "some updated description", image_url: "some updated image_url", intensity: "some updated intensity", map_link: "some updated map_link", name: "some updated name", starting_location: "some updated starting_location"}
    @invalid_attrs %{bring: nil, cost: nil, description: nil, image_url: nil, intensity: nil, map_link: nil, name: nil, starting_location: nil}

    def guide_fixture(attrs \\ %{}) do
      {:ok, guide} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_guide()

      guide
    end

    test "list_guides/0 returns all guides" do
      guide = guide_fixture()
      assert Events.list_guides() == [guide]
    end

    test "get_guide!/1 returns the guide with given id" do
      guide = guide_fixture()
      assert Events.get_guide!(guide.id) == guide
    end

    test "create_guide/1 with valid data creates a guide" do
      assert {:ok, %Guide{} = guide} = Events.create_guide(@valid_attrs)
      assert guide.bring == "some bring"
      assert guide.cost == "some cost"
      assert guide.description == "some description"
      assert guide.image_url == "some image_url"
      assert guide.intensity == "some intensity"
      assert guide.map_link == "some map_link"
      assert guide.name == "some name"
      assert guide.starting_location == "some starting_location"
    end

    test "create_guide/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_guide(@invalid_attrs)
    end

    test "update_guide/2 with valid data updates the guide" do
      guide = guide_fixture()
      assert {:ok, guide} = Events.update_guide(guide, @update_attrs)
      assert %Guide{} = guide
      assert guide.bring == "some updated bring"
      assert guide.cost == "some updated cost"
      assert guide.description == "some updated description"
      assert guide.image_url == "some updated image_url"
      assert guide.intensity == "some updated intensity"
      assert guide.map_link == "some updated map_link"
      assert guide.name == "some updated name"
      assert guide.starting_location == "some updated starting_location"
    end

    test "update_guide/2 with invalid data returns error changeset" do
      guide = guide_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_guide(guide, @invalid_attrs)
      assert guide == Events.get_guide!(guide.id)
    end

    test "delete_guide/1 deletes the guide" do
      guide = guide_fixture()
      assert {:ok, %Guide{}} = Events.delete_guide(guide)
      assert_raise Ecto.NoResultsError, fn -> Events.get_guide!(guide.id) end
    end

    test "change_guide/1 returns a guide changeset" do
      guide = guide_fixture()
      assert %Ecto.Changeset{} = Events.change_guide(guide)
    end
  end
end
