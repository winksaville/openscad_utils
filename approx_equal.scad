function approx_equal(v1, v2, precision=0.00000000000001) =
    abs(v1 - v2) <= precision;
