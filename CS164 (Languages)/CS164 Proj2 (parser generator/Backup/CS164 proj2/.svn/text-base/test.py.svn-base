##
 # Testing script for grammar parsers.
 #
 # $Id: test.py,v 1.1 2007/02/27 00:59:19 cgjones Exp $

import difflib, os, re, sys

##-----------------------------------------------------------------------------
## Configuration constants
##
TEST_DIR = 'test/'
TESTER = 'run-test.py'
TESTPROG = '%s %s'% (sys.executable, TESTER)

##-----------------------------------------------------------------------------
## Helper functions
##
def udiff (expected, got):
    '''Return the diff of LINES1 and LINES2, or None if there is no difference.
    '''
    diff = difflib.unified_diff (expected, got, 'Expected', 'Got')
    for line in diff:  return diff

exceptionRegex = re.compile (
    r'(?:.|[\r\n])*(Traceback \(most recent call last\)\:(?:.|[\n\r])*)$')

def matchException (S):
    '''Return the text of the exception backtrace contained in S, or None'''
    match = exceptionRegex.match (S)
    if match: return match.group (1)

def runTest (test):
    '''Parse the grammar TEST, and return the output from stdout, stderr, and
    the exception backtrace, if there was one.
    '''
    cin, cout, cerr = os.popen3 ('%s %s'% (TESTPROG, test))
    cin.close ()
    output = cout.readlines ()
    errout = cerr.read ()
    exc = matchException (errout)
    print 'output: ', output
    print 'errout: ', errout
    print 'exc: ', exc
    return output, errout, exc

##-----------------------------------------------------------------------------
## Main
files = [TEST_DIR + f for f in os.listdir (TEST_DIR)
         if re.match (r'.*\.grm$', f) and os.access (TEST_DIR + f, os.R_OK)]
tests = [f for f in files if os.access (f +'.out', os.R_OK)]
errTests = [f for f in files if not os.access (f +'.out', os.R_OK)]

totalTests = len (tests) + len (errTests)
failed = 0

print '---------------------------------------------------------------------'
print '  "Correct" Tests\n'

for test in tests:
    print 'Running "%s" ...'% (test),
    
    (out, err, exc) = runTest (test)

    if exc:
        failed += 1
        print 'FAILED; terminated by an exception:'
        print exc
    elif err:
        failed += 1
        print 'FAILED; saw the error:'
        print err
    else:
        diff = udiff ((open (test +'.out')).readlines (), out)
        if diff:
            failed += 1
            print 'FAILED; difference in outputs:\n--- Expected'
            sys.stdout.writelines (diff)
        else:
            print 'passed'

print '\n---------------------------------------------------------------------'
print '  "Error" Tests\n'

for test in errTests:
    print 'Running "%s" ...'% (test),

    (out, err, exc) = runTest (test)

    if exc:
        failed += 1
        print 'FAILED; terminated by an exception:'
        print exc
    elif not err:
        failed += 1
        print 'FAILED; no error reported'
    else:
        print 'passed'

print '\n====================================================================='
print 'Passed %d out of %d tests\n'% (totalTests - failed, totalTests)
