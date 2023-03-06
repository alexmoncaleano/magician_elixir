defmodule Magician do

  def init do
    IO.puts("Welcome to the Magician's Game")
    game = game_create()
    run_game(game)
  end

  def game_create() do
    prizes = ["$50", "$100", "$200", "0","0","0","0","X","X","X"]
    doors = ["|D1","|D2","|D3","|D4","|D5","|D6","|D7","|D8","|D9","|D10|"]
    player = %{prizes: [], accumulated: 0, tires: 0, X: 0}
    round = 0
    %{prizes: prizes, doors: doors, player: player, round: round}
  end

  def run_game(game) do
    new_game = new_round(game)
    validator(new_game)
  end

  def new_round(game) do
    round = game.round + 1
    IO.puts("Round:#{round}")
    IO.puts("Select a door")
    IO.puts(game.doors)
    door = IO.gets("Door:") |> String.trim()
    prize = Enum.random(game.prizes)
    new_player = public_prize(prize, game.player.prizes, door)
    new_prizes = game.prizes -- [prize]
    new_doors = List.replace_at(game.doors, String.to_integer(door) - 1, "|#{prize}")
    %{prizes: new_prizes, doors: new_doors, player: new_player, round: round}
  end

  def public_prize(prize, prizes, door) do

    case prize do
      "X" ->
        IO.puts("There is nothing behind Door: #{door}")
      "0" ->
        IO.puts("You found a tire")
      "$50" ->
        IO.puts("You won $50")
      "$100" ->
        IO.puts("You won $100")
      "$200" ->
        IO.puts("You won $200")
    end

    prizes_list = List.insert_at(prizes, 0, prize)
    tires = Enum.count(prizes_list, &(&1 == "0"))
    x = Enum.count(prizes_list, &(&1 == "X"))

    accumulated = Enum.reduce(prizes_list, 0, fn prize, accumulator ->
      case prize do
        "$50" ->
          accumulator + 50
        "$100" ->
          accumulator + 100
        "$200" ->
          accumulator + 200
        _ ->
          accumulator
      end
    end)

    IO.puts("Total accumulated: $ #{accumulated}")
    IO.puts("Tires found: #{tires}")

    %{prizes: prizes_list, accumulated: accumulated, tires: tires, X: x}
  end

  def validator(game) do
    if game[:round] == 6 do
      IO.puts("Game Over!")
      IO.puts("You win your accumulated: $ #{game.player[:accumulated]}")
    else
      player = game[:player]
    if player[:X] == 3 do
      IO.puts("Sorry, you lost! You found 3 X in the game.")
      IO.puts("You win your accumulated: $ #{player[:accumulated]}")
    end
    if player[:tires] == 4 do
      IO.puts("Congratulations, you win a car! You found 4 tires in the game.")
      IO.puts("You win your accumulated: $ #{player[:accumulated]}")
    else
      run_game(game)
    end
  end
end
end
