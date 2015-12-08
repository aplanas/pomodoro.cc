defmodule Api.Models.Pomodoro do
  use Ecto.Model
  import Ecto.Query
  alias Api.Models.Pomodoro

  @required_fields ~w(type minutes started_at)
  @optional_fields ~w(cancelled_at)
  @one_day {60*60*24/1000000, 0, 0}

  schema "pomodoro" do
    field :type,         :string
    field :minutes,      :integer
    field :started_at,   Ecto.DateTime
    field :cancelled_at, Ecto.DateTime
    timestamps
  end

  # query api
  def all do
    from p in Pomodoro
  end
  def get(pomodoro_id) do
    from p in all,
      where: p.id == ^pomodoro_id
  end
  def daily(day) do
    {beginning_day, ending_day} = get_date_range(day)
    from p in all,
      where: p.started_at >= ^beginning_day,
      where: p.started_at < ^ending_day
  end


  defp get_date_range(day) do
    beginning_day = Timex.DateFormat.parse!(day, "{YYYY}/{0M}/{0D}")
    ending_day = Timex.Date.add(beginning_day, @one_day)
    beginning_day = beginning_day
      |> Timex.Date.Convert.to_erlang_datetime
      |> Ecto.DateTime.from_erl
    ending_day = ending_day
      |> Timex.Date.Convert.to_erlang_datetime
      |> Ecto.DateTime.from_erl
    {beginning_day, ending_day}
  end


  # changeset
  def changeset(model, params \\ :empty) do
    cast(model, params, @required_fields, @optional_fields)
    |> validate_inclusion(:minutes, [5,15,25])
    |> validate_type
    |> validate_minutes
    |> validate_cancelled_at
  end

  defp validate_type(changeset) do
    validate_change(changeset, :type, fn (_, type) ->
      case type do
        "break" -> []
        "pomodoro" -> []
        _ -> [:type, "invalid type"]
      end
    end)
  end


  defp validate_minutes(changeset) do
    validate_change(changeset, :minutes, fn (_, minutes) ->
      type = Ecto.Changeset.get_field(changeset, :type, nil)
      case type do
        nil -> [:minutes, "minutes cannot be validates without type"]
        "break" ->
          if Enum.member?([5,15], minutes), do: [], else: [:minutes, "invalid minutes for type 'break'"]
        "pomodoro" ->
          if minutes == 25, do: [], else: [:minutes, "invalid minutes for type 'pomodoro'"]
        _ -> [:minutes, "invalid type"]
      end
    end)
  end

  defp validate_cancelled_at(changeset) do
    validate_change(changeset, :cancelled_at, fn (_, cancelled_at) ->
      minutes = Ecto.Changeset.get_field(changeset, :minutes, nil)
      started_at = Ecto.Changeset.get_field(changeset, :started_at, nil)
      cancelled_at = Ecto.Changeset.get_field(changeset, :cancelled_at, nil)
      case cancelled_at do
        nil -> []
        _   ->
          if valid_cancelled_at?(started_at, cancelled_at, minutes) do
            []
          else
            [:cancelled_at, "cancelled_at must be a timestamp after started_at"]
          end
      end
    end)
  end

  defp valid_cancelled_at?(started_at, cancelled_at, minutes) do
    if :lt == Ecto.DateTime.compare(started_at, cancelled_at) do
      started_at_tt = Timex.Date.from(Ecto.DateTime.to_erl(started_at))
      cancelled_at_tt = Timex.Date.from(Ecto.DateTime.to_erl(cancelled_at))
      Timex.Date.diff(started_at_tt, cancelled_at_tt, :secs)/60 <= minutes
    else
      false
    end
  end
end
