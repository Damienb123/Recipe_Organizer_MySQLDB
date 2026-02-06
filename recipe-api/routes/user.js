const express = require('express');
const router = express.Router();
const userController = require('../controller/userController');


// Route to get all users
router.get('/', userController.getAllUsers);

router.get('/search', userController.getUsers);

router.get('/:id', userController.getUserById);

// Route to post a user
router.post('/', userController.createUser);

// Route to put a user
router.put('/:id', userController.updateUser);

// Route to update a user
router.patch('/:id', userController.updateUser);

// Route to delete a user
router.delete('/:id', userController.deleteUser);
