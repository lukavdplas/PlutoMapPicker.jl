# PlutoMapPicker

A simple location picker widget for Pluto.jl notebooks. It creates an interactive map using [Leaflet](https://leafletjs.com/).

![screenshot of a pluto notebook showing a cell with "@bind place MapPicker(52.0915, 5.116, 12)". The output of the cell is a map with a marker on it. Another cell shows the value of "place", which contains the coordinates of the marker.](./screenshot.png)

## Prerequisites

PlutoMapPicker is a package for [Julia](https://julialang.org/). It is is designed to be used in [Pluto notebooks](https://github.com/fonsp/Pluto.jl). If you are using Pluto, you're ready to use this package!

### Using PlutoMapPicker outside of Pluto

It is possible to use `PlutoMapPicker` in Julia without Pluto. If you don't have the benefit of Pluto's package manager, you can install it with:

```julia
using Pkg
Pkg.add("PlutoMapPicker")
```

## Usage

PlutoMapPicker is designed to be simple to use. Basic usage looks like this:

```julia
using PlutoMapPicker

# to pick a single location
@bind place MapPicker(0.0, 0.0, 1)

# to pick multiple locations
@bind places MapPickerMultiple(0.0, 0.0, 1)
```

See the docstrings in [map-picker.jl](/src/map-picker.jl) for more detailed documentation.

## Licence

This package is shared under an MIT licence. See [LICENSE](./LICENSE) for more information.

