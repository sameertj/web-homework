defmodule HomeworkWeb.Resolvers.MerchantsResolver do
  alias Homework.Merchants
  alias HomeworkWeb.Resolvers.ResolverFunctions, as: ResolverFunctions

  @doc """
  Get a list of merchants
  """
  def merchants(_root, args, _info) do
    {:ok, Merchants.list_merchants(args)}
  end

  @doc """
  Get a list of merchants by partial name matching
  """
  def merchants_by_name_matching(_root, args, _info) do
    get_records_by_name_matching(args)
  end

  def get_records_by_name_matching(args)  do

    name = Map.get(args,:name)
    page = Map.get(args,:page)
    limit = Map.get(args,:limit)

    validations = ResolverFunctions.validatePageLimitParams(page,limit);

    case validations do

      {:error,error_msg} ->  {:error,error_msg}
      {:ok,page,limit} ->  {:ok, Merchants.list_merchants_by_name_matching(name,page,limit)}
      {:ok,limit} ->  {:ok, Merchants.list_merchants_by_name_matching(name,limit)}
      {:ok} ->  {:ok, Merchants.list_merchants_by_name_matching(name)}
      _ -> {:error}

    end

  end

  @doc """
  Create a new merchant
  """
  def create_merchant(_root, args, _info) do
    case Merchants.create_merchant(args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not create merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a merchant for an id with args specified.
  """
  def update_merchant(_root, %{id: id} = args, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.update_merchant(merchant, args) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a merchant for an id
  """
  def delete_merchant(_root, %{id: id}, _info) do
    merchant = Merchants.get_merchant!(id)

    case Merchants.delete_merchant(merchant) do
      {:ok, merchant} ->
        {:ok, merchant}

      error ->
        {:error, "could not update merchant: #{inspect(error)}"}
    end
  end
end
