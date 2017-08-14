'use strict';

// Currently using a topdown camera for debug
let $topdown;
let topdowncamera;
let topdownrenderer;

let $viewport;
let viewportcamera;
let viewportrenderer;

let scene;

// These are reused to construct the level
let basicWallMesh;
let basicDoorMesh;
// Emulate darkness with a black cube.
let darkCube;

let partyLight;
let partyGaze = new THREE.Vector3(0, 0, 0);
// # of squares ahead they can see
let partyVisibility = 3;

// TODO: This needs to be read from the level, and it currently is not there
let gx = 20;
let gy = 20;

viewportWebGlInit();
viewportWebGlAnimate();

// The default square is a north wall at LLC [0,0,0]
function renderLevelObject (level) {
	let x, y;
	for (let j = 0; j < gy; ++j) {
		for (let i = 0; i < gx; ++i) {
			let newObj;
			let cell = level[j * gx + i];
			if (1 && cell.edge.w !== undefined) {
				[x, y] = [i, j]
				if (cell.edge.w === 'wall') {
					newObj = basicWallMesh.clone();
				} else if (cell.edge.w === 'door' || cell.edge.w === 'hiddendoor') {
					newObj = basicDoorMesh.clone();
				}
				newObj.rotation.z = 0.5 * Math.PI;
				y += 1;
				newObj.position.x = x;	
				newObj.position.y = (gy - y);
				scene.add(newObj);
			}
			if (1 && cell.edge.e !== undefined) {
				[x, y] = [i, j]
				if (cell.edge.e === 'wall') {
					newObj = basicWallMesh.clone();
				} else if (cell.edge.e === 'door' || cell.edge.e === 'hiddendoor') {
					newObj = basicDoorMesh.clone();
				}
				newObj.rotation.z = -0.5 * Math.PI;
				x += 1;
				newObj.position.x = x;	
				newObj.position.y = (gy - y);
				scene.add(newObj);
			}
			if (1 && cell.edge.s !== undefined) {
				[x, y] = [i, j]
				if (cell.edge.s === 'wall') {
					newObj = basicWallMesh.clone();
				} else if (cell.edge.s === 'door' || cell.edge.s === 'hiddendoor') {
					newObj = basicDoorMesh.clone();
				}
				newObj.rotation.z = Math.PI;
				x += 1;
				y += 1;
				newObj.position.x = x;	
				newObj.position.y = (gy - y);
				scene.add(newObj);
			}
			if (1 && cell.edge.n !== undefined) {
				[x, y] = [i, j]
				if (cell.edge.n === 'wall') {
					newObj = basicWallMesh.clone();
				} else if (cell.edge.n === 'door' || cell.edge.n === 'hiddendoor') {
					newObj = basicDoorMesh.clone();
				}
				newObj.position.x = x;	
				newObj.position.y = (gy - y);
				scene.add(newObj);
			}
			if (cell.properties.darkness) {
				newObj = darkCube.clone();
				[x, y] = [i, j]
				x += 0.5;
				y += 0.5;
				newObj.position.x = x;
				newObj.position.y = (gy - y);
				scene.add(newObj);
			}
		}
	}
}

function viewportWebGlInit () {

	$topdown = $('#webgl-topdown');
	$viewport = $('#webgl-viewport');

	viewportcamera = new THREE.PerspectiveCamera(120, $topdown.width() / $topdown.height(), .1, 20000);
	viewportcamera.up = new THREE.Vector3(0, 0, 1);

	topdowncamera = new THREE.PerspectiveCamera(50, $viewport.width() / $viewport.height(), 1, 20000);
	topdowncamera.position.set(10, 10, 35);

	scene = new THREE.Scene();

	let loader = new THREE.TextureLoader();
	let texture;
	let normal;
	let bump;

	let geometry;
	let material;
	let positions = [];
	let uv = [];
	let indices_array = [];

	// The default square is a north wall at LLC [0,0,0]
	positions.push(0, 0, 0); // 0
	positions.push(1, 0, 0); // 1
	positions.push(1, 0, 1); // 2
	positions.push(0, 0, 1); // 3
	uv.push(0, 0);
	uv.push(1, 0);
	uv.push(1, 1);
	uv.push(0, 1);
	indices_array.push(0, 1, 2);
	indices_array.push(0, 2, 3);
	geometry = new THREE.BufferGeometry();
	geometry.setIndex(indices_array);
	geometry.addAttribute('position', new THREE.Float32BufferAttribute(positions, 3));
	geometry.addAttribute('uv', new THREE.Float32BufferAttribute(uv, 2));
	// For lighting
	geometry.computeFaceNormals();
	geometry.computeVertexNormals();
	
	texture = new THREE.TextureLoader().load('textures/brick.jpg');
	bump = new THREE.TextureLoader().load('textures/brick_spec.jpg');
	material = new THREE.MeshLambertMaterial({
		map: texture,
		//bumpMap: bump,
	});
	basicWallMesh = new THREE.Mesh(geometry, material);

	normal = new THREE.TextureLoader().load('textures/door.png');
	material = new THREE.MeshLambertMaterial({ map: normal });
	basicDoorMesh = new THREE.Mesh(geometry, material);

	// darkness is implemented with an inverted black cube
	// odd this works, seems to have two normals now? confused.
	// remember it is centered at the origin
	geometry = new THREE.BoxBufferGeometry(.999, .999, .999);
	material = new THREE.MeshBasicMaterial({color: 0x444444});
	darkCube = new THREE.Mesh(geometry, material);
	darkCube.position.z = 0.5; // move the base object up z
	// reverse all normals so that you can't see out of it! muahahahaha
	darkCube.scale.x = -1;
	darkCube.scale.y = -1;
	darkCube.scale.z = -1;

	renderLevelObject(currentLevel);


	var ambientLight = new THREE.AmbientLight(0x222222);
	scene.add(ambientLight);


	texture = new THREE.TextureLoader().load('textures/floor.jpg');
	texture.wrapS = THREE.RepeatWrapping;
	texture.wrapT = THREE.RepeatWrapping;
	material = new THREE.MeshLambertMaterial({map : texture});
	geometry = new THREE.PlaneGeometry(20, 20, 20, 20);
	// Correct the UVs of the plane
	for (let i = 0; i < geometry.faceVertexUvs[0].length; ++i) {
		for (let j = 0; j < 3; ++j) {
			geometry.faceVertexUvs[0][i][j].x *= 20;
			geometry.faceVertexUvs[0][i][j].y *= 20;
		}
	}
	let floorMesh = new THREE.Mesh(geometry, material);
	floorMesh.position.y = 10;
	floorMesh.position.x = 10;
	floorMesh.position.z = 0;
	floorMesh.rotation.z = -Math.PI / 2;
	scene.add(floorMesh);

	partyLight = new THREE.PointLight(0xffffff, 2, partyVisibility);
	partyLight.position.set(1, 1, 1);
	scene.add(partyLight);

	topdownrenderer = new THREE.WebGLRenderer({ antialias: false });
	topdownrenderer.setPixelRatio(window.devicePixelRatio);
	topdownrenderer.setSize($topdown.width(), $topdown.height());
	$topdown.append(topdownrenderer.domElement);

	viewportrenderer = new THREE.WebGLRenderer({ antialias: true, physicallyCorrectLights: true, });
	viewportrenderer.setPixelRatio(window.devicePixelRatio);
	viewportrenderer.setSize($viewport.width(), $viewport.height());
	$viewport.append(viewportrenderer.domElement);
}

function moveCameraWithParty() {
	let x = Party.loc.i;
	let y = 19 - Party.loc.j;
	let z;

	// Move eye to center of cube
	x += 0.5;
	y += 0.5;
	z  = 0.5;
	viewportcamera.position.set(x, y, z);
	// Assume the party light source is at the eye location. Weird.
	partyGaze.x = x;
	partyGaze.y = y;
	partyGaze.z = z;
	partyLight.position.set(partyGaze.x, partyGaze.y, partyGaze.z);
	// Now set visual target
	if (Party.facing === 'n') {
		partyGaze.y += 1;
	} else if (Party.facing === 's') {
		partyGaze.y -= 1;
	} else if (Party.facing === 'e') {
		partyGaze.x += 1;
	} else {
		partyGaze.x -= 1;
	}
	// Now look!
	viewportcamera.lookAt(partyGaze);
}

function viewportWebGlAnimate () {
	requestAnimationFrame(viewportWebGlAnimate);
	render();
}

function render () {
	moveCameraWithParty();
	topdownrenderer.render(scene, viewportcamera);
	viewportrenderer.render(scene, topdowncamera);
	var time = Date.now() * 0.001;
}
