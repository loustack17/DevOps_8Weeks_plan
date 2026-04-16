package handler

import (
	"log"
	"net/http"
)

func OOM(w http.ResponseWriter, r *http.Request) {
	log.Println("oom endpoint hit, allocating memory until killed")
	var data [][]byte
	for {
		block := make([]byte, 10*1024*1024)
		data = append(data, block)
		log.Printf("allocated %d MB", len(data)*10)
	}
}
