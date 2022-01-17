defmodule Homework.Queries do

  import Ecto.Query, warn: false
  import Ecto.UUID
  import Ecto.Query, warn: false
  alias Homework.Repo

  alias Homework.Users.User
  alias Homework.SeedDb

  def get_row_count(tableName) do

    Repo.one(from p in tableName, select: count(p.id))

  end


  def run_query(query) do

    records = Repo.all(query)
    records_with_row_id = Enum.map(records, fn struct_element -> Map.put(struct_element, :id, Ecto.UUID.load(Map.get(struct_element,:id))|>elem(1)) end)
    records_with_row_id

  end

  def run_query_with_limit_clause(query,limit) do

    query = from(u in query, limit: ^limit)
    run_query(query);

  end


  def run_query_with_page_limit_clause(query,skip,limit,table_name) do

    offset = cond do
      is_integer(limit) and (limit > -1) and not(is_nil(skip)) -> (skip - 1) * limit
      true -> 0
    end

    query = from(u in query, limit: ^limit)
    query = from(u in query, offset: ^offset)
    row_count = get_row_count(table_name);
    records = run_query(query);
    Enum.map(records, fn record -> Map.put_new(record, :row_count, row_count) end)

  end

end