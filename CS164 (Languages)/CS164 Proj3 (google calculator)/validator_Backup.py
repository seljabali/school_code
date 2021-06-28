import re, helpers

# add edge to queue and to graph if edge 
# does not already exist in graph. 
def enqueue(e, graph, queue):
    for i in range(len(graph)):
        if e==graph[i]:
            return
    queue.append(e)
    graph.append(e)
    
def nextIsNonTerm(state):
    if state[2]>=len(state[1]['rhs']):
        return None
    if type(state[1]['rhs'][state[2]])==type('str'):
        return state[1]['rhs'][state[2]]
    return None

def nextIsTerm(state):
    if state[2]>=len(state[1]['rhs']):
        return None
    REGEX = re.compile('regex')
    if type(state[1]['rhs'][state[2]])==type(REGEX):
        return state[1]['rhs'][state[2]]
    return None    
    
def parse(grammarAST, inp):
    def addToTable(key, value):
        #value = [value]
        if not metaTable.has_key(key):
            metaTable[key] = []
            metaTable[key].append(value)            
        else:
            #print "Appending to:",metaTable[key]
            newvalue = metaTable[key]
            newvalue.append(value)
            metaTable[key] = newvalue 

            
    #print 'Entered validator.parse()'
    metaTable = {}
    queue = []    # a worklist
    graph = []    # a list representing edges in the graph
    newGrammar = {}
    for rule in grammarAST.rules:
        lhs = rule.lhs
#        rhs = []
#        for production in rule.productions:
#            rhs.append(production['rhs'])
        newGrammar[lhs] = rule.productions
    grammar = newGrammar
    for  s in grammar[grammarAST.startSymbol]:
        enqueue([0,0,[grammarAST.startSymbol, s, 0]], graph, queue)
    while len(queue)!=0:
        u, v, state = queue.pop(0)
        lhs = state[0]
        rhs = state[1]['rhs']
        curPos = state[2]
        # prediction
        next = nextIsNonTerm(state)
        if next:
            if next=='_':
                key = (u,v,lhs)
                value = [[u,v,[lhs,state[1],curPos+1]],[[u,v,[lhs,state[1],curPos]], [re.compile('_')]]]
                addToTable(key, value)   
                enqueue([u, v, [lhs, state[1], curPos+1]], graph, queue)
                
#                for edge in graph:
#                    if edge[1]==v:
#                        next = nextIsNonTerm(edge[2])
#                        if lhs==next:
#                            print u, v, edge[2][0], edge[2][1], edge[2][2]
#                            key = (edge[0],v,edge[2][0])
#                            value = [[edge[0],v,[edge[2][0],edge[2][1],edge[2][2]+1]],[[edge[0],edge[1],[edge[2][0],edge[2][1],edge[2][2]]], [re.compile('_')]]]
#                            addToTable(key, value)                        
#                            enqueue([edge[0], v, [edge[2][0], edge[2][1], edge[2][2]+1]], graph, queue)
            else:
                rhss = grammar[next]
                for rhs in rhss:
                    enqueue((v, v, (next, rhs, 0)), graph, queue)
                    
        # completion                
        elif state[2]==len(state[1]['rhs']):
            for edge in graph:
                if edge[1]==u:
                    next = nextIsNonTerm(edge[2])
                    if lhs==next:
                        rhsString = helpers.rhsToString(edge[2])
                        key = (edge[0],v,edge[2][0])
                        value = [[edge[0],v,[edge[2][0],edge[2][1],edge[2][2]+1]],[[edge[0],edge[1],[edge[2][0],edge[2][1],edge[2][2]]],[u,v,state]]]
                        addToTable(key, value)                        
                        enqueue(value[0], graph, queue)
        
        # scanner
        next = nextIsTerm(state)
        if next:
            if v<len(inp):
                match = next.match(inp[v][0])
                if match:
                    rhsString = helpers.rhsToString(state)
                    key = (u, v+1, lhs)
                    value = [[u, v+1, [lhs, state[1], state[2]+1]],[[u,v,state],[inp[v][0]]]]  #metaTable[(u, v+1, (lhs, rhsString, state[2]+1))] = ((u, v+1, (lhs, state[1], state[2]+1)),((u,v,state),(inp[v][0]))) 
                    addToTable(key, value)
                    enqueue(value[0], graph, queue)
    
   # for p in metaTable:
   #     p = metaTable[p]
   #     print p
#        print 'edge: ', p[0]
#        print 'prodiction: ', p[1][0]
#        print 'cause: ', p[1][1]
#        print ''
        
#    print 'Testing...'
#    ht = {}
#    
#    ht[(u,v,state[0],r1,state[2])]='johnny'
#    print ht[(u,v,state[0],r1,state[2])]
        
    for i in range(len(graph)):
         if graph[i][0]==0 and graph[i][1]==len(inp) and graph[i][2][2]==len(graph[i][2][1]['rhs']):
           return True, metaTable, graph[i]
    return False, metaTable, graph[i]

        
        


