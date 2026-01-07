-- Grab the title from the recipes table, recipe_id, step_number, and instruction_text from the Instructions table
-- From the recipes table INNER JOIN values (in this case recipe_id)
SELECT 
	Recipes.title,
    Instructions.recipe_id,
    Instructions.step_number,
    Instructions.instruction_text
FROM Recipes
INNER JOIN Instructions ON
Recipes.recipe_id=Instructions.recipe_id
