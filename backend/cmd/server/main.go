package main

import (
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"

	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/handlers"
	"github.com/kinneko-de/poc-awarding-contracts/backend/internal/store"
)

func main() {
	contracts := store.LoadContracts()

	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(corsMiddleware)

	r.Post("/api/match", handlers.MatchHandler(contracts))

	log.Println("Backend listening on :8080")
	if err := http.ListenAndServe(":8080", r); err != nil {
		log.Fatalf("server error: %v", err)
	}
}

// corsMiddleware allows requests from any localhost origin so the Flutter
// web dev server can call the API without browser CORS errors.
func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if r.Method == http.MethodOptions {
			w.WriteHeader(http.StatusNoContent)
			return
		}
		next.ServeHTTP(w, r)
	})
}
