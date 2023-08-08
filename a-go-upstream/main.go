package main

import (
	"log"

	"github.com/mamachanko/renovate-experiments/go-upstream/upstream"
)

func main() {
	log.Printf("%#v", upstream.Upstream{})
	log.Print("ok")
}
