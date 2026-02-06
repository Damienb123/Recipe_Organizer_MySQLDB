const express = require('express');
const router = express.Router();
const restaurantController = require('../controllers/restaurantController');

// Get all restaurants
router.get('/', restaurantController.getAllRestaurants);

// Search restaurants
router.get('/search', restaurantController.searchRestaurants);

// Get restaurants by city
router.get('/city/:city', restaurantController.getRestaurantsByCity);

// Get restaurants by state
router.get('/state/:state', restaurantController.getRestaurantsByState);

// Get a specific restaurant
router.get('/:id', restaurantController.getRestaurantById);

// Get menu items for a restaurant
router.get('/:id/menu', restaurantController.getRestaurantMenu);

// Create a new restaurant
router.post('/', restaurantController.createRestaurant);

// Update a restaurant
router.put('/:id', restaurantController.updateRestaurant);

// Delete a restaurant
router.delete('/:id', restaurantController.deleteRestaurant);

module.exports = router;