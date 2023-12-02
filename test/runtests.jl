using PlutoMapPicker
using HypertextLiteral
using Test

@testset "PlutoMapPicker.jl" begin
    @test typeof(PlutoMapPicker.MapPicker(0.0, 0.0, 1)) == HypertextLiteral.Result
    @test typeof(PlutoMapPicker.MapPickerMultiple(0.0, 0.0, 1)) == HypertextLiteral.Result
    @test typeof(PlutoMapPicker.osm_tile_layer) == PlutoMapPicker.TileLayer
end
