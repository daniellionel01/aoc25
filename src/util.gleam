pub fn unwrap(result: Result(a, b)) -> a {
  let assert Ok(result) = result
  result
}
