defmodule Homework.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Transactions.Transaction
  alias Homework.Queries, as: Queries

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions([])
      [%Transaction{}, ...]

  """
  def list_transactions(_args) do
    Repo.all(Transaction)
  end


  def list_transactions_between_min_max(min, max) do

    IO.inspect("min val is #{min}")
    IO.inspect("max val is #{max}")

    query = from t in "transactions",
                 where: t.amount >= ^min and t.amount <= ^max,
                 select: %{amount: t.amount,description: t.description,credit: t.credit, debit: t.debit, user_id: t.user_id, merchant_id: t.merchant_id,id: t.id}

    Queries.run_query(query)


  end


  def list_transactions_between_min_max(min, max, limit) do

    IO.inspect("min val is #{min}")
    IO.inspect("max val is #{max}")

    query = from t in "transactions",
                 where: t.amount >= ^min and t.amount <= ^max,
                 select: %{amount: t.amount,description: t.description,credit: t.credit, debit: t.debit, user_id: t.user_id, merchant_id: t.merchant_id,id: t.id}

    Queries.run_query_with_limit_clause(query,limit)


  end



  def list_transactions_between_min_max(min, max, page, limit) do

    IO.inspect("min val is #{min}")
    IO.inspect("max val is #{max}")

    query = from t in "transactions",
              where: t.amount >= ^min and t.amount <= ^max,
              select: %{amount: t.amount,description: t.description,credit: t.credit, debit: t.debit, user_id: t.user_id, merchant_id: t.merchant_id,id: t.id}


    Queries.run_query_with_page_limit_clause(query,page,limit,"transactions");


  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
