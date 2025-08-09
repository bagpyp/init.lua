import { VimSimulator } from './components/VimSimulator'

const defaultChallenge = {
  id: 'basic-movement',
  description: 'Move the cursor to the end of the line',
  initialState: {
    mode: 'normal' as const,
    buffer: ['Hello, World!', 'Welcome to VimGame', 'Let\'s learn Vim together'],
    cursor: { line: 0, col: 0 },
    registers: {},
    marks: {}
  },
  expectedState: {
    cursor: { line: 0, col: 12 }
  },
  hints: [
    { delay: 5000, text: 'Try using $ to move to the end of the line' },
    { delay: 10000, text: 'You can also use the End key' }
  ]
}

function App() {
  return (
    <div className="min-h-screen bg-gray-900 flex items-center justify-center p-8">
      <div className="w-full max-w-4xl">
        <h1 className="text-3xl font-bold text-white mb-2 text-center">VimGame</h1>
        <p className="text-gray-400 text-center mb-8">Master Vim Through Gaming</p>
        
        <div className="bg-gray-800 rounded-lg p-6 mb-4">
          <h2 className="text-xl font-semibold text-white mb-2">Challenge: {defaultChallenge.description}</h2>
          <p className="text-gray-400 text-sm">Move your cursor to complete the challenge!</p>
        </div>
        
        <VimSimulator
          challenge={defaultChallenge}
          onCommandExecuted={(result) => {
            console.log('Command executed:', result)
          }}
          onChallengeComplete={(success, stats) => {
            console.log('Challenge complete:', success, stats)
            if (success) {
              alert('Challenge completed! Great job!')
            }
          }}
        />
      </div>
    </div>
  )
}

export default App