# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Homework.Repo.insert!(%Homework.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SeedDb do

  alias Homework.Repo

  alias Homework.Users.User, as: User
  alias Homework.Transactions.Transaction, as: Transaction
  alias Homework.Merchants.Merchant, as: Merchant


  def bool_val(bool_str) do

    cond do
      bool_str == "true" or bool_str == "t" -> true
      bool_str == "false" or bool_str == "f" -> true
      true -> :error
    end

  end

  def transactions_delete() do

    Repo.delete_all(Transaction)

  end

  def users_delete() do

      Repo.delete_all(User)

  end

  def merchants_delete() do

    Repo.delete_all(Merchant)

  end

  def merchants_insert(file_name) do

    file_stream = File.stream!(file_name, [:utf8], :line)
    file_stream
    |> Stream.drop(1)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn s -> String.split(s,"\n") end)
    |> Stream.map(fn s -> merchant_data(s) end)
    |> Stream.each(fn rec -> Repo.insert(rec) end)
    |> Stream.run()

  end

  def merchant_data(str) do

    str_0 = Enum.at(str,0)
    str_0_split = String.split(str_0,",")

    %Merchant{
      id: Enum.at(str_0_split,0),
      name: Enum.at(str_0_split,1),
      description: Enum.at(str_0_split,2)}

  end

  def transactions_insert(file_name) do

    file_stream = File.stream!(file_name, [:utf8], :line)
    file_stream
    |> Stream.drop(1)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn s -> String.split(s,"\n") end)
    |> Stream.map(fn s -> transaction_data(s) end)
    |> Stream.each(fn rec -> Repo.insert(rec) end)
    |> Stream.run()

  end



  def transaction_data(str) do

    str_0 = Enum.at(str,0)
    str_0_split = String.split(str_0,",")
    {amt,amt_parse_message} = Integer.parse(Enum.at(str_0_split,1))
    credit = bool_val(Enum.at(str_0_split,2))
    debit = bool_val(Enum.at(str_0_split,3))
    %Transaction{
      id: Enum.at(str_0_split,0),
      amount: amt,
      credit: credit,
      debit: debit,
      description: Enum.at(str_0_split,4),
      user_id: Enum.at(str_0_split,5),
      merchant_id: Enum.at(str_0_split,6)}

  end

  def users_insert(file_name) do
    users_delete()
    file_stream = File.stream!(file_name, [:utf8], :line)
    file_stream
    |> Stream.drop(1)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn s -> String.split(s,"\n") end)
    |> Stream.map(fn s -> user_data(s) end)
    |> Stream.each(fn rec -> Repo.insert(rec) end)
    |> Stream.run()
  end

  def user_data(str) do
    str_0 = Enum.at(str,0)
    str_0_split = String.split(str_0,",")
    %User{
                      id: Enum.at(str_0_split,0),
                      first_name: Enum.at(str_0_split,1),
                      last_name: Enum.at(str_0_split,2),
                      dob: Enum.at(str_0_split,3)}


  end


end

SeedDb.transactions_delete()
SeedDb.users_delete()
SeedDb.merchants_delete()
SeedDb.users_insert("/Users/sameerthajudin/elixir-projects/web-homework/elixir/priv/repo/db-users.csv");
SeedDb.merchants_insert("/Users/sameerthajudin/elixir-projects/web-homework/elixir/priv/repo/db-merchants.csv");
SeedDb.transactions_insert("/Users/sameerthajudin/elixir-projects/web-homework/elixir/priv/repo/db-transactions.csv");

IO.inspect("seeding done.");