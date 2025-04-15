sample of bingo web code :   import { useState, useEffect } from 'react'
import { Button } from "/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "/components/ui/card"
import { motion } from 'framer-motion'

export default function BingoGame() {
  const [bingoCard, setBingoCard] = useState<number[][]>([])
  const [calledNumbers, setCalledNumbers] = useState<number[]>([])
  const [currentNumber, setCurrentNumber] = useState<number | null>(null)
  const [gameStatus, setGameStatus] = useState<'idle' | 'playing' | 'won'>('idle')
  const [winningPattern, setWinningPattern] = useState<{row: number, col: number}[]>([])

  // Generate a random bingo card
  const generateBingoCard = () => {
    const newCard: number[][] = []
    const ranges = [
      [1, 15],   // B
      [16, 30],  // I
      [31, 45],  // N
      [46, 60],  // G
      [61, 75]   // O
    ]

    for (let col = 0; col < 5; col++) {
      const [min, max] = ranges[col]
      const columnNumbers: number[] = []
      
      // Generate 5 unique numbers for each column
      while (columnNumbers.length < 5) {
        const num = Math.floor(Math.random() * (max - min + 1)) + min
        if (!columnNumbers.includes(num)) {
          columnNumbers.push(num)
        }
      }
      
      // Add to card (transpose to rows)
      for (let row = 0; row < 5; row++) {
        if (!newCard[row]) newCard[row] = []
        newCard[row][col] = columnNumbers[row]
      }
    }

    // Set center as free space
    newCard[2][2] = 0 // 0 represents free space
    return newCard
  }

  // Initialize game
  const startGame = () => {
    setBingoCard(generateBingoCard())
    setCalledNumbers([])
    setCurrentNumber(null)
    setGameStatus('playing')
    setWinningPattern([])
  }

  // Call next number
  const callNumber = () => {
    if (gameStatus !== 'playing') return
    
    const allNumbers = Array.from({length: 75}, (_, i) => i + 1)
    const availableNumbers = allNumbers.filter(n => !calledNumbers.includes(n))
    
    if (availableNumbers.length === 0) {
      // All numbers called, game over
      return
    }
    
    const randomIndex = Math.floor(Math.random() * availableNumbers.length)
    const nextNumber = availableNumbers[randomIndex]
    
    setCurrentNumber(nextNumber)
    setCalledNumbers([...calledNumbers, nextNumber])
  }

  // Check for win condition
  const checkWin = () => {
    if (!bingoCard.length) return false
    
    const marked = bingoCard.map((row, rowIndex) => 
      row.map((num, colIndex) => 
        num === 0 || calledNumbers.includes(num) ? {row: rowIndex, col: colIndex} : null
      )
    )
    
    // Check rows
    for (let row = 0; row < 5; row++) {
      if (marked[row].every(cell => cell !== null)) {
        setWinningPattern(marked[row].filter(Boolean) as {row: number, col: number}[])
        return true
      }
    }
    
    // Check columns
    for (let col = 0; col < 5; col++) {
      if ([0,1,2,3,4].every(row => marked[row][col] !== null)) {
        setWinningPattern([0,1,2,3,4].map(row => marked[row][col]).filter(Boolean) as {row: number, col: number}[])
        return true
      }
    }
    
    // Check diagonals
    if ([0,1,2,3,4].every(i => marked[i][i] !== null)) {
      setWinningPattern([0,1,2,3,4].map(i => marked[i][i]).filter(Boolean) as {row: number, col: number}[])
      return true
    }
    
    if ([0,1,2,3,4].every(i => marked[i][4-i] !== null)) {
      setWinningPattern([0,1,2,3,4].map(i => marked[i][4-i]).filter(Boolean) as {row: number, col: number}[])
      return true
    }
    
    return false
  }

  // Check for win after each number is called
  useEffect(() => {
    if (gameStatus === 'playing' && calledNumbers.length > 0) {
      if (checkWin()) {
        setGameStatus('won')
      }
    }
  }, [calledNumbers])

  // Auto-start game on first render
  useEffect(() => {
    startGame()
  }, [])

  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-indigo-100 py-8 px-4">
      <Card className="max-w-4xl mx-auto">
        <CardHeader>
          <CardTitle className="text-3xl font-bold text-center">
            <span className="text-red-500">B</span>
            <span className="text-yellow-500">I</span>
            <span className="text-blue-500">N</span>
            <span className="text-green-500">G</span>
            <span className="text-purple-500">O</span>
          </CardTitle>
        </CardHeader>
        
        <CardContent className="space-y-8">
          {/* Current Number Display */}
          <div className="text-center">
            <div className="text-lg font-semibold mb-2">Current Number:</div>
            {currentNumber ? (
              <motion.div
                initial={{ scale: 0.5, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                className="inline-block"
              >
                <div className="text-6xl font-bold bg-primary text-primary-foreground rounded-full w-24 h-24 flex items-center justify-center mx-auto shadow-lg">
                  {currentNumber}
                </div>
              </motion.div>
            ) : (
              <div className="text-2xl text-muted-foreground">No number called yet</div>
            )}
          </div>

          {/* Bingo Card */}
          <div className="grid grid-cols-5 gap-1 max-w-md mx-auto">
            {['B', 'I', 'N', 'G', 'O'].map((letter, col) => (
              <div key={letter} className="text-center font-bold text-lg bg-primary text-primary-foreground py-2 rounded-t">
                {letter}
              </div>
            ))}
            
            {bingoCard.map((row, rowIndex) => 
              row.map((num, colIndex) => (
                <motion.div
                  key={`${rowIndex}-${colIndex}`}
                  initial={{ scale: 1 }}
                  animate={winningPattern.some(cell => cell.row === rowIndex && cell.col === colIndex) ? 
                    { scale: [1, 1.1, 1], rotate: [0, 5, -5, 0] } : 
                    { scale: 1 }}
                  transition={{ repeat: winningPattern.length ? Infinity : 0, duration: 0.5 }}
                  className={`aspect-square flex items-center justify-center border rounded 
                    ${num === 0 ? 'bg-yellow-100 font-bold' : ''}
                    ${calledNumbers.includes(num) ? 'bg-green-100' : 'bg-white'}
                    ${winningPattern.some(cell => cell.row === rowIndex && cell.col === colIndex) ? 
                      'ring-4 ring-yellow-500' : ''}
                  `}
                >
                  {num === 0 ? 'FREE' : num}
                </motion.div>
              ))
            )}
          </div>

          {/* Game Controls */}
          <div className="flex justify-center gap-4 pt-4">
            <Button 
              onClick={callNumber}
              disabled={gameStatus !== 'playing'}
              className="px-8 py-4 text-lg"
            >
              Call Number
            </Button>
            <Button 
              variant="outline" 
              onClick={startGame}
              className="px-8 py-4 text-lg"
            >
              New Game
            </Button>
          </div>

          {/* Win Message */}
          {gameStatus === 'won' && (
            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              className="text-center mt-6"
            >
              <div className="text-4xl font-bold text-green-600 mb-2">BINGO!</div>
              <p className="text-lg">You've got a winning pattern!</p>
            </motion.div>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
