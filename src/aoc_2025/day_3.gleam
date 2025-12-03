import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util

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

pub fn pt_2(input: Input) -> Int {
  input
  |> list.map(joltage_pt2)
  |> list.fold(0, int.add)
}

pub fn joltage_pt2(bank: List(Int)) -> Int {
  do_joltage_pt2([], bank, 12)
  |> list.map(int.to_string)
  |> string.join("")
  |> int.parse
  |> result.unwrap(0)
}

pub fn do_joltage_pt2(acc: List(Int), bank: List(Int), n: Int) -> List(Int) {
  let rest_len = list.length(bank)
  case n {
    0 -> acc
    n if n == rest_len -> {
      list.append(acc, bank)
    }
    _ -> {
      let first = list.length(bank) - n + 1

      let assert Ok(#(x, i)) =
        bank
        |> list.take(first)
        |> list.index_map(fn(x, i) { #(x, i) })
        |> list.sort(by: fn(a, b) { int.compare(b.0, a.0) })
        |> list.first

      let acc = list.append(acc, [x])

      let #(_, bank) = list.split(bank, i + 1)

      do_joltage_pt2(acc, bank, n - 1)
    }
  }
}
