defmodule CmsContext.CMSTest do
  use CmsContext.DataCase

  alias CmsContext.CMS

  describe "pages" do
    alias CmsContext.CMS.Page

    @valid_attrs %{body: "some body", title: "some title", views: 42}
    @update_attrs %{body: "some updated body", title: "some updated title", views: 43}
    @invalid_attrs %{body: nil, title: nil, views: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert CMS.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert CMS.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = CMS.create_page(@valid_attrs)
      assert page.body == "some body"
      assert page.title == "some title"
      assert page.views == 42
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, page} = CMS.update_page(page, @update_attrs)
      assert %Page{} = page
      assert page.body == "some updated body"
      assert page.title == "some updated title"
      assert page.views == 43
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_page(page, @invalid_attrs)
      assert page == CMS.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = CMS.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = CMS.change_page(page)
    end
  end

  describe "authors" do
    alias CmsContext.CMS.Author

    @valid_attrs %{bio: "some bio", genre: "some genre", role: "some role"}
    @update_attrs %{
      bio: "some updated bio",
      genre: "some updated genre",
      role: "some updated role"
    }
    @invalid_attrs %{bio: nil, genre: nil, role: nil}

    def author_fixture(attrs \\ %{}) do
      {:ok, author} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_author()

      author
    end

    test "list_authors/0 returns all authors" do
      author = author_fixture()
      assert CMS.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = author_fixture()
      assert CMS.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      assert {:ok, %Author{} = author} = CMS.create_author(@valid_attrs)
      assert author.bio == "some bio"
      assert author.genre == "some genre"
      assert author.role == "some role"
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_author(@invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author = author_fixture()
      assert {:ok, author} = CMS.update_author(author, @update_attrs)
      assert %Author{} = author
      assert author.bio == "some updated bio"
      assert author.genre == "some updated genre"
      assert author.role == "some updated role"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = author_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_author(author, @invalid_attrs)
      assert author == CMS.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = author_fixture()
      assert {:ok, %Author{}} = CMS.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = author_fixture()
      assert %Ecto.Changeset{} = CMS.change_author(author)
    end
  end
end
