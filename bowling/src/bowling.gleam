import gleam/bool
import gleam/list
import gleam/result

pub opaque type Frame {
  Frame(rolls: List(Int), bonus: List(Int))
}

pub type Game {
  Game(frames: List(Frame))
}

pub type Error {
  InvalidPinCount
  GameComplete
  GameNotComplete
}

pub fn roll(game: Game, knocked_pins: Int) -> Result(Game, Error) {
  use <- bool.guard(
    knocked_pins < 0 || knocked_pins > 10,
    Error(InvalidPinCount),
  )
  case list.length(game.frames), game.frames {
    10, [frame, ..rest] ->
      case frame {
        Frame([10], [] as bonus) | Frame([10], [10] as bonus) ->
          Ok(Game([Frame(..frame, bonus: [knocked_pins, ..bonus]), ..rest]))
        Frame([10], [b] as bonus) ->
          case b + knocked_pins <= 10 {
            True ->
              Ok(Game([Frame(..frame, bonus: [knocked_pins, ..bonus]), ..rest]))
            False -> Error(InvalidPinCount)
          }
        Frame([r], []) -> [Frame([knocked_pins, r], []), ..rest] |> Game |> Ok
        Frame([a, b], []) if a + b == 10 ->
          Ok(Game([Frame(..frame, bonus: [knocked_pins]), ..rest]))
        _ -> Error(GameComplete)
      }
    _, [Frame([r], []), ..rest] if r < 10 ->
      case r + knocked_pins <= 10 {
        True -> [Frame([knocked_pins, r], []), ..rest] |> Game |> Ok
        False -> Error(InvalidPinCount)
      }
    _, _ -> [Frame([knocked_pins], []), ..game.frames] |> Game |> Ok
  }
}

pub fn score(game: Game) -> Result(Int, Error) {
  use <- bool.guard(list.length(game.frames) < 10, Error(GameNotComplete))
  let assert [Frame(rolls:, bonus:) as last_frame, second_last_frame, ..] =
    game.frames
  let last_frame_score_result = case last_frame {
    Frame([10], [b1, b2]) -> 10 + b1 + b2 |> Ok
    Frame([r1, r2], [b]) if r1 + r2 == 10 -> 10 + b |> Ok
    Frame([r1, r2], []) if r1 + r2 < 10 -> r1 + r2 |> Ok
    _ -> Error(GameNotComplete)
  }
  use last_frame_score <- result.map(last_frame_score_result)
  let second_last_frame_score = case second_last_frame {
    Frame([10], ..) ->
      [bonus, rolls]
      |> list.concat
      |> list.reverse
      |> list.take(2)
      |> list.fold(10, fn(a, b) { a + b })
    Frame([a, b], ..) if a + b == 10 -> {
      let assert [r, ..] = list.reverse(rolls)
      10 + r
    }
    _ -> list.fold(second_last_frame.rolls, 0, fn(a, b) { a + b })
  }
  let scores_except_last_2 =
    list.window(game.frames, 3)
    |> list.fold(0, fn(score, window) {
      let assert [f3, f2, Frame(rolls:, ..)] = window
      case rolls {
        [10] ->
          [f3, f2]
          |> list.flat_map(fn(frame) { frame.rolls })
          |> list.reverse
          |> list.take(2)
          |> list.fold(10, fn(a, b) { a + b })
        [a, b] if a + b == 10 -> {
          let assert [r, ..] = list.reverse(f2.rolls)
          a + b + r
        }
        _ -> list.fold(rolls, 0, fn(a, b) { a + b })
      }
      + score
    })
  last_frame_score + second_last_frame_score + scores_except_last_2
}

