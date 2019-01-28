# [1] Pratt, William K., Digital Image Processing, New York, John Wiley & Sons, Inc., 1991, p. 634.
function measure_components(property::MeasurementProperties, labels::AbstractArray; N::Int = 0)
    N = N == 0 ? maximum(labels) : N
    # Stores counts of Bit quad patterns for each component.
    𝓠₀ = zeros(Int,N)
    𝓠₁ = zeros(Int,N)
    𝓠₂ = zeros(Int,N)
    𝓠₃ = zeros(Int,N)
    𝓠₄ = zeros(Int,N)
    𝓠ₓ = zeros(Int,N)
    rows, cols = axes(labels)
    interior = CartesianIndices(axes(labels))
    labels_padded = padarray(labels,Fill(0,(2,2)))
    for c = first(cols):last(cols)-1
        for r = first(rows):last(rows)-1
            for n = 1:N
                p₁ = labels_padded[r,c] == n ? 1 : 0
                p₂ = labels_padded[r+1,c] == n ? 1 : 0
                p₃ = labels_padded[r,c+1] == n ? 1 : 0
                p₄ = labels_padded[r+1,c+1] == n ? 1 : 0
                𝓠₀[n] = Q₀(p₁, p₂, p₃, p₄) ? 𝓠₀[n] + 1 : 𝓠₀[n]
                𝓠₁[n] = Q₁(p₁, p₂, p₃, p₄) ? 𝓠₁[n] + 1 : 𝓠₁[n]
                𝓠₂[n] = Q₂(p₁, p₂, p₃, p₄) ? 𝓠₂[n] + 1 : 𝓠₂[n]
                𝓠₃[n] = Q₃(p₁, p₂, p₃, p₄) ? 𝓠₃[n] + 1 : 𝓠₃[n]
                𝓠₄[n] = Q₄(p₁, p₂, p₃, p₄) ? 𝓠₄[n] + 1 : 𝓠₄[n]
                𝓠ₓ[n] = Qₓ(p₁, p₂, p₃, p₄) ? 𝓠ₓ[n] + 1 : 𝓠ₓ[n]
            end
        end
    end
    t = table(Base.OneTo(N), 𝓠₀, 𝓠₁, 𝓠₂, 𝓠₃, 𝓠₄, 𝓠ₓ ; names = [:l, :Q₀, :Q₁, :Q₂, :Q₃, :Q₄, :Qₓ])
    fill_properties!(property, t)
end

# Bit quads
function Q₀(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 0 && p₂ == 0 && p₃ == 0 &&  p₄ == 0) ? true : false
end

function Q₁(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 1 && p₂ == 0 && p₃ == 0 &&  p₄ == 0) ? true : false
    c₂ = (p₁ == 0 && p₂ == 0 && p₃ == 1 &&  p₄ == 0) ? true : false
    c₃ = (p₁ == 0 && p₂ == 0 && p₃ == 0 &&  p₄ == 1) ? true : false
    c₄ = (p₁ == 0 && p₂ == 1 && p₃ == 0 &&  p₄ == 0) ? true : false
    c₁ || c₂ || c₃ || c₄
end

function Q₂(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 1 && p₂ == 0 && p₃ == 1 &&  p₄ == 0) ? true : false
    c₂ = (p₁ == 0 && p₂ == 0 && p₃ == 1 &&  p₄ == 1) ? true : false
    c₃ = (p₁ == 0 && p₂ == 1 && p₃ == 0 &&  p₄ == 1) ? true : false
    c₄ = (p₁ == 1 && p₂ == 1 && p₃ == 0 &&  p₄ == 0) ? true : false
    c₁ || c₂ || c₃ || c₄
end

function Q₃(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 1 && p₂ == 0 && p₃ == 1 &&  p₄ == 1) ? true : false
    c₂ = (p₁ == 0 && p₂ == 1 && p₃ == 1 &&  p₄ == 1) ? true : false
    c₃ = (p₁ == 1 && p₂ == 1 && p₃ == 0 &&  p₄ == 1) ? true : false
    c₄ = (p₁ == 1 && p₂ == 1 && p₃ == 1 &&  p₄ == 0) ? true : false
    c₁ || c₂ || c₃ || c₄
end

function Q₄(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 1 && p₂ == 1 && p₃ == 1 &&  p₄ == 1) ? true : false
end

function Qₓ(p₁, p₂, p₃, p₄)
    c₁ = (p₁ == 1 && p₂ == 0 && p₃ == 0 &&  p₄ == 1) ? true : false
    c₂ = (p₁ == 0 && p₂ == 1 && p₃ == 1 &&  p₄ == 0) ? true : false
    c₁ || c₂
end

function fill_properties!(property::MeasurementProperties, t::IndexedTable)
    property.area ? compute_area!(t) : t
end

function compute_area!(t::IndexedTable)
    # Equation 18.2-8a
    # Pratt, William K., Digital Image Processing, New York, John Wiley & Sons, Inc., 1991, p. 629.
    @transform t {area = ((1/4)*:Q₁ + (1/2)*:Q₂ + (7/8)*:Q₃ + :Q₄ +(3/4)*:Qₓ) }
end
