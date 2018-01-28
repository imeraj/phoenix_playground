use ExGuard.Config

guard("formatter", run_on_start: true)
|> command("mix format")
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
|> ignore(~r{deps})
|> notification(:auto)

guard("credo", run_on_start: true)
|> command("mix credo")
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
|> ignore(~r{deps})
|> notification(:auto)

guard("test", run_on_start: true)
|> command("mix test")
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
|> ignore(~r{deps})
|> notification(:auto)