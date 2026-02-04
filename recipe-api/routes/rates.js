const express = require('express');
const router = express.Router();
const ratesController = require('../controllers/ratesController');

// Route to get average rating for a recipe
router.get('/', ratesController.getAllRatings);

router.get('/search', ratesController.getRatings);

router.get('/id', ratesController.getARatingId);

// Route to post a new rating for a recipe
router.post('/', ratesController.createRating);

// Route to update an existing rating for a recipe
router.put('/id', ratesController.udpateRating)

// Route to delete a rating for a recipe
router.delete('/id', ratingController.deleteRating);

module.exports = router;