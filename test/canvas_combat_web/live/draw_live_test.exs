defmodule CanvasCombatWeb.DrawLiveTest do
  use CanvasCombatWeb.ConnCase

  import Phoenix.LiveViewTest
  import CanvasCombat.GameFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_draw(_) do
    draw = draw_fixture()
    %{draw: draw}
  end

  describe "Index" do
    setup [:create_draw]

    test "lists all draws", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/draws")

      assert html =~ "Listing Draws"
    end

    test "saves new draw", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/draws")

      assert index_live |> element("a", "New Draw") |> render_click() =~
               "New Draw"

      assert_patch(index_live, ~p"/draws/new")

      assert index_live
             |> form("#draw-form", draw: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#draw-form", draw: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/draws")

      html = render(index_live)
      assert html =~ "Draw created successfully"
    end

    test "updates draw in listing", %{conn: conn, draw: draw} do
      {:ok, index_live, _html} = live(conn, ~p"/draws")

      assert index_live |> element("#draws-#{draw.id} a", "Edit") |> render_click() =~
               "Edit Draw"

      assert_patch(index_live, ~p"/draws/#{draw}/edit")

      assert index_live
             |> form("#draw-form", draw: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#draw-form", draw: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/draws")

      html = render(index_live)
      assert html =~ "Draw updated successfully"
    end

    test "deletes draw in listing", %{conn: conn, draw: draw} do
      {:ok, index_live, _html} = live(conn, ~p"/draws")

      assert index_live |> element("#draws-#{draw.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#draws-#{draw.id}")
    end
  end

  describe "Show" do
    setup [:create_draw]

    test "displays draw", %{conn: conn, draw: draw} do
      {:ok, _show_live, html} = live(conn, ~p"/draws/#{draw}")

      assert html =~ "Show Draw"
    end

    test "updates draw within modal", %{conn: conn, draw: draw} do
      {:ok, show_live, _html} = live(conn, ~p"/draws/#{draw}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Draw"

      assert_patch(show_live, ~p"/draws/#{draw}/show/edit")

      assert show_live
             |> form("#draw-form", draw: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#draw-form", draw: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/draws/#{draw}")

      html = render(show_live)
      assert html =~ "Draw updated successfully"
    end
  end
end
