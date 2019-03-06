import sys
import os
import subprocess

def runTestCase( program, numOfTestCase ):

    script_dir = os.path.dirname(__file__)
    relpath = "palindromes-testcases/testcase" + str(numOfTestCase)

    fileInput = open(os.path.join(script_dir, relpath + ".in"), 'r')
    fileOutput = open(os.path.join(script_dir, relpath + ".out"), 'r')

    stringBuf = []

    for line in fileInput:
        stringBuf.append(line)

    numOfChars = stringBuf[0]
    stringToCheck = stringBuf[1]

    solution = fileOutput.readline()

    fileInput.close()
    fileOutput.close()

    program = subprocess.Popen(program, stdout=subprocess.PIPE, stdin=subprocess.PIPE)
    program.stdin.write(numOfChars)
    program.stdin.write(stringToCheck)
    
    print("NumOfChars: " + numOfChars)
    print("Computed: " + program.stdout.readline())

    print("Solution is: " + str(solution))


if __name__ == "__main__":

    programName = sys.argv[1]
    testCase = sys.argv[2]

    runTestCase(str(programName), testCase)