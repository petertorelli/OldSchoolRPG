
/*
 * Frustum definition: 
 *
 * 3L3 2L3 1L3 0L3 0C3 0R3 1R3 2R3 3R3
 *     2L2 1L2 0L2 0C2 0R2 1R2 2R2
 *         1L1 0L1 0C1 0R1 1R1
 *             0L0 0C0 0R0
 *
 * NOTE:
 *
 * Wizardry I used a 1:1 viewport, but didn't render beyond +/-1 left/right
 * because the angle of the walls looks hideas. Might and Magic 3 used a 
 * much wider viewport which solved a lot fo the perspective issues, because
 * the edges simply vanish to the point where they only need two angles for
 * walls, a 45 and a wider-angle.
 *
 */

// Aspect ratio and dividers
const MAX_W = 8;
const MAX_H = 8;
const THETA = 1.5; // some kind of depth-of-field thing
// 1.406 fits all depth 5 fov
// Perspective scalar when rendering walls; filled on in init closure
const PERSP = [0, 1];

const moveToPct = ($canvas, $context, xpct, ypct) => {
	$context.moveTo($canvas.width() * xpct, $canvas.height() * ypct);
};

const lineToPct = ($canvas, $context, xpct, ypct) => {
	$context.lineTo($canvas.width() * xpct, $canvas.height() * ypct);
};

// Construct an array of array frustum out to 'depth' as defined by the comments above
const findCoordsOfDepthFromParty = (depth) => {
	let result = [];
	if (Party.facing === 'n') {
		for (let i = Party.loc.i - (depth + 1); i <= Party.loc.i + (depth + 1); ++i) {
			result.push(gridWrap(i, Party.loc.j - depth));
		}
	} else if (Party.facing === 'e') {
		for (let j = Party.loc.j - (depth + 1); j <= Party.loc.j + (depth + 1); ++j) {
			result.push(gridWrap(Party.loc.i + depth, j));
		}
	} else if (Party.facing === 's') {
		for (let i = Party.loc.i + (depth + 1); i >= Party.loc.i - (depth + 1); --i) {
			result.push(gridWrap(i, Party.loc.j + depth));
		}
	} else { // w
		for (let j = Party.loc.j + (depth + 1); j >= Party.loc.j - (depth + 1); --j) {
			result.push(gridWrap(Party.loc.i - depth, j));
		}
	}
	if (depth === 0) {
		return [ result ];
	} else {
		let child = findCoordsOfDepthFromParty(depth - 1);
		child.push(result);
		return child;
	}
};

/**
 * This is a trapezoid that changes shape with x, fortunately it is
 * symmetric about the horizontal axis
 */
const drawWallLR = (VP3D, VP3DCTX, X, Y, isLeft) => {
	let modifier = isLeft ? 0 : 1;
 	let w;
 	w = (MAX_W - PERSP[Y + 1] * 2) / MAX_W;
 	// x1, y1 is just the URC of the front-facing square
 	let [x1, y1] = [(PERSP[Y + 1] / MAX_W) + ((X + modifier) * w), PERSP[Y + 1] / MAX_H];
 	// x2, y2 is the ULC of the front-facing square directly behind it
 	w = (MAX_W - PERSP[Y + 0] * 2) / MAX_W;
 	let [x2, y2] = [(PERSP[Y + 0] / MAX_W) + ((X + modifier) * w), PERSP[Y + 0] / MAX_H];
	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x2, 1 - y2);
	lineToPct(VP3D, VP3DCTX, x1, 1 - y1);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};

/**
 * This is the easiest, it's just a square slid left/right
 */
const drawWallF = (VP3D, VP3DCTX, X, Y) => {
 	let w = (MAX_W - PERSP[Y + 1] * 2) / MAX_W;
 	let h = (MAX_H - PERSP[Y + 1] * 2) / MAX_H;
 	let [x1, y1] = [(PERSP[Y + 1] / MAX_W) + (X * w), PERSP[Y + 1] / MAX_H];
 	let [x2, y2] = [x1 + w, y1 + h];
	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x1, y2);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};


const draw3dViewPort = () => {
	// This creates a ZANY inverse FOV that goes beyond the frustum
	for (let x = 1; x < 7; ++x) {
		PERSP.push(PERSP[x] + (THETA / Math.pow(2, x - 1)));
	}

	let depth = 4;

	let frustum = findCoordsOfDepthFromParty(depth);
	frustum.forEach(a1 => {
		a1.forEach(a2 => {
			shadeCell({i: a2[0], j: a2[1]}, 'orange')
		});
	});
	let VP3D = $('canvas#viewport');
	let VP3DCTX = VP3D[0].getContext('2d');

	VP3DCTX.save();
	VP3DCTX.fillStyle = "#222";
	VP3DCTX.fillRect(0, 0, VP3D.width(), VP3D.height());
	VP3DCTX.strokeStyle = "lightgreen";
	VP3DCTX.lineJoin = 'bevel';
	VP3DCTX.lineWidth = 2;

	let x, y;		// Where in the frustum we're looking
	let i, j;		// Grid coordinates of current cell
	let L, C, R;	// LCR cell references
	let T;			// Cardinal direction to relative orientation transform
	T = XLATE_UCS2PARTY[Party.facing];
	for (y = depth; y >= 0; --y) {
		for (x = 0; x <= 2 * y + 2; ++x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			// Render all C.f walls
			if (C.edge[T.f] !== undefined) {
				drawWallF(VP3D, VP3DCTX, x - (y + 1), y);
			}
		}
		// Render R walls to the RIGHT
		for (x = 2 * y + 2; x >= ((2 * y) + 2) / 2; --x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			if (C.edge[T.r] !== undefined) {
				drawWallLR(VP3D, VP3DCTX, x - (y + 1), y, false);
			}
		}
		// Render L walls to the LEFT
		for (x = 0; x <= ((2 * y) + 2) / 2; ++x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			if (C.edge[T.l] !== undefined) {
				drawWallLR(VP3D, VP3DCTX, x - (y + 1), y, true);
			}
		}
	}
	VP3DCTX.restore();
};
