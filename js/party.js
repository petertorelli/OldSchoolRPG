
const Party = {
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
