// ==UserScript==
// @name           Project 1: Part 4
// @namespace      ozzy85@gmail.com
// @description    Finds postal addresses and links them
// @include        http://play.cs.berkeley.edu/wiki/cs164/fa07/index.php/Project_1#Part_3:_Geolocator
// ==/UserScript=

//Websites: http://www.flashgames247.com/game/exclusive-games/mahjong-247.html
//	    http://www.funtoosh.com/miniclip2.php?file=icon-wars
//	    http://www.flasharcade.com/fun-games/darth-vader-game.html

(function () {

			buttons.type = "button";

			//document.body.appendChild(buttons);
			element_flash.parentNode.insertBefore(buttons, element_flash);	
			element_flash.style.display='none';
			element_flash.on=false;

			buttons.addEventListener('click', function () {
				buttons.style.visibility = "hidden";
				}, true);
	}
})();


//window.onload = init;
//</script>

/*<!--
function disenable() {
	console.log("holla");
	if (flash.on == true) {
		button.value =  "Flash Off";
		button.value =  "Flash On";
	//true;
}
//-->*/