import gleam/int
import gleam/list
import gleam/string

pub type Input =
  List(#(String, List(Int)))

pub fn parse(input: String) -> Input {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(fn(line) {
    line
    |> string.trim
    |> string.split(" ")
    |> list.filter(fn(el) { el != "" })
  })
  |> list.reverse
  |> list.transpose
  |> list.map(fn(col) {
    let assert Ok(op) = list.first(col)
    let assert Ok(rest) = list.rest(col)
    let rest =
      list.map(rest, fn(n) {
        let assert Ok(n) = int.parse(n)
        n
      })
    #(op, rest)
  })
}

pub fn pt_1(input: Input) {
  input
  |> list.map(fn(el) {
    let #(op, numbers) = el
    let init = case op {
      "*" -> 1
      _ -> 0
    }
    list.fold(numbers, init, fn(acc, cur) {
      case op {
        "+" -> acc + cur
        "*" -> acc * cur
        _ -> panic as "operator unknown"
      }
    })
  })
  |> echo
  |> list.fold(0, int.add)
}

pub fn pt_2(input: Input) {
  todo as "part 2 not implemented"
}
