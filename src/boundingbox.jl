function measure_components(property::BoundingBoxProperties, labels::AbstractArray; N::Int = 0)
    if N == 0
        N = maximum(labels)
    end
    init = StepRange(typemax(Int),-1,-typemax(Int))
    coords = [(init, init) for i = 1:N]

    for i in CartesianIndices(labels)
        l = labels[i]
        if  l != 0
            rs, cs = coords[l]
            rs = i[1] < first(rs) ? StepRange(i[1], 1, last(rs)) : rs
            rs = i[1] > last(rs) ? StepRange(first(rs), 1, i[1]) : rs
            cs = i[2] < first(cs) ? StepRange(i[2], 1, last(cs)) : cs
            cs = i[2] > last(cs) ? StepRange(first(cs), 1, i[2]) : cs
            coords[l] = rs, cs
        end
    end
    coords_matrix = reshape(reinterpret(StepRange{Int,Int},coords),(2,N))
    t = table(Base.OneTo(N), view(coords_matrix,1,:), view(coords_matrix,2,:) ; names = [:l, :r, :c])
    #t = table(view(coords_matrix,1,:), view(coords_matrix,2,:) ; names = [:r, :c])
    fill_properties!(property, t)

end

function fill_properties!(property::BoundingBoxProperties, t::IndexedTable)
    property.box_area ? compute_box_area!(t) : t
end

function compute_box_area!(t::IndexedTable)
    @transform t {box_area = length(:r) *  length(:c)}
end
