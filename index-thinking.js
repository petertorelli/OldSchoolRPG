/*

How can this be described as a MVC?

The model is the set of:
- cells, which includes position, bounding edges, contents, 
  and relationships to other cells
- Behavior operators related to the party and the cells' attributes
- Look up tables for producing dynamic content

The view:
Several rendering planes:
- 2D top down omniscient design view
- 3D camera view
- Temporal / dynamic content view

The controller:
- The ~12 user keypresses
- The 

*/

// Globals: They make life easier
let $ctx;
let $canvas;

// Instead of using padding can we just do a translate
let grid = {
	i: 20,
	j: 20,
	w: 0,
	h: 0,
};

let Cursor = {
 	cell: {
 		i: undefined,
 		j: undefined,
 	},
 	edge: undefined,
};

let Session = {
	mode: undefined,
	type: undefined,
};

/*
 * For some reason 'this' is returning the root window and not
 * RenderPrimTable object?
 */
let RenderPrimTable = {
	basicLine: function (x1, y1, x2, y2) {
		$ctx.save();
		$ctx.strokeStyle = 'black';
		$ctx.lineWidth = 1;
		$ctx.beginPath();
		$ctx.moveTo(x1, y1);
		$ctx.lineTo(x2, y2);
	    $ctx.closePath();
		$ctx.stroke();
		$ctx.restore();
	},
	basicTriangle: function (x, y, r, rot) {
	    let cos1 = Math.cos(rot * Math.PI / 180.0);
	    let sin1 = Math.sin(rot * Math.PI / 180.0);
	    let cos2 = Math.cos((rot + 120.0) * Math.PI / 180.0);
	    let sin2 = Math.sin((rot + 120.0) * Math.PI / 180.0);
	    let cos3 = Math.cos((rot + 240.0) * Math.PI / 180.0);
	    let sin3 = Math.sin((rot + 240.0) * Math.PI / 180.0);
	    let [x1, y1] = [x + r * cos1, y + r * sin1];
	    let [x2, y2] = [x + r * cos2, y + r * sin2];
	    let [x3, y3] = [x + r * cos3, y + r * sin3];
	    $ctx.save();
		$ctx.strokeStyle = 'black';
		$ctx.lineWidth = 1;
	    $ctx.beginPath();
	    $ctx.moveTo(x1, y1);
	    $ctx.lineTo(x2, y2);
	    $ctx.lineTo(x3, y3);
	    $ctx.lineTo(x1, y1);
	    $ctx.closePath();
		$ctx.stroke();
	    $ctx.restore();
	},
	basicDoor: function (x1, y1, x2, y2, edge, isHidden) {
		$ctx.save();
		$ctx.lineWidth = 1;
		$ctx.fillStyle = isHidden ? 'lightgray' : 'white';
		$ctx.strokeStyle = isHidden ? 'lightgray' : 'black';
		let [midx, midy] = [(x1 + x2) / 2, (y1 + y2) / 2];
		let [dw, dh] = [7, 7];
		let dir = (edge === 's' || edge === 'e') ? -1 : 1;
		if (edge === 'w' || edge === 'e') {
			$ctx.fillRect(midx, midy - (dh/2), dw * dir * .6, dh);
			$ctx.strokeRect(midx, midy - (dh/2), dw * dir * .6, dh);
		} else if (edge === 'n' || edge === 's') {
			$ctx.fillRect(midx - (dw/2), midy, dw, dh * dir * .6);
			$ctx.strokeRect(midx - (dw/2), midy, dw, dh * dir * .6);
		}
		$ctx.restore();
		RenderPrimTable.basicLine(x1, y1, x2, y2);
	},
	'edge:wall': function (x1, y1, x2, y2, edge) {
		RenderPrimTable.basicLine(x1, y1, x2, y2);
	},
	'edge:door': function (x1, y1, x2, y2, edge) {
		RenderPrimTable.basicDoor(x1, y1, x2, y2, edge, false);
	},
	'edge:hiddendoor': function (x1, y1, x2, y2, edge) {
		RenderPrimTable.basicDoor(x1, y1, x2, y2, edge, true);
	},
	stairs: function (ulcx, ulcy, type) {
	    let rot = (type === 'up') ? 270 : 90;
    	let ox = ulcx + grid.w / 2;
    	// nudge the triangle up or down so it looks centered...
    	let oy = ulcy + grid.h * ((type === 'up') ? 0.57 : 0.43);
    	RenderPrimTable.basicTriangle(ox, oy, grid.h / 4, rot);
	},
};

// Return a reference to the (logical) cell's unique object
let _getCellReference = (i, j, k = 1) => {
	// TODO make a member function that comprehends dimensions
	return level[i + j * 20];
};

let _renderEdge = (x1, y1, x2, y2, edge, edgeType) => {
	// TODO Might be faster to store a reference to the render function too
	if (edgeType === undefined) {
		return;
	}
	let renderFunc = RenderPrimTable['edge:' + edgeType];
	if (renderFunc === undefined) {
		console.error(`_renderEdge: Edge type? ${edgeType}`);
		return;
	}
	renderFunc(x1, y1, x2, y2, edge);
};

let _renderCell = function (i, j) {
	// Translate grid coords to logical bounding box (only compute once)
	let [ulx, uly] = [i * grid.w, j * grid.h];
	let [lrx, lry] = [ulx + grid.w, uly + grid.h];
	let cell = _getCellReference(i, j);
	// Edge rendering is deterministic (no culling optimization here)
	_renderEdge(ulx, uly, lrx, uly, 'n', cell.edge.n);
	_renderEdge(lrx, uly, lrx, lry, 'e', cell.edge.e);
	_renderEdge(ulx, lry, lrx, lry, 's', cell.edge.s);
	_renderEdge(ulx, uly, ulx, lry, 'w', cell.edge.w);
	// Render cell contents
	if (cell.properties.stairs !== 'none') {
		RenderPrimTable.stairs(ulx, uly, cell.properties.stairs);
	}
	if (cell.properties.darkness) {
	}
	if (cell.properties.spinner) {
	}
};

let Party = {
    loc: {
        i: 0,
        j: 19,
    },
    facing: 'n',
    turnLeft: function () {
        this.facing = 
        	(this.facing === 'n' ? 'w' : 
        	(this.facing === 'w' ? 's' : 
        	(this.facing === 's' ? 'e' : 'n')));
    },
    turnRight: function () {
        this.facing = 
        	(this.facing === 'n' ? 'e' : 
        	(this.facing === 'e' ? 's' : 
        	(this.facing === 's' ? 'w' : 'n')));
    },
    advance: function () {
        if (this.facing === 'n') {
            if (! this.collisionCheck(this.facing)) {
                this.loc.j -= 1;
            }
        } else if (this.facing === 'e') {
            if (! this.collisionCheck(this.facing)) {
                this.loc.i += 1;
            }
        } else if (this.facing === 's') {
            if (! this.collisionCheck(this.facing)) {
                this.loc.j += 1;
            }
        } else {
            if (! this.collisionCheck(this.facing)) {
                this.loc.i -= 1;
            }
        }
        this.wrap();
    },
    wrap: function () {
        this.loc.i = (this.loc.i >= grid.i) ? 0 : this.loc.i;
        this.loc.j = (this.loc.j >= grid.j) ? 0 : this.loc.j;
        this.loc.i = (this.loc.i < 0) ? grid.i - 1 : this.loc.i;
        this.loc.j = (this.loc.j < 0) ? grid.j - 1 : this.loc.j;
    },
    collisionCheck: function () {
		let cell = _getCellReference(this.loc.i, this.loc.j);
		if (cell.edge[this.facing] !== undefined) {
			return 1;
		}
        return 0;
    }
};

let drawGrid = () => {
    $ctx.save();
    $ctx.beginPath();
    for (let i = 0; i <= grid.i; ++i) {
        let [x1, y1] = [i * grid.w, 0]
        let [x2, y2] = [i * grid.w, grid.h * grid.j];
        $ctx.moveTo(x1, y1);
        $ctx.lineTo(x2, y2);
    }
    for (let j = 0; j <= grid.j; ++j) {
        let [x1, y1] = [0, j * grid.h]
        let [x2, y2] = [grid.w * grid.i, j * grid.h];
        $ctx.moveTo(x1, y1);
        $ctx.lineTo(x2, y2);
    }
    $ctx.closePath();
    $ctx.strokeStyle = '#dddddd';
    $ctx.lineWidth = 1;
    $ctx.stroke();
    $ctx.restore();
};

let computeEdgeVertices = (ulcx, ulcy, mousex, mousey) => {
	// Determine the wall
	let x1, y1, x2, y2;
	// partial is the normalized location inside a grid square
	let [partialx, partialy] = [(mousex % grid.w) / grid.w, (mousey % grid.h) / grid.h];
	// the y=x and y=1-x lines define the N, E, S, W walls
	let [A, B] = [partialy > partialx, partialy > 1 - partialx];
	if (A && B) {
		// Bottom in UCS
		[x1, y1] = [ulcx, ulcy + grid.h];
		[x2, y2] = [ulcx + grid.w, ulcy + grid.h];
		wall = 's';
	} else if (!A & B) {
		// Right in UCS
		[x1, y1] = [ulcx + grid.w, ulcy];
		[x2, y2] = [ulcx + grid.w, ulcy + grid.h];
		wall = 'e';
	} else if (A & !B) {
		// Left in UCS
		[x1, y1] = [ulcx, ulcy];
		[x2, y2] = [ulcx, ulcy + grid.h];
		wall = 'w';
	} else {
		// Top in UCS
		[x1, y1] = [ulcx, ulcy];
		[x2, y2] = [ulcx + grid.w, ulcy];
		wall = 'n';
	}
	return {x1, y1, x2, y2, wall};
};

let drawParty = () => {
    let [ulcx, ulcy] = [Party.loc.i * grid.w, Party.loc.j * grid.h];
    ulcx += grid.w / 2;
    ulcy += grid.h / 2;
    $ctx.lineWidth = 1;
    $ctx.strokeStyle = 'red';
    $ctx.beginPath();
    $ctx.arc(ulcx, ulcy, grid.w / 4.0, grid.h / 4.0, 0, 2.0 * Math.PI, false);
    $ctx.closePath();
    $ctx.strokeStyle = 'red';
    $ctx.stroke();
    $ctx.beginPath();
    $ctx.moveTo(ulcx, ulcy);
    if (Party.facing === 'n') {
        $ctx.lineTo(ulcx, ulcy - grid.h / 4);
    } else if (Party.facing === 's') {
        $ctx.lineTo(ulcx, ulcy + grid.h / 4);
    } else if (Party.facing === 'e') {
        $ctx.lineTo(ulcx + grid.w / 4, ulcy);
    } else {
        $ctx.lineTo(ulcx - grid.w / 4, ulcy);
    }
    $ctx.closePath();
    $ctx.stroke();
};

let redraw = () => {
	$ctx.clearRect(-grid.w/2, -grid.h/2, $canvas.width(), $canvas.height());
	drawGrid();
    for (let j = 0; j < 20; ++j) {
    	for (let i = 0; i < 20; ++i) {
    		_renderCell(i, j);
    	}
    }
    drawParty();
};

/*
 * Expects x & y have been un-translated due to our previous 2D xlate
 */
let xy2ij = (x, y) => {
	return {
		i: Math.floor(x / grid.w) - 1, // TODO ???? -1 ???
		j: Math.floor(y / grid.h) - 1, // related to xlate?
	};
};

/*
 * Draws a cell and closest-edge cursor at the current cell.
 */
let mouseMoveHandler = (mousex, mousey) => {
	redraw();
	// Re-translate mouse to match coord system
	mousex += grid.w / 2;
	mousey += grid.h / 2;
	// Translate mouse to cell
	let cell = xy2ij(mousex, mousey);
	if (cell.i < 0 || cell.j < 0 || cell.i >= grid.i || cell.j >= grid.j) {
		return;
	}
	// Determine the upper-left corner x,y coordinates for the cell.
	let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
	$ctx.save();
	$ctx.globalAlpha = 0.25;
	$ctx.fillStyle = 'grey';
	$ctx.fillRect(ulcx, ulcy, grid.w, grid.h);
	let edge = computeEdgeVertices(ulcx, ulcy, mousex, mousey);
	if (Session.type === 'edge') {
		$ctx.beginPath();
		$ctx.moveTo(edge.x1, edge.y1);
		$ctx.lineTo(edge.x2, edge.y2);
		$ctx.strokeStyle = 'blue';
		$ctx.lineWidth = 5;
		$ctx.stroke();
	}
	$ctx.restore();
	// Save current position so we don't have to recalc on click
	Cursor.cell.i = cell.i;
	Cursor.cell.j = cell.j;
	Cursor.edge = edge.wall;
};

let continuityChecks = () => {
	// #1 Make opposite cell's wall match current edge!
};

let handleCanvasClick = () => {
	console.log(Cursor.cell.i, Cursor.cell.j, Cursor.edge, Session.mode);
	let cell = _getCellReference(Cursor.cell.i, Cursor.cell.j);
	if (Session.type === 'edge') {
		if (cell.edge[Cursor.edge] === Session.mode) {
			cell.edge[Cursor.edge] = undefined;
		} else {
			cell.edge[Cursor.edge] = Session.mode;
		}
	} else if (Session.type === 'cell') {
		if (Session.mode === 'stairs') {
			if (cell.properties.stairs === 'none') {
				cell.properties.stairs = 'up';
			} else if (cell.properties.stairs === 'up') {
				cell.properties.stairs = 'down';
			} else {
				cell.properties.stairs = 'none';
			}
		} else {
			cell.properties[Session.mode] = ! cell.properties[Session.mode];
		}
	}
	continuityChecks();
	redraw();
};

let printJson = () => {
	let state = JSON.stringify(Session.state);
	console.log(state);
};

let loadJson = (state) => {
	Session.state = JSON.parse(state);
	redraw();
};

$(() => {
	$canvas = $('canvas#draw-grid');
	$ctx = $canvas[0].getContext('2d');
	// set scale values for drawing (make the grid size a little smaller)
	grid.w = $canvas.width() / (grid.i + 2);
	grid.h = $canvas.height() / (grid.j + 2);
	// Center the grid in the canvas so that we don't have half-lines on edges
	$ctx.translate(grid.w / 2, grid.h / 2);
	// Draw mode select
	$('input[name="draw-mode"]').on('click', e => {
		Session.mode = e.target.value;
		Session.type = e.target.getAttribute('data-type');
	});
 	$('input[name=draw-mode][value=wall]').click();
	// Mouse move colorization
	$canvas[0].addEventListener('mousemove', e => {
        mouseMoveHandler(e.offsetX, e.offsetY);
	}, false);
	// Canvas click
	$('canvas#draw-grid').on('click', (e) => {
		handleCanvasClick(e.offsetX, e.offsetY);
	})
    // The controller... that's really it!
    $('body').keydown((e) => {
        if (e.which === 37) { // left turn
            Party.turnLeft();
        } else if (e.which === 38) { // up is forward
            Party.advance();
        } else if (e.which === 39) { // right turn
            Party.turnRight();
        } else if (e.which === 40) { // down
        }
        redraw();
    });
    redraw();
});
