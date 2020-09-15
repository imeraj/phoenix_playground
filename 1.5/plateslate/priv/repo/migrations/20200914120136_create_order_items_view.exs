defmodule Plateslate.Repo.Migrations.CreateOrderItemsView do
  use Ecto.Migration

  def up do
    execute("""
      CREATE VIEW order_items AS
      SELECT i.*, o.id AS order_id
      FROM orders AS o, jsonb_to_recordset(o.items)
      AS i (name text, quantity int, price float, id text)
    """)
  end

  def down do
    execute("DROP VIEW order_items")
  end
end
