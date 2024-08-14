package router

import (
	"coffee-app/coffee-server/handlers"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/recover"
)

func Routes(app fiber.Router) fiber.Router {
	// Middleware
	app.Use(recover.New()) // Error recovery middleware
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "http://localhost, https://example.com",
		AllowMethods:     "GET,POST,PATCH,PUT,DELETE,OPTIONS",
		AllowHeaders:     "Accept,Authorization,Content-Type,X-CSRF-Token",
		ExposeHeaders:    "Link",
		AllowCredentials: true,
		MaxAge:           300,
	}))

	// Routes
	app.Get("/api/v1/coffees", handlers.GetAllCoffees)
	app.Get("/api/v1/coffees/coffee/:id", handlers.GetCoffeeById)
	app.Post("/api/v1/coffees/coffee", handlers.CreateCoffee)
	app.Put("/api/v1/coffees/coffee/:id", handlers.UpdateCoffee)
	app.Delete("/api/v1/coffees/coffee/:id", handlers.DeleteCoffee)

	return app
}
