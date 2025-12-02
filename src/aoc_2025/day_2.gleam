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
  |> list.map(process_invalid_ids)
  |> list.flatten
  |> list.fold(0, int.add)
}

pub fn pt_2(input: List(#(Int, Int))) -> Int {
  todo as "part 2 not implemented"
}

pub fn process_invalid_ids(range: #(Int, Int)) -> List(Int) {
  let #(a, b) = range
  list.range(a, b)
  |> list.filter(fn(n) {
    let n = int.to_string(n)
    let l = string.length(n)
    case l % 2 {
      0 -> {
        let half = l / 2
        let first = string.slice(from: n, at_index: 0, length: half)
        let second = string.slice(from: n, at_index: half, length: half)
        first == second
      }
      _ -> False
    }
  })
}
