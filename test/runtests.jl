using PlutoMapPicker
using HypertextLiteral
using Test

@testset "PlutoMapPicker.jl" begin
    @testset "tile layers" begin
        @test typeof(PlutoMapPicker.osm_tile_layer) == PlutoMapPicker.TileLayer
        @test typeof(PlutoMapPicker.osm_tile_layers.standard) == PlutoMapPicker.TileLayer
        @test typeof(PlutoMapPicker.stadia_tile_layers.osm_bright) == PlutoMapPicker.TileLayer
    end

    @testset "MapPicker" begin
        @test typeof(PlutoMapPicker.MapPicker(0.0, 0.0, 1)) == HypertextLiteral.Result

        alt_tile_layer = PlutoMapPicker.osm_tile_layers.humanitarian
        @test typeof(PlutoMapPicker.MapPicker(0.0, 0.0, 1; tile_layer = alt_tile_layer)) == HypertextLiteral.Result
    end

    @testset "MapPickerMultiple" begin
        @test typeof(PlutoMapPicker.MapPickerMultiple(0.0, 0.0, 1)) == HypertextLiteral.Result

        alt_tile_layer = PlutoMapPicker.osm_tile_layers.humanitarian
        @test typeof(PlutoMapPicker.MapPickerMultiple(0.0, 0.0, 1; tile_layer = alt_tile_layer)) == HypertextLiteral.Result
    end
end