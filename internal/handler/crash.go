package handler

import (
	"log"
	"net/http"
	"os"
)

func Crash(w http.ResponseWriter, r *http.Request) {
	log.Println("crash endpoint hit, exiting process")
	os.Exit(1)
}
