affine(Right, { [i, j, k] -> [i, j + i, k] } )
affine(Norm, { [i, j, 0] -> [i, j, j] } )
realign(Norm, Right, 3)
realign(Left, Norm, 3)
L = lift(Left, 3)
affine(L, {[i, j, k] -> [i, k, j]})
affine(L, { [i, j, k] -> [i1, j1, k1, i2, j2, k2]: i1 = [i/128] and i2 = i%128 and j1 = [j/128] and j2 = j%128 and k1 = [k/128] and k2 = k%128} )
