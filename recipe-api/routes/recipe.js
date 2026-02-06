const express = require('express');
const router = express.Router();
const recipeController = require('../controllers/recipeController');

// Get all recipes
router.get('/', recipeController.getAllRecipes);

// Search/filter recipes (by category, cuisine, difficulty, etc.)
router.get('/search', recipeController.searchRecipes);

// Get recipes by category
router.get('/category/:category', recipeController.getRecipesByCategory);

// Get recipes by cuisine
router.get('/cuisine/:cuisine', recipeController.getRecipesByCuisine);

// Get recipes by difficulty
router.get('/difficulty/:difficulty', recipeController.getRecipesByDifficulty);

// Get a specific recipe with full details (ingredients + instructions)
router.get('/:id', recipeController.getRecipeById);

// Get ingredients for a specific recipe
router.get('/:id/ingredients', recipeController.getRecipeIngredients);

// Get instructions for a specific recipe
router.get('/:id/instructions', recipeController.getRecipeInstructions);

// Get ratings for a specific recipe
router.get('/:id/ratings', recipeController.getRecipeRatings);

// Create a new recipe
router.post('/', recipeController.createRecipe);

// Update a recipe
router.put('/:id', recipeController.updateRecipe);
router.patch('/:id', recipeController.updateRecipe);

// Delete a recipe
router.delete('/:id', recipeController.deleteRecipe);

module.exports = router;
