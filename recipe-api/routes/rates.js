const express = require('express');
const router = express.Router();
const ratingsController = require('../controllers/ratesController');

// Route to get average rating for a recipe
router.get('/', ratingsController.getAllRatings);

router.get('/search', ratingsController.getRatings);

router.get('/:id', ratingsController.getARatingId);

// Route to post a new rating for a recipe
router.post('/', ratingsController.createRating);

// Route to update an existing rating for a recipe
router.put('/id', ratingsController.updateRating)

// Route to delete a rating for a recipe
router.delete('/id', ratingsController.deleteRating);

module.exports = router;
