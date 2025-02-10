const express = require('express');
const { auth, isAdmin } = require('../middleware/auth');
const Event = require('../models/Event');
const Registration = require('../models/Registration');
const router = express.Router();

// Get all events with pagination
/**
 * @swagger
 * /api/events:
 *   get:
 *     summary: Get all events with pagination
 *     tags: [Events]
 *     description: Retrieves a paginated list of events sorted by date by default.
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           example: 1
 *         description: The page number.
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           example: 10
 *         description: Number of events per page.
 *       - in: query
 *         name: sort
 *         schema:
 *           type: string
 *           example: "date"
 *         description: The field to sort events by.
 *     responses:
 *       200:
 *         description: A list of events.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 events:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       id:
 *                         type: integer
 *                         example: 1
 *                       name:
 *                         type: string
 *                         example: "Tech Conference"
 *                       date:
 *                         type: string
 *                         format: date-time
 *                         example: "2025-06-15T10:00:00Z"
 *                 totalPages:
 *                   type: integer
 *                   example: 5
 *                 currentPage:
 *                   type: integer
 *                   example: 1
 *       400:
 *         description: Bad request.
 */

/**
 * @swagger
 * /api/events:
 *   post:
 *     summary: Create a new event
 *     tags: [Events]
 *     description: Creates a new event.
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Tech Conference"
 *               date:
 *                 type: string
 *                 format: date-time
 *                 example: "2025-06-15T10:00:00Z"
 *               capacity:
 *                 type: integer
 *                 example: 100
 *     responses:
 *       201:
 *         description: Event created successfully.
 *       400:
 *         description: Bad request.
 */

/**
 * @swagger
 * /api/events/{id}/register:
 *   post:
 *     summary: Register for an event
 *     tags: [Events]
 *     description: Registers the authenticated user for an event.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: The event ID.
 *     responses:
 *       201:
 *         description: Registration successful.
 *       400:
 *         description: Event is full or other error.
 *       404:
 *         description: Event not found.
 */

/**
 * @swagger
 * /api/events/{id}:
 *   put:
 *     summary: Update an event
 *     tags: [Events]
 *     description: Updates an event's details.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: The event ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: "Updated Event Name"
 *               date:
 *                 type: string
 *                 format: date-time
 *                 example: "2025-07-20T10:00:00Z"
 *     responses:
 *       200:
 *         description: Event updated successfully.
 *       400:
 *         description: Bad request.
 *       404:
 *         description: Event not found.
 */

/**
 * @swagger
 * /api/events/{id}:
 *   delete:
 *     summary: Delete an event
 *     tags: [Events]
 *     description: Deletes an event. Only accessible to admins.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: integer
 *         description: The event ID.
 *     responses:
 *       204:
 *         description: Event deleted successfully.
 *       404:
 *         description: Event not found.
 */

router.get('/', async (req, res) => {
  try {
    const { page = 1, limit = 10, sort = 'date' } = req.query;
    const events = await Event.findAndCountAll({
      limit: parseInt(limit),
      offset: (page - 1) * limit,
      order: [[sort, 'ASC']]
    });
    
    res.json({
      events: events.rows,
      totalPages: Math.ceil(events.count / limit),
      currentPage: page
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Create event
router.post('/', auth, async (req, res) => {
  try {
    const event = await Event.create(req.body);
    res.status(201).json(event);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Register for an event
router.post('/:id/register', auth, async (req, res) => {
  try {
    const event = await Event.findByPk(req.params.id);
    if (!event) {
      return res.status(404).json({ error: 'Event not found' });
    }

    const registrationCount = await Registration.count({
      where: { 
        EventId: event.id,
        status: 'CONFIRMED'
      }
    });

    if (registrationCount >= event.capacity) {
      return res.status(400).json({ error: 'Event is full' });
    }

    const registration = await Registration.create({
      UserId: req.user.id,
      EventId: event.id
    });

    res.status(201).json(registration);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Update event
router.put('/:id', auth, async (req, res) => {
  try {
    const event = await Event.findByPk(req.params.id);
    if (!event) {
      return res.status(404).json({ error: 'Event not found' });
    }

    await event.update(req.body);
    res.json(event);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Delete event (admin only)
router.delete('/:id', [auth, isAdmin], async (req, res) => {
  try {
    const event = await Event.findByPk(req.params.id);
    if (!event) {
      return res.status(404).json({ error: 'Event not found' });
    }

    await event.destroy();
    res.status(204).send();
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;