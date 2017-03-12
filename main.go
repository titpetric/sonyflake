package main

import (
	"fmt"
	"log"

	"encoding/json"
	"net/http"

	"github.com/namsral/flag"
	"github.com/sony/sonyflake"
)

func nextId(sf *sonyflake.Sonyflake) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		id, err := sf.NextID()
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		body, err := json.Marshal(sonyflake.Decompose(id))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Header()["Content-Type"] = []string{"application/json; charset=utf-8"}
		w.Write(body)
	}
}

func main() {
	var sf *sonyflake.Sonyflake
	var st sonyflake.Settings

	sf = sonyflake.NewSonyflake(st)
	if sf == nil {
		panic("Sonyflake not created")
	}

	var (
		port = flag.Int("port", 80, "Listen port for server")
	)
	flag.Parse()

	http.HandleFunc("/", nextId(sf))

	// start up http server
	log.Printf("Ready and listening on port %d\n", *port)
	if err := http.ListenAndServe(fmt.Sprintf(":%d", *port), nil); err != nil {
		panic(err)
	}
}
