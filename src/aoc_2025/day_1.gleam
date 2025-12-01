import gleam/int
import gleam/list
import gleam/string

pub type Rotation {
  Left(Int)
  Right(Int)
}

pub fn parse(input: String) -> List(Rotation) {
  input
  |> string.split("\n")
  |> list.map(fn(line) {
    case string.trim(line) {
      "L" <> distance -> {
        let assert Ok(distance) = int.parse(distance)
        Left(distance)
      }
      "R" <> distance -> {
        let assert Ok(distance) = int.parse(distance)
        Right(distance)
      }
      _ -> panic as "not implemented"
    }
  })
}

pub fn pt_1(input: List(Rotation)) -> Int {
  let #(zero_counter, _) =
    list.fold(input, #(0, 50), fn(acc, cur) {
      let #(zero_counter, digit) = acc

      let digit = rotate(digit, cur)
      let zero_counter = case digit {
        0 -> zero_counter + 1
        _ -> zero_counter
      }

      #(zero_counter, digit)
    })
  zero_counter
}

pub fn pt_2(input: List(Rotation)) -> Int {
  todo as "part 2 not implemented"
}

pub fn rotate(current: Int, rotation: Rotation) -> Int {
  let distance = case rotation {
    Left(distance) -> {
      let distance = distance % 100
      100 - distance
    }
    Right(distance) -> {
      distance % 100
    }
  }
  { current + distance } % 100
}
