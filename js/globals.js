

// Mucking with different levels
let currentLevel = { cells: undefined, dims: undefined };
if (0) {
	currentLevel.cells = level;
	currentLevel.dims = level_dims;
} else {
	currentLevel.cells = LEVEL_ONE;
	currentLevel.dims = LEVEL_ONE_DIMS;
}


// Return a reference to the (logical) cell's unique object
const _getCellReference = (i, j, k = 1) => {
	if (i < 0 || j < 0) {
		return undefined;
	}
	if (i >= currentLevel.dims.i  || j >= currentLevel.dims.j) {
		return undefined;
	}
	return currentLevel.cells[i + j * (currentLevel.dims.j)];
};


/**
 * The drawing grid used to represent the editable regions of the level.
 * [i, j] refer to logical coordinates. [w, h] represent the number of pixels
 * per grid division on the target 2D rendering surface.
 */
const grid = {
	i: 20,
	j: 20,
	w: undefined,
	h: undefined,
};

// Translate party front/back/left/right to N/S/E/W
const XLATE_UCS2PARTY = {
	n: { f: 'n', b: 's', r: 'e', l: 'w' },
	s: { f: 's', b: 'n', r: 'w', l: 'e' },
	e: { f: 'e', b: 'w', r: 's', l: 'n' },
	w: { f: 'w', b: 'e', r: 'n', l: 's' }
};

// JavaScript divmod is boned
const divMod = (n, d) => {
	return n - d * Math.floor(n / d);
};

// Give an [i, j] coordinate and wrap it if exceeds grid dimensions
const gridWrap = (i, j) => {
    return [divMod(i, grid.i), divMod(j, grid.j)];
};
