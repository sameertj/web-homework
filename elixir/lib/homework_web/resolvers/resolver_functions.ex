defmodule HomeworkWeb.Resolvers.ResolverFunctions do

  def validatePageLimitParams(page, limit) do
      cond do
        (not(is_nil(page)) and page <= 0) -> {:error, "page num should be greater than 0"}
        (not(is_nil(page)) and page > 0) and (is_nil(limit) or limit <= 0) -> {:error,"page parameter should also include positive limit value"}
        (not(is_nil(page) or is_nil(limit))) -> {:ok, page, limit}
        (not(is_nil(limit))) -> {:ok, limit}
        true -> {:ok}
      end
  end
end

