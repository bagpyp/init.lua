const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "http://localhost:3000",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('../simple-client'));

// Load curriculum
let curriculum = null;
try {
  const curriculumPath = path.join(__dirname, '../lessons/curriculum.yaml');
  const fileContents = fs.readFileSync(curriculumPath, 'utf8');
  curriculum = yaml.load(fileContents);
  console.log('✅ Curriculum loaded successfully');
} catch (error) {
  console.error('❌ Failed to load curriculum:', error);
  curriculum = { lessons: [] };
}

// Simple in-memory storage
const gameState = {
  sessions: new Map(),
  progress: new Map()
};

// API Routes
app.get('/api/curriculum', (req, res) => {
  res.json(curriculum);
});

app.get('/api/lessons', (req, res) => {
  const lessons = curriculum.lessons || [];
  res.json(lessons.map(lesson => ({
    id: lesson.id,
    title: lesson.title,
    category: lesson.category,
    difficulty: lesson.difficulty,
    description: lesson.description,
    points: lesson.points,
    estimated_time: lesson.estimated_time
  })));
});

app.get('/api/lesson/:id', (req, res) => {
  const lesson = curriculum.lessons?.find(l => l.id === req.params.id);
  if (!lesson) {
    return res.status(404).json({ error: 'Lesson not found' });
  }
  res.json(lesson);
});

// Socket.IO for real-time game interaction
io.on('connection', (socket) => {
  console.log('🎮 User connected:', socket.id);
  
  socket.on('start_lesson', (lessonId) => {
    const lesson = curriculum.lessons?.find(l => l.id === lessonId);
    if (lesson) {
      gameState.sessions.set(socket.id, {
        lessonId,
        currentChallenge: 0,
        startTime: Date.now(),
        score: 0
      });
      
      socket.emit('lesson_started', {
        lesson,
        challenge: lesson.challenges[0]
      });
      console.log(`🚀 Started lesson: ${lesson.title}`);
    }
  });
  
  socket.on('vim_command', (command) => {
    const session = gameState.sessions.get(socket.id);
    if (!session) return;
    
    const lesson = curriculum.lessons?.find(l => l.id === session.lessonId);
    if (!lesson) return;
    
    const challenge = lesson.challenges[session.currentChallenge];
    if (!challenge) return;
    
    console.log(`⌨️ Command received: ${command}`);
    
    // Check if command matches expected
    const expectedCommands = challenge.expected_commands || [];
    const isCorrect = expectedCommands.includes(command);
    
    if (isCorrect) {
      session.score += 50;
      socket.emit('command_result', {
        success: true,
        message: `✅ Correct! You used: ${command}`,
        score: session.score,
        command
      });
      
      // Move to next challenge or complete lesson
      session.currentChallenge++;
      if (session.currentChallenge >= lesson.challenges.length) {
        socket.emit('lesson_completed', {
          totalScore: session.score,
          timeSpent: Date.now() - session.startTime
        });
        console.log(`🎉 Lesson completed: ${lesson.title}`);
      } else {
        socket.emit('next_challenge', {
          challenge: lesson.challenges[session.currentChallenge]
        });
      }
    } else {
      socket.emit('command_result', {
        success: false,
        message: `❌ Try again! Expected: ${expectedCommands.join(' or ')}`,
        score: session.score,
        command
      });
    }
  });
  
  socket.on('disconnect', () => {
    console.log('👋 User disconnected:', socket.id);
    gameState.sessions.delete(socket.id);
  });
});

// Serve the client app
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '../simple-client/index.html'));
});

const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`🎮 VimGame server running on http://localhost:${PORT}`);
  console.log(`📚 Teaching YOUR Space+1-8 shortcuts!`);
});

module.exports = app;