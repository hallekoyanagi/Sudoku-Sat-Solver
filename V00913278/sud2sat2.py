import sys

def dealWithRawData(input_str):
    input_str = input_str.replace("\n", "")
    input_str = input_str.replace("\r", "")
    input_str = input_str.replace(" ", "")
    problem = [["." for _ in range(9)] for _ in range(9)]
    for i in range(len(input_str)):
        if  '1' <= input_str[i] <= '9':
            problem[i // 9][i % 9] = input_str[i]
    
    return problem

def getVariables(x, y, z):
    return str(81*(x-1) + 9*(y-1) + (z-1) + 1)

def  efficientEncoding():
    cnf = []

    # There is at most one number in each cell
    for x in range(1, 10):
        for y in range(1, 10):
            for z1 in range(1, 9):
                for z2 in range(z1 + 1, 10):
                    clause = ["-" + getVariables(x, y, z1), "-" + getVariables(x, y, z2)]
                    cnf.append(clause)
    
    # There is at least one number in each entry
    for x in range(1, 10):
        for y in range(1, 10):
            clause = [getVariables(x, y, z) for z in range(1, 10)]
            cnf.append(clause)
    
    # Each number appears at most once in each row
    for y in range(1, 10):
        for z in range(1, 10):
            for x in range(1, 9):
                for i in range(x+1, 10):
                    clause = ["-" + getVariables(x, y, z), "-" + getVariables(i, y, z)]
                    cnf.append(clause)
    
    # Each number appears at most once in each column
    for x in range(1, 10):
        for z in range(1, 10):
            for y in range(1, 9):
                for i in range(y+1, 10):
                    clause = ["-" + getVariables(x, y, z), "-" + getVariables(x, i, z)]
                    cnf.append(clause)
    
    # Each number appears at most once in each 3x3 sub-grid
    for z in range(1, 10):
        for i in range(0, 3):
            for j in range(0, 3):
                for x in range(1, 4):
                    for y in range(1, 4):
                        for k in range(y+1, 4):
                            clause = ["-" + getVariables(3*i+x, 3*j+y, z), "-" + getVariables(3*i+x, 3*j+k, z)]
                            cnf.append(clause)
                        for k in range(x+1, 4):
                            for l in range(1, 4):
                                clause = ["-" + getVariables(3*i+x, 3*j+y, z), "-" + getVariables(3*i+k, 3*j+l, z)]
                                cnf.append(clause)
    
    return cnf

def sud2sat(problem):
    cnf = efficientEncoding()
    
    # unit clauses representing the pre-assigned entries
    for x in range(1, 10):
        for y in range(1, 10):
            if problem[x - 1][y - 1] != '.':
                value = int(problem[x - 1][y - 1])
                for z in range(1, 10):
                    if z != value:
                        cnf.append(['-' + getVariables(x, y, z)])

    res = 'p cnf 729 {}\n'.format(len(cnf))
    for clause in cnf:
        res += ' '.join(clause) + ' 0\n'
        
    return res


if __name__ == "__main__":
    problem = dealWithRawData(sys.stdin.read())
    print(sud2sat(problem))