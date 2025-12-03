import gleeunit
import util

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn sandbox_test() {
  echo { 829 % 100 }
}

pub fn combinations_test() {
  assert [
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 1],
      [8, 7, 6, 5, 4, 3, 2, 1, 1, 1],
      [7, 6, 5, 4, 3, 2, 1, 1, 1, 1],
      [6, 5, 4, 3, 2, 1, 1, 1, 1, 1],
      [5, 4, 3, 2, 1, 1, 1, 1, 1, 1],
      [4, 3, 2, 1, 1, 1, 1, 1, 1, 1],
    ]
    == util.combinations([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 10)
}
