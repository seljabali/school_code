import re
def Pow(x,y):
    if type(x) == type([]):
        exp = [x[0]**y, {}]
        for unit in x[1]:
            exp[1][unit] = exp[1][unit] ** y
        return exp  
    else:
        return x**y
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

def Convert(From,To):
    result = [From[0],{}]
    stopFlag = False
    for unit in To[1]:
        conv = convTable[unit]
            
        if  unit == "mph" or unit == 'c' or unit == 'knot' or unit == 'knots':
            stopFlag = True    
#        for u in conv[1]:                #get meters, sec
#            convertedUnits[u] = conv[1][u]   
        for i in range(len(conv)):
            if i > 1:
                temp = conv[i]
                if From[1].has_key(temp):
                    exp = From[1][temp]
                else:
                    print "Mismatch: Can't convert"
                    return None
                #print "To:",unit         
                #print "Conv:",conv
                result[1][unit] = exp
                if stopFlag:
                    result[0] *= (1/conv[0])**exp
                    result[1] = conv[1]
                    #print result
                    break
                elif exp >1: #3:
                    result[0] *= (1/conv[0])
                else:
                    result[0] *= (1/conv[0])**exp
    #print stopFlag
    #print conv[1] == {'s':-1,'m':1}
    
    if stopFlag and (conv[1] == {'s':-1,'m':1} or conv[1] == {'m':1,'s':-1}):
        print "Result:",result
        return result        
    elif result[1]!= To[1]:
        print "Mismatch: Can't convert"
        print "Result:",result[1]
        print "To:",To[1]
    else:
        print "Result:",result
    
#    if convertedUnits != From[1]:
#        print "Mismatch: Can't convert"
#        print "From units:", convertedUnits
#        print "To units:", From[1]
#        
#    else:
#        print "Result:",result

#Distance    
#a = [1, { 'm': 2}]
#b = [1, { 'acre': 1}]

#Volume
#a = [1, { 'm': 3}]
#b = [1, { 'liter': 1}]

#Speed
#a = [1, { 'm': 1, 's':-1}]
#b = [1, { 'mph': 1}]

#Time
#a = [1, { 's': 1}]
#b = [1, { 'years': 1}]

#Error Checking
#a = [1, { 's': -3}]
#b = [1, { 'feet': -3}]
a = [1, { 'm': 2}]
b = [1, { 'feet': -3}]

print "From:", a
print "To:",b[1]
print "***********"
Convert(a,b)