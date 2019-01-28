module ImageComponentAnalysis

using Images, IndexedTables, JuliaDBMeta

abstract type MeasurementProperties end

struct Measurement <: MeasurementProperties
	area::Bool
	perimeter::Bool
end

abstract type BoundingBoxProperties end

struct BoundingBox <: BoundingBoxProperties
	box_area::Bool
end

abstract type ComponentAnalysisAlgorithm end
struct ContourTracing <: ComponentAnalysisAlgorithm end

include("boundingbox.jl")
include("measurement.jl")
include("contour_tracing.jl")

export
	BoundingBox,
	Measurement,
	measure_components,
    label_components,
	ContourTracing
end # module
