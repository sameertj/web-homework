defmodule HomeworkWeb.Resolvers.TransactionsResolver do
  alias Homework.Merchants
  alias Homework.Transactions
  alias Homework.Users
  alias HomeworkWeb.Resolvers.ResolverFunctions, as: ResolverFunctions

  @doc """
  Get a list of transactions
  """
  def transactions(_root, args, _info) do
    {:ok, Transactions.list_transactions(args)}
  end

  def transactions_between_min_max(_root, args, _info) do

    min = Map.get(args,:min) |> stringToInteger
    max = Map.get(args,:max) |> stringToInteger
    page = Map.get(args,:page)
    limit = Map.get(args,:limit)

    validations = ResolverFunctions.validatePageLimitParams(page,limit);

    case validations do

      {:error,error_msg} ->  {:error,error_msg}
      {:ok,page,limit} ->  {:ok, Transactions.list_transactions_between_min_max(min,max,page,limit)}
      {:ok,limit} ->  {:ok, Transactions.list_transactions_between_min_max(min,max,limit)}
      {:ok} ->  {:ok, Transactions.list_transactions_between_min_max(min,max)}
      _ -> {:error}

    end

  end


  defp stringToInteger(s) do

    case Float.parse(s) do
      {float,_} ->  trunc(float*100)
      _error -> :error
    end
  end

  @doc """
  Get the user associated with a transaction
  """
  def user(_root, _args, %{source: %{user_id: user_id}}) do
    {:ok, Users.get_user!(user_id)}
  end

  @doc """
  Get the merchant associated with a transaction
  """
  def merchant(_root, _args, %{source: %{merchant_id: merchant_id}}) do
    {:ok, Merchants.get_merchant!(merchant_id)}
  end

  @doc """
  Create a new transaction
  """
  def create_transaction(_root, args, _info) do
    case Transactions.create_transaction(args) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not create transaction: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a transaction for an id with args specified.
  """
  def update_transaction(_root, %{id: id} = args, _info) do
    transaction = Transactions.get_transaction!(id)

    case Transactions.update_transaction(transaction, args) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not update transaction: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a transaction for an id
  """
  def delete_transaction(_root, %{id: id}, _info) do
    transaction = Transactions.get_transaction!(id)

    case Transactions.delete_transaction(transaction) do
      {:ok, transaction} ->
        {:ok, transaction}

      error ->
        {:error, "could not update transaction: #{inspect(error)}"}
    end
  end
end
