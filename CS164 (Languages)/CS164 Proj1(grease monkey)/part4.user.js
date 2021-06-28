// ==UserScript==
// @name           Project 1: Part 4
// @namespace      ozzy85@gmail.com
// @description    Finds postal addresses and links them
// @include        *
// ==/UserScript=

//Websites: http://www.flashgames247.com/game/exclusive-games/mahjong-247.html
//	    http://www.funtoosh.com/miniclip2.php?file=icon-wars
//	    http://www.flasharcade.com/fun-games/darth-vader-game.html

(function () {
	var elements=document.getElementsByTagName("object");

	for (i=0; i<elements.length; i++) {
		var element_flash= elements[i];

		if (element_flash.innerHTML.match(/.swf|shockwave|flash/)) {
			var buttons=document.createElement("input");

			buttons.type = "button";
			buttons.id = i;
			buttons.value = "Enable Flash"; 

			//document.body.appendChild(buttons);
			element_flash.parentNode.insertBefore(buttons, element_flash);	
			element_flash.style.display='none';
			element_flash.on=false;

			buttons.addEventListener('click', function () {
				buttons.style.visibility = "hidden";
				element_flash.style.display='';
				element_flash.on=true;
				}, true);
		}
	}
})();


//window.onload = init;
//</script>

/*<!--
function disenable() {
	console.log("holla");
	if (flash.on == true) {
		flash.style.display='none';
		//placeholder.innerHTML="[Play Flash]";
		button.value =  "Flash Off";
		flash.on=false;
	}
	else {
		flash.style.display='';
		//placeholder.innerHTML="[Stop Flash]";
		button.value =  "Flash On";
		flash.on=true;
	}
	//true;
}
//-->*/
