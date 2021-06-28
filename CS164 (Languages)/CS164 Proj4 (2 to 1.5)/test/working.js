var x : Number = 5; var y : Number = 5;
x+y;

var x : Number = 5; var y : Boolean = 5;
x+y;

var x : Number = 5; var y : String = "Hello";
x + y;

function Yap (y : Number) : Number {
	var z: String = "Hello"
    return z;
};

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
arr[lol];