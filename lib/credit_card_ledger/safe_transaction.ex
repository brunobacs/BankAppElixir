defmodule CreditCardLedger.SafeTransaction do
  use DynamicSupervisor
  alias CreditCardLedger.AccountWorker


  # a nao declaracao dessa func dava problema pra inicializar o GenServer pelo dynamicSupervisor
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init (_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_transaction(user_id, amount) do
    {:ok, pid} = get_or_create_worker(user_id)
    GenServer.call(pid, {:add_transaction, %{user_id: user_id, amount: amount}})
  end


  @spec get_or_create_worker(any()) ::
          :ignore | {:error, any()} | {:ok, pid() | port()} | {:ok, pid(), any()}
  def get_or_create_worker(user_id) do
    worker_name = :"AccountWorker.#{user_id}"

    case DynamicSupervisor.start_child(__MODULE__, {AccountWorker, {user_id, worker_name}}) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      error -> error
    end

    # case Process.whereis(worker_name) do
    #   nil -> DynamicSupervisor.start_child(
    #     __MODULE__,
    #     {AccountWorker, {user_id, worker_name}}
    #   )
    #   pid ->
    #     {:ok, pid}
    # end
  end
end
