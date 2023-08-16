package main

import "core:fmt"
import "core:net"
import "core:bytes"
import "core:os"

main :: proc() {
	endpoint, ok := net.parse_endpoint("127.0.0.1:3000")
	if !ok {
		fmt.println("Error parsing endpoint: ", ok)
		os.exit(1)
	}
	socket, socket_error := net.listen_tcp(endpoint)
	if socket_error != nil {
		fmt.println("Error listening on endpoint: ", socket_error)
		os.exit(1)
	}

	defer net.close(socket)
	fmt.println("Listening on http://127.0.0.1:3000")

	for {
		client_socket, _, accept_error := net.accept_tcp(socket)
		if accept_error != nil {
			fmt.println("Error accepting connection: ", accept_error)
			os.exit(1)
		}
		fmt.println("Accepted connection ", client_socket)
		r :: "HTTP/1.1 200 OK\r\nConnection: close\r\nContent-Type: text/html\r\nContent-Length: 19\r\n\r\n<h1>Hello world</h1>"
		buf: [len(r)]u8
		copy(buf[:], r)
		bytes_written, write_error := net.send_tcp(client_socket, buf[:])
		if write_error != nil {
			fmt.println("Error writing to connection: ", write_error)
			os.exit(1)
		}
		fmt.println("Wrote ", bytes_written, " bytes to connection")
		net.close(client_socket)
	}
}
