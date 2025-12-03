import gleam/int
import gleam/list
import gleam/result
import gleam/string

type Input =
  List(List(Int))

pub fn parse(input: String) -> Input {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.trim
    |> string.split("")
    |> list.map(fn(n) {
      let assert Ok(n) = int.parse(n)
      n
    })
  })
}

pub fn pt_1(input: Input) -> Int {
  input
  |> list.map(joltage_pt1)
  |> list.fold(0, int.add)
}

pub fn pt_2(input: Input) -> Int {
  todo as "part 2 not implemented"
}

pub fn joltage_pt1(bank: List(Int)) -> Int {
  bank
  |> list.combination_pairs
  |> list.map(fn(pair) {
    let #(a, b) = pair
    a * 10 + b
  })
  |> list.sort(by: int.compare)
  |> list.last
  |> result.unwrap(0)
}
