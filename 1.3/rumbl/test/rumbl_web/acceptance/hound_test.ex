defmodule HoundTest do
  use ExUnit.Case
  use Hound.Helpers
  import RumblWeb.Router.Helpers
  import RumblWeb.TestHelpers

  @page_url page_url(RumblWeb.Endpoint, :index)
  @user_url user_url(RumblWeb.Endpoint, :index)

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Rumbl.Repo)
	  metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Rumbl.Repo, self())
    Hound.start_session(metadata: metadata)
    :ok
  end

  describe "homepage" do
    test "homepage loads successfully", _meta do
      navigate_to(@page_url)
      assert page_title() == "Hello Rumbl!"
    end
  end

  describe "registration" do
    test "successfull registration", _meta do
      navigate_to(@page_url)

      element = find_element(:link_text, "Register")
      element |> click()

      name = find_element(:xpath, ~s|//*[@id="user_name"]|)
      name |> fill_field("Meraj")

      username = find_element(:xpath, ~s|//*[@id="user_username"]|)
      username |> fill_field("meraj")

      password = find_element(:xpath, ~s|//*[@id="user_password"]|)
      password |> fill_field("password")

      submit = find_element(:xpath, ~s|/html/body/div/main/form/div[4]/button|)
      submit |> click()

      assert current_url() == @user_url
      assert page_source() =~ "Listing Users"
      assert page_source() =~ "meraj"
    end
  end

  describe "login" do
    test "successful login", _meta do
      user = insert_user()
	    navigate_to(@page_url)

	    element = find_element(:link_text, "Log In")
	    element |> click()

	    username = find_element(:xpath, ~s|//*[@id="session_username"]|)
	    username |> fill_field(user.name)

	    password = find_element(:xpath, ~s|//*[@id="session_password"]|)
	    password |> fill_field(user.password)

	    submit = find_element(:xpath, ~s|/html/body/div/main/form/button|)
	    submit |> click()

	    assert current_url() == @user_url
	    assert page_source() =~ "Listing Users"
	    assert page_source() =~ "meraj"
    end
  end
end
