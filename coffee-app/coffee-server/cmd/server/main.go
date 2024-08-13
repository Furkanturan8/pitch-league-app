package main

import (
	"fmt"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

type Config struct {
	Port string
}

type Application struct {
	Config Config
}

func (app *Application) Serve() error {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error leading .env file")
	}
	port := os.Getenv("PORT")
	fmt.Println("API is listening on port", port)

	srv := &http.Server{
		Addr: fmt.Sprintf(":%s", port),
	}
	return srv.ListenAndServe()
}

func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error leading .env file")
	}

	cfg := Config{
		Port: os.Getenv("PORT"),
	}

	app := &Application{
		Config: cfg,
	}

	err = app.Serve()
	if err != nil {
		log.Fatal(err)
	}
}
