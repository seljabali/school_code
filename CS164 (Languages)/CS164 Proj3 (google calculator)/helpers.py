import re

def rhsToString(state):
    r1 = ''
    REGEX1 = re.compile('a')
    for r in state[1]['rhs']:
        if type(r)==type(REGEX1):
            r1 = r1 + str(r.pattern)
        else:
            r1 = r1 + str(r)
    return r1
