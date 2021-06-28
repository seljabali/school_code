import re

def printTable(table):
    dummy = {}
    if type(table)==type(dummy):
        for key in table:
            print table[key], key.pattern
    else:
        for key in table:
            print key[0], key[1]

def lex(gram, text):
    table = {}
    REGEX = re.compile ('a')
    for whitespace in gram.opIgnoreDecls:
        #print whitespace[0].pattern
        table[whitespace[0]] = 0
    for rule in gram.rules:
        for prod in rule.productions:
            for sym in prod['rhs']:
                if type(sym) == type (REGEX):
                    if not table.has_key(sym):
                        table[sym] = len(table)+1
    #printTable(table)                     
    result = scanText(table, text)
    return result

def scanText(table, text):
    lexemes = []
    curPos = 0
    while (curPos<len(text)):
        max = 0
        matchList = []
        whitespaceFound = False
        for elem in table:
            match = elem.match(text, curPos)
            if match!=None:
                matchLen = len(match.group())
            else:
                continue
            if table[elem]!=0:
                if matchLen > max:
                    max = matchLen
                    matchList = []
                    matchList.append((match.group(), table[elem]))
                elif matchLen == max:
                    matchList.append((match.group(), table[elem]))
            else:
                curPos += matchLen
                whitespaceFound = True
                continue
        if whitespaceFound==True:
            whitespaceFound = False
            continue
        if len(matchList)==0:
            #print 'Error: did not match any lexeme at position', curPos, 'in input file'#Remoev this before submitting
            return None
        elif len(matchList)==1:
            lexemes.append(matchList[0])
            curPos += len(matchList[0][0])
        else:
            maxPrec = 0
            for item in matchList:
                if item[1] > maxPrec:
                    maxPrec = item[1]
                    maxItem = item
            lexemes.append(maxItem)
            curPos += len(maxItem[0])
    return lexemes
                    
                
