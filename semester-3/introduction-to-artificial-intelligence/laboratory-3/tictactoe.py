from copy import deepcopy

class State:
    def __init__(self, start_state=None):
        self._state = start_state if start_state else self.generateEmptyState()
        self._xnumber, self._onumber = self._countChosenPlaces()
        self._isTerminal = self.isTerminal()

    def __str__(self):
        tictactoe = ''
        for row in range(0, 3):
            for column in range(0, 3):
                tictactoe += self._state[row][column] if self._state[row][column] else ' '
                tictactoe += '|' if column < 2 else '\n'
        return tictactoe

    def getState(self):
        return self._state

    def getXNumber(self):
        return self._xnumber

    def getONumber(self):
        return self._onumber

    def getIsTerminal(self):
        return self._isTerminal

    def _countChosenPlaces(self, size=3):
        x_number = 0
        o_number = 0
        for row in range(0, size):
            for column in range(0, size):
                if self._state[row][column] != None:
                    if self._state[row][column] == 'X':
                        x_number = x_number + 1
                    else:
                        o_number = o_number + 1
        return x_number, o_number

    def generateEmptyState(self, size=3):
        empty_state = []
        for row in range(0, size):
            empty_state.append([])
            for column in range(0, size):
                empty_state[row].append(None)
        return empty_state

    def generateChildren(self):
        states = []
        parent_state = deepcopy(self._state)
        for row in range(0, 3):
            for column in range(0, 3):
                if self._state[row][column] == None:
                    children_state = deepcopy(parent_state)
                    children_state[row][column] = 'X' if self._xnumber == self._onumber else 'O'
                    state = State(children_state)
                    states.append(state)
        return states
 
    def isTerminal(self):
        board = self._state

        for item in range(0, 3):
            if board[item][0] == board[item][1] == board[item][2] and board[item][0] != None:
                return True
            if board[0][item] == board[1][item] == board[2][item] and board[0][item] != None:
                return True

        if board[0][0] == board[1][1] == board[2][2] and board[0][0] != None:
            return True
        if board[0][2] == board[1][1] == board[2][0] and board[0][2] != None:
            return True

        if self._xnumber + self._onumber == 9:
            return True

        return False

    def checkWinner(self):
        board = self._state

        for item in range(0, 3):
            if board[item][0] == board[item][1] == board[item][2] and board[item][0] != None:
                return board[item][0]
            if board[0][item] == board[1][item] == board[2][item] and board[0][item] != None:
                return board[0][item]

        if board[0][0] == board[1][1] == board[2][2] and board[0][0] != None:
            return board[0][0]
        if board[0][2] == board[1][1] == board[2][0] and board[0][2] != None:
            return board[0][2]
        if self._xnumber + self._onumber == 9:
            return 'tie'

        return None

class Player:
    def __init__(self, isMaximizing):
        self._isMaximizing = isMaximizing
    
    def getIsMaximizing(self):
        return self._isMaximizing

class Game:
    def __init__(self, state=None, depth=9):
        self._currentstate = State() if not state else state
        self._max_player = Player(True)
        self._min_player = Player(False)
        self._depth = depth

    def play(self):
        depth           = self._depth
        min_player      = self._min_player
        max_player      = self._max_player
        players         = [max_player, min_player]
        current_state   = self._currentstate

        while not current_state.isTerminal():
            current_player  = players.pop(0)
            isMaximizing    = current_player.getIsMaximizing()
            best_score      = -float('inf') if isMaximizing else float('inf')
            children        = current_state.generateChildren()

            for child in children:
                current_score = minimax(child, isMaximizing, depth)
                if isMaximizing:
                    if current_score > best_score:
                        best_score = current_score
                        current_state = child
                else:
                    if current_score < best_score:
                        best_score = current_score
                        current_state = child
            print(current_state)
            players.append(current_player)

def minimax(board_state, isMaximizing, depth):
    if board_state.isTerminal() or depth == 0:
        return heuristic(board_state)

    grades = []
    children = board_state.generateChildren()
    for child in children:
        grades.append(minimax(child, not isMaximizing, depth-1))

    if isMaximizing:
        return max(grades)
    else:
        return min(grades)

def heuristic(board_state):
    grade = calculate_heuristic(board_state)

    if board_state.checkWinner() == 'X':
        grade = 10
    elif board_state.checkWinner() == 'O':
        grade = -10
    elif board_state.checkWinner() == 'tie':
        grade = 0
    
    return grade

def calculate_heuristic(board_state):
    heuristic_board = [[3, 2, 3], [2, 4, 2], [3, 2, 3]]
    grade           = 0
    board           = board_state.getState()
    for row in range(0, 3):
        for column in range(0, 3):
            if board[row][column] == 'X':
                grade += heuristic_board[row][column]
            elif board[row][column] == 'O':
                grade -= heuristic_board[row][column]
    return grade

game = Game()
game.play()
