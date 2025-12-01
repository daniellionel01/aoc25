import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn sandbox_test() {
  echo { 0 % 100 }
  echo { 99 % 100 }
  echo { 100 % 100 }
}
