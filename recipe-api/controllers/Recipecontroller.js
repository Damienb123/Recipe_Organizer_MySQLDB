const db = require('../config/database');

// Get all recipes
exports.getAllRecipes = async (req, res) => {
  try {
    const [recipes] = await db.query('SELECT * FROM Recipes');
    res.json({
      success: true,
      count: recipes.length,
      data: recipes
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching recipes',
      error: error.message
    });
  }
};

// Get single recipe by ID with ingredients and instructions
exports.getRecipeById = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Get recipe details
    const [recipes] = await db.query(
      'SELECT * FROM Recipes WHERE recipe_id = ?',
      [id]
    );
    
    if (recipes.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    // Get ingredients for this recipe
    const [ingredients] = await db.query(`
      SELECT i.ingredient_id, i.name, ri.quantity
      FROM RecipeIngredients ri
      JOIN Ingredients i ON ri.ingredient_id = i.ingredient_id
      WHERE ri.recipe_id = ?
    `, [id]);
    
    // Get instructions for this recipe
    const [instructions] = await db.query(
      'SELECT * FROM Instructions WHERE recipe_id = ? ORDER BY step_number',
      [id]
    );
    
    // Get average rating
    const [ratingResult] = await db.query(`
      SELECT AVG(rating) as avg_rating, COUNT(*) as rating_count
      FROM UserRatings
      WHERE recipe_id = ?
    `, [id]);
    
    const recipe = {
      ...recipes[0],
      ingredients,
      instructions,
      avg_rating: ratingResult[0].avg_rating || 0,
      rating_count: ratingResult[0].rating_count
    };
    
    res.json({
      success: true,
      data: recipe
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching recipe',
      error: error.message
    });
  }
};

// Create new recipe
exports.createRecipe = async (req, res) => {
  const connection = await db.getConnection();
  
  try {
    await connection.beginTransaction();
    
    const { title, description, category, cuisine, cooking_time, difficulty, ingredients, instructions } = req.body;
    
    // Insert recipe
    const [result] = await connection.query(
      `INSERT INTO Recipes (title, discription, category, cuisine, cooking_time, difficulty)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [title, description, category, cuisine, cooking_time, difficulty]
    );
    
    const recipeId = result.insertId;
    
    // Insert ingredients if provided
    if (ingredients && ingredients.length > 0) {
      for (const ingredient of ingredients) {
        await connection.query(
          'INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity) VALUES (?, ?, ?)',
          [recipeId, ingredient.ingredient_id, ingredient.quantity]
        );
      }
    }
    
    // Insert instructions if provided
    if (instructions && instructions.length > 0) {
      for (const instruction of instructions) {
        await connection.query(
          'INSERT INTO Instructions (recipe_id, step_number, instruction_text) VALUES (?, ?, ?)',
          [recipeId, instruction.step_number, instruction.instruction_text]
        );
      }
    }
    
    await connection.commit();
    
    res.status(201).json({
      success: true,
      message: 'Recipe created successfully',
      data: { recipe_id: recipeId }
    });
  } catch (error) {
    await connection.rollback();
    res.status(500).json({
      success: false,
      message: 'Error creating recipe',
      error: error.message
    });
  } finally {
    connection.release();
  }
};

// Update recipe
exports.updateRecipe = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, category, cuisine, cooking_time, difficulty } = req.body;
    
    const [result] = await db.query(
      `UPDATE Recipes 
       SET title = ?, discription = ?, category = ?, cuisine = ?, cooking_time = ?, difficulty = ?
       WHERE recipe_id = ?`,
      [title, description, category, cuisine, cooking_time, difficulty, id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    res.json({
      success: true,
      message: 'Recipe updated successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating recipe',
      error: error.message
    });
  }
};

// Delete recipe
exports.deleteRecipe = async (req, res) => {
  try {
    const { id } = req.params;
    
    const [result] = await db.query('DELETE FROM Recipes WHERE recipe_id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Recipe not found'
      });
    }
    
    res.json({
      success: true,
      message: 'Recipe deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting recipe',
      error: error.message
    });
  }
};

// Search recipes by title, category, or cuisine
exports.searchRecipes = async (req, res) => {
  try {
    const { query, category, cuisine, difficulty } = req.query;
    
    let sql = 'SELECT * FROM Recipes WHERE 1=1';
    const params = [];
    
    if (query) {
      sql += ' AND title LIKE ?';
      params.push(`%${query}%`);
    }
    
    if (category) {
      sql += ' AND category = ?';
      params.push(category);
    }
    
    if (cuisine) {
      sql += ' AND cuisine = ?';
      params.push(cuisine);
    }
    
    if (difficulty) {
      sql += ' AND difficulty = ?';
      params.push(difficulty);
    }
    
    const [recipes] = await db.query(sql, params);
    
    res.json({
      success: true,
      count: recipes.length,
      data: recipes
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error searching recipes',
      error: error.message
    });
  }
};