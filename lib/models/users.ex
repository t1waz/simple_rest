defmodule Models.User do
  defstruct [:id, :email]

  def new(data) do
    validate_email!(data)

    %Models.User{email: Map.get(data, "email")}
  end

  def update(user, user_data) do
    new_email = Map.get(user_data, "email")
    if new_email != nil do
      %Models.User{user | email: new_email}
    end
  end

  defp validate_email!(data) do
    # TODO
    IO.puts(Map.get(data, "email"))
  end

end
