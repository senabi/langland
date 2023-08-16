package main

import (
  "fmt"
  "net/http"
  "log"
)

func main() {
  log.Println("Listening on port http://localhost:3000")
  http.HandleFunc("/", handler)
  log.Fatal(http.ListenAndServe(":3000", nil))
}

func handler(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintf(w, "<h1>Hello World!</h1>")
}
