
use <approx_equal.scad>
use <cartesian_polar.scad>
use <triangle.scad>

trih1b2 = [[0,-1], [-1, 0], [1,0]];
trih1b4 = [[1,1], [2, 0], [-2,0]];

function xDistanceToLeftPoint(points, center) =
    points[nextIndex(points, center)][0] - points[center][0];

function yDistanceToLeftPoint(points, center) =
    points[nextIndex(points, center)][1] - points[center][1];


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
    //echo("shellize:+");
    innerPoints = [ for (i=[0:len(points)-1])
                let( 
                    //ei = echo("i=", i),
                    cp = centerPoint(points, i),
                    //ecp = echo("cp=", cp),
                    cpa = triAngle(points, i),
                    //ecpa = echo("cpa=", cpa),
                    halfCpa = cpa / 2,
                    //ehalfCpa = echo("halfCpa=", halfCpa),
                    xDistToLeftPt = xDistanceToLeftPoint(points, i),
                    //exDistToLeftPt = echo("xDistToLeftPt=", xDistToLeftPt),
                    yDistToLeftPt = yDistanceToLeftPoint(points, i),
                    //eyDistLeftPt = echo("yDistToLeftPt=", yDistToLeftPt),
                    s1 = thickness / sin(halfCpa),
                    //es1 = echo("s1=", s1),
                    lpPolar = cartesianToPolar([[xDistToLeftPt, yDistToLeftPt]], 0),
                    //elpPolar = echo("lpPolar=", lpPolar),
                    a1 = lpPolar[1] - halfCpa,
                    //ea1 = echo("a1=", a1),
                    x1 = s1 * cos(a1),
                    //ex1 = echo("x1=", x1),
                    y1 = s1 * sin(a1),
                    //ey1 = echo("y1=", y1),
                    point = cp + [x1, y1]
                    //point = [cp[0] + x1, cp[1] + y1],
                    //e=echo("shellize: point=", point)
                ) point];
    //echo("shellize: innerPoints=", innerPoints);
    allPoints=concat(points,innerPoints);
    //echo("shellize: allPoints=", allPoints);
    outerPath=[for(i=[0:1:len(points)-1]) i];
    //echo("shellize: outerPath=", outerPath);
    innerPath=[for(i=[len(points):1:len(points) + len(innerPoints) - 1]) i];
    //echo("shellize: innerPath=", innerPath);
    paths=[outerPath, innerPath];
    //echo("shellize: paths=", paths);
    //polygon(allPoints, [outerPath]);
    //polygon(allPoints, [innerPath]);
    polygon(allPoints, paths);
    //echo("shellize:-");
}

module shellizeTest() {
      // TODO: Add tests, right now just visualizing
      //shellize(trih1b2, 0.1);
      shellize(trih1b4, 0.1);

}
shellizeTest();