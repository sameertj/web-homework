defmodule Homework.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  alias Homework.Merchants.Merchant
  alias Homework.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transactions" do
    field(:amount, :integer)
    field(:credit, :boolean, default: false)
    field(:debit, :boolean, default: false)
    field(:description, :string)

    belongs_to(:merchant, Merchant, type: :binary_id, foreign_key: :merchant_id)
    belongs_to(:user, User, type: :binary_id, foreign_key: :user_id)

    timestamps()
  end

  def convert_amt_to_cents(changeset) do
    amount = get_field(changeset, :amount)

    if not(is_nil(amount)) do
      put_change(changeset, :amount, amount * 100)
    else
      changeset
    end
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:user_id, :amount, :debit, :description, :merchant_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:user_id, :amount, :debit, :description, :merchant_id])
#    |> convert_amt_to_cents()
  end
end
