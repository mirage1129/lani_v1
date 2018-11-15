defmodule LaniWeb.GuideControllerTest do
  use LaniWeb.ConnCase

  alias Lani.Events

  @create_attrs %{bring: "some bring", cost: "some cost", description: "some description", image_url: "some image_url", intensity: "some intensity", map_link: "some map_link", name: "some name", starting_location: "some starting_location"}
  @update_attrs %{bring: "some updated bring", cost: "some updated cost", description: "some updated description", image_url: "some updated image_url", intensity: "some updated intensity", map_link: "some updated map_link", name: "some updated name", starting_location: "some updated starting_location"}
  @invalid_attrs %{bring: nil, cost: nil, description: nil, image_url: nil, intensity: nil, map_link: nil, name: nil, starting_location: nil}

  def fixture(:guide) do
    {:ok, guide} = Events.create_guide(@create_attrs)
    guide
  end

  describe "index" do
    test "lists all guides", %{conn: conn} do
      conn = get conn, guide_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Guides"
    end
  end

  describe "new guide" do
    test "renders form", %{conn: conn} do
      conn = get conn, guide_path(conn, :new)
      assert html_response(conn, 200) =~ "New Guide"
    end
  end

  describe "create guide" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, guide_path(conn, :create), guide: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == guide_path(conn, :show, id)

      conn = get conn, guide_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Guide"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, guide_path(conn, :create), guide: @invalid_attrs
      assert html_response(conn, 200) =~ "New Guide"
    end
  end

  describe "edit guide" do
    setup [:create_guide]

    test "renders form for editing chosen guide", %{conn: conn, guide: guide} do
      conn = get conn, guide_path(conn, :edit, guide)
      assert html_response(conn, 200) =~ "Edit Guide"
    end
  end

  describe "update guide" do
    setup [:create_guide]

    test "redirects when data is valid", %{conn: conn, guide: guide} do
      conn = put conn, guide_path(conn, :update, guide), guide: @update_attrs
      assert redirected_to(conn) == guide_path(conn, :show, guide)

      conn = get conn, guide_path(conn, :show, guide)
      assert html_response(conn, 200) =~ "some updated bring"
    end

    test "renders errors when data is invalid", %{conn: conn, guide: guide} do
      conn = put conn, guide_path(conn, :update, guide), guide: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Guide"
    end
  end

  describe "delete guide" do
    setup [:create_guide]

    test "deletes chosen guide", %{conn: conn, guide: guide} do
      conn = delete conn, guide_path(conn, :delete, guide)
      assert redirected_to(conn) == guide_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, guide_path(conn, :show, guide)
      end
    end
  end

  defp create_guide(_) do
    guide = fixture(:guide)
    {:ok, guide: guide}
  end
end
