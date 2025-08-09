import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import path from 'path';
import { fileURLToPath } from 'url';
import { VimGameEngine } from './game/VimGameEngine.js';
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
    cors: {
        origin: "http://localhost:3000",
        methods: ["GET", "POST"]
    }
});
const PORT = process.env.PORT || 3001;
// Serve static files from the client build
app.use(express.static(path.join(__dirname, '../../client/dist')));
// API routes
app.get('/api/health', (_req, res) => {
    res.json({ status: 'ok', timestamp: new Date().toISOString() });
});
// Socket.io connection handling
io.on('connection', (socket) => {
    console.log('New client connected:', socket.id);
    const gameEngine = new VimGameEngine();
    socket.on('execute-command', (command) => {
        try {
            const result = gameEngine.executeCommand(command);
            socket.emit('command-result', result);
        }
        catch (error) {
            socket.emit('error', { message: 'Command execution failed', error });
        }
    });
    socket.on('get-state', () => {
        socket.emit('state', gameEngine.getState());
    });
    socket.on('reset', (initialState) => {
        gameEngine.reset(initialState);
        socket.emit('state', gameEngine.getState());
    });
    socket.on('disconnect', () => {
        console.log('Client disconnected:', socket.id);
    });
});
// Catch-all route - serve the React app
app.get('*', (_req, res) => {
    res.sendFile(path.join(__dirname, '../../client/dist/index.html'));
});
httpServer.listen(PORT, () => {
    console.log(`VimGame server running on port ${PORT}`);
    console.log(`Open http://localhost:${PORT} in your browser`);
});
//# sourceMappingURL=index.js.map