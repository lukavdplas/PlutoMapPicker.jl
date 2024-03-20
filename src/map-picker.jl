### A Pluto.jl notebook ###
# v0.19.38

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

# ╔═╡ a09bf4e8-270e-4331-9961-b27513efdf72
md"""
## Tile layers
"""

# ╔═╡ 784a312f-2da7-4d16-b9eb-85760c9e98be
"""
A tile layer that can be used in a Leaflet map.

The configuration includes:
- `url`: a url template to request tiles
- `options`: a `Dict` with extra configurations, such as a minimum and maximum zoom level of the tiles. This is interpolated to a Javascript object using HypertextLiteral.

The configuration is used to create a TileLayer in leaflet; see [leaflet's TileLayer documentation](https://leafletjs.com/reference.html#tilelayer) to read more about URL templates and the available options.
"""
struct TileLayer
	url::String
	options::Dict{String,Any}
end

# ╔═╡ e248e1dc-6aa6-4bfb-aba8-5ec9be8ed87a
attribution_stadia = "&copy; <a href='https://stadiamaps.com/'>Stadia Maps</a>"

# ╔═╡ 6e90fd7e-e4b6-4883-8ad5-6eb4341cc6b4
attribution_stamen = "&copy; <a href='https://stamen.com/'>Stamen Design</a>"

# ╔═╡ 4e8e3342-5b83-4849-a4c6-443dd2013ee8
attribution_openmaptiles = "&copy; <a href='https://openmaptiles.org/'>OpenMapTiles</a>"

# ╔═╡ 2e42276e-3f5a-4a9e-a905-24e618a705be
attribution_osm = "&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a>"

# ╔═╡ 370d3360-2891-458a-bc7a-fd2bc9801ec2
"""
TileLayer for open street map. Please read OSM's [tile usage policy](https://operations.osmfoundation.org/policies/tiles/) to decide if your usage complies with it.
"""
osm_tile_layer = TileLayer(
	"https://tile.openstreetmap.org/{z}/{x}/{y}.png",
	Dict(
		"maxZoom" => 19,
		"attribution" => attribution_osm
	)
)

# ╔═╡ 3b1fdb24-81f9-46b1-8450-9ceae2204556
osm_humanitarian_tile_layer = TileLayer(
	"https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
	Dict(
		"maxZoom" => 19,
		"subdomains" => "ab",
		"attribution" => attribution_osm
	)
)

# ╔═╡ b756ba60-99bc-4825-8b73-dec91139f52b
"""
TileLayers for Open Street Map. Please read OSM's [tile usage policy](https://operations.osmfoundation.org/policies/tiles/) to decide if your usage complies with it.
"""
osm_tile_layers = (
	standard = osm_tile_layer,
	humanitarian = osm_humanitarian_tile_layer,
)

# ╔═╡ c0ab32a2-20f8-412b-a345-64cde911a7ba
stadia_osm_bright_tile_layer = TileLayer(
	"https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png",
	Dict(
		"maxZoom" => 20,
		"attribution" =>  "$attribution_stadia $attribution_openmaptiles $attribution_osm",
		"referrerPolicy" => "origin",
	)
)

# ╔═╡ 30b61543-72f5-4ae4-8167-4631e0556ddd
stadia_outdoors_tile_layer = TileLayer(
	"https://tiles.stadiamaps.com/tiles/outdoors/{z}/{x}/{y}{r}.png",
	Dict(
		"maxZoom" => 20,
		"attribution" =>  "$attribution_stadia $attribution_openmaptiles $attribution_osm",
		"referrerPolicy" => "origin",
	)
)

# ╔═╡ 34730e40-b5b7-4f90-85e5-7eeb09a1fc8a
stadia_stamen_toner_tile_layer = TileLayer(
	"https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}{r}.png",
	Dict(
		"maxZoom" => 20,
		"attribution" =>  "$attribution_stadia $attribution_stamen $attribution_openmaptiles $attribution_osm",
		"referrerPolicy" => "origin",
	)
)

# ╔═╡ 14b2f1b1-32d3-400c-9c69-6d348d795592
stadia_stamen_watercolor_tile_layer = TileLayer(
	"https://tiles.stadiamaps.com/tiles/stamen_watercolor/{z}/{x}/{y}.jpg",
	Dict(
		"maxZoom" => 16,
		"attribution" =>  "$attribution_stadia $attribution_stamen $attribution_openmaptiles $attribution_osm",
		"referrerPolicy" => "origin",
	)
)

# ╔═╡ da8fca16-2e46-40ae-a67c-b7d54178be43
"""
Tile layers that retrieve tiles from Stadia Maps.

See [the documentation of Stadia Maps](https://docs.stadiamaps.com/) for more information about their terms of service.

## Styles

- `osm_bright`: similar to the OpenStreetMap layout.
- `outdoors`: similar to `osm_bright`, but puts more focus on things like parks, hiking trails, mountains, etc.
- `stamen_toner`: a high-contrast, black and white style.
- `stamen_watercolor`: looks like a watercolour painting.

## Authentication

Requests to Stadia Maps are not authenticated and do not contain an API key.

At the time of writing, Stadia Maps allows unauthenticated requests from `localhost`, such as those from a local Pluto notebook. If you want to host your notebook online, you should request an API key from Stadia Maps and create a `TileLayer` that uses your API key. 
"""
stadia_tile_layers = (
	osm_bright = stadia_osm_bright_tile_layer,
	outdoors = stadia_outdoors_tile_layer,
	stamen_toner = stadia_stamen_toner_tile_layer,
	stamen_watercolor = stadia_stamen_watercolor_tile_layer,
)

# ╔═╡ b0f4b7d6-c2fd-4f6d-ad9e-77ede10b5d11
md"""
## MapPicker
"""

# ╔═╡ 34a08f16-4269-4801-931b-03a1f033328c
map_picker_instructions = """
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

# ╔═╡ 3c1c32ec-f5c7-4527-8e8a-2261f1a05847
"""
Create an interactive map to pick a location.

Basic usage in a Pluto notebook:

```julia
@bind place MapPicker(0.0, 0.0, 1)
```

Uses [Leaflet](https://leafletjs.com/) to render a map. By default, the map uses tiles from OpenStreetMap. Please read OSM's [usage policy](https://operations.osmfoundation.org/policies/tiles/).

Users can place a marker on the map to select a location. If you use `@bind` in Pluto, your bound variable will receive the coordinates in a `Dict` with keys `"lat"` and `"lng"`, or `nothing` if no marker has been placed.

Input:

You have to supply the latitude and longitude that the map should initially centre on, as well as the initial zoom level.

Additional parameters:
- `tile_layer`: a `TileLayer` configuration.
- `height`: height of the map in pixels.
"""
function MapPicker(
	latitude::Number, longitude::Number, zoom::Number;
	tile_layer::TileLayer = osm_tile_layers.standard,
	height::Number = 500,
)::HypertextLiteral.Result
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
				alert($map_picker_instructions);
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
				let target = e.originalEvent.target;
				
				if (target.id === 'map') {
					if (key === 'Enter') {
						addMarker(map.getCenter());
					}
					if (key === 'Delete') {
						if (marker) {
							removeMarker(marker);
						}
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

# ╔═╡ 393f9939-6b71-4c49-907c-0c819cc45f9b
@bind place2 MapPicker(52.0915, 5.116, 12)

# ╔═╡ b2af50d6-c7c8-41b2-8ac4-86ae54caf98c
@bind place MapPicker(52.0915, 5.116, 12)

# ╔═╡ 2d3d6924-ca22-4ea9-98bd-a195d8abec99
place

# ╔═╡ 396475cb-2a4e-4f5a-8fce-af8535f2c157
md"""
## MapPickerMultiple
"""

# ╔═╡ 92f5e0cd-a4bc-4bbf-baf8-bcc6a5f93fa2
map_picker_multiple_instructions = """
Place markers on the map!

Mouse controls:
- Click on the map to remove a marker
- Click on a marker to remove it

Keyboard controls:
- When focused on the map, press Enter to create a marker, and Delete to remove all markers
- When focused on a marker, press Delete to remove it
"""

# ╔═╡ 9c9b2151-765f-422c-84bb-669aaf8c424b
"""
Create an interactive map to pick multiple locations

Basic usage in a Pluto notebook:
```julia
@bind places MapPickerMultiple(0.0, 0.0, 1)
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
	tile_layer::TileLayer = osm_tile_layers.standard,
	height::Number = 500,
)::HypertextLiteral.Result
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
				alert($map_picker_multiple_instructions);
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
				let key = e.originalEvent.key;
				if (key === 'Delete') {
					removeMarker(marker);
				}
			}

			function onMapClick(e) {
				addMarker(e.latlng);
			}

			function onMapKeydown(e) {
				let key = e.originalEvent.key;
				let target = e.originalEvent.target;

				if (target.id === 'map') {
					if (key === 'Enter') {
						addMarker(map.getCenter());
					}
					if (key === 'Delete') {
						removeAllMarkers();
					}				
				}
			}

			map.on('click', onMapClick);
			map.on('keydown', onMapKeydown);
		</script>
	</div>
	"""
end

# ╔═╡ 9e3d29d9-3447-40c5-a480-f49cfe668d82
@bind places MapPickerMultiple(52.0915, 5.116, 12)

# ╔═╡ 1e2075fe-0479-4348-b6f7-732c958ae35a
places

# ╔═╡ 3bea7d19-ea4e-4dc3-826d-6228c62e39da
export TileLayer, osm_tile_layer, osm_tile_layers, stadia_tile_layers, MapPicker, MapPickerMultiple

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

julia_version = "1.6.7"
manifest_format = "2.0"
project_hash = "5b37abdf7398dc5da4cd347d0609990238d895bb"

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
# ╟─a09bf4e8-270e-4331-9961-b27513efdf72
# ╠═784a312f-2da7-4d16-b9eb-85760c9e98be
# ╠═b756ba60-99bc-4825-8b73-dec91139f52b
# ╠═370d3360-2891-458a-bc7a-fd2bc9801ec2
# ╠═3b1fdb24-81f9-46b1-8450-9ceae2204556
# ╠═da8fca16-2e46-40ae-a67c-b7d54178be43
# ╠═393f9939-6b71-4c49-907c-0c819cc45f9b
# ╠═c0ab32a2-20f8-412b-a345-64cde911a7ba
# ╠═30b61543-72f5-4ae4-8167-4631e0556ddd
# ╠═34730e40-b5b7-4f90-85e5-7eeb09a1fc8a
# ╠═14b2f1b1-32d3-400c-9c69-6d348d795592
# ╠═e248e1dc-6aa6-4bfb-aba8-5ec9be8ed87a
# ╠═6e90fd7e-e4b6-4883-8ad5-6eb4341cc6b4
# ╠═4e8e3342-5b83-4849-a4c6-443dd2013ee8
# ╠═2e42276e-3f5a-4a9e-a905-24e618a705be
# ╟─b0f4b7d6-c2fd-4f6d-ad9e-77ede10b5d11
# ╠═34a08f16-4269-4801-931b-03a1f033328c
# ╠═3c1c32ec-f5c7-4527-8e8a-2261f1a05847
# ╠═b2af50d6-c7c8-41b2-8ac4-86ae54caf98c
# ╠═2d3d6924-ca22-4ea9-98bd-a195d8abec99
# ╟─396475cb-2a4e-4f5a-8fce-af8535f2c157
# ╠═92f5e0cd-a4bc-4bbf-baf8-bcc6a5f93fa2
# ╠═9c9b2151-765f-422c-84bb-669aaf8c424b
# ╠═9e3d29d9-3447-40c5-a480-f49cfe668d82
# ╠═1e2075fe-0479-4348-b6f7-732c958ae35a
# ╠═3bea7d19-ea4e-4dc3-826d-6228c62e39da
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
