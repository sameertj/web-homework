defmodule HomeworkWeb.Resolvers.UsersResolver do
  alias Homework.Users
  alias HomeworkWeb.Resolvers.ResolverFunctions, as: ResolverFunctions

  @doc """
  Get a list of users
  """
  def users(_root, args, _info) do
    {:ok, Users.list_users(args)}
  end

  @doc """
  Get a list of users by name matching
  """
  def users_by_name_matching(_root, args, _info) do
    fetch_records_by_name_matching(args);
  end

  def fetch_records_by_name_matching(args)  do

    first_name = Map.get(args,:first_name)
    last_name = Map.get(args,:last_name)
    page = Map.get(args,:page)
    limit = Map.get(args,:limit)

    validations = ResolverFunctions.validatePageLimitParams(page,limit);

    case validations do

      {:error,error_msg} ->  {:error,error_msg}
      {:ok,page,limit} ->  {:ok, Users.run_list_users_by_name_matching(first_name,last_name,page,limit)}
      {:ok,limit} ->  {:ok, Users.run_list_users_by_name_matching(first_name,last_name,limit)}
      {:ok} ->  {:ok, Users.run_list_users_by_name_matching(first_name,last_name)}
       _ -> {:error}

    end

  end

  @doc """
  Creates a user
  """
  def create_user(_root, args, _info) do
    case Users.create_user(args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not create user: #{inspect(error)}"}
    end
  end

  @doc """
  Updates a user for an id with args specified.
  """
  def update_user(_root, %{id: id} = args, _info) do
    user = Users.get_user!(id)

    case Users.update_user(user, args) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end

  @doc """
  Deletes a user for an id
  """
  def delete_user(_root, %{id: id}, _info) do
    user = Users.get_user!(id)

    case Users.delete_user(user) do
      {:ok, user} ->
        {:ok, user}

      error ->
        {:error, "could not update user: #{inspect(error)}"}
    end
  end
end
