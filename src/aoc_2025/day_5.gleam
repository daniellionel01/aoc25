import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import gleam/string

pub type Input {
  Input(fresh_ranges: List(#(Int, Int)), available: List(Int))
}

pub fn parse(input: String) -> Input {
  let #(fresh_ranges, available) =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.trim)
    |> list.filter(fn(el) { el != "" })
    |> list.partition(string.contains(_, "-"))

  let fresh_ranges =
    fresh_ranges
    |> list.map(fn(el) {
      let assert [a, b] = string.split(el, "-")
      let assert Ok(a) = int.parse(a)
      let assert Ok(b) = int.parse(b)
      #(a, b)
    })

  let available =
    list.map(available, fn(el) {
      let assert Ok(n) = int.parse(el)
      n
    })

  Input(fresh_ranges:, available:)
}

pub fn pt_1(input: Input) {
  input.available
  |> list.filter(fn(id) {
    input.fresh_ranges
    |> list.find(fn(range) { id >= range.0 && id <= range.1 })
    |> result.is_ok
  })
  |> list.length
}

pub fn pt_2(input: Input) {
  input.fresh_ranges
  |> list.sort(fn(a, b) { int.compare(a.0, b.0) })
  |> list.fold(from: #(0, 0), with: fn(acc, range) {
    let #(count, last_end) = acc

    case int.compare(last_end, range.0) {
      order.Eq -> #(count + range.1 - range.0, range.1)
      order.Gt -> {
        case int.compare(last_end, range.1) {
          order.Eq -> #(count, last_end)
          order.Gt -> #(count, last_end)
          order.Lt -> #(count + range.1 - last_end, range.1)
        }
      }
      order.Lt -> #(count + range.1 - range.0 + 1, range.1)
    }
  })
  |> pair.first
}
