import re, copy

convTable = {

   #Distance
   ('m'):       (1.,{'m':1},'m'),
   ('cm'):      (1/100.,{'m':1},'m'),
   ('mm'):      (1/1000., {'m':1},'m'),
   ('km'):      (1/0.001, {'m':1},'m'),
   ('feet'):    (1/3.2808399, {'m':1},'m'),
   ('foot'):    (1/3.2808399, {'m':1},'m'),
   ('in'):      (1/0.0254, {'m':1},'m'),
   ('inch'):    (1/0.0254, {'m':1},'m'),
   ('inches'):  (1/0.0254, {'m':1},'m'),
   ('smoot'):   (1/1.7018, {'m':1},'m'),
   ('smoots'):  (1/1.7018, {'m':1},'m'),
   ('mile'):    (1/1609.344, {'m':1},'m'),
   ('miles'):   (1/1609.344, {'m':1},'m'),
   ('ly'):      (1.05702341*10**-16, {'m':1},'m'),
   ('lightyear'):  (1.05702341*10**-16, {'m':1},'m'),
   ('lightyears'): (1.05702341*10**-16, {'m':1},'m'),
   ('AU'):         (6.68458134*10**-12, {'m':1},'m'),

   #Weight
   ('g'):       (1.,{'g':1},'g'),
   ('gram'):    (1.,{'g':1},'g'),
   ('grams'):   (1.,{'g':1},'g'),
   ('kg'):      (1000.,{'g':1},'g'),
   ('lb'):      (0.00220462262,{'g':1},'g'),
   ('lbs'):     (0.00220462262,{'g':1},'g'),
   ('pound'):   (0.00220462262,{'g':1},'g'),
   ('pounds'):  (0.00220462262,{'g':1},'g'),

   ('acre'):    (4046.85642,{'m':2},'m'),
   ('acres'):   (4046.85642,{'m':2},'m'),

   #Time
   ('s'):       (1., {'s':1},'s'),
   ('sec'):     (1.,{'s':1},'s'),
   ('secs'):    (1.,{'s':1},'s'),
   ('second'):  (1.,{'s':1},'s'),
   ('seconds'): (1.,{'s':1},'s'),
   ('min'):     (60.,{'s':1},'s'),
   ('minute'):  (60.,{'s':1},'s'),
   ('minutes'): (60.,{'s':1},'s'),
   ('h'):       (3600.,{'s':1},'s'),
   ('hour'):    (3600.,{'s':1},'s'),
   ('hours'):   (3600.,{'s':1},'s'),
   ('day'):     (86400.,{'s':1},'s'),
   ('days'):    (86400.,{'s':1},'s'),
   ('year'):    (31556926.,{'s':1},'s'),
   ('years'):   (31556926.,{'s':1},'s'),

   #Volume
   ('a cup'):    (0.000236588238,{'m':3},'m'),
   ('a cups'):   (0.000236588238,{'m':3},'m'),
   ('cup'):      (0.000236588238,{'m':3},'m'),
   ('cups'):     (0.000236588238,{'m':3},'m'),
   ('L'):        (0.001, {'m':3},'m'),
   ('l'):        (0.001, {'m':3},'m'),
   ('liter'):    (0.001, {'m':3},'m'),
   ('liters'):   (0.001, {'m':3},'m'),
   ('Liter'):    (0.001, {'m':3},'m'),
   ('Liters'):   (0.001, {'m':3},'m'),
   ('teaspoon'): (4.92892161*10**-6, {'m':3},'m'),
   ('teaspoons'):(4.92892161*10**-6, {'m':3},'m'),
   ('kilderkin'): (0.0818296538,{'m':3},'m'),
   ('kilderkins'):(0.0818296538,{'m':3},'m'),
   ('pint'):      (0.000473176475,{'m':3},'m'),
   ('pints'):     (0.000473176475,{'m':3},'m'),
   ('fl oz'):     (2.95735297*10**-5,{'m':3},'m'),

   #Speed
   ('mph'):   (0.44704,{'m':1, 's':-1},'m','s'),
   ('c'):     (299792458.,{'m':1, 's':-1},'m','s'),
   ('knot'):  (0.514444444,{'m':1, 's':-1},'m','s'),
   ('knots'): (0.514444444,{'m':1, 's':-1},'m','s'),

   #Energy
   ('J'):        (1.,{'J':1},'J'),
   ('Joule'):    (1.,{'J':1},'J'),
   ('Joules'):   (1.,{'J':1},'J'),
   ('joule'):    (1.,{'J':1},'J'),
   ('joules'):   (1.,{'J':1},'J'),
   ('cal'):      (4.18400,{'J':1},'J'),
   ('calorie'):  (4.18400,{'J':1},'J'),
   ('calories'): (4.18400,{'J':1},'J'),
   ('Cal'):      (4.18400,{'J':1},'J'),
   ('Calorie'):  (4.18400,{'J':1},'J'),
   ('Calories'): (4.18400,{'J':1},'J'),

   ('W'):        (1., {'J':1,'s':-1},'J','s'),
   ('Watt'):     (1., {'J':1,'s':-1},'J','s'),
   ('watt'):     (1., {'J':1,'s':-1},'J','s'),
   ('Watts'):    (1., {'J':1,'s':-1},'J','s'),
   ('watts'):    (1., {'J':1,'s':-1},'J','s'),
}

def printResult(val):
    print ""
    if type(val) != type([]):
        if val == None:
            print "Error: Couldn't evaluate it!"
        else:
            print val
    else:
        value = val[0]
        unit = val[1]
        print "Result:", value,'*',
        for k in unit:
            print k,'^',unit[k],
    print ""
            
            
#--------------------------MATH FUNCTIONS---------------------------------    
    
def Add(x,y):        
    if x[1].keys() != y[1].keys():
        print "Error: Can't add these units together"
        return None
    else:
        sum = [0,x[1]]
        sum[0] = x[0] + y[0]
        return sum

def Convert(From,To):
    def findExp():
        canDo = True  
        toUnit = conv[i]
        #print toUnit
        if From[1].has_key(toUnit):
            expFrom = From[1][toUnit] #From exp
            expTo = convTable[unit][1][toUnit]
            #print expTo
            if expFrom == expTo:
                expFrom = 1
            #print expFrom
        else:
            expFrom = 0
            canDo = False
        return expFrom , canDo


    result = [From[0],{}]
    stopFlag = False
    #print ""
    #print "\tConvert:",From, "To:",To
    
    for unit in To[1]:
        conv = convTable[unit]
        if  unit == "mph" or unit == 'c' or unit == 'knot' or unit == 'knots':
            stopFlag = True    
            
        for i in range(len(conv)):
            if i > 1:
                exp, valid = findExp()
#                if valid == False:
#                    print "\tMismatch: Can't convert"
#                    return None
                
                result[1][unit] = exp
                if stopFlag:
                    result[0] *= (1/conv[0])**exp
                    result[1] = conv[1]
                    break
                elif exp >1: #3:
                    result[0] *= (1/conv[0])**exp
                else:
                    result[0] *= (1/conv[0])**exp
    
    if stopFlag and (conv[1] == {'s':-1,'m':1} or conv[1] == {'m':1,'s':-1}):
        #print "Result:",result
        return result        
    elif result[1]!= To[1]:
        #print "Mismatch: Can't convert"
        #print "Result:",result[1]
        return None
    else:
        #print "Result:",result
        return result
    
def remove0exp(list):
    toRemove = [] #If there are any 0 exponents
    for unit in list[1]:
        if list[1][unit] == 0:
            toRemove.append(unit)
    for unit in toRemove:
        del list[1][unit]
        
def Divide(x,y):
    #print ""
    #print "\tDivide", x,"by",y
    quotient = [0,{}]
    if (type(y) == type(69) and y==0 or type(y) == type(6.9) and y==0.0) or (type(y) == type([]) and y[0]==0):
        print "Can't divide by zero!"
        return None
    
    if type(x) == type(69):
        if type(y) == type([]):                   
            quotient[0] =  x / y[0]
        else:
            quotient[0] =  x / y
            #print "\t=",quotient
            return quotient
    else:
        if type(y) == type([]):
            quotient[0] =  x[0] / y[0]
        else:
            quotient[0] = x[0] / y
            quotient[1] = x[1]
            #print "\t=",quotient
            return quotient 
    
    if len(y[1]) == 0:    #Dividing by scalar
        quotient[1] = x[1]
        #print "\t=",quotient
        return quotient
    
    for unit in x[1]:    #Subtract exponents, of common units in X and Y
        if y[1].has_key(unit):
            quotient[1][unit] =  x[1][unit] - y[1][unit]
        else:
            quotient[1][unit] =  x[1][unit]
    
    for unit in y[1]:    #Subtract powers from Y that aren't in X
        if not quotient[1].has_key(unit):
            quotient[1][unit] = -1 * y[1][unit]
    
    remove0exp(quotient)
            
    #print "\t=",quotient
    return quotient
        
def Factorial(x):
    def FactHelper(num):
        if num==0:
            return 1
        else:
            return num*FactHelper(num-1)
    
    if type(x) == type([]):
        if x[1] != None:
            print "Error: Factorials are defined for positive, dimensionless integers only"
            return None
        num = FactHelper(x[0])
        #print [num, x[1]]
        return [num, x[1]]
    else:
        #print FactHelper(x)
        return FactHelper(x)

def FQ(x):
    #print "\tFQ",x
    List = {'half': .5, 'double': .25, 'dozen':12.,}
    
    var = copy.deepcopy(List)
    #print "\tReturn:",var[x]
    
    return var[x]

def Epsilon(x):
    #print "\tEpsilon",Epsilon
    if type(x) == type(re.compile('lol')):
        return 1
    

def Root(x,y):
    return Pow(x,(1/y))

def Subtract(x,y):
    if x[1].keys() != y[1].keys():
        print "Error: Can't subtract these units form one another"
        return None
    else:
        diff = [0,x[1]]
        diff[0] = x[0] - y[0]
        return diff 

def Times(x,y):
    #print ""
    #print "\t",x,"Times", y
    #print 'M->',convTable['m']
    product = [1,{}]
    if type(x) == type(69) or type(x) == type(6.9) :        #X is scalar
        if type(y) == type([]):
            #product[0] = x * y[0]
            #product[1] = y[1]
            y[0] *= x
            #print "\t=",y
            return y
        else:       
            #product[0] =  x * y
            #print "\t=",x * y #product
            return x * y
    else:                            #Y is a scalar
        if type(y) == type(69) or type(y) == type(6.9):
            #product[0] = x[0] * y
            #product[1] = x[1]
            x[0] *= y
            #print 'M->',convTable['m']
            #print "\t=",x
            return x
        else:
            product[0] = x[0] * y[0]
            for unit in x[1]:    #Add powers of common units in X and Y
                if y[1].has_key(unit):
                    product[1][unit] =  x[1][unit] + y[1][unit]
                else:
                    product[1][unit] =  x[1][unit]        
            for unit in y[1]:    #Add powers from Y that aren't in X
                if not product[1].has_key(unit):
                    product[1][unit] = y[1][unit]
            
            remove0exp(product)
            #print 'M->',convTable['m']
#            print "\t=",product
            return product      
     
def Negate(x):
    if type(x) == type([]):
        return [x[0] *(-1), x[1]]
    else:
        return x*(-1)    

def Pow(x,y):
#    print ""
#    print "\tPow:", x, "^", y
    #print '\tM->',convTable['m']
    #print ""
    if type(x) == type([]):
#        zero = x[0]
#        one = x[1]
#        newVar = [zero,one]
        newVar = copy.deepcopy(x)
        newVar[0] = newVar[0] ** y
        for unit in x[1]:
            oldexp = newVar[1][unit]
            newVar[1][unit] = oldexp * y
        #print '\tM->',convTable['m']
        #print "\t=",newVar
        return newVar
    else:
        #print 'Other M->',convTable['m']
        product = x**y
        #print "\t=",product
        return product
#--------------------------END OF MATH FUNCTIONS---------------------------------

class Term:
    #unitList (unit, exponent)    
    def __init__(self,units):
        self.unit = units
    
    def getSI(self):
        #print convTable['m']
        self.result = convTable[self.unit]    
        self.val = [1*self.result[0], self.result[1]] 
#        print "\tConstructor:Unit",self.unit,"in table",self.result
#        print  "\tthen to",self.val
        return self.val
    
    def getInit(self):
        return [1, {self.unit: 1}]