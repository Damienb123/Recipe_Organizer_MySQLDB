-- ================================================
-- Database Definition File for Recipe Management DB
-- ================================================

-- Drop existing tables to ensure a clean slate
DROP TABLE IF EXISTS UserRatings;
DROP TABLE IF EXISTS RestaurantMenus;
DROP TABLE IF EXISTS RecipeIngredients;
DROP TABLE IF EXISTS Instructions;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Recipes;
DROP TABLE IF EXISTS Ingredients;

-- Problem faced with previous table: referencing Ingredients(ingredient_id) never got defined or loaded in script (meaningless)
-- ingredient_id is redefined
-- ================================================
-- Table: Ingredients
-- ================================================
CREATE TABLE IF NOT EXISTS Ingredients (
ingredients_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NOT NULL UNIQUE
) COMMENT 'Stores all ingredients for each recipe';


-- ================================================
-- Table: Recipes
-- ================================================
CREATE TABLE IF NOT EXISTS Recipes (
 `recipe_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `title` varchar(500) NOT NULL,
 `discription` text DEFAULT NULL,
 `category` varchar(500) NOT NULL,
 `cuisine` varchar(500) NOT NULL,
 `cooking_time` int NOT NULL,
 `difficulty` enum('easy', 'medium', 'hard') DEFAULT NULL,
 `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
 `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Stores basic recipe information.';

CREATE INDEX index_1 ON Recipes (`title`);

-- ================================================
-- Table: Restaurants
-- ================================================
CREATE TABLE IF NOT EXISTS Restaurants (
 `restaurant_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `name` varchar(500) NOT NULL,
 `address` varchar(500) NOT NULL,
 `city` varchar(500) NOT NULL,
 `state` varchar(500) NOT NULL,
 `zip_code` varchar(500) NOT NULL,
 `phone` varchar(500) NOT NULL,
 `rating` decimal(3,2) NOT NULL
) COMMENT 'Contains data about restaurants that may offer recipes or menu items.';

-- ================================================
-- Table: Users
-- ================================================
CREATE TABLE IF NOT EXISTS Users (
 `user_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `username` varchar(500) NOT NULL,
 `email` varchar(500) NOT NULL UNIQUE,
 `password_hash` varchar(500) NOT NULL,
 `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT 'This table stores user account details.';

-- ================================================
-- Table: Instructions
-- ================================================
CREATE TABLE IF NOT EXISTS Instructions (
 `instruction_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `recipe_id` int NOT NULL,
 `step_number` int NOT NULL,
 `instruction_text` text DEFAULT NULL
) COMMENT 'Stores the step-by-step instructions for each recipe.';

-- ================================================
-- Table: RecipeIngredients
-- ================================================
CREATE TABLE IF NOT EXISTS RecipeIngredients (
 `recipe_id` int NOT NULL,
 `ingredient_id` int NOT NULL,
 `quantity` decimal(5,2) NOT NULL,
 PRIMARY KEY (`recipe_id`, `ingredient_id`)
) COMMENT 'A join table that links recipes to their ingredients, along with the required quantity.';

-- ================================================
-- Table: RestaurantMenus
-- ================================================
CREATE TABLE IF NOT EXISTS RestaurantMenus (
 `id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `restaurant_id` int NOT NULL,
 `recipe_id` int NOT NULL,
 `price` decimal(5,2) NOT NULL
) COMMENT 'Links restaurants to recipes they offer as menu items, along with pricing.';

-- ================================================
-- Table: UserRatings
-- ================================================
CREATE TABLE IF NOT EXISTS UserRatings (
 `rating_id` int NOT NULL AUTO_INCREMENT PRIMARY KEY,
 `recipe_id` int NOT NULL,
 `user_id` int NOT NULL,
 `rating` tinyint NOT NULL,
 `review_text` text DEFAULT NULL,
 `rating_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) COMMENT 'Holds user ratings and optional reviews for recipes.';


-- ================================================
-- Table: Foreign Key Constraints
-- ================================================
ALTER TABLE Instructions ADD CONSTRAINT fk_instructions_recipes FOREIGN KEY (`recipe_id`) REFERENCES Recipes (`recipe_id`) ON DELETE CASCADE;
ALTER TABLE RecipeIngredients ADD CONSTRAINT fk_recipeingredients_recipes FOREIGN KEY (`recipe_id`) REFERENCES Recipes (`recipe_id`) ON DELETE CASCADE;
ALTER TABLE RecipeIngredients ADD CONSTRAINT fk_recipeingredients_ingredients FOREIGN KEY (`ingredient_id`) REFERENCES Ingredients (`ingredient_id`) ON DELETE CASCADE;
ALTER TABLE RestaurantMenus ADD CONSTRAINT fk_restaurantmenus_recipes FOREIGN KEY (`recipe_id`) REFERENCES Recipes (`recipe_id`) ON DELETE CASCADE;
ALTER TABLE RestaurantMenus ADD CONSTRAINT fk_restaurantmenus_restaurants FOREIGN KEY (`restaurant_id`) REFERENCES Restaurants (`restaurant_id`) ON DELETE CASCADE;
ALTER TABLE UserRatings ADD CONSTRAINT fk_userratings_recipes FOREIGN KEY (`recipe_id`) REFERENCES Recipes (`recipe_id`) ON DELETE CASCADE;
ALTER TABLE UserRatings ADD CONSTRAINT fk_userratings_users FOREIGN KEY (`user_id`) REFERENCES Users (`user_id`) ON DELETE CASCADE;

-- ================================================
-- Data Insertion
-- ================================================

-- RestaruantMenus
INSERT INTO RestaurantMenus (restaurant_id, recipe_id, price) VALUES
(1, 1, 12.99),
(2, 2, 15.50),
(3, 3, 10.00),
(4, 4, 20.00),
(5, 5, 8.50);

-- charlie_black had a bad email not written correctly, now fixed with '@' instead of '.'
-- Users
INSERT INTO Users (username, email, password_hash) VALUES
('john_doe', 'jondoe@example.com', 'hashed_password_1'),
('jane_smith', 'janesmith@example.com', 'hashed_password_2'),
('alice_jones', 'alicejones@example.com', 'hashed_password_3'),
('bob_brown', 'bobbrown@example.com', 'hashed_password_4'),
('charlie_black', 'charlieblack@example.com', 'hashed_password_5');

-- UserRatings
INSERT INTO UserRatings (recipe_id, user_id, rating, review_text) VALUES
(1, 1, 5, 'Absolutely loved this recipe!'),
(2, 2, 4, 'Very good but could use more spices.'),
(3, 3, 3, 'It was okay, nothing special.'),
(4, 4, 2, 'Did not like it at all.'),
(5, 5, 1, 'Terrible recipe! Would not recommend.');

(1, 2, 5, 'Best recipe ever!'),
(2, 3, 4, 'Tasty and easy to make.'),
(3, 4, 3, 'Average recipe.'),
(4, 5, 2, 'Not my favorite.'),
(5, 1, 1, 'Did not enjoy this at all.');

-- Instructions
-- Instructions are now updated with improved accuracy per each recipe 
-- Spotted inconsistencies with instructions not matching the assigned recipe during testing
-- each recipe has a given quick easy 3 step process for completion
INSERT INTO Instructions (recipe_id, step_number, instruction_text) VALUES
(1, 1, 'boil spaghetti in salted water until tender. Drain and set aside'),
(1, 2, 'Cook ground beef with a little oil until browned.'),
(1, 3, 'Add the spaghetti to the sauce, toss well, and top with grated parmesan cheese. Serve hot.'),
(2, 1, 'In a pan, heat a little oil and cook chicken pieces until browned.'),
(2, 2, 'Add chopped onion, garlic, and curry powder. Stir for a minute, then pour in coconut milk or tomato sauce..'),
(2, 3, 'Let it gently simmer for 10–15 minutes until the chicken is cooked through and the sauce thickens.Serve hot with rice.'),    
(3, 1, 'Wash and chop romaine lettuce.'),
(3, 2, 'Toss lettuce with caesar dressing, cruotons, little grated parmesan cheese.'),
(3, 3, 'Serve in a bowl.'),
(4, 1, 'In a pan, cook ground beef with a little oil until browned. Drain excess fat if needed.'),
(4, 2, 'Add taco seasoning (or salt, pepper, and a little chili powder) plus a splash of water. Let it simmer for 2–3 minutes.'),
(4, 3, 'Spoon the beef into taco shells or tortillas and top with lettuce, cheese, and salsa. Serve and enjoy!'),
(5, 1, 'In a bowl, stir together chocolate cake mix (or flour, sugar, cocoa powder) with eggs, milk, and oil until smooth.'),
(5, 2, 'Pour into a greased pan and bake at 180°C / 350°F until a toothpick comes out clean (about 30–35 minutes).'),
(5, 3, 'Let it cool, spread with chocolate frosting, slice, and enjoy!');

-- Table was missing previously, now added
-- Ingredients
INSERT INTO Ingredients (name) VALUES
('Spaghetti'),
('Ground Beef'),
('Tomato Sauce'),
('Parmesan Cheese'),
('Chicken'),
('Onion'),
('Garlic'),
('Curry Powder'),
('Coconut Milk'),
('Romaine Lettuce'),
('Caesar Dressing'),
('Croutons'),
('Taco Seasoning'),
('Tortillas'),
('Cheddar Cheese'),
('Cake Mix'),
('Eggs'),
('Milk'),
('Vegetable Oil'),
('Chocolate Frosting');

-- previous RecipeIngredients table show old recipes with ID's / replacing old data with new 
-- RecipeIngredients
INSERT INTO RecipeIngredients (recipe_id, ingredient_id, quantity) VALUES
(1,1,200),(1,2,300),(1,3,150),(1,4,30),
(2,5,300),(2,6,100),(2,7,10),(2,8,5),(2,9,200),
(3,10,150),(3,11,50),(3,12,30),(3,4,20),
(4,2,250),(4,13,5),(4,14,4),(4,10,50),(4,15,40),
(5,16,1),(5,17,3),(5,18,200),(5,19,100),(5,20,150);

-- restaurants
INSERT INTO Restaurants (name, address, city, state, zip_code, phone, rating) VALUES
('Pasta Palace', '123 Noodle St', 'Pasta City', 'NY', '10001', '555-1234', 4.5),
('Burger Barn', '456 Burger Ave', 'Burger Town', 'CA', '90001', '555-5678', 4.0),
('Sushi Spot', '789 Sushi Rd', 'Sushi City', 'WA', '98001', '555-8765', 4.8),
('Taco Town', '321 Taco Blvd', 'Taco City', 'TX', '73301', '555-4321', 3.9),
('Pizza Place', '654 Pizza Ln', 'Pizza Town', 'FL', '33101', '555-6789', 4.2);

-- recipes
INSERT INTO Recipes (title, discription, category, cuisine, cooking_time, difficulty) VALUES
('Spaghetti Bolognese', 'A classic Italian pasta dish with a rich meat sauce.', 'Pasta', 'Italian', 30, 'medium'),
('Chicken Curry', 'A spicy and flavorful chicken dish.', 'Curry', 'Indian', 45, 'hard'),
('Caesar Salad', 'A fresh salad with romaine lettuce and Caesar dressing.', 'Salad', 'American', 15, 'easy'),
('Beef Tacos', 'Tasty tacos filled with seasoned beef and toppings.', 'Tacos', 'Mexican', 20, 'easy'),
('Chocolate Cake', 'A rich and moist chocolate cake.', 'Dessert', 'American', 60, 'hard');

-- ================================================
-- End of script
-- ================================================
