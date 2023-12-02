### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ d0fb0290-9101-11ee-1593-69ea7d8b0c00
using HypertextLiteral

# ╔═╡ 784a312f-2da7-4d16-b9eb-85760c9e98be
"""
A tile layer that can be used in a map.

The configuration includes:
- `url`: a url template to request tiles
- `options`: a `Dict` with extra configurations, such as a minimum and maximum zoom level of the tiles. This is interpolated to a Javascript object using HypertextLiteral.

The configuration is used to create a TileLayer in leaflet; see [leaflet's TileLayer documentation](https://leafletjs.com/reference.html#tilelayer) to read more about URL templates and the available options.
"""
struct TileLayer
	url::String
	options::Dict{String,Any}
end

# ╔═╡ 370d3360-2891-458a-bc7a-fd2bc9801ec2
"""
TileLayer configuration for open street map. Please read OSM's [tile usage policy](https://operations.osmfoundation.org/policies/tiles/) to decide if your usage complies with it.
"""
osm_tile_layer = TileLayer(
	"https://tile.openstreetmap.org/{z}/{x}/{y}.png",
	Dict(
		"maxZoom" => 19,
		"attribution" => "&copy; <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>"
	)
)

# ╔═╡ 3c1c32ec-f5c7-4527-8e8a-2261f1a05847
"""
Create an interactive map to pick a location.

Basic usage in a Pluto notebook:
```julia
@bind place MapPicker(0.0, 0.0, 1);
```

Uses [Leaflet](https://leafletjs.com/) to render a map. By default, the map uses tiles from OpenStreetMap. Please read OSM's [usage policy](https://operations.osmfoundation.org/policies/tiles/).

Users can place a marker on the map to select a location. If you use `@bind` in Pluto, your bound variable will receive the coordinates in a `Dict` with keys `"lat"` and `"lng"`, or `nothing` if no marker has been placed.

Input:

You have to supply the latitude and longitude that the map should initially centre on, as well as the initial level.

Additional parameters:
- `tile_layer`: a `TileLayer` configuration.
- `height`: height of the map in pixels.
"""
function MapPicker(
	latitude::Number, longitude::Number, zoom::Number;
	tile_layer::TileLayer = osm_tile_layer,
	height::Number = 500,
)::HypertextLiteral.Result
	instructions = """
	Place a marker on the map!

	Mouse controls:
	- Click on the map to place a marker
	- Click on a marker to remove it
	- Drag the map to move the view, scroll to zoom
	
	Keyboard controls:
	- When focused on the map, press Enter to create a marker, and Delete to remove it
	- When focused on the marker, press Delete to remove it
	- Use the arrow keys to move the view, and +/- to zoom
	"""
	
	@htl """
	<div>
		<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
			integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
			crossorigin=""/>
		<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
	    	integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
	    	crossorigin=""></script>
	
		<div id="map"></div>
	
		<style>
			#map { height: $(height)px; }
		</style>
	
		<script>
			var parent = currentScript.parentElement;
			var mapElement = parent.querySelector("#map");
			var map = L.map(mapElement).setView([$latitude, $longitude], $zoom);
			L.tileLayer($(tile_layer.url), $(tile_layer.options)).addTo(map);

			// add instructions control

			function showInstructions(e) {
				e.stopPropagation();
				alert($instructions);
			} 

			L.Control.Instruction = L.Control.extend({
				onAdd: function(map) {
					const button = L.DomUtil.create('button');
					button.innerText = "?";
					button.title = "view controls";
					button.addEventListener("click", showInstructions)
					return button;
				},
				onRemove: function(map) {},
			});

			L.control.instruction = function(opts) {
			    return new L.Control.Instruction(opts);
			}
			L.control.instruction({ position: 'bottomleft' }).addTo(map);

			// event dispatcher
			
			function emit() {
				parent.value = markerActive() ? marker.getLatLng() : null;
				parent.dispatchEvent(new CustomEvent("input"));
			}

			// markers
			
			function makeMarker(latlng) {
				var marker = L.marker(latlng);
				marker.on("click", (e) => onMarkerClick(e, marker));
				marker.on("keydown", (e) => onMarkerKeydown(e, marker));
				return marker
			}

			function markerActive() {
				return !!marker._map;
			}

			function removeMarker() {
				marker.remove();
				emit();
			}

			function addMarker(latlng) {
				marker.setLatLng(latlng);
				marker.addTo(map);
				emit();
			}

			// event handlers

			function onMarkerClick(e, marker) {
				removeMarker();
			}

			function onMarkerKeydown(e, marker) {
				var key = e.originalEvent.key;
				if (key === 'Delete') {
					removeMarker();
				}
			}

			function onMapClick(e) {
				addMarker(e.latlng);
			}

			function onMapKeydown(e) {
				var key = e.originalEvent.key;
				if (key === 'Enter') {
					addMarker(map.getCenter());
				}
				if (key === 'Delete') {
					if (marker) {
						removeMarker(marker);
					}
				}
			}

			var marker = makeMarker();
			map.on('click', onMapClick);
			map.on('keydown', onMapKeydown);
		</script>
	</div>
	"""
end

# ╔═╡ 9c9b2151-765f-422c-84bb-669aaf8c424b
"""
Create an interactive map to pick multiple locations

Basic usage in a Pluto notebook:
```julia
@bind places MapPickerMultiple(0.0, 0.0, 1);
```

Uses [Leaflet](https://leafletjs.com/) to render a map. By default, the map uses tiles from OpenStreetMap. Please read OSM's [usage policy](https://operations.osmfoundation.org/policies/tiles/).

Users can place and remove markers on the map to select locations. If you use `@bind` in Pluto, your bound variable will receive an array with the coordinates for each selected point. Each point is provided as a `Dict` with keys `"lat"` and `"lng"`.

Input:

You have to supply the latitude and longitude that the map should initially centre on, as well as the initial zoom level.

Additional parameters:
- `tile_layer`: a `TileLayer` configuration.
- `height`: height of the map in pixels.
"""
function MapPickerMultiple(
	latitude::Number, longitude::Number, zoom::Number;
	tile_layer::TileLayer = osm_tile_layer,
	height::Number = 500,
)::HypertextLiteral.Result
	instructions = """
	Place markers on the map!

	Mouse controls:
	- Click on the map to remove a marker
	- Click on a marker to remove it
	
	Keyboard controls:
	- When focused on the map, press Enter to create a marker, and Delete to remove all markers
	- When focused on a marker, press Delete to remove it
	"""
	
	@htl """
	<div>
		<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
			integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
			crossorigin=""/>
		<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
	    	integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
	    	crossorigin=""></script>
	
		<div id="map"></div>
	
		<style>
			#map { height: $(height)px; }
		</style>
	
		<script>
			var parent = currentScript.parentElement;
			var mapElement = parent.querySelector("#map");
			var map = L.map(mapElement).setView([$latitude, $longitude], $zoom);
			L.tileLayer($(tile_layer.url), $(tile_layer.options)).addTo(map);

			// add instructions control
			function showInstructions(e) {
				e.stopPropagation();
				alert($instructions);
			} 

			L.Control.Instruction = L.Control.extend({
				onAdd: function(map) {
					const button = L.DomUtil.create('button');
					button.innerText = "?";
					button.title = "view controls";
					button.addEventListener("click", showInstructions)
					return button;
				},
				onRemove: function(map) {},
			});

			L.control.instruction = function(opts) {
			    return new L.Control.Instruction(opts);
			}
			L.control.instruction({ position: 'bottomleft' }).addTo(map);

			// event dispatcher
			
			function emit() {
				parent.value = markers.map(marker => marker.getLatLng());
				parent.dispatchEvent(new CustomEvent("input"));
			}
			
			// markers
			
			var markers = [];

			function makeMarker(latlng) {
				var marker = L.marker(latlng);
				marker.on("click", (e) => onMarkerClick(e, marker));
				marker.on("keydown", (e) => onMarkerKeydown(e, marker));
				return marker
			}

			function removeMarker(marker) {
				marker.remove();
				markers = markers.filter(m => m._leaflet_id !== marker._leaflet_id);
				emit();
			}

			function removeAllMarkers() {
				markers.forEach(marker => marker.remove());
				markers = [];
				emit();
			}

			function addMarker(latlng) {
				var marker = makeMarker(latlng);
				marker.addTo(map);
				markers.push(marker);
				emit();
			}

			// event handlers 
			
			function onMarkerClick(e, marker) {
				removeMarker(marker);
			}

			function onMarkerKeydown(e, marker) {
				var key = e.originalEvent.key;
				if (key === 'Delete') {
					removeMarker(marker);
				}
			}

			function onMapClick(e) {
				addMarker(e.latlng);
			}

			function onMapKeydown(e) {
				var key = e.originalEvent.key;
				if (key === 'Enter') {
					addMarker(map.getCenter());
				}
				if (key === 'Delete') {
					removeAllMarkers();
				}
			}

			map.on('click', onMapClick);
			map.on('keydown', onMapKeydown);
		</script>
	</div>
	"""
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"
"""

# ╔═╡ Cell order:
# ╠═d0fb0290-9101-11ee-1593-69ea7d8b0c00
# ╠═784a312f-2da7-4d16-b9eb-85760c9e98be
# ╠═370d3360-2891-458a-bc7a-fd2bc9801ec2
# ╠═3c1c32ec-f5c7-4527-8e8a-2261f1a05847
# ╠═9c9b2151-765f-422c-84bb-669aaf8c424b
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
