#Sami Eljabali, CS164-BH
#HW3
import re

def parse(grammar, inp):
    def CheckInput ():
        for i in range (len(Graph)):
            edge = Graph[i]
            edgeSate = edge[2]
            if edge[0]==0 and edge[1]==len(inp) and edgeSate[2]==len(edgeSate[1]):
                #Print ('Valid edge: ' + EdgeToString(edge))
                return True
        return False
    
    def enque(production):
        Q.append(production)
        Graph.append(production)
        
    def Predictor(edge):
        u = edge[0]
        v = edge[1]
        rhs =  edge[2][1]
        lhs = edge[2][0]
        B = nonTerminal.match(rhs, edge[2][2])
        if B != None:
            #print '1st case:',B.group(0)
            #For Each B -> &
            for prod in grammar[B.group(0)]:
                production = [v, v, [B.group(0), prod, 0]]
                #print 'Production: ', production
                if production not in Graph:
                    #print 'Inserted: ', production 
                    enque(production)            
        print '\n1st case', edge
        print 'Queue'
        for prod in Q:
            print prod
        print 'Graph:'
        for prod in Graph:
            print prod   
    
    def Completer(edge):
        #print '2nd case:'
        for q in Graph:
            #print q[2][1],q[2][2]
            B = nonTerminal.match(q[2][1], q[2][2]) #(u, v, A -> & . B &)
            if B != None:
                if lhs == B.group(0) and u == q[1]:
                    production = [q[0], v, [q[2][0], q[2][1], q[2][2]+1]]
                    if production not in Graph:
                        #print 'Inserted: ', production 
                        enque(production)
        print '\n2nd case', edge
        print 'Queue'
        for prod in Q:
            print prod
        print 'Graph:'
        for prod in Graph:
            print prod
                    
    def Scanner(edge):
        d = Terminal.match(edge[2][1], edge[2][2])
        if v < len(inp):
            #print inp[v]
            eState = edge[2]
            eDotPos = eState[2]
            #print inp[v][v],eState[1][eDotPos]
            if (inp[v][v] == eState[1][eDotPos]):#edge[2][1][edge[2][2]]]):#d.group(0):
                production = [u, v+1, [lhs, rhs, edge[2][2]+1]]
                #if production not in Graph:
                #print 'Inserted: ', production 
                enque(production)
        print '\n3rd case', edge
        print 'Queue'
        for prod in Q:
            print prod
        print 'Graph:'
        for prod in Graph:
            print prod
        
    Q = []
    Graph = []
            
    nonTerminal = re.compile('[A-Z]')
    Terminal = re.compile('[^A-Z]')
    case0 = re.compile('([a-z]|[A-Z])')
    case1 = re.compile('([A-Z][a-z]|[a-z][A-Z])*.?[A-Z]')
    case2 = re.compile('[^A-Z]|[A-Z]')
    case3 = re.compile('([A-Z][a-z]|[a-z][A-Z])*.?[a-z]')
    
    #Initialize
    for p in grammar['S']:
        Q.append([0,0, ["S", p, 0]])
        Graph.append([0,0, ["S", p, 0]])
    
    print 'Q: Before'
    for prod in Q:
        print prod
        
    while (len(Q) != 0):
        edge =  Q.pop(0)
        #print 'Popped ', edge
        u = edge[0]
        v = edge[1]
        rhs =  edge[2][1]
        lhs = edge[2][0]
        casematch = case1.match(rhs, edge[2][2])
        casematch2 = case2.match(rhs)
        casematch3 = case3.match(rhs, edge[2][2]) 
        if casematch != None and edge[2][2] != len(edge[2][1]): #If edge is (u, v, A -> & . B &) edge[2][1][edge[2][2]].isupper():
            Predictor(edge)
        elif edge[2][2] == len(edge[2][1]):
            Completer(edge)
        elif casematch3 != None: #not edge[2][1][edge[2][2]].isupper():
            Scanner(edge)
    
    if CheckInput(): 
        return True
    else: 
        return False            
    print 'Q: After'    
    for prod in Q:
        print prod
    print 'Graph: After'    
    for prod in Graph:
        print prod

def main():
    G={'S':('S+S','S-S','S*S','(S)','-S','V'), \
   'V':('a','b','c') \
   }
    inputs=('a+a',\
#        'a*a-a--(a*a)+-b--c',\
#        'a-+a',\
        )
    parse(G, inputs)
#    for i in inputs:
#
#        if parse(G, i): print 'Parsed OK'
#
#        else: print 'Syntax error'
main()

# Output of this sample run:
# Parsed OK
# Syntax error