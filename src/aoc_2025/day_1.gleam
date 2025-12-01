import gleam/int
import gleam/io
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
  let #(zero_counter, _) =
    list.fold(input, #(0, 50), fn(acc, cur) {
      let #(zero_counter, current_digit) = acc

      let distance = case cur {
        Left(x) -> x
        Right(x) -> x
      }
      let full_rotations = distance / 100
      let zero_counter = zero_counter + full_rotations

      let digit = rotate(current_digit, cur)
      let zero_counter = case digit {
        0 -> zero_counter + 1
        _ -> zero_counter
      }

      let turn = completes_turn(current_digit, cur)
      let zero_counter = case turn {
        True if current_digit != 0 && digit != 0 -> zero_counter + 1
        _ -> zero_counter
      }

      let cur_string = case cur {
        Left(x) -> "Left(" <> int.to_string(x) <> ")"
        Right(x) -> "Right(" <> int.to_string(x) <> ")"
      }
      io.println(
        "#("
        <> int.to_string(zero_counter)
        <> ", "
        <> cur_string
        <> ", "
        <> int.to_string(current_digit)
        <> ", "
        <> int.to_string(digit)
        <> ")",
      )

      #(zero_counter, digit)
    })
  zero_counter
}

pub fn rotate(current: Int, rotation: Rotation) -> Int {
  let distance = normalize_distance(rotation)
  { current + distance } % 100
}

pub fn normalize_distance(rotation: Rotation) -> Int {
  case rotation {
    Left(distance) -> {
      let distance = distance % 100
      100 - distance
    }
    Right(distance) -> {
      distance % 100
    }
  }
}

pub fn completes_turn(digit: Int, rotation: Rotation) -> Bool {
  let norm_distance = normalize_distance(rotation)

  case rotation {
    Left(x) -> {
      let x = x % 100
      x > digit
    }
    Right(_) -> {
      { digit + norm_distance } > 100
    }
  }
}
