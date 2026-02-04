const express = require('express');
const router = express.Router();
const recipeController = require('../controllers/recipeController');

// Route to get all recipes
router.get('/', recipeController.getAllRecipes);

router.get('/search', recipeController.searchRecipes);

router.get('/:id', recipeController.getRecipeById);

// Route to post all recipes
router.post('/', recipeController.createRecipe);

// Route to put all recipes
router.put('/:id', recipeController.updateRecipe);

// Route to update all recipes
router.patch('/id', recipeController.updateRecipe);

// Route to delete all recipes
router.delete('/:id', recipeController.deleteRecipe);

module.exports = router;