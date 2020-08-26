defmodule Plateslate.Seeds do
  def run() do
    alias Plateslate.{Menu, Repo}

    #
    # TAGS
    #

    vegetarian =
      %Menu.ItemTag{name: "Vegetarian"}
      |> Repo.insert!()

    _vegan =
      %Menu.ItemTag{name: "Vegan"}
      |> Repo.insert!()

    _gluten_free =
      %Menu.ItemTag{name: "Gluten Free"}
      |> Repo.insert!()

    #
    # SANDWICHES
    #

    sandwiches = %Menu.Category{name: "Sandwiches"} |> Repo.insert!()

    _rueben =
      %Menu.Item{name: "Reuben", price: 4.50, category: sandwiches}
      |> Repo.insert!()

    _croque =
      %Menu.Item{name: "Croque Monsieur", price: 5.50, category: sandwiches}
      |> Repo.insert!()

    _muffuletta =
      %Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches}
      |> Repo.insert!()

    _bahn_mi =
      %Menu.Item{name: "Bánh mì", price: 4.50, category: sandwiches}
      |> Repo.insert!()

    _vada_pav =
      %Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches, tags: [vegetarian]}
      |> Repo.insert!()

    #
    # SIDES
    #

    sides = %Menu.Category{name: "Sides"} |> Repo.insert!()

    _fries =
      %Menu.Item{name: "French Fries", price: 2.50, category: sides}
      |> Repo.insert!()

    _papadum =
      %Menu.Item{name: "Papadum", price: 1.25, category: sides}
      |> Repo.insert!()

    _pasta_salad =
      %Menu.Item{name: "Pasta Salad", price: 2.50, category: sides}
      |> Repo.insert!()

    #
    # BEVERAGES
    #

    beverages = %Menu.Category{name: "Beverages"} |> Repo.insert!()

    _water =
      %Menu.Item{name: "Water", price: 0, category: beverages}
      |> Repo.insert!()

    _soda =
      %Menu.Item{name: "Soft Drink", price: 1.5, category: beverages}
      |> Repo.insert!()

    _lemonade =
      %Menu.Item{name: "Lemonade", price: 1.25, category: beverages}
      |> Repo.insert!()

    _chai =
      %Menu.Item{name: "Masala Chai", price: 1.5, category: beverages}
      |> Repo.insert!()

    _vanilla_milkshake =
      %Menu.Item{name: "Vanilla Milkshake", price: 3.0, category: beverages}
      |> Repo.insert!()

    _chocolate_milkshake =
      %Menu.Item{name: "Chocolate Milkshake", price: 3.0, category: beverages}
      |> Repo.insert!()

    :ok
  end
end