{:ok, _} = Enum.into(%{}, %{
                 name: "Wolfram", username: "wolfram", 
                 credential: %{
                    email: "wolfram@gmail.com",
                    password: "phoenix" }
          })
          |> Rumbl.Accounts.register_user()