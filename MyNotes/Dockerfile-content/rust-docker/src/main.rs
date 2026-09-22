fn main() {
    println!("Hello from Rust inside Docker! 🦀");
    use std::io::{self, Write};
    io::stdout().flush().unwrap();
}