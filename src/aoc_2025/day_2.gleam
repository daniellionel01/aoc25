import gleam/int
import gleam/list
import gleam/string

pub fn parse(input: String) -> List(#(Int, Int)) {
  input
  |> string.replace("\n", "")
  |> string.trim
  |> string.split(",")
  |> list.map(fn(el) {
    let assert [a, b] = string.split(el, "-")
    let assert Ok(a) = int.parse(a)
    let assert Ok(b) = int.parse(b)
    #(a, b)
  })
}

pub fn pt_1(input: List(#(Int, Int))) -> Int {
  input
  |> list.map(process_invalid_ids_pt1)
  |> list.flatten
  |> list.fold(0, int.add)
}

pub fn pt_2(input: List(#(Int, Int))) -> Int {
  input
  |> list.map(process_invalid_ids_pt2)
  |> list.flatten
  |> list.fold(0, int.add)
}

pub fn process_invalid_ids_pt1(range: #(Int, Int)) -> List(Int) {
  let #(a, b) = range
  list.range(a, b)
  |> list.filter(fn(n) {
    let n = int.to_string(n)
    let len = string.length(n)
    case len % 2 {
      0 -> {
        let half = len / 2
        let first = string.slice(from: n, at_index: 0, length: half)
        let second = string.slice(from: n, at_index: half, length: half)
        first == second
      }
      _ -> False
    }
  })
}

pub fn process_invalid_ids_pt2(range: #(Int, Int)) -> List(Int) {
  let #(a, b) = range
  list.range(a, b)
  |> list.filter(fn(n) {
    let n = int.to_string(n)
    any_repeating_sequence(n)
  })
}

pub fn any_repeating_sequence(digits: String) -> Bool {
  let digits = string.to_graphemes(digits)
  let len = list.length(digits)
  list.range(1, len / 2)
  |> list.any(fn(d) {
    let digits = list.sized_chunk(digits, d)
    case list.length(digits) {
      1 -> False
      _ -> {
        let assert Ok(to_match) = list.first(digits)
        list.all(digits, fn(el) { el == to_match })
      }
    }
  })
}
