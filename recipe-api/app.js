// Create the express app
import express from 'express';
import recipeRoutes from './routes/recipeRoutes.js';

const app = express();
app.use(express.json());

// Use the recipe routes
app.use('/api/recipes', recipeRoutes);

app.listen(3000, () => {
  console.log('Recipe API is running on http://localhost:3000');
});
