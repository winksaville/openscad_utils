
use <approx_equal.scad>
use <cartesian_polar.scad>
use <triangle.scad>

trih1b2 = [[0,-1], [-1, 0], [1,0]];
trih1b4 = [[1,1], [2, 0], [-2,0]];


//rotate(-10)
//translate([-10, -5])
//translate([10, 5])
//rotate(10)
// polygon(trih1b2);

function xDistanceToLeftPoint(points, center) =
    points[nextIndex(points, center)][0] - points[center][0];

// Return 1 if the direction along the X-axis
// from center to the left point is positive,
// else return -1.
function xSignToLeftPoint(points, center) =
    //xDistanceToLeftPoint(points, center) >= 0 ? 1 : -1;
    let(dist=xDistanceToLeftPoint(points, center),
        sign=dist >= 0 ? 1 : -1,
        esign=echo("xSign=", sign, "xDist=", dist)
    ) sign;

function yDistanceToLeftPoint(points, center) =
    points[nextIndex(points, center)][1] - points[center][1];

// Return 1 if the direction along the X-axis
// from center to the left point is positive,
// else return -1.
function ySignToLeftPoint(points, center) =
    //yDistanceToLeftPoint(points, center) >= 0 ? 1 : -1;
    let(dist=yDistanceToLeftPoint(points, center),
        sign=dist >= 0 ? 1 : -1,
        esign=echo("ySign=", sign, "yDist=", dist)
    ) sign;

function signsEqual(v1, v2) = (((v1 >= 0) && (v2 >= 0)) || ((v1 < 0) && (v2 < 0)));


// take a set of points which define the outside of a
// solid and create a shell.
module playAround(points, thickness) {
    echo("playaround:+");

    // Translate points to the origin by subtracting
    // centerPoint (cp) from every point
    echo("points", points);
    trans=centerPoint(points);
    npoints = [for(i=[0:len(points)-1]) points[i] - trans];
    echo("npoints=", npoints);
    polygon(npoints);

    // rotate every point by 10deg around the origin which
    // is where centerPoint(points, 0) is, so we don't need
    // to rotate it
    changeInAngle = -10;
    rpoints = [[0, 0], for(i=[1:len(npoints)-1])
        let(
            polar = cartesianToPolar(npoints, i),
            newAngle = polar[1] + changeInAngle,
            enewAngle = echo("newAngle=", newAngle),
            xNew = polar[0] * cos(newAngle),
            exNew = echo("xNew=", xNew),
            yNew = polar[0] * sin(newAngle),
            eyNew = echo("yNew=", yNew),
            rpoint = [xNew, yNew],
            erpoint = echo("rpoint=", rpoint)
        ) rpoint];
    echo("rpoints=", rpoints);
    polygon(rpoints);

    cpa = triAngle(points, 0);
    ecpa = echo("cpa=", cpa);
    halfCpa = cpa / 2;
    ehalfCpa = echo("halfCpa=", halfCpa);

    echo("playaround:-");
}
//playAround(trih1b4, 0.1);

// take a set of points which define the outside of a
// solid and create a shell.
module shellize(points, thickness) {
    echo("shellize:+");
    innerPoints = [ for (i=[0:len(points)-1])
                let( 
                    ei = echo("i=", i),
                    cp = centerPoint(points, i),
                    ecp = echo("cp=", cp),
                    cpa = triAngle(points, i),
                    ecpa = echo("cpa=", cpa),
                    halfCpa = cpa / 2,
                    ehalfCpa = echo("halfCpa=", halfCpa),
                    xDistToLeftPt = xDistanceToLeftPoint(points, i),
                    exDistToLeftPt = echo("xDistToLeftPt=", xDistToLeftPt),
                    yDistToLeftPt = yDistanceToLeftPoint(points, i),
                    eyDistLeftPt = echo("yDistToLeftPt=", yDistToLeftPt),
                    s1 = thickness / sin(halfCpa),
                    es1 = echo("s1=", s1),
                    lpPolar = cartesianToPolar([[xDistToLeftPt, yDistToLeftPt]], 0),
                    elpPolar = echo("lpPolar=", lpPolar),
                    a1 = lpPolar[1],
                    ea1 = echo("a1=", a1),
                    x1 = s1 * sin(a1),
                    ex1 = echo("x1=", x1),
                    y1 = s1 * cos(a1),
                    ey1 = echo("y1=", y1),
                    point = cp + [x1, y1],
                    e=echo("shellize: point=", point)
                ) point];
    echo("shellize: innerPoints=", innerPoints);
    allPoints=concat(points,innerPoints);
    echo("shellize: allPoints=", allPoints);
    outerPath=[for(i=[0:1:len(points)-1]) i];
    echo("shellize: outerPath=", outerPath);
    innerPath=[for(i=[len(points):1:len(points) + len(innerPoints) - 1]) i];
    echo("shellize: innerPath=", innerPath);
    paths=[outerPath, innerPath];
    echo("shellize: paths=", paths);
    //polygon(allPoints, [outerPath]);
    //polygon(allPoints, [innerPath]);
    polygon(allPoints, paths);
    echo("shellize:-");
}
//// take a set of points which define the outside of a
//// solid and create a shell.
//module shellize(points, thickness) {
//    echo("shellize:+");
//    innerPoints = [ for (i=[0:len(points)-1])
//                let( 
//                    ei = echo("i=", i),
//                    cpa = triAngle(points, i),
//                    ecpa = echo("cpa=", cpa),
//                    halfCpa = cpa / 2,
//                    ehalfCpa = echo("halfCpa=", halfCpa),
//                    xDistToLeftPt = xDistanceToLeftPoint(points, i),
//                    exDistToLeftPt = echo("xDistToLeftPt=", xDistToLeftPt),
//                    yDistToLeftPt = yDistanceToLeftPoint(points, i),
//                    eyDistLeftPt = echo("yDistToLeftPt=", yDistToLeftPt),
//                    lptan = yDistToLeftPt / xDistToLeftPt,
//                    elptan = echo("lptan=", lptan),
//                    signsEq = signsEqual(xDistToLeftPt, yDistToLeftPt),
//                    esignsEq = echo("signsEq=", signsEq),
//                    point = (i < 2) ?
//                        let(
//                            e=echo("i lt 2 i=", i),
//                            lpa = atan(signsEq ? lptan : 1/lptan),
//                            elpa = echo("lpa=", lpa),
//                            a1 = signsEq ? halfCpa - lpa : lpa + halfCpa, // sign issue?
//                            ea1 = echo("a1=", a1),
//                            s1 = thickness / sin(halfCpa),
//                            es1 = echo("s1=", s1),
//                            x1 = s1 * sin(a1),
//                            ex1 = echo("x1=", x1),
//                            y1 = s1 * cos(a1),
//                            ey1 = echo("y1=", y1),
//                            //point = [points[i][0] + ((signsEq ? -1 : 1) * x1),
//                            //            points[i][1] + ((signsEq ? 1 : -1) * y1)],
//                            point = [points[i][0] + (-xSignToLeftPoint(points, i) * x1),
//                                        points[i][1] + (ySignToLeftPoint(points, i) * y1)]) point
//                    :
//                        let(
//                            // This is WRONG but just wanted to see it work!
//                            e=echo("i gt 2 i=", i),
//                            lpa = atan(signsEq ? lptan : 1/lptan),
//                            elpa = echo("lpa=", lpa),
//                            a1 = signsEq ? halfCpa - lpa : lpa + halfCpa, // sign issue?
//                            ea1 = echo("a1=", a1),
//                            s1 = thickness / sin(halfCpa),
//                            es1 = echo("s1=", s1),
//                            x1 = s1 * cos(halfCpa),
//                            ex1 = echo("x1=", x1),
//                            y1 = thickness,
//                            ey1 = echo("y1=", y1),
//                            //point = [points[i][0] + ((signsEq ? -1 : 1) * x1),
//                            //            points[i][1] + ((signsEq ? 1 : -1) * y1)],
//                            point = [points[i][0] + x1, points[i][1] + y1]) point,
//                    e=echo("shellize: i=", i, "cpa=", cpa ,"halfCpa=", halfCpa, "point=", point)
//                ) point];
//    echo("shellize: innerPoints=", innerPoints);
//    allPoints=concat(points,innerPoints);
//    echo("shellize: allPoints=", allPoints);
//    outerPath=[for(i=[0:1:len(points)-1]) i];
//    echo("shellize: outerPath=", outerPath);
//    innerPath=[for(i=[len(points):1:len(points) + len(innerPoints) - 1]) i];
//    echo("shellize: innerPath=", innerPath);
//    paths=[outerPath, innerPath];
//    echo("shellize: paths=", paths);
//    //polygon(allPoints, [outerPath]);
//    //polygon(allPoints, [innerPath]);
//    polygon(allPoints, paths);
//    echo("shellize:-");
//}

module shellizeTest() {
      shellize(trih1b4, 0.1);
}
shellizeTest();

//// take a set of points which define the outside of a
//// solid and create a shell.
//module shellize(points, thickness) {
//    echo("shellize:+");
//    innerPoints = [ for (i=[0:len(points)-1])
//                let( 
//                    pointAngle = triAngle(points, i),
//                    halfAngle = pointAngle / 2,
//                    side = thickness / tan(halfAngle),
//                    point = [points[i][0] + (xSignToLeftPoint(points, i) * side),
//                                points[i][1] + (ySignToLeftPoint(points, i) * thickness)],
//                    e=echo("shellize: i=", i, "pointAngle=", pointAngle ,"halfAngle=", halfAngle, "side=", side, "point=", point)
//                ) point];
//    echo("shellize: innerPoints=", innerPoints);
//    allPoints=concat(points,innerPoints);
//    echo("shellize: allPoints=", allPoints);
//    outerPath=[for(i=[0:1:len(points)-1]) i];
//    echo("shellize: outerPath=", outerPath);
//    innerPath=[for(i=[len(points):1:len(points) + len(innerPoints) - 1]) i];
//    echo("shellize: innerPath=", innerPath);
//    paths=[outerPath, innerPath];
//    echo("shellize: paths=", paths);
//    //polygon(allPoints, [outerPath]);
//    //polygon(allPoints, [innerPath]);
//    polygon(allPoints, paths);
//    echo("shellize:-");
//}