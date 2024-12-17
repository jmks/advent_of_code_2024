defmodule Inputs do
  def binary(day) do
    day
    |> path()
    |> File.read!()
  end

  def lines(day, :binary) when is_integer(day) do
    read(day)
    |> Enum.into([])
  end

  def lines(day, fun) when is_integer(day) do
    day
    |> read()
    |> Stream.map(fun)
    |> Enum.into([])
  end

  defp read(day) do
    day
    |> path()
    |> File.stream!(:line)
    |> Stream.map(&String.trim/1)
  end

  defp path(day) do
    Path.join(["lib/inputs", filename_day(day)])
  end

  defp filename_day(day) when is_integer(day) do
    day |> to_string() |> String.pad_leading(2, "0")
  end
end
