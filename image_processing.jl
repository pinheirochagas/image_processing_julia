### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 82a1312c-1a0e-11eb-3a88-a96fe91bccfd
begin
	using Images
	using ImageMagick
	using Statistics
	using LinearAlgebra
	using ImageFiltering
end

# ╔═╡ 14233506-1a0e-11eb-0e96-379ae8bb4185


# ╔═╡ 7b795578-1a0e-11eb-35c3-c3c3e9210cb0
Pkg.add(["Images",
		 "ImageMagick",
		 "PlutoUI",
		 "Hyperscript",
		 "ImageFiltering"])|

# ╔═╡ b1c9f3d2-1a0e-11eb-39e6-5d75ced5e13d
img = load("/Users/pinheirochagas/Pedro/Stanford/code/image_processing_julia/mosca_olho.jpg")	

# ╔═╡ cf5d04aa-1a0e-11eb-3171-d55dd31a0945
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ cedbb294-1a0e-11eb-2225-f7b65ac10050
brightness(c::AbstractRGB) = 0.3 * c.r + 0.59 * c.g + 0.11 * c.b

# ╔═╡ ce66cd6a-1a0e-11eb-2d2e-97e627b743d4
function convolve(M, kernel)
    height, width = size(kernel)
    
    half_height = height ÷ 2
    half_width = width ÷ 2
    
    new_image = similar(M)
	
    # (i, j) loop over the original image
	m, n = size(M)
    @inbounds for i in 1:m
        for j in 1:n
            # (k, l) loop over the neighbouring pixels
			accumulator = 0 * M[1, 1]
			for k in -half_height:-half_height + height - 1
				for l in -half_width:-half_width + width - 1
					Mi = i - k
					Mj = j - l
					# First index into M
					if Mi < 1
						Mi = 1
					elseif Mi > m
						Mi = m
					end
					# Second index into M
					if Mj < 1
						Mj = 1
					elseif Mj > n
						Mj = n
					end
					
					accumulator += kernel[k, l] * M[Mi, Mj]
				end
			end
			new_image[i, j] = accumulator
        end
    end
    
    return new_image
end

# ╔═╡ cf228b38-1a0e-11eb-07aa-179ec052056d
function edgeness(img)
	Sy, Sx = Kernel.sobel()
	b = brightness.(img)

	∇y = convolve(b, Sy)
	∇x = convolve(b, Sx)

	sqrt.(∇x.^2 + ∇y.^2)
end

# ╔═╡ ec9b7916-1a0e-11eb-21ea-01b12f1364a5
e = edgeness(img);

# ╔═╡ ec55e536-1a0e-11eb-147f-b3b4cdc72de8
begin 
	i_save = pencil(e)
save("/Users/pinheirochagas/Pedro/Stanford/code/image_processing_julia/mosca_olho_pencil.jpg", i_save)
end

# ╔═╡ Cell order:
# ╠═14233506-1a0e-11eb-0e96-379ae8bb4185
# ╠═7b795578-1a0e-11eb-35c3-c3c3e9210cb0
# ╠═82a1312c-1a0e-11eb-3a88-a96fe91bccfd
# ╠═b1c9f3d2-1a0e-11eb-39e6-5d75ced5e13d
# ╠═ec9b7916-1a0e-11eb-21ea-01b12f1364a5
# ╠═ec55e536-1a0e-11eb-147f-b3b4cdc72de8
# ╟─cf5d04aa-1a0e-11eb-3171-d55dd31a0945
# ╟─cf228b38-1a0e-11eb-07aa-179ec052056d
# ╟─cedbb294-1a0e-11eb-2225-f7b65ac10050
# ╟─ce66cd6a-1a0e-11eb-2d2e-97e627b743d4
