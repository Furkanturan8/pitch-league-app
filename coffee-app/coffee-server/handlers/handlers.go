package handlers

import (
	"coffee-app/coffee-server/helpers"
	"coffee-app/coffee-server/services"
	"github.com/gofiber/fiber/v2"
)

var coffee services.Coffee

// GET /coffees
func GetAllCoffees(c *fiber.Ctx) error {
	all, err := coffee.GetAllCoffees()
	if err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusInternalServerError).SendString("Internal Server Error")
	}
	return c.JSON(fiber.Map{"coffees": all})
}

// GET /coffees/coffee/:id
func GetCoffeeById(c *fiber.Ctx) error {
	id := c.Params("id")
	coffee, err := coffee.GetCoffeeById(id)
	if err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusNotFound).SendString("Coffee not found")
	}
	return c.JSON(coffee)
}

// POST /coffees/coffee
func CreateCoffee(c *fiber.Ctx) error {
	var coffeeData services.Coffee
	if err := c.BodyParser(&coffeeData); err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusBadRequest).SendString("Bad Request")
	}

	coffeeCreated, err := coffee.CreateCoffee(coffeeData)
	if err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusInternalServerError).SendString("Internal Server Error")
	}
	return c.JSON(coffeeCreated)
}

// PUT /coffees/coffee/:id
func UpdateCoffee(c *fiber.Ctx) error {
	var coffeeData services.Coffee
	id := c.Params("id")
	if err := c.BodyParser(&coffeeData); err != nil {
		return c.Status(fiber.StatusBadRequest).SendString("Bad Request")
	}
	coffeeUpdated, err := coffee.UpdateCoffee(id, coffeeData)
	if err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusInternalServerError).SendString("Internal Server Error")
	}
	return c.JSON(coffeeUpdated)
}

// DELETE /coffees/coffee/:id
func DeleteCoffee(c *fiber.Ctx) error {
	id := c.Params("id")
	err := coffee.DeleteCoffee(id)
	if err != nil {
		helpers.MessageLogs.ErrorLog.Println(err)
		return c.Status(fiber.StatusInternalServerError).SendString("Internal Server Error")
	}
	return c.JSON(fiber.Map{"message": "successful deletion"})
}
