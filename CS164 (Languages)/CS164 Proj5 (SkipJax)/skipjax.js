/**
 * @file skipjax.js
 *
 * $Id: skipjax.js,v 1.1 2007/04/27 10:54:28 cgjones Exp $
 *
 * This code borrows heavily from the Flapjax library, available from
 * http://www.flapjax-lang.org.  The Flapjax license notice is
 * presented below, just in case.
 */

/*
Copyright (c) 2006, the Flapjax Team All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
  * Neither the name of the Brown University, the Flapjax Team, nor the names
    of its contributors may be used to endorse or promote products derived
    from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


/** The set of functions we don't want to be lifted. */
var dontLift = [];


//-----------------------------------------------------------------------------
// Dataflow operators
//

/**
 * Create a new stream that only produces data after a "calming"
 * period. Precisely, when STREAM produces new data, the new stream
 * waits for PERIOD milliseconds before propagating the data. If any
 * new data arrives in this period, the first datum is discarded and
 * the process repeats for the second.
 */
function calm (value, period) {
    if (isDynamic (period))  __NYI ();

    var src = new Source ([], valueNow (value));

    var timeout = null;
    lift (function (v) {
              if (timeout) clearTimeout (timeout);
              timeout = setTimeout (function () { injectEvent (v, [src]); });
          }, value);

    return value instanceof Event ? changes (src) : src;
}
dontLift.push ('calm');


/** 
 * Return a new event stream whose events are a fold over the events
 * previously occurring on EV.
 *
 * EV must be an event.
 */
function collect (ev, func, init) {
	
	if (!(ev instanceof Event)) throw "ev is not an instance of event";
	if (isDynamic(init)) throw "init is dynamic"
	
	valueNow = init;
	
	return lift(function (event){
		valueNow = func(valueNow, event);
		return valueNow;
	}, ev);
	
	/*
	
	collectEvent = new Event(ev);
	oldUpdater = collectEvent.updater;
	valueNow = init;
	
	collectEvent.updater = function(){
		valueNow = func(valueNow, oldUpdater.apply(this, arguments));
		return valueNow;
	}
	
	return collectEvent;
	* 
	*/
}
dontLift.push ('collect');


/** Create a new stream that is delayed in time by LAG milliseconds. */
function delay (value, lag) {
    if (isDynamic (lag))  __NYI ();

    var src = new Source ([], valueNow (value));

    lift (function (val) { 
              setTimeout (function () { injectEvent (val, [src]); },
                          lag); },
          value);

    return (value instanceof Event) ? changes (src) : src;
}
dontLift.push ('delay');


/**
 * Create a new stream that is only defined at instances where: (i)
 * STREAM is defined, and (ii) PREDICATE(valueNow(STREAM) is a true
 * value.
 */
function filter (stream, fn) {
	//newEvent = sync (trigger, value);
	//alert (newEvent.updater)
	if (!isDynamic(stream)) throw "not a stream";
	
	/*
	var oldUpdate = stream.updater;
	*/
	
	return lift (function (oldStream){
		if(fn(oldStream)){
			return oldStream;
		}
	}, stream);
	
	/*
	stream.updater = function (){
		if (fn(oldUpdate.apply(this, arguments))){
			return oldUpdate.apply(this, arguments);
		}
	}
	
	return stream;	
	*/

}
dontLift.push ('filter');


/**
 * Turn the event-stream arguments to this function into one event
 * stream: whenever an event occurs on any of the inputs, propagate
 * it. 
 */
function merge (/* ... */) {
    var nodes = xslice (arguments, 0);

    for (var i = 0; i < nodes.length; i++)
        if (!(nodes[i] instanceof Event))
            throw 'Only Events can be merged.';

    // can't use lift() for this
    return new Event (
        new Behavior (
            function () { 
                for (var i = 0; i < arguments.length; i++)
                    if (arguments[i] !== undefined) 
                        return arguments[i];
                }, 
                nodes));
}
dontLift.push ('merge');


/**
 * Create a new event stream that takes on the value of VALUE whenever
 * an event occurs on TRIGGER.
 *
 * TRIGGER must be an Event.
 */
function snapshot (trigger, value) {
    if (!(trigger instanceof Event)) throw "Trigger is not an instance of Event";
 	if (value instanceof Event) throw "Value is an instance of Event";
	
	newEvent = sync (trigger, value);
	//alert (newEvent.updater)
	
	var oldUpdate = newEvent.updater
	newEvent.updater = function (val){
		temp = oldUpdate(val);
		return temp[1];
	}		
	//alert(newEvent.updater)
	//alert (newEvent instanceof Behavior)
	return newEvent;
}
dontLift.push ('snapshot');


//-----------------------------------------------------------------------------
// Data sources
//

/**
 * Create a time varying value with the current time in seconds,
 * updated every INTERVALSECS seconds.
 *
 * INTERVALSECS may be time varying.
 */
function seconds (intervalSecs) {
    if (intervalSecs === undefined)
        intervalSecs = 1;

    intervalSecs = lift (function (i) { return 1000 * i; }, intervalSecs);

    return timer (intervalSecs).transform (
        function (t) { return Math.floor (t / 1000); });
}
dontLift.push ('seconds');


/** 
 * Create a time varying value with the current time in deciseconds
 * (tenths of a second), updated every INTERVALDS deciseconds.
 *
 * INTERVALDS may be time varying.
 */
function deciseconds (intervalDs) {
    if (intervalDs === undefined)
        intervalDs = 1;

    intervalDs = lift (function (i) { return 100 * i; }, intervalDs);

    return timer (intervalDs).transform (
        function (t) { return Math.floor (t / 100); });
}
dontLift.push ('deciseconds');


/**
 * Create an event stream that sends the current time in milliseconds
 * every intervalMs.
 */
function ticks (intervalMs) {
    intervalMs = lift (function (i) { return i; }, intervalMs);    
    return new Event(timer (intervalMs));
}
dontLift.push ('ticks');


/** The mouse "top" coordinate. */
function mouseTop (domObj) {
    return lift (function (coords) { return coords.top; },
                 mousePosition.apply (this, arguments));
}
dontLift.push ('mouseTop');


/** The mouse "left" coordinate. */
function mouseLeft (domObj) {
    return lift (function (coords) { return coords.left; },
                 mousePosition.apply (this, arguments));
}
dontLift.push ('mouseLeft');


/** An event stream that is defined only when the mouse clicks domObj. */
function clicks (domObj) {
    return extractEvent (domObj, 'click');
}
dontLift.push ('clicks');


/** 
 * The time-varying value of domObj. value() only works with objects
 * that have an event like onchange, such as form elements.
 */
function value (domObj) {
    return extractValue (domObj);
}
dontLift.push ('value');


/** 
 * The time varying object { top: [mouse top coord], left: [mouse top
 * coord] }. 
 */
function mousePosition (domObj) {
    if (!domObj) domObj = document;

    return new Behavior (
        function (e) {
            return (e.pageX || e.pageY) ?  
                       {left: e.pageX, top: e.pageY} :
                       (e.clientX || e.clientY) ?
                           {left: e.clientX + document.body.scrollLeft,
                            top: e.clientY + document.body.scrollTop} :
                            __defaultMousePos;
        },
        [hold (extractEvent (domObj, 'mousemove'), __defaultMousePos)],
        __defaultMousePos);
}
var __defaultMousePos = { left: 0, top: 0 };
dontLift.push ('mousePosition');


/**
 * Create a time-varying value, the current time in milliseconds,
 * updated every INTERVALMS milliseconds.
 */
function timer (intervalMs) {
    if (!isDynamic (intervalMs)) {
        var timer_source = staticTimer (intervalMs);
        return timer_source[1];
    }

    var currentTimer;

    var timerStream = lift (
        function (newInterval) {
            if (currentTimer !== undefined)  clearInterval (currentTimer);

            var timer_source = staticTimer (newInterval);
            currentTimer = timer_source[0];
            return timer_source[1];
        }, intervalMs);

    return switch_ (timerStream);
}
dontLift.push ('timer');


/**
 * Create an event stream of the results of evaluating the foreign
 * scipt specified by URLANDVALUENAME, when URLANDVALUENAME changes.
 * URLANDVALUENAME should be an object with the fields url, the
 * location of the script to evaluate, and globalArg, the JavaScript
 * variable in which the foreign script will store its results.
 */
function evalForeignScript (urlAndValueName) {
    if (!isDynamic (urlAndValueName))
        urlAndValueName = mkConstantNode (urlAndValueName);

    var evalNode = lift (
        function (arg) {
            runScript (arg.url, arg.globalArg,
                       function (newVal) {
                           injectEvent (newVal, [source]);
                       });
        }, changes (urlAndValueName));

    var source = new Source ([changes (evalNode)]);

    return changes (source);
}
dontLift.push ('evalForeignScript');


/** 
 * Return an event stream that is defined only when EVENTNAME occurs
 * on DOMOBJ.
 */
function extractEvent (domObj, eventName) {
    if (!(isDynamic (domObj) || isDynamic (eventName)))
        return extractEventStatic (domObj, eventName);

    return switch_ (
        lift (function (d, ev) {
            return extractEventStatic (d, ev);
        }, domObj, eventName));
}
dontLift.push ('extractEvent');


/** 
 * Returns the merge of all the events on <code>domObj</code> named in
 * the variable arguments to this function.
 */
function extractEvents (domObj /*, ... */) {
    var eventNames = xslice (arguments, 1);
    return merge.apply (
        this, 
        eventNames.map (function (e) {
                            return extractEvent (domObj, e); })
        );
}
dontLift.push ('extractEvents');


//-----------------------------------------------------------------------------
// Data sinks

/** Keep the INDEX field of DOMOBJ up to date with VALUE. */
function insertValue (value, domObj, index) {
    if (isDynamic (domObj))  __NYI ();

    domObj = $(domObj);

    if (index === undefined) {
        var info = __inputFieldInfo[domObj.type];
        if (info)
            index = info.valueLoc;
        else
            index = 'innerHTML';
    }

    return lift (function (v, i) { deepUpdate (domObj, v, i); },
                 value, index);
}
dontLift.push ('insertValue');


/** Insert domObj into the document's DOM tree. */
function insertDom (domObj, hook) {
    var currentObj = hook;

    return lift (
        function (newObj) {
            if (!((typeof(newObj) == 'object') && (newObj.nodeType == 1))) { 
                var d = document.createElement ('span');
                d.appendChild (document.createTextNode (newObj));
                newObj = d;
            }
            swapDom (currentObj, newObj);
            currentObj = newObj;
            return newObj;
        }, 
        domObj);
}
dontLift.push ('insertDom');


//-----------------------------------------------------------------------------
// Primitive operators
//

/** Return the current value of X. */
function valueNow (x) {
    return isDynamic (x) ? x.valueNow () : x;
}
dontLift.push ('valueNow');


/** 
 * Create a time-varying value that starts as initVal and changes
 * value whenever an event occurs, taking on the value of that event.
*/
function hold (event, initVal) {
    return new Behavior (function (val) {return val; }, 
                         [event.behavior], initVal);
}
dontLift.push ('hold');


/**
 * Make an event steam whose events are the values of the behavior
 * whenever it changes.
 */
function changes (behavior) {
    return new Event (behavior);
}
dontLift.push ('changes');


/** 
 * Return a stream that produces the same data as the most recently
 * arrived stream from streams.
 */
function switch_ (streams) {
    var src = new Source ([]);

    lift (
        function (s) { 
            src.inc[0] = s;
            s.out.push (src);
            src.updateRank ();
            injectEvent (s.valueNow (), [src]);
        }, 
        streams);

    return src;
}
dontLift.push ('switch_');


/** Lift a computation into the world of Skipjax. */
function lift (fn /*, ... */) {
    var doPartialEval = true;
    for (var i = 0; i < arguments.length; i++) {
        if (isDynamic (arguments[i])) {
            doPartialEval = false;
            break;
        }
    }
    if (doPartialEval)
        return arguments[0].apply (this, xslice (arguments, 1));

    var elts = vsync (arguments);

    if (elts instanceof Event)
        return new Event (
            new Behavior (function (eltsArr) { 
                          return eltsArr[0].apply (this, eltsArr.slice (1)) 
                      }, [elts], undefined));
    else
        return new Behavior (
            function (/* ... */) {
                return arguments[0].apply (this, xslice (arguments, 1));
            },
            elts, 
            elts[0].valueNow ().apply (
                this, elts.slice (1).map (
                    function (elt) { return elt.valueNow (); }))
            );
}
dontLift.push ('lift');


/** 
 * If all arguments to this function are constants or behaviors,
 * returns an array of those behaviors. Otherwise, returns an event
 * that propagates arrays of the argument values, when all arguments
 * actually have a value.
 */
function sync (n1 /*, ... */) {
    return vsync (arguments);
}
dontLift.push ('sync');


/** 
 * Returns either an array of behaviors, or a single event that propagates 
 * a value consisting of an array of all constituent values, when all
 * constituents actually have a value.
 *
 * The former case occurs when all nodes are behaviors or constants, and the
 * latter when there is at least one event in the mix.
 */
function vsync (nodes) {
    nodes = xslice (nodes, 0);    /* hope the GC is smart ... */

    var hasEvents = false;
    for (var i = 0; i < nodes.length; i++) {
        if (nodes[i] instanceof Event)
            hasEvents = true;
        else if (!(nodes[i] instanceof Behavior || nodes[i] instanceof Source))
            nodes[i] = mkConstantNode (nodes[i]);
    }

    if (!hasEvents)
        return nodes;

    // This function is implemented in this way to ape Flapjax.
    // However, this scheme will cause serious memory leakage for mismatched
    // periodic events.  For example, with
    //    vsync ([changes (timer (100)), changes (timer (200))]);
    // the first event will fire twice as often as the second, meaning that 
    // after n*100 milliseconds, the first event will have n/2 pulses
    // waiting in its queue.  As n grows quite large, this could waste
    // considerable memory (i.e., you leave a tab open a few days because of 
    // inattention).

    // Create new event with the following properties:
    //   (1) there is a queue for each event, containing all received values
    //   (2) the event only propagates when a pulse has been received 
    //       each event
    //   (3) the pulse propagated is an array comprising the earliest pulse
    //       from each event, and the current value of each behavior
    var fifos = [];
    for (var i = 0; i < nodes.length; i++)  fifos[i] = [];

    var updater = function (/* ... */) {
        var readyToSend = true;

        for (var i = 0; i < arguments.length; i++) {
            if (nodes[i] instanceof Event) {
                if (arguments[i] !== undefined)  fifos[i].push (arguments[i]);
                readyToSend &= fifos[i].length > 0;
            } else
                fifos[i] = arguments[i];
        }

        if (readyToSend) {
            var pulse = [];
            for (var i = 0; i < fifos.length; i++)
                pulse[i] = (nodes[i] instanceof Event) ? 
                               fifos[i].shift () : fifos[i];

            return pulse;
        }
    }
        
    return new Event (new Behavior (updater, nodes, undefined));
}
dontLift.push ('vsync');


//-----------------------------------------------------------------------------
// Miscellaneous helper functions

/** A timer whose interval does not change. */
function staticTimer (intervalMs) {
    var source = new Source ([], Date.now ());
    var timerID = setInterval (
        function () { injectEvent (Date.now (), [source]); },
        intervalMs);
    return [timerID, source];
}



/** Recurse into INTO[INDEX] to update its properties from FROM. */
function deepUpdate (into, from, index) {
    if (typeof(from) == 'object') {
        for (var i in from) {
            if (!(Object.prototype) || !(Object.prototype[i])) {
                deepUpdate(index? into[index] : into, from[i], i);
            }
        }
    } else {
        into[index] = from;
    }
}

//-----------------------------------------------------------------------------
// DOM hackery

/* === Here on down is (mostly) shameless copied from Flapjax === */

function swapDom (replaceMe, withMe) {
    var replaceMeD = $(replaceMe);

    if (withMe) {
        var withMeD = $(withMe);

        try {
            replaceMeD.parentNode.replaceChild(withMeD, replaceMeD);
        } catch (e) {
            throw('swapDom: could not replace DOM element');
        }
    } else {
        replaceMeD.parentNode.removeChild(replaceMeD);
    }

    return replaceMeD;
}


var domEvents = {};

function extractEventStatic (domObj, eventName) {
    domObj = $(domObj);
    var id = getEventName(domObj);
        
    if (!domEvents[id]) { domEvents[id] = {}; }
        
    if (!domEvents[id][eventName]) {
        var source = new Source ([]);

        domEvents[id][eventName] = changes (source);
        addEvent (
            domObj, eventName,
            function (evt) {
                var event = evt;
                if (!evt) { event = window.event; }
                injectEvent (event, [domEvents[id][eventName].behavior]);
                return true;
        });
    }

    /* XXX: should we return a dependent event here? */
    return domEvents[id][eventName];
}

var __inputFieldInfo = {
    checkbox:  { events: ['click', 'keyup', 'change'], valueLoc: 'checked' },
    text:      { events: ['click', 'keyup', 'change'], valueLoc: 'value' },
    textArea:  { events: ['click', 'keyup', 'change'], valueLoc: 'value' },
    hidden:    { events: ['click', 'keyup', 'change'], valueLoc: 'value' },
    password:  { events: ['click', 'keyup', 'change'], valueLoc: 'value' },
    button:    { events: ['click', 'keyup', 'change'], valueLoc: 'value' },
    // XXX/TODO:
    // 'select-one':
    // 'select-multiple':
    // radio: 
};

function extractValue (domObj) {
    var obj = $(domObj);
    var info = __inputFieldInfo[obj.type];
    if (info) {
        var events = info.events;
        var valueLoc = info.valueLoc;
    } else {
        throw 'No info about the value of DOM element of type '+ obj.type;
    }

    return lift (function () { return obj[valueLoc]; },
                 hold (extractEvents.apply (this, [obj].concat (events)),
                       obj[valueLoc]));
}

/* XXX: questionably named, since we're getting the object's ID */
var eventCounter = 0;
function getEventName (domObj) {
    var id = null;
    try {
        id = domObj.getAttribute('id');
    } catch (exn) {}
    if ( (id === null) || (id === undefined) || (id.length < 1)) {
        id = 'flapjaxDomEvent' + eventCounter++;
        domObj.id = 'id';
    }
    return id;
}

function addEvent (obj, evType, fn) {
    if (obj.addEventListener) {
        obj.addEventListener(evType, fn, false);
        return true;
    } else if (obj.attachEvent) {
        return obj.attachEvent("on"+evType, fn); 
    } else {
        throw "Can't attach DOM event listener for: "+ evType;
    }
}


var scriptCounter = 0;
function deleteScript (scriptID) {
    var scriptD = $(scriptID);
    scriptD.parentNode.removeChild(scriptD);
}

function runScript (url, param, fn) {
    var script = document.createElement("script");
    script.src = url;
    var scriptID = 'scriptFnRPC' + scriptCounter++;
    script.setAttribute('id', scriptID);
    document.getElementsByTagName("head").item(0).appendChild(script);
    var timer = {};
    var check = 
        function () {
            eval("try { if (" + param + "!== undefined) {var stat = " + param + ";}} catch (e) {}");
            if (stat !== undefined) {
                eval(param + " = undefined;");
                clearInterval(timer.timer);
                clearInterval(timer.timeout);
                if (fn instanceof Function) { fn(stat); }
                deleteScript(scriptID);
            }
        };
    timer.timer = setInterval(check, 3500);
    timer.timeout = 
        setTimeout( 
            function () { 
                try { clearInterval(timer.timer); }
                catch (e) {}
            },
            5000);
}


//-----------------------------------------------------------------------------
// Dataflow nodes
//

/**
 * Behaviors are continuously defined; that is, it always makes sense
 * to call Behavior.valueNow ().
 *
 * UPDATER is the function that computest this node's value.
 * INC is the set of edges incident on this node.
 * INITVAL is the initial value of this Behavior.
 */
function Behavior (updater, inc, initVal) {
    this.updater = updater;
    this.inc = inc.slice (0);
    this.out = [];
    this.value = initVal;
    this.lastUpdated = -1;
    this.rank = 1 + inc.reduce (
        function (max, n) { return Math.max (max, n.rank) }, 0);

    for (var i = 0; i < inc.length; i++)
        inc[i].out.push (this);
}
/** Receive a pulse and recompute my value. */
Behavior.prototype.update = function (pulse) {
    var args = this.inc.slice (0).map (function (n) { return n.valueNow () });
    this.value = this.updater.apply (this, args);
    this.lastUpdated = pulse.time;
    return this.value;
}
/** Return my current value. */
Behavior.prototype.valueNow = function () {
    return this.value;
}
/** Create a new node that consumes my data and transforms it with FN. */
Behavior.prototype.transform = function (fn) {
    return lift (fn, this);
}
/** Update my topological rank. */
Behavior.prototype.updateRank = function () {
    var newRank = 1 + this.inc.reduce (
        function (max, n) { return Math.max (max, n.rank) }, 0);
    if (newRank != this.rank) {
        this.rank = newRank;
        for (var i = 0; i < this.out.length; i++)
            this.out[i].updateRank ();
    }
}


/**
 * Events are undefined at every point in time except those where it 
 * receives a new pulse.
 *
 * We wrap events around behaviours by creating a new behavior that only
 * propagates changes.  The behavior also has an overridden
 * valueNow() function that returns undefined except when it was last
 * updated at the current time step.
 */
function Event (behavior) {
    Behavior.call (
        this,
        function (val) { return val !== undefined ? val : undefined; },
        [behavior],
        undefined);
    this.behavior = behavior; /* save this to make hold() more convenient */
}
Event.prototype.update = Behavior.prototype.update;
Event.prototype.valueNow = function () {
    return this.lastUpdated === Pulse.time ? this.value : undefined;
}
Event.prototype.transform = Behavior.prototype.transform;
Event.prototype.updateRank = Behavior.prototype.updateRank;


/**
 * Sources are starting points for event propagation.  Their sole job is to
 * propagate received pulses.
 */
function Source (inc, initVal) {
    Behavior.call (this, null, inc, initVal);
}
Source.prototype.update = function (pulse) {
    this.value = pulse.val;
    this.lastUpdated = pulse.time;
    return this.value;
}
Source.prototype.valueNow = Behavior.prototype.valueNow;
Source.prototype.transform = Behavior.prototype.transform;
Source.prototype.updateRank = Behavior.prototype.updateRank;


function isDynamic (x) {
    return x instanceof Behavior || x instanceof Event || x instanceof Source;
}


//-----------------------------------------------------------------------------
// Factory
//

/** Create a behavior from a non-time-varying value.  */
function mkConstantNode (val) {
    return new Behavior (null, [], val);
}


//-----------------------------------------------------------------------------
// Data structures
//

/** A very inefficient, but simple, priority queue. */
function PriorityQueue () {
    var self = this;

    this.Q = [];

    var order = function (e1, e2) { return e1.k - e2.k };

    this.push = function (k, v) {
        self.Q.push ({k: k, v: v});
        self.Q.sort (order);
    }

    this.pop = function () {
        var e = self.Q.splice (0, 1)[0];
        return e === undefined ? undefined : e.v;
    }

    this.empty = function () {
        return self.Q.length === 0;
    }
}

/** 
 * A Pulse models the propagation of a datum along an edge in the dataflow
 * graph.  VAL is the datum, and TIME is the time the datum was generated.
 */
function Pulse (time, val) {
    this.time = time;
    this.val = val;
}
Pulse.time = 1;                 /* global Skipjax time */
Pulse.tick = function () {
    return ++Pulse.time;
}


//-----------------------------------------------------------------------------
// Evaluation core
//

/**
 * The set of nodes waiting to be evaluated, and the Pulses they are
 * to receive.  The nodes are sorted by their rank in the dataflow
 * graph.
 */
var evalQ = new PriorityQueue ();

/** 
 * Events that have been "injected" into the dataflow graph and are
 * waiting to be propagated.
 */
var eventQ = [];

/** Inject a new event into the dataflow graph, targeted at NODES. */
function injectEvent (val, nodes) {
    if (evalQ.empty () && eventQ.length === 0)
        propagatePulse (new Pulse (Pulse.tick (), val), nodes);
    else
        eventQ.push ({val: val, nodes: nodes});
}

/** 
 * Propagate PULSE to NODES.  Nodes that receive pulses aren't 
 * evaluated right away.  Instead, they are placed into evalQ until
 * it's their turn to be computed.
 */
function propagatePulse (pulse, nodes) {
    for (var i = 0; i < nodes.length; i++)
        evalQ.push (nodes[i].rank, {node: nodes[i], pulse: pulse});

    for (var np = evalQ.pop (); np !== undefined; np = evalQ.pop ()) {
        var n = np.node, p = np.pulse;
        
        if (n.lastUpdated === Pulse.time)
            continue;

        var newVal = n.update (p);

        if (newVal !== undefined) {
            p = new Pulse (Pulse.time, newVal);
            for (var i = 0; i < n.out.length; i++)
                evalQ.push (n.out[i].rank, {node: n.out[i], pulse: p});
        }
    }

    if (eventQ.length > 0) {
        var e = eventQ.shift ();
        propagatePulse (new Pulse (Pulse.tick (), e.val), e.nodes);
    }
}


//-----------------------------------------------------------------------------
// Utility
//

/** Return the left fold of FN over this array. */
Array.prototype.reduce = function (fn, acc) {
    for (var i = 0; i < this.length; i++)  acc = fn (acc, this[i]);
    return acc;
}

/** Return the right fold of FN over this array. */
Array.prototype.reduceR = function (fn, acc) {
    for (var i = this.length - 1; i >= 0; i--)  acc = fn (acc, this[i]);
    return acc;
}

/**
 * For one argument, return the DOM element referenced by the
 * argument. For multiple arguments, return an array of DOM elements.
 */
function $ (/* ... */) {
  var elements = new Array();

  for (var i = 0; i < arguments.length; i++) {
    var element = arguments[i];
    if (typeof element == 'string')
      element = document.getElementById(element);

    if (arguments.length == 1)
      return element;

    elements.push(element);
  }

  return elements;
}

/**
 * Return arr[start:stop].  The same operation as
 * Array.prototype.slice, but works for argument lists.
 */
//credit 4umi, by way of Flapjax
function xslice (arr, start, stop) {
    var i, len = arr.length, r = [];
    if( !stop ) { stop = len; }
    if( stop < 0 ) { stop = len + stop; }
    if( start < 0 ) { start = len - start; }
    if( stop < start ) { i = start; start = stop; stop = i; }
    for( i = 0; i < stop - start; i++ ) { r[i] = arr[start+i]; }
    return r;
}

/** Return a new array, created from the arguments to this function. */
function mkArray (/* ... */) {
    return xslice (arguments, 0);
}

/** 
 * Return a new object.  Arguments at even offsets are properties, and
 * arguments at odd offsets are values.
 */
function mkObject (/* ... */) {
    var retObj = {};
    for (var i = 0; i < arguments.length; i += 2)
        retObj[arguments[i]] = arguments[i+1];
    return retObj;
}


//-----------------------------------------------------------------------------
// Functions to be swept under the carpet.  This includes compiler
// hackery.

/** The X is time-varying, throw an exception.  Otherwise return it. */
function __JSValueOrDie (x) {
    if (isDynamic (x))  throw 'Attempt to read time-varying value.';
    else                return x;
}

/** Only lift FN if it did not come from the Skipjax library. */
function __maybeLiftCall (fn /*, ... */) {
    if ((fn instanceof Function) && (fn.__doNotLift))
        return fn.apply (this, xslice (arguments, 1));
    else
        return lift.apply (this, arguments);
}

/** Set up the __doNotLift property of functions don't want lifted. */
for (var i = 0; i < dontLift.length; i++)
    window[dontLift[i]].__doNotLift = true;


function __NYI () { throw 'Sorry, not yet implemented.'; }