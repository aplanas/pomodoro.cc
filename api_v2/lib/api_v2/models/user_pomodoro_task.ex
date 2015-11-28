defmodule ApiV2.Models.UserPomodoroTask do
  use Ecto.Model

  schema "user_pomodoro_task" do
    field :user_id,          :integer
    field :pomodoro_task_id, :integer
  end
end