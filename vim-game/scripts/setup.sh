#!/bin/bash

# VimGame Development Setup Script
# This script sets up the complete development environment for VimGame

set -e

echo "🎮 Setting up VimGame development environment..."
echo "=================================================="

# Check Node.js version
echo "📋 Checking Node.js version..."
node_version=$(node -v | cut -d'v' -f2)
required_version="20.0.0"

if [ "$(printf '%s\n' "$required_version" "$node_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "❌ Node.js version $node_version is not supported. Please use Node.js 20.0.0 or higher."
    echo "💡 If using asdf: asdf install nodejs 20.11.0 && asdf local nodejs 20.11.0"
    exit 1
fi

echo "✅ Node.js version: $node_version (OK)"

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
echo "------------------------------"

# Root dependencies
echo "Installing root dependencies..."
npm install

# Server dependencies
echo "Installing server dependencies..."
cd server
npm install
cd ..

# Client dependencies  
echo "Installing client dependencies..."
cd client
npm install
cd ..

echo "✅ All dependencies installed!"

# Create necessary directories
echo ""
echo "📁 Creating directory structure..."
echo "-----------------------------------"

mkdir -p server/src/{api,game,lessons,database,websocket}
mkdir -p server/tests
mkdir -p client/src/{components,game,lessons,hooks}
mkdir -p client/tests
mkdir -p database
mkdir -p docs/images

echo "✅ Directory structure created!"

# Initialize database
echo ""
echo "🗄️ Setting up database..."
echo "-------------------------"

# Create basic SQLite database
cat > database/schema.sql << 'EOF'
-- VimGame Database Schema

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  lesson_id TEXT NOT NULL,
  completed BOOLEAN DEFAULT FALSE,
  score INTEGER DEFAULT 0,
  time_spent INTEGER DEFAULT 0,
  attempts INTEGER DEFAULT 0,
  completed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, lesson_id)
);

CREATE TABLE IF NOT EXISTS achievements (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  badge_id TEXT NOT NULL,
  earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS daily_streaks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  date DATE NOT NULL,
  lessons_completed INTEGER DEFAULT 0,
  points_earned INTEGER DEFAULT 0,
  FOREIGN KEY (user_id) REFERENCES users(id),
  UNIQUE(user_id, date)
);

CREATE TABLE IF NOT EXISTS command_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  lesson_id TEXT NOT NULL,
  command TEXT NOT NULL,
  success BOOLEAN NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_progress_user_id ON progress(user_id);
CREATE INDEX IF NOT EXISTS idx_progress_lesson_id ON progress(lesson_id);
CREATE INDEX IF NOT EXISTS idx_achievements_user_id ON achievements(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_streaks_user_id ON daily_streaks(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_streaks_date ON daily_streaks(date);
CREATE INDEX IF NOT EXISTS idx_command_history_user_id ON command_history(user_id);

-- Insert demo user
INSERT OR IGNORE INTO users (username, email) VALUES ('demo', 'demo@vimgame.dev');
EOF

# Initialize SQLite database
sqlite3 database/vimgame.db < database/schema.sql
echo "✅ Database initialized!"

# Create development configuration
echo ""
echo "⚙️ Creating configuration files..."
echo "-----------------------------------"

# Server environment file
cat > server/.env << 'EOF'
NODE_ENV=development
PORT=3001
DATABASE_URL=../database/vimgame.db
JWT_SECRET=your-super-secure-jwt-secret-change-this-in-production
CORS_ORIGIN=http://localhost:3000
EOF

# TypeScript configuration for server
cat > server/tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EOF

# Vite configuration for client
cat > client/vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react-swc'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true
      },
      '/socket.io': {
        target: 'http://localhost:3001',
        changeOrigin: true,
        ws: true
      }
    }
  },
  build: {
    outDir: 'dist',
    sourcemap: true
  }
})
EOF

# Tailwind configuration
cat > client/tailwind.config.js << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        vim: {
          green: '#00ff00',
          black: '#000000',
          gray: '#808080'
        }
      },
      fontFamily: {
        mono: ['JetBrains Mono', 'SF Mono', 'Monaco', 'Inconsolata', 'monospace']
      }
    },
  },
  plugins: [],
}
EOF

# PostCSS configuration
cat > client/postcss.config.js << 'EOF'
export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
}
EOF

echo "✅ Configuration files created!"

# Create basic server entry point
echo ""
echo "🚀 Creating server entry point..."
echo "-----------------------------------"

cat > server/src/index.ts << 'EOF'
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import compression from 'compression';
import { createServer } from 'http';
import { Server } from 'socket.io';
import dotenv from 'dotenv';

// Load environment variables
dotenv.config();

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: process.env.CORS_ORIGIN || "http://localhost:3000",
    methods: ["GET", "POST"]
  }
});

const PORT = process.env.PORT || 3001;

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors({
  origin: process.env.CORS_ORIGIN || "http://localhost:3000"
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Basic health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// WebSocket handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
  
  socket.on('execute_command', (data) => {
    console.log('Command received:', data);
    // TODO: Process vim command with VimGameEngine
    socket.emit('command_result', {
      success: true,
      feedback: `Processed: ${data.command}`,
      score: 10
    });
  });
});

server.listen(PORT, () => {
  console.log(`
╔════════════════════════════════════════════╗
║            🎮 VimGame Server               ║
╚════════════════════════════════════════════╝

  🚀 Server running at: http://localhost:${PORT}
  🌐 API available at:  http://localhost:${PORT}/api
  🔌 WebSocket ready at: ws://localhost:${PORT}/socket.io
  
  Environment: ${process.env.NODE_ENV}
  Database: ${process.env.DATABASE_URL}
  `);
});
EOF

# Create basic client entry point
echo ""
echo "💻 Creating client entry point..."
echo "-----------------------------------"

cat > client/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>VimGame - Learn Vim Interactively</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

mkdir -p client/src
cat > client/src/main.tsx << 'EOF'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

cat > client/src/App.tsx << 'EOF'
import React from 'react'
import { VimSimulator } from './components/VimSimulator'

// Demo challenge
const demoChallenge = {
  id: 'demo',
  description: 'Press j to move down',
  initialState: {
    mode: 'normal' as const,
    buffer: ['Welcome to VimGame!', 'Press j to move down'],
    cursor: { line: 0, col: 0 },
    registers: {},
    marks: {}
  },
  expectedState: {
    cursor: { line: 1, col: 0 }
  },
  hints: [
    { delay: 3000, text: "Press 'j' to move down" }
  ]
};

function App() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-600 to-blue-600 p-8">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold text-white text-center mb-8">
          🎮 VimGame
        </h1>
        <p className="text-white text-center mb-8">
          Learn JetBrains-style Neovim through interactive lessons
        </p>
        <VimSimulator
          challenge={demoChallenge}
          onCommandExecuted={(result) => console.log('Command:', result)}
          onChallengeComplete={(success, stats) => console.log('Complete:', success, stats)}
        />
      </div>
    </div>
  )
}

export default App
EOF

cat > client/src/index.css << 'EOF'
@tailwind base;
@tailwind components;  
@tailwind utilities;

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.vim-simulator {
  @apply max-w-3xl mx-auto;
}
EOF

echo "✅ Entry points created!"

# Run initial tests
echo ""
echo "🧪 Running initial tests..."
echo "----------------------------"

# Test server compilation
cd server
npm run build
cd ..

echo "✅ Server builds successfully!"

# Test client compilation  
cd client
npm run build
cd ..

echo "✅ Client builds successfully!"

# Create start script
echo ""
echo "📝 Creating start scripts..."
echo "-----------------------------"

cat > start-dev.sh << 'EOF'
#!/bin/bash

echo "🎮 Starting VimGame development servers..."
echo "==========================================="

# Kill any existing processes on these ports
lsof -ti:3000 | xargs kill -9 2>/dev/null || true
lsof -ti:3001 | xargs kill -9 2>/dev/null || true

# Start both servers concurrently
npm run dev
EOF

chmod +x start-dev.sh

echo "✅ Start scripts created!"

# Final instructions
echo ""
echo "🎉 VimGame setup complete!"
echo "=========================="
echo ""
echo "🚀 To start development:"
echo "   ./start-dev.sh"
echo "   OR"
echo "   npm run dev"
echo ""
echo "🌐 URLs:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:3001"
echo "   API:      http://localhost:3001/api"
echo ""
echo "🧪 To run tests:"
echo "   npm test"
echo ""
echo "📚 Next steps:"
echo "   1. Read TODO.md for current tasks"
echo "   2. Check specs/ARCHITECTURE.md for technical details"
echo "   3. Start implementing the remaining API endpoints"
echo "   4. Add more lessons to curriculum.yaml"
echo ""
echo "Happy coding! 🎯"