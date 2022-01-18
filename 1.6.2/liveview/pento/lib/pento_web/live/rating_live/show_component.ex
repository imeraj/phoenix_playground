defmodule PentoWeb.RatingLive.ShowComponent do
  use PentoWeb, :live_component

  def render_rating_stars(stars) do
    filled_stars(stars)
    |> Enum.concat(unfilled_stars(stars))
    |> Enum.join(" ")
  end

  defp filled_stars(stars) do
    List.duplicate("<span class='fa fa-star checked'></span>", stars)
  end

  defp unfilled_stars(stars) do
    List.duplicate("<span class='fa fa-star'></span>", 5 - stars)
  end
end
