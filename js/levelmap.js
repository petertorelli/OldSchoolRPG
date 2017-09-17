/**
 * Draws the top-down map & handles canvas editing. We use an HTML CANVAS
 * as the 2D surface.
 */

/**
 * The user mouse points to a cell and to the nearest edge of the cell.
 * Edge is a direction, 'n', 's', 'e' or 'w'.
 */
const Cursor = {
 	cellCoords: {
 		i: undefined,
 		j: undefined,
 	},
 	edge: undefined,
};

// This seems kinda pointless, it would be easier if each cell had no
// dependencies.
const continuityChecks = (currentCell) => {
	// #1 Make opposite cell's wall match current edge!
	// ------------------------------------------------
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
	if (currentCell.edge === 'n') {
		oi = currentCell.cellCoords.i + 0;
		oj = currentCell.cellCoords.j - 1;
		oe = 's';
	} else if (currentCell.edge ==='s') {
		oi = currentCell.cellCoords.i + 0;
		oj = currentCell.cellCoords.j + 1;
		oe = 'n';
	} else if (currentCell.edge === 'e') {
		oi = currentCell.cellCoords.i + 1;
		oj = currentCell.cellCoords.j + 0;
		oe = 'w';
	} else { // w
		oi = currentCell.cellCoords.i - 1;
		oj = currentCell.cellCoords.j + 0;
		oe = 'e';
	}
	[oi, oj] = gridWrap(oi, oj);
	let cell = _getCellReference(currentCell.cellCoords.i, currentCell.cellCoords.j);
	let ocell = _getCellReference(oi, oj);
	if (cell.edge[currentCell.edge] === undefined) {
		ocell.edge[oe] = undefined;
	} else {
		if (ocell.edge[oe] === undefined) {
			ocell.edge[oe] = 'wall';
		}
	}

	// #2... There is no check #2
};

/**
 * Here's a list of generic things to draw...
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
	teleportArrow: function (x1, y1, x2, y2) {
        let radians = Math.atan((y2 - y1) / (x2 - x1));
        radians += ((x2 > x1) ? 90 : -90) * Math.PI / 180;
        this.CONTEXT.save();
		this.CONTEXT.lineWidth = 2;
		this.CONTEXT.strokeStyle = 'dodgerblue';
		this.CONTEXT.fillStyle = 'dodgerblue';
		this.CONTEXT.globalAlpha = 0.5;
        this.CONTEXT.beginPath();
        this.CONTEXT.moveTo(x1, y1);
        this.CONTEXT.lineTo(x2, y2);
        this.CONTEXT.stroke();
        this.CONTEXT.beginPath();
        this.CONTEXT.translate(x2, y2);
        this.CONTEXT.rotate(radians);
        this.CONTEXT.moveTo(0,0);
        this.CONTEXT.lineTo(5,20);
        this.CONTEXT.lineTo(-5,20);
        this.CONTEXT.closePath();
        this.CONTEXT.fill();
        this.CONTEXT.restore();
	},
	basicX: function (x, y, r) {
	    this.CONTEXT.save();
		this.CONTEXT.strokeStyle = 'black';
		this.CONTEXT.lineWidth = 1;
	    this.CONTEXT.beginPath();
	    this.CONTEXT.moveTo(x - r, y - r);
	    this.CONTEXT.lineTo(x + r, y + r);
	    this.CONTEXT.moveTo(x - r, y + r);
	    this.CONTEXT.lineTo(x + r, y - r);
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
	teleportEditStart: function (cellCoords) {
        let [ox, oy] = [cellCoords.i * grid.w, cellCoords.j * grid.h];
        ox += grid.w / 2;
        oy += grid.h / 2;
        this.basicX(ox, oy, grid.w * .75)		
	},
	stairs: function (ulcx, ulcy, type) {
	    let rot = (type === 'up') ? 270 : 90;
    	let ox = ulcx + grid.w / 2;
    	// nudge the triangle up or down so it looks centered...
    	let oy = ulcy + grid.h * ((type === 'up') ? 0.57 : 0.43);
    	RenderPrimTable.basicTriangle(ox, oy, grid.h / 4, rot);
	},
	party: function (cellCoords) {
        let [ulcx, ulcy] = [cellCoords.i * grid.w, cellCoords.j * grid.h];
        ulcx += grid.w / 2;
        ulcy += grid.h / 2;
        this.CONTEXT.lineWidth = 1;
        let rx = grid.w * .5;
        let ry = grid.h * .5;
        this.CONTEXT.strokeStyle = 'red';
        this.CONTEXT.strokeRect(ulcx - 0.5 * rx, ulcy - 0.5 * ry, rx, ry);;
        this.CONTEXT.beginPath();
        this.CONTEXT.moveTo(ulcx, ulcy);
        // "Party-facing" indicator
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

/**
 * Given a mouse coordiate, determine the absolute screen coordinates on the 
 * for the nearest edge, and a text character describing what direction wall 
 * the edge describes (nsew).
 */
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

/**
 * This object draws the tops-down map, but also handles editing as well, but
 * only if the controller function connects a canvas mouse callback.
 */
const LevelMap = {
	// 'edge' or 'cell' editing
	editType: undefined,
	// 'edge' or 'wall'
	editEntity: undefined,
	userIsEditing: false,
	// teleport connectors
	userIsInTwoPart: false,
	teleportStartPoint: { i: undefined, j: undefined, },
	teleportStartCell: undefined,
	init: function (canvas) {
		this.CANVAS = canvas;
		this.CONTEXT = this.CANVAS[0].getContext('2d');
		RenderPrimTable.CONTEXT = this.CONTEXT;
	},
	translate: function (x, y) {
		this.CONTEXT.translate(x, y);
	},
	drawEdge: function (x1, y1, x2, y2, edge, edgeType) {
		// TODO Might be faster to store a reference to the draw function too
		if (edgeType === undefined) {
			return;
		}
		let drawFunc = RenderPrimTable['edge:' + edgeType];
		if (drawFunc === undefined) {
			console.error(`drawEdge: Edge type? ${edgeType}`);
			return;
		}
		drawFunc(x1, y1, x2, y2, edge);
	},

	shadeCell: function (cellCoords, color) {
		let [ulcx, ulcy] = [cellCoords.i * grid.w, cellCoords.j * grid.h];
		this.CONTEXT.save();
		this.CONTEXT.globalAlpha = 0.25;
		this.CONTEXT.fillStyle = color;
		this.CONTEXT.fillRect(ulcx, ulcy, grid.w, grid.h);
		this.CONTEXT.restore();
	},

	/**
	 * Draws a cell and closest-edge cursor at the current cell.
	 */
	mouseMoveHandler: function (mousex, mousey) {
		redraw();
		// Re-translate mouse to match coord system
		//mousex += grid.w ;
		//mousey += grid.h ;
		// Translate mouse to cell
		let coords = { 
			i : (Math.floor(mousex / grid.w) - 1), 
			j : (Math.floor(mousey / grid.h) - 1)
		};
		if (coords.i < 0 || coords.j < 0 || coords.i >= grid.i || coords.j >= grid.j) {
			return;
		}
		// Determine the upper-left corner x,y coordinates for the cell.
		this.shadeCell(coords, this.userIsEditing ? 'red' : 'grey');
		let [ulcx, ulcy] = [coords.i * grid.w, coords.j * grid.h];
		let edge = computeEdgeVertices(ulcx, ulcy, mousex, mousey);
		if (this.editType === 'edge') {
			this.CONTEXT.save();
			this.CONTEXT.beginPath();
			this.CONTEXT.moveTo(edge.x1, edge.y1);
			this.CONTEXT.lineTo(edge.x2, edge.y2);
			this.CONTEXT.globalAlpha = .7;
			this.CONTEXT.strokeStyle = this.userIsEditing ? 'red' : 'grey';
			this.CONTEXT.lineWidth = 5;
			this.CONTEXT.stroke();
			this.CONTEXT.restore();
		}
		if (this.editEntity === 'teleport') {
			this.userIsInTwoPart = true;
			RenderPrimTable.teleportEditStart(coords);
			if (this.teleportStartPoint.i !== undefined) {
				let [ox, oy] = [this.teleportStartPoint.i * grid.w + grid.w / 2, 
								this.teleportStartPoint.j * grid.h + grid.h / 2];
				let [px, py] = [ulcx + grid.w / 2, ulcy + grid.h / 2];
				RenderPrimTable.teleportArrow(ox, oy, px, py);
			}
		}
		// Save current position so we don't have to recalc on click
		Cursor.cellCoords.i = coords.i;
		Cursor.cellCoords.j = coords.j;
		Cursor.edge = edge.wall;
	},

	/**
	 * Canvas clicks are only used for editing. This code cycles through the
	 * logical operations of a click based on the editing mode and editing 
	 * entity.
	 */
	handleCanvasClick: function () {
		if (! this.userIsEditing) {
			return;
		}
		let cell = _getCellReference(Cursor.cellCoords.i, Cursor.cellCoords.j);
		if (cell == undefined) 
			return;
		if (this.editType === 'edge') {
			// If mode is what is on the edge, remove it
			if (cell.edge[Cursor.edge] === this.editEntity) {
				cell.edge[Cursor.edge] = undefined;
			}
			// Otherwise add it 
			else {
				cell.edge[Cursor.edge] = this.editEntity;
			}
			// Continuity check wall & cell edits
			continuityChecks(Cursor);
		} else if (this.editType === 'cell') {
			if (this.editEntity === 'stairs') {
				if (cell.properties.stairs === 'none') {
					cell.properties.stairs = 'up';
				} else if (cell.properties.stairs === 'up') {
					cell.properties.stairs = 'down';
				} else {
					cell.properties.stairs = 'none';
				}
			} else if (this.editEntity === 'darkness') {
				cell.properties.darkness = ! cell.properties.darkness;
			} else if (this.editEntity === 'teleport') {
				if (this.teleportStartPoint.i === undefined) {
					this.teleportStartPoint.i = Cursor.cellCoords.i;
					this.teleportStartPoint.j = Cursor.cellCoords.j;
					this.teleportStartCell = cell;
					// Erase if there is an arrow here already
					if (cell.properties.teleportTo !== undefined) {
						cell.properties.teleportTo = undefined;
					}
				} else {
					// clicked and we have point 1 already
					if (Cursor.cellCoords.i == this.teleportStartPoint.i &&
						Cursor.cellCoords.j == this.teleportStartPoint.j) {
						// same point, do nothing
					} else {
						let cellRef = _getCellReference(
							this.teleportStartPoint.i,
							this.teleportStartPoint.j,
						);
						if (cellRef.properties.teleportTo === undefined) {
							cellRef.properties.teleportTo = {
								i: Cursor.cellCoords.i,
								j: Cursor.cellCoords.j,
							}
						}
					}
					this.teleportStartPoint.i = undefined;
					this.teleportStartPoint.j = undefined;
					this.teleportStartCell = undefined;
				}
			}
		}
		continuityChecks(Cursor);
		redraw();

		// Trigger a rebuild of the 3D!
		viewportWebGlInit();
	},
	escapeHit: function () {
		// if the user hits ESC, that disables any two-part editing commands
		this.userIsInTwoPart = false;
		this.teleportStartPoint.i = undefined;
		this.teleportStartPoint.j = undefined;
		this.teleportStartCell = undefined;
	},

	/**
	 * Given the [i, j] coordinate of the grid, see if there is a cell for that
	 * coordinate in the level map, and render it.
	 */
	drawCell: function (i, j) {
		// Translate grid coords to logical bounding box (only compute once)
		let [ulx, uly] = [i * grid.w, j * grid.h];
		let [lrx, lry] = [ulx + grid.w, uly + grid.h];
		let cell = _getCellReference(i, j);
		if (cell == undefined) {
			return;
		}
		// Edge drawing is deterministic (no culling optimization here)
		this.drawEdge(ulx, uly, lrx, uly, 'n', cell.edge.n);
		this.drawEdge(lrx, uly, lrx, lry, 'e', cell.edge.e);
		this.drawEdge(ulx, lry, lrx, lry, 's', cell.edge.s);
		this.drawEdge(ulx, uly, ulx, lry, 'w', cell.edge.w);
		// Render cell contents
		if (cell.properties.stairs !== 'none') {
			RenderPrimTable.stairs(ulx, uly, cell.properties.stairs);
		}
		if (cell.properties.darkness) {
			this.shadeCell({i, j}, 'gray');
		}
		if (cell.properties.spinner) {
		}
		if (cell.properties.teleportTo) {
			RenderPrimTable.teleportArrow(
				ulx + grid.w / 2,
				uly + grid.h / 2,
				cell.properties.teleportTo.i * grid.w + grid.w / 2,
				cell.properties.teleportTo.j * grid.h + grid.h / 2,
			);
		}
	},

	/**
	 * Draws a light-grey grid represengting the editable regions of the level.
	 */
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

	/**
	 * The top-level draw function. Draws the level on to the grid cell by cell.
	 */
	draw: function () {
		// 1. Clear
		this.CONTEXT.clearRect(
			// TODO: Explain translation here?
			-0.5 * grid.w,
			-0.5 * grid.h,
			this.CANVAS.width(),
			this.CANVAS.height()
		);
		// 2. Grid
		this.drawGrid();
		// 3. Level
	    for (let j = 0; j < grid.j; ++j) {
	    	for (let i = 0; i < grid.i; ++i) {
	    		this.drawCell(i, j);
	    	}
	    }
	    // 4. Party
	    RenderPrimTable.party(Party.loc);
	},
};


