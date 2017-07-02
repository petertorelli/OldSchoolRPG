

let currentLevel;
if (1) {
	currentLevel = level;
} else {
	currentLevel = LEVEL_ONE;
}

// Instead of using padding can we just do a translate
const grid = {
	i: 20,
	j: 20,
	w: 0,
	h: 0,
};

// Return a reference to the (logical) cell's unique object
const _getCellReference = (i, j, k = 1) => {
	// TODO make a member function that comprehends dimensions
	return currentLevel[i + j * (grid.i)];
	//return level[i + j * 20];
};

// Translate relative personal orientation to cardinals
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



