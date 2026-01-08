SELECT
	Recipes.title,
    UserRatings.recipe_id,
    UserRatings.review_text
FROM Recipes
INNER JOIN UserRatings ON
Recipes.recipe_id=UserRatings.recipe_id
	

    