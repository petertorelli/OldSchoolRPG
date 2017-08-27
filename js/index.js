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
		if (e.which === 37) { // left turn
			Party.turnLeft();
		} else if (e.which === 38) { // up is forward
			Party.advance();
		} else if (e.which === 39) { // right turn
			Party.turnRight();
		} else if (e.which === 40) { // down
		} else if (e.which === 0x42 || e.which === 0x62) { // b, B
			Party.bash();
		} else if (e.which === 27) {
			LevelMap.escapeHit();
		}
		// Redraw on every party move... par-tay.
		redraw();
		eventCheck();
	});
}
$(() => {
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
