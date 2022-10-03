defmodule Repositories.UserRepository do
  use GenServer


  def start_link(_) do
    GenServer.start_link(__MODULE__, [1 | %{}], name: :user_repository)
  end

  def all() do
    GenServer.call(:user_repository, :all)
  end

  def get_by_id(user_id) do
    GenServer.call(:user_repository, {:get_by_id, user_id})
  end

  def add(user) do
    GenServer.call(:user_repository, {:add, user})
  end

  def update(user) do
    GenServer.call(:user_repository, {:update, user})
  end

  def delete_by_id(user_id) do
    GenServer.call(:user_repository, {:delete, user_id})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:all, _from, [current_id | users_data]) do
    users = Enum.map(users_data, fn({_, value}) -> value end)

    {:reply, users, [current_id | users_data]}
  end

  @impl true
  def handle_call({:get_by_id, user_id}, _from, [current_id | users_data]) do
    user = Map.get(users_data, user_id)

    {:reply, user, [current_id | users_data]}
  end

  @impl true
  def handle_call({:add, user}, _from, [current_id | users_data]) do
    user = Map.put(user, :id, current_id)
    users_data = Map.put(users_data, current_id, user)
    current_id = current_id + 1

    {:reply, user, [current_id | users_data]}
  end

  @impl true
  def handle_call({:delete, user_id}, _from , [current_id | users_data]) do
    {user, users_data} = Map.pop(users_data, user_id)

    {:reply, user, [current_id | users_data]}
  end

  @impl true
  def handle_call({:update, user}, _from, [current_id | users_data]) do
    users_data = Map.replace(users_data, user.id, user)

    {:reply, user, [current_id | users_data]}
  end

end