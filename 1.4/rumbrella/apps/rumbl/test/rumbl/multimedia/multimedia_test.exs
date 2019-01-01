defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category
  alias Rumbl.Multimedia.Video

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for category <- ~w(Drama Action Comedy), do: Multimedia.create_category(category)

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
          name
        end

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    @valid_attrs %{description: "desc", title: "title", url: "http://local", category_id: 1}
    @invalid_attrs %{description: nil, title: nil, url: nil, category_id: nil}

    setup do
      {:ok, category: Multimedia.create_category("Action")}
    end

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_user_videos(owner)
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_user_videos(owner)
    end

    test "get_user_video!/1 returns the video with given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner)
      assert %Video{id: ^id} = Multimedia.get_user_video!(owner, id)
    end

    test "create_video/2 with valid data creates a video", %{category: %Category{id: id}} do
      owner = user_fixture()
      attrs = Map.put(@valid_attrs, :category_id, id)
      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, attrs)
    end

    test "create_video/2 with invalid data returns error changeset" do
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end
  end
end
