defmodule Homework.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Users.User
  alias Homework.Queries, as: Queries

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users([])
      [%User{}, ...]

  """
  def list_users(_args) do
    Repo.all(User)
  end


  def first_name_last_name_matching_query(first_name,last_name) do

    first_name_exp = "%" <> first_name <> "%"
    last_name_exp = "%" <> last_name <> "%"


    from u in "users",
                 where: like(fragment("lower(?)",u.first_name), ^first_name_exp) and like(fragment("lower(?)",u.last_name), ^last_name_exp),
                 select: %Homework.Users.User{first_name: u.first_name,last_name: u.last_name, id: u.id}

  end

  def first_name_matching_query(first_name) do

    first_name_exp = "%" <> first_name <> "%"

    from u in "users",
                 where: like(fragment("lower(?)",u.first_name), ^first_name_exp),
                 select: %Homework.Users.User{first_name: u.first_name,last_name: u.last_name, id: u.id}

  end

  def last_name_matching_query(last_name) do


    last_name_exp = "%" <> last_name <> "%"
    from u in "users",
                 where: like(fragment("lower(?)",u.last_name), ^last_name_exp),
                 select: %Homework.Users.User{first_name: u.first_name,last_name: u.last_name, id: u.id}

  end

  def user_table_query() do

    from u in "users",
             select: %Homework.Users.User{first_name: u.first_name,last_name: u.last_name, id: u.id}

  end

  def list_users_by_name_matching_query(first_name,last_name) do

    cond do

      not(is_nil(first_name) or is_nil(last_name)) -> first_name_last_name_matching_query(first_name,last_name)
      not(is_nil(first_name)) -> first_name_matching_query(first_name)
      not(is_nil(last_name)) -> last_name_matching_query(last_name)
      true -> user_table_query()

    end

  end

  def run_list_users_by_name_matching(first_name, last_name) do

    query = list_users_by_name_matching_query(first_name,last_name);
    Queries.run_query(query);

  end

  def run_list_users_by_name_matching(first_name, last_name,limit) do

    query = list_users_by_name_matching_query(first_name,last_name);
    Queries.run_query_with_limit_clause(query,limit);

  end

  def run_list_users_by_name_matching(first_name, last_name,page,limit) do

    query = list_users_by_name_matching_query(first_name,last_name);
    cond  do
      not(is_nil(limit)) ->
        Queries.run_query_with_page_limit_clause(query,page,limit,"users");
    true ->
        Queries.run_query(query)
    end
 end


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
