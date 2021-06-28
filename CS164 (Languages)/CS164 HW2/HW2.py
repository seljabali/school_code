import sys, re
def IsInt( str ):
    ok = 1
    try:
        num = int(str)
    except ValueError:
        ok = 0
    return ok

def IsOp( str ):
    ok = 1
    if (str == "+" or str == "-" or str == "x" or str == "%"):
        ok = 1
    else:
        ok = 0
    return ok

def IsAs( str ):
    ok = 1
    if (str == ":=" ):
        ok = 1
    else:
        ok = 0
    return ok

def IsDel( str ):
    ok = 1
    if (str == ":x" ):
        ok = 1
    else:
        ok = 0
    return ok

def IsVar( str ):
     ok = 1
     if ((IsOp(str) == 0) and ( IsInt(str) == 0)):
        ok = 1
     else:
        ok = 0
     return ok   
#def main():
if __name__ == "__main__":
    #x = str(raw_input("Please an expression: "))
    dict = {}
    stack = []
    if (len(sys.argv) < 3):
        print "Exhausted Stack" 
        exit()
    for i in range(1, len(sys.argv)):
        char = sys.argv[i];
        if(i == len(sys.argv)):
            answer = int(stack.pop())
            if (IsInt(answer)):
                print answer
                exit();
            else:
                print "Error! Answer not a number"
                exit();
        else:
            if (IsInt(char)): 
                stack.append(char)
            elif(IsOp(char)):
                try:
                    operand = stack.pop()
                    operand2 = stack.pop()
                except:
                    print "Error! Depleted stack!"
                    exit()
                if ( (IsVar(operand) == 1) and (dict.has_key(operand)) == 0):
                    print "Variable not foind!"
                    exit()
                if ( (IsVar(operand2) == 1) and (dict.has_key(operand2)) == 0):
                    print "Variable not foind!"
                    exit()
                if ( (IsVar(operand) == 1)):
                     operand = dict[operand];
                else:
                    operand = int(operand)
                if ( (IsVar(operand2) == 1)):
                     operand2 = dict[operand2];
                else:
                    operand2 = int(operand2)                     
                if(char == '-'):
                    intermediate = operand2 - operand
                    stack.append(intermediate)
                elif(char == '+'):
                    intermediate = operand + operand2
                    stack.append(intermediate)
                elif(char == 'x'):
                    intermediate = operand * operand2
                    stack.append(intermediate)
                elif(char == '%'):
                    intermediate = operand % operand2
                    stack.append(intermediate)
            elif(IsAs(char)):
                try:
                    operand = stack.pop()
                    operand2 = int(stack.pop())
                except:
                    print "Error! Assignment not a varible"
                    exit()
                try:#Assinging
                    dict[operand] = operand2
                except:
                    print "Can't assign " + Operand    
            elif(IsDel(char)):    
                try:
                    operand = stack.pop()
                except:
                    print "Error! Depleted stack!"
                    exit()
                if (dict.has_key(operand) == 0):
                    print "Couldn't find " + operand
                    exit(); 
                try:
                    del dict[operand]
                except:
                    print "Coudn't delete " + operand
            else:
                stack.append(char)
    if (len(stack) > 1):
        print "t00 big of a stack!"
        exit()
    else:
        answer = int(stack.pop())
        if (IsInt(answer)):
            print answer
            exit()
        else:
            print "Error!Answer not a number"