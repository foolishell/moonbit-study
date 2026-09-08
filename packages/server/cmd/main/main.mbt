///|
async fn send_json(conn : @http.ServerConnection, code : Int, body : String) -> Unit {
  let headers : @http.Headers = Map([
    (@http.CaseInsensitiveString("Content-Type"), "application/json"),
    (
      @http.CaseInsensitiveString("Content-Length"),
      body.length().to_string(),
    ),
  ])
  conn.send_response(code, "OK", extra_headers=headers)
  conn.write_string(body)
  conn.end_response()
}

///|
async fn main {
  let port = 3000
  let server = @http.Server(@socket.Addr::parse("0.0.0.0:\{port}"))
  println("Server listening on http://localhost:\{port}")
  server.run_forever() <| ((request, _body, conn) => {
    match (request.meth, request.path) {
      (Get, "/") =>
        send_json(conn, 200, "{\"message\":\"Hello from MoonBit!\"}")
      (Get, "/health") =>
        send_json(conn, 200, "{\"status\":\"ok\"}")
      _ =>
        send_json(conn, 404, "{\"error\":\"not found\"}")
    }
  })
}
