defmodule ApiV2.Repo do
  use Ecto.Repo, otp_app: :api_v2
  import Ecto.Query
  alias ApiV2.Models.PomodoroTask
  alias ApiV2.Models.UserPomodoroTask

  def tasks_for(user_id) do
    all(
      from pt in PomodoroTask,
        join: upt in UserPomodoroTask, on: pt.id == upt.pomodoro_task_id,
        where: upt.user_id == ^user_id,
        where: pt.deleted == false,
      select: pt
    )
  end
end
