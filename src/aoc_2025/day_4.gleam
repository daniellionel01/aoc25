import gleam/list
import gleam/string
import iv

pub type Cell {
  Empty
  Paper
}

pub type Grid {
  Grid(rows: Int, cols: Int, cells: iv.Array(Cell))
}

pub fn parse(input: String) -> Grid {
  let lines =
    input
    |> string.trim
    |> string.split("\n")
    |> list.map(string.trim)

  let assert Ok(first_line) = list.first(lines)

  let rows = list.length(lines)
  let cols = string.length(first_line)

  let cells =
    lines
    |> string.join("")
    |> string.split("")
    |> list.map(fn(el) {
      case el {
        "@" -> Paper
        _ -> Empty
      }
    })
    |> iv.from_list

  Grid(rows:, cols:, cells:)
}

pub fn pt_1(input: Grid) {
  input.cells
  |> iv.index_map(fn(cell, index) {
    let #(row, col) = get_row_col(input, index)
    let adjacent = adjacent_cells(input, row, col)
    #(cell, adjacent)
  })
  |> iv.filter(fn(el) {
    let #(cell, _) = el
    case cell {
      Paper -> True
      Empty -> False
    }
  })
  |> iv.filter(fn(el) {
    let #(_, adjacent) = el
    let paper =
      iv.filter(adjacent, fn(cell) {
        case cell {
          Empty -> False
          Paper -> True
        }
      })
    iv.length(paper) < 4
  })
  |> iv.length
}

pub fn pt_2(input: Grid) {
  do_pt_2(input, 0)
}

pub fn do_pt_2(input: Grid, removed: Int) {
  let accessible =
    input.cells
    |> iv.index_map(fn(cell, index) {
      let #(row, col) = get_row_col(input, index)
      let adjacent = adjacent_cells(input, row, col)
      #(index, cell, adjacent)
    })
    |> iv.filter(fn(el) {
      let #(_, cell, _) = el
      case cell {
        Paper -> True
        Empty -> False
      }
    })
    |> iv.filter(fn(el) {
      let #(_, _, adjacent) = el
      let paper =
        iv.filter(adjacent, fn(cell) {
          case cell {
            Empty -> False
            Paper -> True
          }
        })
      iv.length(paper) < 4
    })

  let count = iv.length(accessible)
  case count {
    0 -> removed
    _ -> {
      let cells =
        iv.fold(from: input.cells, over: accessible, with: fn(acc, cur) {
          let #(index, _, _) = cur
          let assert Ok(acc) = iv.update(acc, index, fn(_) { Empty })
          acc
        })

      let input = Grid(..input, cells:)

      do_pt_2(input, removed + count)
    }
  }
}

pub fn get_row_col(grid: Grid, index: Int) -> #(Int, Int) {
  let row = index / grid.cols
  let col = index % grid.cols

  #(row, col)
}

pub fn get_cell(grid: Grid, row: Int, col: Int) -> Result(Cell, Nil) {
  let oob = row < 0 || col < 0 || row >= grid.rows || col >= grid.cols
  case oob {
    True -> Error(Nil)
    False -> {
      let i = row * grid.cols + col
      iv.get(grid.cells, i)
    }
  }
}

pub fn adjacent_cells(grid: Grid, row: Int, col: Int) -> iv.Array(Cell) {
  let positions =
    iv.from_list([
      // left
      #(row, col - 1),
      // right
      #(row, col + 1),
      // top
      #(row - 1, col),
      // bottom
      #(row + 1, col),
      // top left
      #(row - 1, col - 1),
      // top right
      #(row - 1, col + 1),
      // bottom left
      #(row + 1, col - 1),
      // bottom right
      #(row + 1, col + 1),
    ])

  iv.filter_map(positions, fn(pos) {
    let #(row, col) = pos
    case get_cell(grid, row, col) {
      Error(_) -> Error(Nil)
      Ok(cell) -> Ok(cell)
    }
  })
}
