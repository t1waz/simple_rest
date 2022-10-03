defmodule Endpoints.UserEndpoint do
  use Plug.Router

  alias Repositories.UserRepository, as: UserRepository
  alias Models.User, as: User

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/users" do
    conn = Plug.Conn.update_resp_header(
      conn,
      "content-type",
      "application/json; charset=utf-8",
      &(&1)
    )

    {_, users_data} = JSON.encode(for user <- UserRepository.all(), do: %{
      "id" => user.id,
      "email" => user.email
    })

    send_resp(conn, 200, users_data)
  end

  get "/users/:id" do
    conn = Plug.Conn.update_resp_header(
      conn,
      "content-type",
      "application/json; charset=utf-8",
      &(&1)
    )

    {user_id, _} = Integer.parse(id)
    user = UserRepository.get_by_id(user_id)

    {status_code, data} = if user != nil do
      {200, %{
        "id" => user.id,
        "email" => user.email
      }}
    else
      {404, ""}
    end
    {_, users_data} = JSON.encode(data)

    send_resp(conn, status_code, users_data)
  end

  post "/users" do
    conn = Plug.Conn.update_resp_header(
      conn,
      "content-type",
      "application/json; charset=utf-8",
      &(&1)
    )

    {_, raw_data, _} = read_body(conn)
    user_data = Jason.decode!(raw_data)
    user = User.new(user_data) |> UserRepository.add()

    {_, user_data} = JSON.encode(%{
      "id" => user.id,
      "email" => user.email
    })

    send_resp(conn, 200, user_data)
  end

  patch "/users/:id" do
    conn = Plug.Conn.update_resp_header(
      conn,
      "content-type",
      "application/json; charset=utf-8",
      &(&1)
    )

    {user_id, _} = Integer.parse(id)
    {_, raw_data, _} = read_body(conn)
    user_data = Jason.decode!(raw_data)

    user = UserRepository.get_by_id(user_id)

    {status_code, data} = if user != nil do
      user = User.update(user, user_data) |> UserRepository.update()
      {200, %{
        "id" => user.id,
        "email" => user.email
      }}
    else
      {404, ""}
    end
    {_, users_data} = JSON.encode(data)

    send_resp(conn, status_code, users_data)
  end

  delete "/users/:id" do
    conn = Plug.Conn.update_resp_header(
      conn,
      "content-type",
      "application/json; charset=utf-8",
      &(&1)
    )

    {user_id, _} = Integer.parse(id)
    user = UserRepository.delete_by_id(user_id)

    {status_code, data} = if user != nil do
      {200, ""}
    else
      {404, ""}
    end
    {_, users_data} = JSON.encode(data)

    send_resp(conn, status_code, users_data)
  end

end