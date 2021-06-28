import re

# add edge to queue and to graph if edge 
# does not already exist in graph. 
def enqueue(e, graph, queue):
    for i in range(len(graph)):
        if e==graph[i]:
#            print 'edge equals...'
#            print e
#            print graph[i]
#            print ''
            return
#    if not e in graph:
    queue.append(e)
    graph.append(e)
    
def nextIsNonTerm(state):
    if state[2]>=len(state[1]):
        return None
    if type(state[1][state[2]])==type('str'):
        return state[1][state[2]]
    return None

def nextIsTerm(state):
    if state[2]>=len(state[1]):
        return None
    REGEX = re.compile('regex')
    if type(state[1][state[2]])==type(REGEX):
        return state[1][state[2]]
    return None

def parse(grammarAST, inp):

    #print 'Entered validator.parse()'
    queue = []    # a worklist
    graph = []    # a list representing edges in the graph
    newGrammar = {}
    for rule in grammarAST.rules:
        lhs = rule.lhs
        rhs = []
        for production in rule.productions:
            rhs.append(production['rhs'])
        newGrammar[lhs] = rhs
    grammar = newGrammar
    for  s in grammar[grammarAST.startSymbol]:
        enqueue((0,0,(grammarAST.startSymbol, s, 0)), graph, queue)
    while len(queue)!=0:
        u, v, state = queue.pop(0)
        lhs = state[0]
        rhs = state[1]
        curPos = state[2]
        next = nextIsNonTerm(state)
        if next:
            if next=='_':
                enqueue((u, v, (lhs, rhs, curPos+1)), graph, queue)
                #enqueue((u, v, (lhs, rhs, 0)), graph, queue)
#                for edge in graph:
#                    if edge[1]==v:
#                        next = nextIsNonTerm(edge[2])
#                        if lhs==next:
##                            print u, v, edge[2][0], edge[2][1], edge[2][2]
#                            #enqueue((edge[0], v, (edge[2][0], edge[2][1], edge[2][2]+1)), graph, queue)
#                            enqueue((u, v, (lhs, rhs, state[2]+1)), graph, queue)
            else:
                rhss = grammar[next]
                for rhs in rhss:
                    enqueue((v, v, (next, rhs, 0)), graph, queue)                
        elif state[2]==len(state[1]):
            for edge in graph:
                if edge[1]==u:
                    next = nextIsNonTerm(edge[2])
                    if lhs==next:
                        enqueue((edge[0], v, (edge[2][0], edge[2][1], edge[2][2]+1)), graph, queue)
        next = nextIsTerm(state)
        if next:
            if v<len(inp):
                match = next.match(inp[v][0])
                if match:
                    enqueue((u, v+1, (lhs, state[1], state[2]+1)), graph, queue)
    for i in range(len(graph)):
         if graph[i][0]==0 and graph[i][1]==len(inp) and graph[i][2][2]==len(graph[i][2][1]):
           return True
    return False
