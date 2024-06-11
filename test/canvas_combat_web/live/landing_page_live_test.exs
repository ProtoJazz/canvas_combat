defmodule CanvasCombatWeb.LandingPageLiveTest do
  use CanvasCombatWeb.ConnCase

  import Phoenix.LiveViewTest
  import CanvasCombat.GameFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_landing_page(_) do
    landing_page = landing_page_fixture()
    %{landing_page: landing_page}
  end

  describe "Index" do
    setup [:create_landing_page]

    test "lists all landing_page", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/landing_page")

      assert html =~ "Listing Landing page"
    end

    test "saves new landing_page", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/landing_page")

      assert index_live |> element("a", "New Landing page") |> render_click() =~
               "New Landing page"

      assert_patch(index_live, ~p"/landing_page/new")

      assert index_live
             |> form("#landing_page-form", landing_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#landing_page-form", landing_page: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/landing_page")

      html = render(index_live)
      assert html =~ "Landing page created successfully"
    end

    test "updates landing_page in listing", %{conn: conn, landing_page: landing_page} do
      {:ok, index_live, _html} = live(conn, ~p"/landing_page")

      assert index_live |> element("#landing_page-#{landing_page.id} a", "Edit") |> render_click() =~
               "Edit Landing page"

      assert_patch(index_live, ~p"/landing_page/#{landing_page}/edit")

      assert index_live
             |> form("#landing_page-form", landing_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#landing_page-form", landing_page: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/landing_page")

      html = render(index_live)
      assert html =~ "Landing page updated successfully"
    end

    test "deletes landing_page in listing", %{conn: conn, landing_page: landing_page} do
      {:ok, index_live, _html} = live(conn, ~p"/landing_page")

      assert index_live |> element("#landing_page-#{landing_page.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#landing_page-#{landing_page.id}")
    end
  end

  describe "Show" do
    setup [:create_landing_page]

    test "displays landing_page", %{conn: conn, landing_page: landing_page} do
      {:ok, _show_live, html} = live(conn, ~p"/landing_page/#{landing_page}")

      assert html =~ "Show Landing page"
    end

    test "updates landing_page within modal", %{conn: conn, landing_page: landing_page} do
      {:ok, show_live, _html} = live(conn, ~p"/landing_page/#{landing_page}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Landing page"

      assert_patch(show_live, ~p"/landing_page/#{landing_page}/show/edit")

      assert show_live
             |> form("#landing_page-form", landing_page: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#landing_page-form", landing_page: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/landing_page/#{landing_page}")

      html = render(show_live)
      assert html =~ "Landing page updated successfully"
    end
  end
end
