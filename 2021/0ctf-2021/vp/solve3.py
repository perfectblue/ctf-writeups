#!/usr/bin/env python3

import json
import fileinput
import sys
from itertools import combinations
from copy import deepcopy

from z3 import Solver, Ints, sat

GRID_SIZE = 10
MIN_VAL = 1
MAX_VAL = 10
SUM = 55

def assert_sum_and_uniqueness(areaVars, solver):
    """ Adds constraints in the Z3 solver for the list of area variables so
    that a) every variable is unique and b) the sum of all variables equals SUM
    """

    solver.add(sum(areaVars) == SUM)

    for pair in combinations(areaVars, 2):
        a, b = list(pair)
        solver.add(a != b)

def assert_initvals(sodukuVars, sudokuMatrix, solver):
    for i in range(len(sudokuMatrix)):
        for j in range(len(sudokuMatrix[i])):

            # The input matrix marks unknown digits with 0
            if sudokuMatrix[i][j] != 0:
                solver.add(sodukuVars[i][j] == sudokuMatrix[i][j])
            else:
                solver.add(sodukuVars[i][j] >= MIN_VAL)
                solver.add(sodukuVars[i][j] <= MAX_VAL)

def assert_rows(sodukuVars, solver):
    for row in sodukuVars:
        assert_sum_and_uniqueness(areaVars=row, solver=solver)

def assert_columns(sodukuVars, solver):
    for j in range(GRID_SIZE):
        areaVars = []
        for i in range(GRID_SIZE):
            areaVars.append(sodukuVars[i][j])

        assert_sum_and_uniqueness(areaVars, solver)

def print_solution(sudokuMatrix, sudokuVars, model):
    """ Create a copy of the original sudoku matrix problem and fill
    the blanks (i.e. zeros) with the solutions from the model
    """

    solvedMatrix = deepcopy(sudokuMatrix)

    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            if solvedMatrix[i][j] == 0:
                solvedMatrix[i][j] = model[sudokuVars[i][j]].as_long()

    ret = [];
    #print(json.dumps({"board": solvedMatrix}))
    for row in solvedMatrix:
#        print(row)
        row2 = [str(x - 1) for x in row]
        print(''.join(row2))

def main():
    sudokuInput = ''

#    for line in fileinput.input():
#        sudokuInput = sudokuInput + line
#
#    try:
#        jsonSudokuInput = json.loads(sudokuInput)
#    except json.JSONDecodeError:
#        print("Input is not valid JSON", file=sys.stderr)
#        sys.exit(1)

    grid2 = '''
__4_8_9016
__5__7__9_
512398____
409_______
8______9__
_9_______8
9_____8__7
68_9______
0______8_9
7__8_9_6__
    '''.strip().split('\n')
    grid2 = '''
__3___910_
__8__7__9_
512398____
409_______
8______9__
_9_______8
9_____8__7
68_9______
_______8_9
7__8_9_6__
    '''.strip().split('\n')
    grid = [[0 if c == '_' else int(c) + 1 for c in line] for line in grid2]
    sudokuMatrix = grid

    # Assert input dimensions. Currently only 9x9
    # sudoku puzzles are supported
    assert len(sudokuMatrix) == GRID_SIZE
    for row in sudokuMatrix:
        assert len(row) == GRID_SIZE
        for element in row:
            assert element >= 0
            assert element <= GRID_SIZE

    print('Input OK',file=sys.stderr)
    print(sudokuMatrix, file=sys.stderr)

    # Create matrix of Z3 variables
    sudokuVars = [[] for i in range(GRID_SIZE)]
    for i in range(GRID_SIZE):
        sudokuVars[i] = Ints("X%s%s" % (i,j) for j in range(GRID_SIZE))

    solver = Solver()

    # Add assertions for subgrids, rows and columns
    # The functions mutate the solver object

    assert_initvals(sudokuVars, sudokuMatrix, solver)
    assert_rows(sudokuVars, solver)
    assert_columns(sudokuVars, solver)

    result = solver.check()
    if result == sat:
        print_solution(sudokuMatrix, sudokuVars, solver.model())
        sys.exit(0)
    else:
        print('Could not find a solution for this puzzle.',file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
