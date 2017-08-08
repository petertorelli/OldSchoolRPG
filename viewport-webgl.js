

let $topdown;
let topdowncamera;
let topdownrenderer;

let $viewport;
let viewportcamera;
let viewportrenderer;

let scene;
var mesh, parent_node;

let partyBall;
let scalar = 100;

let lookAt = new THREE.Vector3(0, 0, 0);

init();
animate();

function init () {

	$topdown = $('#webgl-topdown');
	$viewport = $('#webgl-viewport');

	viewportcamera = new THREE.PerspectiveCamera(100, $topdown.width() / $topdown.height(), 1, 20000);
	viewportcamera.up = new THREE.Vector3(0, 0, 1);
	viewportcamera.position.set(0.5 * scalar, 0.5 * scalar, 0.5 * scalar);
	viewportcamera.lookAt(new THREE.Vector3(0.5 * scalar, (1 + 0.5) * scalar, 0.5 * scalar));

	topdowncamera = new THREE.PerspectiveCamera(50, $viewport.width() / $viewport.height(), 1, 20000);
	topdowncamera.position.set(10 * scalar, 10 * scalar, 3000);

	scene = new THREE.Scene();

	var positions = [];
	var colors = [];
	var indices_array = [];

	// a) this shouldn't be here; b) general case is bugged if gx != gy
	let gx = 20;
	let gy = 20;

	function make_full_level () {
		// vertices
		for (let k = 0; k <= 1; ++k) {
			for (let j = 0; j <= gx; ++j) {
				for (let i = 0; i <= gy; ++i) {
					positions.push(i * scalar, j * scalar, k * scalar)
					//colors.push(Math.random(),Math.random(),Math.random());
					if (i < 2 && j < 2 && k == 0) {
						colors.push(1,0,0);
					} else {
						colors.push(Math.random(), Math.random(), Math.random());
					}
				}
			}
		}
		// indices
		let nextRow = gx + 1;
		let gy1 = gy + 1;
		let nextPlane = nextRow * gy1;

		// haha, my verticies go opposite my cell coord system. doh.
		// 0 = 0, 19 or 0 + 19 * 20.. dang
		let fakeIndex = 0;
		let cellIndex = 0;

		for (let z = 0; z < (gx + 1) * gy; ++z) {
			if ((z + 1) % (gx + 1) == 0) continue;

			// lol
			let y = 19 - parseInt(fakeIndex / 20);
			let x = fakeIndex % 20;
			cellIndex = x + y * 20;
			let cell = currentLevel[cellIndex];

			// bottom
			/*
			indices_array.push(z, z + 1, z + nextRow);
			indices_array.push(z + nextRow, z + 1, z + 1 + nextRow);
			*/
			if (cell.edge.s !== undefined) {
				indices_array.push(z, z + nextPlane, z + 1 + nextPlane);
				indices_array.push(z, z + 1 + nextPlane, z + 1);
			}
			if (cell.edge.w !== undefined) {
				indices_array.push(z + nextPlane + nextRow, z + nextPlane, z);
				indices_array.push(z + nextPlane + nextRow, z, z + nextRow);
			}
			if (cell.edge.e !== undefined) {
				indices_array.push(1 + z, 1 + z + nextPlane, z + 1 + nextPlane + nextRow);
				indices_array.push(1 + z + nextRow, 1 + z,  z + 1 + nextPlane + nextRow);
			}
			if (cell.edge.n !== undefined) {
				indices_array.push(z + nextRow, z + 1 + nextRow + nextPlane, z + nextRow + nextPlane);
				indices_array.push(z + nextRow, z + 1 + nextRow, z + 1 + nextRow + nextPlane);
			}

			++fakeIndex;

		}
		console.log(cellIndex);
	}

	make_full_level();

	let geometry;
	let material;
	let mesh;


	// Level
	geometry = new THREE.BufferGeometry();
	material = new THREE.MeshBasicMaterial({ vertexColors: THREE.VertexColors });
	geometry.setIndex(indices_array);
	geometry.addAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
	geometry.addAttribute('color', new THREE.Float32BufferAttribute(colors, 3));
	mesh = new THREE.Mesh(geometry, material);
	scene.add(mesh);

/*
	// Level wire
	let wireframe = new THREE.WireframeGeometry(geometry);
	let line = new THREE.LineSegments(wireframe);
	line.material.color = new THREE.Color(1,1,1);;
	line.material.depthTest = true;
	line.material.opacity = 1;
	scene.add(line);
*/
	// Party
	geometry = new THREE.SphereGeometry( 50, 3, 6 );
	material = new THREE.MeshBasicMaterial( {color: 0xff0000} );
	partyBall = new THREE.Mesh( geometry, material );
	partyBall.position.set(50, 50, 50);
	scene.add( partyBall );


	topdownrenderer = new THREE.WebGLRenderer({ antialias: true });
	topdownrenderer.setPixelRatio(window.devicePixelRatio);
	topdownrenderer.setSize($topdown.width(), $topdown.height());
	$topdown.append(topdownrenderer.domElement);

	viewportrenderer = new THREE.WebGLRenderer({ antialias: true });
	viewportrenderer.setPixelRatio(window.devicePixelRatio);
	viewportrenderer.setSize($viewport.width(), $viewport.height());
	$viewport.append(viewportrenderer.domElement);
}

function moveCameraWithParty() {
	let x = Party.loc.i;
	let y = 19 - Party.loc.j;

	viewportcamera.position.set((x + 0.5) * scalar, (y + 0.5) * scalar, 0.5 * scalar);

	lookAt.x = (x + 0.5) * scalar;
	lookAt.y = (y + 0.5) * scalar;
	lookAt.z = 0.5 * scalar;
	partyBall.position.set(lookAt.x, lookAt.y, lookAt.z);
	if (Party.facing === 'n') {
		lookAt.y += 1 * scalar;
	} else if (Party.facing === 's') {
		lookAt.y -= 1 * scalar;
	} else if (Party.facing === 'e') {
		lookAt.x += 1 * scalar;
	} else {
		lookAt.x -= 1 * scalar;
	}
	viewportcamera.lookAt(lookAt);
}

function animate () {
	//requestAnimationFrame(animate);
	render();
}

function render () {
	moveCameraWithParty();
	topdownrenderer.render(scene, viewportcamera);
	viewportrenderer.render(scene, topdowncamera);
	var time = Date.now() * 0.001;
}
