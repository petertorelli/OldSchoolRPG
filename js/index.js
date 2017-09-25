
/**
 * The FontStruction “5x7 LED” (https://fontstruct.com/fontstructions/show/901022)
 * by John Smith is licensed under a Creative Commons Attribution Share Alike
 * license (http://creativecommons.org/licenses/by-sa/3.0/).
 */

const PIXEL_RATIO = (function () {
	let 
		ctx = document.createElement("canvas").getContext("2d"),
		dpr = window.devicePixelRatio || 1,
		bsr = 
			ctx.webkitBackingStorePixelRatio ||
			ctx.mozBackingStorePixelRatio ||
			ctx.msBackingStorePixelRatio ||
			ctx.oBackingStorePixelRatio ||
			ctx.backingStorePixelRatio || 1;
	return dpr / bsr;
})();

// Redraw all the visual thingies...
const redraw = () => {
	LevelMap.draw();
	render();
};

const eventCheck = () => {
	// 1. teleports.
	let cell = _getCellReference(Party.loc.i, Party.loc.j);
	if (cell == undefined)
		return;
	if (cell.properties.teleportTo !== undefined) {
		Party.loc.i = cell.properties.teleportTo.i;
		Party.loc.j = cell.properties.teleportTo.j;
		redraw();
		eventCheck();
	}
};

function initControllers () {
	$('#my-tabs a').click(function (e) {
		e.preventDefault()
		$(this).tab('show')
	});
	// Connect the mouse event controller for editing
	$('canvas#draw-grid')[0].addEventListener('mousemove', e => {
		LevelMap.mouseMoveHandler(e.offsetX, e.offsetY);
	}, false);
	
	// LevelMap editing controllers
	$('input[name="draw-entity"]').on('click', e => {
		LevelMap.editEntity = e.target.value;
		LevelMap.editType = e.target.getAttribute('data-type');
	});
	$('canvas#draw-grid').on('click', (e) => {
		LevelMap.handleCanvasClick(e.offsetX, e.offsetY);
	})
	$('input[name=enable-edit]').on('click', e => {
		$('input[name=draw-entity]').prop('disabled', !e.target.checked);
		LevelMap.userIsEditing = e.target.checked;
	});
	$('input[name=draw-entity][value=wall]').click();
	$('input[name=enable-edit]').click();  

	// Party Movement
	$('body').keydown((e) => {
		console.log(e.which);
		if (e.which === 37 || e.which === 65) { // left turn
			Party.turnLeft();
		} else if (e.which === 38 || e.which === 87) { // up is forward
			Party.advance();
		} else if (e.which === 39 || e.which === 68) { // right turn
			Party.turnRight();
		} else if (e.which === 75) { // kick (not "bash")
			Party.bash();
		} else if (e.which === 27) {
			LevelMap.escapeHit();
		}
		// Redraw on every party move... par-tay.
		redraw();
		eventCheck();
	});
}

function drawCastleMarket () {
	$('.sr[data-idx=0]').html( '  + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +');
	$('.sr[data-idx=1]').html( '  +   C A S T L E                                               M A R K E T   !');
	$('.sr[data-idx=2]').html( '  + - - - - - - - - - - -   C U R R E N T   P A R T Y :   - - - - - - - - - - +');

	$('.sr[data-idx=4]').html( '    #   C H A R A C T E R   N A M E     C L A S S   A C   H I T S   S T A T U S');






	$('.sr[data-idx=11]').html('  + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +');

	$('.sr[data-idx=13]').html('                            Y O U   M A Y   G O   T O :                        ');

	$('.sr[data-idx=15]').html("  T H E   A ) D V E N T U R E R ' S   I N N ,   G ) I L G A M E S H'           ");
	$('.sr[data-idx=16]').html("  T A V E R N ,   B ) O L T A C ' S   T R A D I N G   P O S T ,   T H E        ");
	$('.sr[data-idx=17]').html("  T E M P L E   O F   C ) A N T ,   O R   T H E   E ) D G E   O F   T O W N .  ");

}


$(() => {

	$('.sr').each((idx, el) => {
		$(el).css('top', (idx * 15.8));
	})
	drawCastleMarket();

	$('.fakescreen').html('a');
	$('.ur1').html('F)ORWARD  C)AMP    S)TATUS');
	$('.ur2').html('L)EFT     Q)UICK   A<-W->D');
	$('.ur3').html('R)IGHT    T)IME    CLUSTER'); 
	$('.ur4').html('K)ICK     I)NSPECT');
	$('.bot1').html('# CHARACTER NAME  CLASS AC HITS STATUS');
	$('.bot2').html('1');
	$('.bot3').html('2');
	$('.bot4').html('3');
	$('.bot5').html('4');
	$('.bot6').html('5');
	$('.bot7').html('6');
	// Initialize the tops-down map
	LevelMap.init($('canvas#draw-grid'));
	// -- begin CANVAS tweaks
	// Center the grid in the canvas so that we don't have half-lines on edges
	// set scale values for drawing (make the grid size a little smaller)
	grid.w = LevelMap.CANVAS.width() / (grid.i + 2);
	grid.h = LevelMap.CANVAS.height() / (grid.j + 2);
	// Make aspect ratio 1:1 by shrinking the larger size dimension
	if (grid.w != grid.h) {
		if (grid.w > grid.h) {
			grid.w *= (grid.h / grid.w);
		} else {
			grid.h *= (grid.w / grid.h);
		}
	}
	LevelMap.translate(grid.w, grid.h);
	// -- end CANVAS tweaks
	initControllers();
	redraw();
	eventCheck();
});
