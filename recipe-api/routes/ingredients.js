const express = require('express');
const router = express.Router();
const IngredientsController = require('../controllers/IngredientsController');

// Get all ingredients
router.get('/', IngredientsController.getAllIngredients);

// Search ingredients
router.get('/search', IngredientsController.searchIngredients);

// Get a specific ingredient
router.get('/:id', IngredientsController.getIngredientsById);

// Get recipes that use this ingredient
router.get('/:id/recipe', IngredientsController.getRecipeIngredientsById);

// Create a new ingredient
router.post('/', IngredientsController.postIngredient);

// Update an ingredient
router.put('/:id', IngredientsController.updateIngredient)

// Delete an ingredient
router.delete('/:id', IngredientsController.deleteIngredient);

module.exports = router;



