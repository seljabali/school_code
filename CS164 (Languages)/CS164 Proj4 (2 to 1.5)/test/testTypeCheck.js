/*
# Void: undefined
# Null: undefined, null
# Boolean: true, false
# Number: ints U floats
# String: strings
# Array: arrays, null, undefined
*/

class B {
 var x : Number = 5; 
 var z : Number = 5;
 
  function Zib (x : Number) : Number -> Number-> Number {
    return function (y : Number) : Number-> Number {
        return function (z : Number) : Number {
        	return x + y;
    	}
    }
  }
}


class A extends B{
	var x : Number = 5; 
	var y : Number  = 5;
	function Zib (x : Number) : Number{
		return 5;
	}
}	

var x : Number = 5; var y : Number = 5;
x+y;

var x : Number = 5; var y : Boolean = 5;
x+y;

var x : Number = 5; var y : String = "Hello";
x + y;

/*
function Yap (y : Number) : Number {
	var z: String = "Hello"
    return z;
};
*/
function lol (x : Number) : Number -> Number {
    return function (y : Number) : Number {
        return x + y;
    };
}

var curryAdd : Number -> Number -> Number = function  (x : Number) : Number -> Number {
    return function (y : Number) : Number {
        return x + y;
    };
};
var add1 : Number -> Number = curryAdd(1);
var two : Number = add1(1);

var a : Dynamic = 0;
a = 3;


var arr:Array = [1,2,3,4];
//arr[lol];


var a1:A = new A();
a1.w; 
//b1 = new B();

//var c:Dynamic = 5;

//c = "String";

	
//var arr:Array = [1,2,3,4];


/*
Not Working
var transform : (Number -> Number) * Number -> Number = 
   function (f : Number -> Number, i : Number) : Number {
       return f(i);
   };
var three : int = transform(add1, 2);
* 
* 
var a1 = new A();
a1.S(5);
*/