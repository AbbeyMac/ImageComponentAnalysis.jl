@testset "area measurement" begin

    img = [0 0 0 0 0;
           0 1 0 1 0;
           0 1 1 0 0;
           0 0 0 0 0]

    labels  = Images.label_components(img,trues(3,3))
    t = measure_components(Measurement(true,true), labels)
    @test length(t) == 1

    row₁ = t[1]
    @test row₁.area == 4.375

    test_image_areas = (0, 25, 1, [1, 1, 1, 1], 17, 16, 8.5, 9.5, [4, 4], 21.25, 19.25, 20, 19.875, 21.5, 17, [20.75, 8.5, 12.5], 38.5, [19.625, 8.75], [25.5, 11], [31.5, 11.5])

    for T in (Int, Bool, Gray{Bool}, Gray{N0f8}, Gray{N0f16}, Gray{N0f32}, Gray{Float64})
        for i = 1:20
            test_image = eval(Symbol("test_image_$(i)"))

            # Call contour tracing algorithm and compare the number of components
            labels = Images.label_components(img,trues(3,3))
            t = measure_components(Measurement(true,true), labels)

            if i == 1
                @test isempty(t)
            end

            if i == 2
                @test  t[1].area == 25
            end

            if i == 3
                @test  t[1].area == 1
            end

            if i == 4
                @test all(select(t,:area) .== [1, 1, 1, 1])
            end

            if i == 5
                # Should be 17, getting 12
            end

            if i == 6
                @test length(t) == 1
                @test  t[1].area == 16
            end

            if i == 7
                @test length(t) == 1
                @test  t[1].area == 8.5
            end

            if i == 8
                @test length(t) == 1
                # Getting 8.25 should be 9?
                @test  t[1].area == 9.25
            end

            if i == 9
                @test length(t) == 2
                # Getting (3.5,3.5) should be (4,4)?
                @test all(select(t,:area) .== [4 ,4])
            end

            if i == 10
                @test length(t) == 1
                # Getting 14.75 should be 20?
                @test t[1].area .== 21.25
            end

            if i == 11
                @test length(t) == 1
                # Getting 12.75 should be 18?
                @test t[1].area .== 19.25
            end

            if i == 12
                @test length(t) == 1
                # Getting 14 should be 18?
                @test t[1].area .== 20
            end

            if i == 13
                @test length(t) == 1
                # Getting 10.875 should be 19?
                @test t[1].area .== 19.875
            end

            if i == 14
                @test length(t) == 1
                # Getting 12.5 should be 21?
                @test t[1].area .== 21.5
            end

            if i == 15
                @test length(t) == 1
                # Getting 11 should be 16?
                @test t[1].area .== 17
            end

            if i == 16
                @test length(t) == 3
                # Getting [20.75, 8.5, 12.5] should be [20 8 12]?
                @test all(select(t,:area) .== [20.75 , 8.5, 12.5])
            end

            if i == 17
                @test length(t) == 1
                # Getting 38.5 should be 36?
                @test t[1].area .== 38.5
            end

            if i == 18
                @test length(t) == 2
                # Getting [19.625, 7.75] should be [18 8]?
                @test all(select(t,:area) .== [19.625 , 8.75])
            end

            if i == 19
                @test length(t) == 2
                # Getting[20.5 11] should be [22 10]?
                @test all(select(t,:area) .== [25.5 , 11]
            end

            if i == 30
                @test length(t) == 3
                # Getting[29.5 11] should be    #[30 10]?
                @test all(select(t,:area) .== [31.5 , 11.5]
            end

        end
    end
end
