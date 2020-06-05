// Cartesian Polar conversions

use <approx_equal.scad>
use <triangle.scad>

// Returns the polar coordinates as [magnitude, angle] of a point
// in cartesian coordinates [x, y]
function cartesianToPolar(points, center) =
    let(
        cp = centerPoint(points, center),
        //ecp = echo("cp=", cp),
        x = cp[0],
        //ex = echo("x=", x),
        y = cp[1],
        //ey = echo("y=", y),
        mag = sqrt(x * x + y * y),
        //emag = echo("mag=", mag),
        qa = quadrantAdjustment([x, y]),
        angle=(x == 0) ? ((y == 0) ? 0 : atan(y / x) + qa) : (atan(y / x) + qa),
        //eangle = echo("angle=", angle),
        polar = [mag, angle]
        //evector = echo("polar=", polar)
    ) polar;

// Returns the cartesian coordinates as [x, y] of a point
// in polar coordinates [magnitude, angle].
function polarToCartesian(points, center) =
    let(
        cp = centerPoint(points, center),
        //ecp = echo("cp=", cp),
        mag = cp[0],
        //emag = echo("mag=", mag),
        angle = cp[1],
        //eangle = echo("angle=", angle),

        x = mag * cos(angle),
        //ex = echo("x=", x),
        y = mag * sin(angle),
        //ey = echo("y=", y),

        cartesian = [x, y]
        //ecartesian = echo("cartesian=", cartesian)
    ) cartesian;

function quadrantIndex(point) =
    let(
        x=point[0],
        y=point[1],
        index=((x >= 0) && (y >= 0)) ? 0 :
        ((x < 0) && (y >= 0)) ? 1 :
        ((x < 0) && (y < 0)) ? 2 : 3
        //eindex = echo("quadrantIndex=", index)
    ) index;

function quadrantAdjustment(point) =
    let(
        adjustments=[0, 180, 180, 360],
        adjustment = adjustments[quadrantIndex(point)]
        //emultiplier = echo("quadrantAdjustment=", adjustment)
    ) adjustment;

module cartesianToPolarTest() {
    assert(cartesianToPolar([[0,0]], 0) == [0, 0]);
    assert(cartesianToPolar([[1,0]], 0) == [1, 0]);
    assert(cartesianToPolar([[1,1]], 0) == [sqrt(2), 45]);
    assert(cartesianToPolar([[0,1]], 0) == [1, 90]);
    assert(cartesianToPolar([[-1,1]], 0) == [sqrt(2), 90 + 45]);
    assert(cartesianToPolar([[-1,0]], 0) == [1, 180]);
    assert(cartesianToPolar([[-1,-1]], 0) == [sqrt(2), 180 + 45]);
    assert(cartesianToPolar([[0,-1]], 0) == [1, 270]);
    assert(cartesianToPolar([[1,-1]], 0) == [sqrt(2), 270 + 45]);
    assert(cartesianToPolar([[1,0]], 0) == [1, 0]);
    assert(cartesianToPolar([[0,0]], 0) == [0, 0]);
}
cartesianToPolarTest();

module polarToCartesianTest() {
    assert(polarToCartesian([[0,0]], 0) == [0, 0]);
    assert(polarToCartesian([[1,0]], 0) == [1, 0]);
    assert(let(
        pt = polarToCartesian([[sqrt(2), 45]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, 1) && approx_equal(y, 1)
    ) r);
    assert(let(
        pt = polarToCartesian([[1, 90]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, 0) && approx_equal(y, 1)
    ) r);
    assert(let(
        pt = polarToCartesian([[sqrt(2), 90 + 45]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, -1) && approx_equal(y, 1)
    ) r);
    assert(let(
        pt = polarToCartesian([[1, 180]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, -1) && approx_equal(y, 0)
    ) r);
    assert(let(
        pt = polarToCartesian([[sqrt(2), 180 + 45]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, -1) && approx_equal(y, -1)
    ) r);
    assert(let(
        pt = polarToCartesian([[1, 270]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, 0) && approx_equal(y, -1)
    ) r);
    assert(let(
        pt = polarToCartesian([[sqrt(2), 270 + 45]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, 1) && approx_equal(y, -1)
    ) r);
    assert(let(
        pt = polarToCartesian([[sqrt(2), 45]], 0),
        x = pt[0],
        y = pt[1],
        r = approx_equal(x, 1) && approx_equal(y, 1)
    ) r);
    assert(polarToCartesian([[0,0]], 0) == [0, 0]);
}
polarToCartesianTest();