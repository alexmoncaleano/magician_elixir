defmodule Mago do

  def init do
    IO.puts("\nBienvenidos al Juego del Mago")
    game = gameCreate()
    runGame(game)
  end

  def gameCreate() do
    prizes = ["$50", "$100", "$200", "0","0","0","0","X","X","X"]
    doors = ["|P1","|P2","|P3","|P4","|P5","|P6","|P7","|P8","|P9","|P10|"]
    player = %{prizes: [], acumulado: 0, llantas: 0, X: 0}
    round = 0
    %{prizes: prizes, doors: doors, player: player, round: round}
  end

  def runGame(game) do
    newGame = newRound(game)
    validator(newGame)
  end

  def newRound(game) do
    round = game.round + 1
    IO.puts("\nRonda:#{round}")
    IO.puts("\nSeleccione una puerta\n")
    IO.puts(game.doors)
    door = IO.gets("Puerta:") |> String.trim()
    prize = Enum.random(game.prizes)
    newPlayer = publicPrize(prize, game.player.prizes, door)
    newPrizes = game.prizes -- [prize]
    newDoors = List.replace_at(game.doors, String.to_integer(door) - 1, "|#{prize}")
    %{prizes: newPrizes, doors: newDoors, player: newPlayer, round: round}
  end

  def publicPrize(prize, prizes, door) do

    case prize do
      "X" ->
        IO.puts("No hay nada en la Puerta: #{door}")
      "0" ->
        IO.puts("Has encontrado una llanta")
      "$50" ->
        IO.puts("Has obtenido $50")
      "$100" ->
        IO.puts("Has obtenido $100")
      "$200" ->
        IO.puts("Has obtenido $200")
    end

    listPrizes = List.insert_at(prizes, 0, prize)
    llantas = Enum.count(listPrizes, &(&1 == "0"))
    x = Enum.count(listPrizes, &(&1 == "X"))

    acumulado = Enum.reduce(listPrizes, 0, fn prize, acumulador ->
      case prize do
        "$50" ->
          acumulador + 50
        "$100" ->
          acumulador + 100
        "$200" ->
          acumulador + 200
        _ ->
          acumulador
      end
    end)

    IO.puts("\nTotal acumulado: $ #{acumulado}")
    IO.puts("Llantas encontradas: #{llantas}\n")

    %{prizes: listPrizes, acumulado: acumulado, llantas: llantas, X: x}
end

def validator(game) do
  if game[:round] == 6 do
    IO.puts("¡Juego Finalizado!\n")
    IO.puts(game.doors)
    IO.puts("\nTe llevas tu acumulado: $ #{game.player[:acumulado]}")
  else
    player = game[:player]
  if player[:X] == 3 do
    IO.puts("¡Lo siento, perdiste! Has encontrado 3 X en el juego.\n")
    IO.puts(game.doors)
    IO.puts("\nTe llevas tu acumulado: $ #{player[:acumulado]}")
  end
  if player[:llantas] == 4 do
    IO.puts("¡Felicidades, ganaste un carro! Has encontrado 4 llantas en el juego.\n")
    IO.puts(game.doors)
    IO.puts("\nTe llevas tu acumulado: $ #{player[:acumulado]}")
  else
    runGame(game)
  end
  end
  end
end
