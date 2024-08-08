defmodule Capsule do
  alias Capsule.Locator
  alias Capsule.Errors.InvalidStorage

  def add_metadata(%Locator{} = locator, key, val),
    do: add_metadata(locator, %{to_string(key) => val})

  def add_metadata(%Locator{} = locator, data) when is_list(data),
    do: add_metadata(locator, Map.new(data, fn {k, v} -> {to_string(k), v} end))

  def add_metadata(%Locator{} = locator, data),
    do: %{
      locator
      | metadata:
          data
          |> Map.new(fn {k, v} -> {to_string(k), v} end)
          |> Map.merge(locator.metadata, fn _, new_value, _ -> new_value end)
    }

  def storage!(%Locator{storage: module_name}) when is_binary(module_name) do
    module_name
    |> String.replace_prefix("", "Elixir.")
    |> String.replace_prefix("Elixir.Elixir", "Elixir")
    |> String.to_existing_atom()
  rescue
    ArgumentError -> raise InvalidStorage
  end

  def storage!(%Locator{storage: module_name}) when is_atom(module_name), do: module_name
end
