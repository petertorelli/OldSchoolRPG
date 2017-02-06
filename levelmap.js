
let $ctx;
let $canvas;

// Mouse cursor
const Cursor = {
 	cell: {
 		i: undefined,
 		j: undefined,
 	},
 	edge: undefined,
};

const continuityChecks = () => {
	// #1 Make opposite cell's wall match current edge!
	// Wall, Door, Hidden Door
	/*    Adjacent cell sharing edge
	 *    W D h E
	 *  W b b b W
	 *  D k k k W
	 *  h k k k W
	 *  E W W W e
	 * ^-- this cell
	 * b = do nothing; logic blocked, can't pass
	 * W = add wall
	 * k = do nothing; logic kick
	 */
	let oi, oj, oe;
	if (Cursor.edge === 'n') {
		oi = Cursor.cell.i + 0;
		oj = Cursor.cell.j - 1;
		oe = 's';
	} else if (Cursor.edge ==='s') {
		oi = Cursor.cell.i + 0;
		oj = Cursor.cell.j + 1;
		oe = 'n';
	} else if (Cursor.edge === 'e') {
		oi = Cursor.cell.i + 1;
		oj = Cursor.cell.j + 0;
		oe = 'w';
	} else { // w
		oi = Cursor.cell.i - 1;
		oj = Cursor.cell.j + 0;
		oe = 'e';
	}
	[oi, oj] = gridWrap(oi, oj);
	let cell = _getCellReference(Cursor.cell.i, Cursor.cell.j);
	let ocell = _getCellReference(oi, oj);
	if (cell.edge[Cursor.edge] === undefined) {
		ocell.edge[oe] = undefined;
	} else {
		if (ocell.edge[oe] === undefined) {
			ocell.edge[oe] = 'wall';
		}
	}
};



/*
 * For some reason 'this' is returning the root window and not
 * RenderPrimTable object? ...duh... let deliberately acts this way
 */
const RenderPrimTable = {
	CONTEXT: undefined,
	basicLine: function (x1, y1, x2, y2) {
		this.CONTEXT.save();
		this.CONTEXT.strokeStyle = 'black';
		this.CONTEXT.lineWidth = 1;
		this.CONTEXT.beginPath();
		this.CONTEXT.moveTo(x1, y1);
		this.CONTEXT.lineTo(x2, y2);
	    this.CONTEXT.closePath();
		this.CONTEXT.stroke();
		this.CONTEXT.restore();
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
	    this.CONTEXT.save();
		this.CONTEXT.strokeStyle = 'black';
		this.CONTEXT.lineWidth = 1;
	    this.CONTEXT.beginPath();
	    this.CONTEXT.moveTo(x1, y1);
	    this.CONTEXT.lineTo(x2, y2);
	    this.CONTEXT.lineTo(x3, y3);
	    this.CONTEXT.lineTo(x1, y1);
	    this.CONTEXT.closePath();
		this.CONTEXT.stroke();
	    this.CONTEXT.restore();
	},
	basicDoor: function (x1, y1, x2, y2, edge, isHidden) {
		this.CONTEXT.save();
		this.CONTEXT.lineWidth = 1;
		this.CONTEXT.fillStyle = isHidden ? 'lightgray' : 'white';
		this.CONTEXT.strokeStyle = isHidden ? 'lightgray' : 'black';
		let [midx, midy] = [(x1 + x2) / 2, (y1 + y2) / 2];
		let [dw, dh] = [7, 7];
		let dir = (edge === 's' || edge === 'e') ? -1 : 1;
		if (edge === 'w' || edge === 'e') {
			this.CONTEXT.fillRect(midx, midy - (dh/2), dw * dir * .6, dh);
			this.CONTEXT.strokeRect(midx, midy - (dh/2), dw * dir * .6, dh);
		} else if (edge === 'n' || edge === 's') {
			this.CONTEXT.fillRect(midx - (dw/2), midy, dw, dh * dir * .6);
			this.CONTEXT.strokeRect(midx - (dw/2), midy, dw, dh * dir * .6);
		}
		this.CONTEXT.restore();
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
	party: function (cell) {
        let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
        ulcx += grid.w / 2;
        ulcy += grid.h / 2;
        this.CONTEXT.lineWidth = 1;
        this.CONTEXT.strokeStyle = 'red';
        this.CONTEXT.beginPath();
        this.CONTEXT.arc(ulcx, ulcy, grid.w / 4.0, grid.h / 4.0, 0, 2.0 * Math.PI, false);
        this.CONTEXT.closePath();
        this.CONTEXT.strokeStyle = 'red';
        this.CONTEXT.stroke();
        this.CONTEXT.beginPath();
        this.CONTEXT.moveTo(ulcx, ulcy);
        if (Party.facing === 'n') {
            this.CONTEXT.lineTo(ulcx, ulcy - grid.h / 4);
        } else if (Party.facing === 's') {
            this.CONTEXT.lineTo(ulcx, ulcy + grid.h / 4);
        } else if (Party.facing === 'e') {
            this.CONTEXT.lineTo(ulcx + grid.w / 4, ulcy);
        } else {
            this.CONTEXT.lineTo(ulcx - grid.w / 4, ulcy);
        }
        this.CONTEXT.closePath();
        this.CONTEXT.stroke();
	},
};



const _renderEdge = (x1, y1, x2, y2, edge, edgeType) => {
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

const _renderCell = (i, j) => {
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





const computeEdgeVertices = (ulcx, ulcy, mousex, mousey) => {
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



const shadeCell = (cell, color) => {
	let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
	$ctx.save();
	$ctx.globalAlpha = 0.25;
	$ctx.fillStyle = color;
	$ctx.fillRect(ulcx, ulcy, grid.w, grid.h);
	$ctx.restore();
};

const handleCanvasClick = () => {
	if ($('input[name=enable-edit]').prop('checked') === false) {
		return;
	}
	let cell = _getCellReference(Cursor.cell.i, Cursor.cell.j);
	if (Session.type === 'edge') {
		// If mode is what is on the edge, remove it
		if (cell.edge[Cursor.edge] === Session.mode) {
			cell.edge[Cursor.edge] = undefined;
		}
		// Otherwise add it 
		else {
			cell.edge[Cursor.edge] = Session.mode;
		}
		// Continuity check wall & cell edits
		continuityChecks();
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

const LevelMap = {
	init: function (canvas) {
		this.CANVAS = canvas;
		this.CONTEXT = this.CANVAS[0].getContext('2d');
		$ctx = this.CONTEXT;
		$canvas = canvas;
		RenderPrimTable.CONTEXT = this.CONTEXT;
	},
	translate: function (x, y) {
		this.CONTEXT.translate(x, y);
	},
	draw: function () {
		this.CONTEXT.clearRect(-grid.w/2, -grid.h/2, this.CANVAS.width(), this.CANVAS.height());
		this.drawGrid();
	    for (let j = 0; j < 20; ++j) {
	    	for (let i = 0; i < 20; ++i) {
	    		_renderCell(i, j);
	    	}
	    }
	    RenderPrimTable.party(Party.loc);
	},
	/*
	 * Draws a cell and closest-edge cursor at the current cell.
	 */
	mouseMoveHandler: function (mousex, mousey) {
		redraw();
		// Re-translate mouse to match coord system
		//mousex += grid.w ;
		//mousey += grid.h ;
		// Translate mouse to cell
		let cell = { 
			i : (Math.floor(mousex / grid.w) - 1), 
			j : (Math.floor(mousey / grid.h) - 1)
		};
		if (cell.i < 0 || cell.j < 0 || cell.i >= grid.i || cell.j >= grid.j) {
			return;
		}
		// Determine the upper-left corner x,y coordinates for the cell.
		shadeCell(cell, $('input[name=enable-edit]').prop('checked') ? 'blue' : 'grey');
		let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
		let edge = computeEdgeVertices(ulcx, ulcy, mousex, mousey);
		if (Session.type === 'edge') {
			this.CONTEXT.save();
			this.CONTEXT.beginPath();
			this.CONTEXT.moveTo(edge.x1, edge.y1);
			this.CONTEXT.lineTo(edge.x2, edge.y2);
			this.CONTEXT.globalAlpha = .7;
			this.CONTEXT.strokeStyle = $('input[name=enable-edit]').prop('checked') ? 'red' : 'grey';
			this.CONTEXT.lineWidth = 5;
			this.CONTEXT.stroke();
			this.CONTEXT.restore();
		}
		// Save current position so we don't have to recalc on click
		Cursor.cell.i = cell.i;
		Cursor.cell.j = cell.j;
		Cursor.edge = edge.wall;
	},
	drawGrid: function () {
	    this.CONTEXT.save();
	    this.CONTEXT.beginPath();
	    for (let i = 0; i <= grid.i; ++i) {
	        let [x1, y1] = [i * grid.w, 0]
	        let [x2, y2] = [i * grid.w, grid.h * grid.j];
	        this.CONTEXT.moveTo(x1, y1);
	        this.CONTEXT.lineTo(x2, y2);
	    }
	    for (let j = 0; j <= grid.j; ++j) {
	        let [x1, y1] = [0, j * grid.h]
	        let [x2, y2] = [grid.w * grid.i, j * grid.h];
	        this.CONTEXT.moveTo(x1, y1);
	        this.CONTEXT.lineTo(x2, y2);
	    }
	    this.CONTEXT.closePath();
	    this.CONTEXT.strokeStyle = '#dddddd';
	    this.CONTEXT.lineWidth = 1;
	    this.CONTEXT.stroke();
	    this.CONTEXT.restore();
	},
};


