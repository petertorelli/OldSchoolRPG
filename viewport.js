
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

/*

Pick a point on a line that starts at the center of the view port
with a fixed slope. select points off of that.

Walls direcly in front fall on the x=y line; This is 90 deg
Top of doors fall on +45 * (7 / 8);
Or, y = x * (7 / 8);

The x compression is [2^(n+2)-3] / (2^n * 8)

First translate n based on squares ahead.

0 squares, the wall in front is 2^2-3 / 2^0*8 = 1 / 8
1 squares, the wall in front is 2^3-3 / 2^1*8 = 5 / 16


The Y value is x...
For the door top the y value is x * 7 / 8;

*/

// Aspect ratio and dividers
const DOOR_OFFSET = 1 / 8;
const MAX_W = 8;
const MAX_H = 8;

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

function perspEqnX(n) {
	return 1 * (Math.pow(2, (n + 2)) - 3) / (Math.pow(2, n) * MAX_W);
}

function perspEqnY(n) {
	return 1 * (Math.pow(2, (n + 2)) - 3) / (Math.pow(2, n) * MAX_H);
}

const drawDoorLR = (VP3D, VP3DCTX, slide, depth, isLeft) => {
	drawWallLR(VP3D, VP3DCTX, slide, depth, isLeft);
	let u = DOOR_OFFSET;
	// find px, py for depth of facing wall and one behind it closer to you
	let px0 = perspEqnX((depth - 1) + u);
	let px1 = perspEqnX(depth - u);

	let py0 = perspEqnY((depth - 1) + u);
	let py1 = perspEqnY(depth - u);

	let x1, y1;
	let x2, y2;
	let x3, y3;
	let x4, y4;

	let w0, h0;
	let w1, h1;

	w0 = (1 - px0) - (px0);
	w1 = (1 - px1) - (px1);

	h0 = (1 - py0) - (py0);
	h1 = (1 - py1) - (py1);

	let slide0 = slide * w0;
	let slide1 = slide * w1;

	[x1, y1] = [px0 + slide0, py0 + h0 * u];
	[x2, y2] = [px1 + slide1, py1 + h1 * u];
	[x3, y3] = [px1 + slide1, py1 + h1];
	[x4, y4] = [px0 + slide0, py0 + h0];

	if (! isLeft) {
		x1 = 1 - x1;
		x2 = 1 - x2;
		x3 = 1 - x3;
		x4 = 1 - x4;
	}

	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x3, y3);
	lineToPct(VP3D, VP3DCTX, x4, y4);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};


const drawWallLR = (VP3D, VP3DCTX, slide, depth, isLeft) => {
	// find px, py for depth of facing wall and one behind it closer to you
	let px0 = perspEqnX(depth - 1);
	let py0 = perspEqnY(depth - 1);
	let px1 = perspEqnX(depth);
	let py1 = perspEqnY(depth);

	let x1, y1;
	let x2, y2;
	let x3, y3;
	let x4, y4;

	let w0, h0;
	let w1, h1;

	w0 = (1 - px0) - (px0);
	h0 = (1 - py0) - (py0);
	w1 = (1 - px1) - (px1);
	h1 = (1 - py1) - (py1);

	[x1, y1] = [px0 + (slide * w0), py0];
	[x2, y2] = [px1 + (slide * w1), py1];
	[x3, y3] = [px1 + (slide * w1), py1 + h1];
	[x4, y4] = [px0 + (slide * w0), py0 + h0];

	if (! isLeft) {
		x1 = 1 - x1;
		x2 = 1 - x2;
		x3 = 1 - x3;
		x4 = 1 - x4;
	}

	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x3, y3);
	lineToPct(VP3D, VP3DCTX, x4, y4);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};

/**
 * This is the easiest, it's just a square slid left/right
 */
const drawWallF = (VP3D, VP3DCTX, slide, depth) => {
	// Find the starting point
	let px = perspEqnX(depth);
	let py = perspEqnY(depth);
	let w = (1 - px) - (px);
	let h = (1 - py) - (py);

	let [x1, y1] = [ px + (slide * w), py ];
	// other point is just w + h
	let [x2, y2] = [ x1 + w, y1 + h ];

	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x1, y2);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};


/**
 * This is the easiest, it's just a SMALLER square slid left/right
 */
const drawDoorF = (VP3D, VP3DCTX, slide, depth) => {
	drawWallF(VP3D, VP3DCTX, slide, depth)

	// Same as with wall, but shrink a little

	// Find the starting point
	let px = perspEqnX(depth);
	let py = perspEqnY(depth);
	let w = (1 - px) - (px);
	let h = (1 - py) - (py);
	// shift left or right
	let [x1, y1] = [ px + (slide * w), py ];
	// other point is just w + h
	let [x2, y2] = [ x1 + w, y1 + h ];

	// Shrink the ULC and URC
	x1 += (w * DOOR_OFFSET);
	y1 += (h * DOOR_OFFSET);
	x2 -= (w * DOOR_OFFSET);

	VP3DCTX.beginPath();
	moveToPct(VP3D, VP3DCTX, x1, y1);
	lineToPct(VP3D, VP3DCTX, x2, y1);
	lineToPct(VP3D, VP3DCTX, x2, y2);
	lineToPct(VP3D, VP3DCTX, x1, y2);
	VP3DCTX.closePath();
	VP3DCTX.fill();
	VP3DCTX.stroke();
};

var globalDepth = 2;

const draw3dViewPort = () => {
	let frustum = findCoordsOfDepthFromParty(globalDepth);
	frustum.forEach(a1 => {
		a1.forEach(a2 => {
			LevelMap.shadeCell({i: a2[0], j: a2[1]}, 'orange')
		});
	});
	let VP3D = $('canvas#viewport');
	let VP3DCTX = VP3D[0].getContext('2d');

	// All viewport lines are draw the same style, so pull this out here
	VP3DCTX.save();
	VP3DCTX.fillStyle = "#222";
	VP3DCTX.fillRect(0, 0, VP3D.width(), VP3D.height());
	VP3DCTX.strokeStyle = "lightgreen";
	VP3DCTX.lineJoin = 'bevel';
	VP3DCTX.lineWidth = 2;

	let x, y;		// Where in the frustum we're looking
	let w;          // For clarity, width of current row in frustrum
	let i, j;		// Grid coordinates of current cell
	let L, C, R;	// LCR cell references
	let T;			// Cardinal direction to relative orientation transform
	let toDraw;
	
	T = XLATE_UCS2PARTY[Party.facing];

	// Render backwards so that polygon fill occludes hidden geometry

	C = _getCellReference(Party.loc.i, Party.loc.j);
	let depth;
	if (C.properties.darkness === true) {
		depth = 0;
	} else {
		depth = globalDepth;
	}

	for (y = depth; y >= 0; --y) {
		let w = 2 * (y + 1);
		for (x = 0; x <= w; ++x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			toDraw = C.edge[T.f];
			if (toDraw === "wall") {
				drawWallF(VP3D, VP3DCTX, x - (y + 1), y);
			} else if (toDraw === "door") {
				drawDoorF(VP3D, VP3DCTX, x - (y + 1), y);
			}
		}

		// Render R walls to the RIGHT
		for (x = w; x >= w / 2; --x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			toDraw = C.edge[T.r];
			if (toDraw === "wall") {
				drawWallLR(VP3D, VP3DCTX, x - (y + 1) + 1, y, true);
			} else if (toDraw === "door") {
				drawDoorLR(VP3D, VP3DCTX, x - (y + 1) + 1, y, true);
			}
		}

		// Render L walls to the LEFT
		for (x = 0; x <= w / 2; ++x) {
			i = frustum[y][x][0];
			j = frustum[y][x][1];
			C = _getCellReference(i, j);
			toDraw = C.edge[T.l];
			if (toDraw === "wall") {
				drawWallLR(VP3D, VP3DCTX, x - y - 1, y, true);
			} else if (toDraw === "door") {
				drawDoorLR(VP3D, VP3DCTX, x - y - 1, y, true);
			}
		}
	}
	
	VP3DCTX.restore();
};
