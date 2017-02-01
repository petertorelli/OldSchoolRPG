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

var currentLevel = LEVEL_ONE;;

let viewDepth = 3; // don't read this from the form it can be 0 sometimes

// Instead of using padding can we just do a translate
const grid = {
	i: 20,
	j: 20,
	w: 0,
	h: 0,
};

const Cursor = {
 	cell: {
 		i: undefined,
 		j: undefined,
 	},
 	edge: undefined,
};

const Session = {
	mode: undefined,
	type: undefined,
};

/*
 * For some reason 'this' is returning the root window and not
 * RenderPrimTable object? ...duh... let deliberately acts this way
 */
const RenderPrimTable = {
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
const _getCellReference = (i, j, k = 1) => {
	// TODO make a member function that comprehends dimensions
	return currentLevel[i + j * (grid.i)];
	//return level[i + j * 20];
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

/**
 * Give an [i, j] coordinate and wrap it if exceeds grid dimensions
 */
const gridWrap = (i, j) => {
    return [divMod(i, grid.i), divMod(j, grid.j)];
};

const Party = {
    loc: {
        i: 9,
        j: 9,
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
    forwardMovement: function (collisionCheckFuncton) {
        if (this.facing === 'n') {
            if (! collisionCheckFuncton(this.facing)) {
                this.loc.j -= 1;
            }
        } else if (this.facing === 'e') {
            if (! collisionCheckFuncton(this.facing)) {
                this.loc.i += 1;
            }
        } else if (this.facing === 's') {
            if (! collisionCheckFuncton(this.facing)) {
                this.loc.j += 1;
            }
        } else {
            if (! collisionCheckFuncton(this.facing)) {
                this.loc.i -= 1;
            }
        }
        [this.loc.i, this.loc.j] = gridWrap(this.loc.i, this.loc.j);
    },
    advance: function () {
    	this.forwardMovement(() => {
			let cell = _getCellReference(this.loc.i, this.loc.j);
			return (cell.edge[this.facing] !== undefined);
    	});
    },
    bash: function () {
    	this.forwardMovement(() => {
			let cell = _getCellReference(this.loc.i, this.loc.j);
			return !(cell.edge[this.facing] === 'door' || 
					 cell.edge[this.facing] === 'hiddendoor' ||
					 cell.edge[this.facing] === undefined);
    	});
    },
};

const drawGrid = () => {
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

const drawParty = () => {
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

/**
 * The most we are ever going to see is a frustum of size:
 *
 *    xxxxxxx
 *     xxxxx
 *      xxx
 *       P
 *
 * Left wall, right wall, front wall... That's it
 */

const moveToPct = ($canvas, $context, xpct, ypct) => {
	$context.moveTo($canvas.width() * xpct, $canvas.height() * ypct);
};

const lineToPct = ($canvas, $context, xpct, ypct) => {
	$context.lineTo($canvas.width() * xpct, $canvas.height() * ypct);
};

const divMod = (n, d) => {
	return n - d * Math.floor(n / d);
};

const findCoordsOfDepthFromParty = (depth) => {
	if (depth === 0) {
		return [[[Party.loc.i, Party.loc.j]]];
	}
	// oh so recursive
	// move +depth ahead and enumerate depth/2 left and right into an array
	// then recurse with depth - 1
	// the # of cells returned is 2 * depth - 1
	// return them as an array of pairs
	let [newi, newj] = [Party.loc.i, Party.loc.j];
	let result = [];
	if (Party.facing === 'n') {
		newj = divMod(Party.loc.j - depth, grid.j);
		for (let i = Party.loc.i - depth; i <= Party.loc.i + depth; ++i) {
			newi = divMod(i, grid.i);
			result.push([newi, newj]);
		}
	} else if (Party.facing === 'e') {
		newi = divMod(Party.loc.i + depth, grid.i);
		for (let j = Party.loc.j - depth; j <= Party.loc.j + depth; ++j) {
			newj = divMod(j, grid.j);
			result.push([newi, newj]);
		}
	} else if (Party.facing === 's') {
		newj = divMod(Party.loc.j + depth, grid.j);
		for (let i = Party.loc.i + depth; i >= Party.loc.i - depth; --i) {
			newi = divMod(i, grid.i);
			result.push([newi, newj]);
		}
	} else { // w
		newi = divMod(Party.loc.i - depth, grid.i);
		for (let j = Party.loc.j + depth; j >= Party.loc.j - depth; --j) {
			newj = divMod(j, grid.j);
			result.push([newi, newj]);
		}
	}

	let child = findCoordsOfDepthFromParty(depth - 1);
	child.push(result);
	return child;;
};

const findVizTriad = (start, facing) => {
	let result = [];
	if (facing === 'n') {
		j = divMod(start.j - 1, grid.j);
		for (let i = start.i - 1; i <= start.i + 1; ++i) {
			result.push({i: divMod(i, grid.i), j});
		}
	} else if (facing === 's') {
		j = divMod(start.j + 1, grid.j);
		for (let i = start.i + 1; i >= start.i - 1; --i) {
			result.push({i: divMod(i, grid.i), j});
		}
	} else if (facing === 'e') {
		i = divMod(start.i + 1, grid.i);
		for (let j = start.j - 1; j <= start.j + 1; ++j) {
			result.push({i, j: divMod(j, grid.j)});
		}
	} else {
		i = divMod(start.i - 1, grid.i);
		for (let j = start.j + 1; j >= start.j - 1; --j) {
			result.push({i, j: divMod(j, grid.j)});
		}
	}
	return result;
};

const nsew2fbrl = {
	n: { f: 'n', b: 's', r: 'e', l: 'w' },
	s: { f: 's', b: 'n', r: 'w', l: 'e' },
	e: { f: 'e', b: 'w', r: 's', l: 'n' },
	w: { f: 'w', b: 'e', r: 'n', l: 's' }
};

// recursively descend triads for occlusion
//
//    P          C
//   111   -->  R
//  22222      RCL 
const culledPartyVizFrustum = (start, facing, depth) => {
	if (depth === 0) {
		return;
	}
	let [ L, C, R ] = findVizTriad(start, facing);
	// cardinal directions now become Left, Center, Right visibility
	// Do we go left? only if the left-cell has no right-wall
	// Do we go forward? only if the center cell has no nearest wall
	// Do we go right? only if the right-cell has no left-wall
	let lc, cc, rc;

	// Can we see into the LEFT cell?
	lc = _getCellReference(L.i, L.j);
	cc = _getCellReference(C.i, C.j);
	rc = _getCellReference(R.i, R.j);
	sc = _getCellReference(start.i, start.j);


	if (!(
			(
				lc.edge[nsew2fbrl[facing]['r']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['l']] !== undefined
			) ||
			(
				sc.edge[nsew2fbrl[facing]['f']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['l']] !== undefined
			) ||
			(
				lc.edge[nsew2fbrl[facing]['b']] !== undefined &&
				lc.edge[nsew2fbrl[facing]['r']] !== undefined
			) ||
			(
				lc.edge[nsew2fbrl[facing]['b']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['f']] !== undefined
			)
		))
	{
		shadeCell(L, 'red');
		culledPartyVizFrustum(L, facing, depth - 1);
	}

	if (!(
			(
				cc.edge[nsew2fbrl[facing]['b']] !== undefined
			)
		))
	{
		shadeCell(C, 'green');
		culledPartyVizFrustum(C, facing, depth - 1);		
	}

	if (!(
			(
				rc.edge[nsew2fbrl[facing]['l']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['r']] !== undefined
			) ||
			(
				sc.edge[nsew2fbrl[facing]['f']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['r']] !== undefined
			) ||
			(
				rc.edge[nsew2fbrl[facing]['b']] !== undefined &&
				rc.edge[nsew2fbrl[facing]['l']] !== undefined
			) ||
			(
				rc.edge[nsew2fbrl[facing]['b']] !== undefined &&
				sc.edge[nsew2fbrl[facing]['f']] !== undefined
			)
		))
	{
		shadeCell(R, 'blue');
		culledPartyVizFrustum(R, facing, depth - 1);
	}
};

const draw3dViewPort = () => {

	let frustum = findCoordsOfDepthFromParty(1);
	frustum.forEach(a1 => {
		a1.forEach(a2 => {
			shadeCell({i: a2[0], j: a2[1]}, 'orange')
		});
	});
	/*
	let cull = culledPartyVizFrustum(Party.loc, Party.facing, viewDepth);
	*/
	let $vp = $('canvas#viewport');
	let $x = $vp[0].getContext('2d');

	$x.save();
	$x.fillStyle = "#222";
	$x.fillRect(0, 0, $vp.width(), $vp.height());
	$x.strokeStyle = "lightgreen";
	$x.lineJoin = 'bevel';
	$x.lineWidth = 2;

	// frustum[1] = [ L1[i,j], C1[i,j], R1[i,j] ]
	// frustum[0] = [          C0[i,j]          ]

	let L, C, R, P;
	// What do we see one look ahead?
	C0 = _getCellReference(frustum[0][0][0], frustum[0][0][1]);
	L1 = _getCellReference(frustum[1][0][0], frustum[1][0][1]);
	C1 = _getCellReference(frustum[1][1][0], frustum[1][1][1]);
	R1 = _getCellReference(frustum[1][2][0], frustum[1][2][1]);

	let xlt = nsew2fbrl[Party.facing];

	if (C0.edge[xlt.l] === undefined) {
		// sees L1.f
		if (L1.edge[xlt.b] === undefined) {
		} else {
			$x.beginPath();
			moveToPct($vp, $x, 0/8, 1/8);
			lineToPct($vp, $x, 1/8, 1/8);
			lineToPct($vp, $x, 1/8, 7/8);
			lineToPct($vp, $x, 0/8, 7/8);
			$x.stroke();
		}
	} else {
		$x.beginPath();
		moveToPct($vp, $x, 0/8, 0/8);
		lineToPct($vp, $x, 1/8, 1/8);
		lineToPct($vp, $x, 1/8, 7/8);
		lineToPct($vp, $x, 0/8, 8/8);
		$x.stroke();
	}

	if (C0.edge[xlt.f] === undefined) {
		// sees L1.r, C1.f, R1.l
		if (L1.edge[xlt.r] === undefined) {
		} else {
			$x.beginPath();
			moveToPct($vp, $x, 1.0/8, 1.0/8);
			lineToPct($vp, $x, 2.5/8, 2.5/8);
			lineToPct($vp, $x, 2.5/8, 5.5/8);
			lineToPct($vp, $x, 1.0/8, 7.0/8);
			$x.closePath();
			$x.stroke();
		}
		// f is actually b of the next step. ahhh... need to decide f/b
		if (C1.edge[xlt.f] === undefined) {
		} else {
			$x.beginPath();
			moveToPct($vp, $x, 2.5/8, 2.5/8);
			lineToPct($vp, $x, 5.5/8, 2.5/8);
			lineToPct($vp, $x, 5.5/8, 5.5/8);
			lineToPct($vp, $x, 2.5/8, 5.5/8);
			$x.closePath();
			$x.stroke();
		}
		// don't forget C1 neighbors' .b ... uh oh there's the problem
		if (R1.edge[xlt.l] === undefined) {
		} else {
			$x.beginPath();
			moveToPct($vp, $x, 7.0/8, 1.0/8);
			lineToPct($vp, $x, 5.5/8, 2.5/8);
			lineToPct($vp, $x, 5.5/8, 5.5/8);
			lineToPct($vp, $x, 7.0/8, 7.0/8);
			$x.closePath();
			$x.stroke();
		}
	} else {
		$x.beginPath();
		moveToPct($vp, $x, 1/8, 1/8);
		lineToPct($vp, $x, 7/8, 1/8);
		lineToPct($vp, $x, 7/8, 7/8);
		lineToPct($vp, $x, 1/8, 7/8);
		$x.closePath();
		$x.stroke();
	}

	if (C0.edge[xlt.r] === undefined) {
		// sees R1.f
		if (R1.edge[xlt.b] === undefined) {
		} else {
			$x.beginPath();
			moveToPct($vp, $x, 8/8, 1/8);
			lineToPct($vp, $x, 7/8, 1/8);
			lineToPct($vp, $x, 7/8, 7/8);
			lineToPct($vp, $x, 8/8, 7/8);
			$x.stroke();
		}
	} else {
		$x.beginPath();
		moveToPct($vp, $x, 8/8, 0/8);
		lineToPct($vp, $x, 7/8, 1/8);
		lineToPct($vp, $x, 7/8, 7/8);
		lineToPct($vp, $x, 8/8, 8/8);
		$x.stroke();
	}

	/*

	let cell = _getCellReference(Party.loc.i, Party.loc.j);

	let edgesToDraw = [];

	if (Party.facing === 'n') {
		edgesToDraw = ['w', 'n', 'e'];
	} else if (Party.facing === 'e') {
		edgesToDraw = ['n', 'e', 's'];
	} else if (Party.facing === 's') {
		edgesToDraw = ['e', 's', 'w'];
	} else { // w
		edgesToDraw = ['n', 'w', 's'];
	}

	let edge;
	// LEFT
	edge = cell.edge[edgesToDraw[0]];
	if (edge) {
		$x.beginPath();
		moveToPct($vp, $x, 0, 0);
		lineToPct($vp, $x, 1/8, 1/8);
		lineToPct($vp, $x, 1/8, 7/8);
		lineToPct($vp, $x, 0, 1);
		$x.stroke();
	}
	// FRONT
	edge = cell.edge[edgesToDraw[1]];
	if (edge) {
		$x.beginPath();
		moveToPct($vp, $x, 1/8, 1/8);
		lineToPct($vp, $x, 7/8, 1/8);
		lineToPct($vp, $x, 7/8, 7/8);
		lineToPct($vp, $x, 1/8, 7/8);
		$x.closePath();
		$x.stroke();
	}
	// RIGHT
	edge = cell.edge[edgesToDraw[2]];
	if (edge) {
		$x.beginPath();
		moveToPct($vp, $x, 1, 0);
		lineToPct($vp, $x, 7/8, 1/8);
		lineToPct($vp, $x, 7/8, 7/8);
		lineToPct($vp, $x, 1, 1);
		$x.stroke();
	}

	*/

	$x.restore();
};

const redraw = () => {
	$ctx.clearRect(-grid.w/2, -grid.h/2, $canvas.width(), $canvas.height());
	drawGrid();
    draw3dViewPort();
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
const xy2ij = (x, y) => {
	return {
		i: Math.floor(x / grid.w) - 1, // TODO ???? -1 ???
		j: Math.floor(y / grid.h) - 1, // related to xlate?
	};
};

const shadeCell = (cell, color) => {
	let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
	$ctx.save();
	$ctx.globalAlpha = 0.25;
	$ctx.fillStyle = color;
	$ctx.fillRect(ulcx, ulcy, grid.w, grid.h);
	$ctx.restore();
};

/*
 * Draws a cell and closest-edge cursor at the current cell.
 */
const mouseMoveHandler = (mousex, mousey) => {
	redraw();
	// Re-translate mouse to match coord system
	//mousex += grid.w ;
	//mousey += grid.h ;
	// Translate mouse to cell
	let cell = xy2ij(mousex, mousey);
	if (cell.i < 0 || cell.j < 0 || cell.i >= grid.i || cell.j >= grid.j) {
		return;
	}
	// Determine the upper-left corner x,y coordinates for the cell.
	shadeCell(cell, $('input[name=enable-edit]').prop('checked') ? 'blue' : 'grey');
	let [ulcx, ulcy] = [cell.i * grid.w, cell.j * grid.h];
	let edge = computeEdgeVertices(ulcx, ulcy, mousex, mousey);
	if (Session.type === 'edge') {
		$ctx.save();
		$ctx.beginPath();
		$ctx.moveTo(edge.x1, edge.y1);
		$ctx.lineTo(edge.x2, edge.y2);
		$ctx.globalAlpha = .7;
		$ctx.strokeStyle = $('input[name=enable-edit]').prop('checked') ? 'red' : 'grey';
		$ctx.lineWidth = 5;
		$ctx.stroke();
		$ctx.restore();
	}
	// Save current position so we don't have to recalc on click
	Cursor.cell.i = cell.i;
	Cursor.cell.j = cell.j;
	Cursor.edge = edge.wall;
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

$(() => {
	$canvas = $('canvas#draw-grid');
	$ctx = $canvas[0].getContext('2d');
	// set scale values for drawing (make the grid size a little smaller)
	grid.w = $canvas.width() / (grid.i + 2);
	grid.h = $canvas.height() / (grid.j + 2);
	// Center the grid in the canvas so that we don't have half-lines on edges
	$ctx.translate(grid.w * 1, grid.h * 1);
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
	$('input[name=enable-edit]').on('click', e => {
		$('input[name=draw-mode]').prop('disabled', !e.target.checked);
	});
	$('input[name=view-depth').on('blur', (e) => {
		viewDepth = e.target.value;
		redraw();
	});
    // The controller... that's really it!
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
	$('input[name=enable-edit]').click();  

});
