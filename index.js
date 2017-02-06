
const redraw = () => {
    LevelMap.draw();
    draw3dViewPort();
};

$(() => {
    LevelMap.init($('canvas#draw-grid'));
	// set scale values for drawing (make the grid size a little smaller)
	grid.w = LevelMap.CANVAS.width() / (grid.i + 2);
	grid.h = LevelMap.CANVAS.height() / (grid.j + 2);
	// Center the grid in the canvas so that we don't have half-lines on edges
	LevelMap.translate(grid.w * 1, grid.h * 1);

    // LevelMap editing
	$('input[name="draw-mode"]').on('click', e => {
		LevelMap.editMode = e.target.value;
		LevelMap.editType = e.target.getAttribute('data-type');
	});
	$canvas[0].addEventListener('mousemove', e => {
        LevelMap.mouseMoveHandler(e.offsetX, e.offsetY);
	}, false);
	$('canvas#draw-grid').on('click', (e) => {
		LevelMap.handleCanvasClick(e.offsetX, e.offsetY);
	})
	$('input[name=enable-edit]').on('click', e => {
		$('input[name=draw-mode]').prop('disabled', !e.target.checked);
	});
    $('input[name=draw-mode][value=wall]').click();
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
        }
        redraw();
    });
    redraw();
});
