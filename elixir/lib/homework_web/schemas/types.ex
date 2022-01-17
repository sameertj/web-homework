defmodule HomeworkWeb.Schemas.Types do
  @moduledoc """
  Defines the types for the Schema to use.
  """
  use Absinthe.Schema.Notation

  import_types(Absinthe.Type.Custom)
  import_types(HomeworkWeb.Schemas.MerchantsSchema)
  import_types(HomeworkWeb.Schemas.TransactionsSchema)
  import_types(HomeworkWeb.Schemas.UsersSchema)

  @desc """
   custom type for money
  """
  scalar :money, name: "Money" do
    serialize &HomeworkWeb.Schemas.Types.serialize_money/1
    parse &parse_money/1
  end

  @spec parse_money(Absinthe.Blueprint.Input.String.t) :: {:ok, Integer.t} | :error
  @spec parse_money(Absinthe.Blueprint.Input.Null.t) :: {:ok, nil}
  defp parse_money(%Absinthe.Blueprint.Input.String{value: value}) do
    parsed_val = Float.parse(value)
    IO.inspect(parsed_val)
    case Float.parse(value) do
      {float, _} -> {:ok, trunc(Float.floor(float,2) * 100)}
      _error -> :error
    end
  end
  defp parse_money(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end
  defp parse_money(_) do
    :error
  end

  def serialize_money(integer) do
    case Float.parse(Integer.to_string(integer)) do
      {float, _} -> convertToString(float/100)
      _error -> :error
   end

  end

  def convertToString(f) do

    decimal_part = trunc(Float.floor(f))
    fractional_part = trunc((f * 100) - (decimal_part * 100))
    "#{decimal_part}.#{fractional_part}"

  end

end
