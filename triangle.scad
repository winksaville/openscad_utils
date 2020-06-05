use <approx_equal.scad>;

// OpenSCAD uses Clockwise (CW) winding for
// normals pointing outward.
//
// Nomencalture; assumes viewer is at cp
// and facing the opposite line:
//   CW: cp, lp, rp   FYI CCW: cp, rp, lp
//
//    left pt  opposite line right pt
//          lp  -----------  rp
//              \    |    /
//               \   |h  /
// left line  ll  \  |  / rl  right line
//                 \ | /
//                  \|/
//                   v
//                   cp
//               center Pt
//
// Clockwise: cp ,    lp   ,   rp
trih1b2 = [[ 0, -1], [-1, 0], [1, 0]];

//                   cp
//                   ^
//                 / |\
//               /   | \
//         rl  /     |  \  ll
//           /       |h  \ 
//         /         |    \
//        ------------------
//      rp         ol       lp
//
// Clockwise: cp ,    lp  ,   rp
trih1b4 = [[ 1, 1], [2, 0], [-2, 0]];

function centerIndex(points, center=0) = center;
function centerPoint(points, center=0) = points[centerIndex(points, center)];
function oppositeLine(points, center=0) = [leftPoint(points, center), rightPoint(points, center)];

function nextIndex(points, center=0) = center+1 >= len(points) ? 0 : center+1;
function nextPoint(points, center=0) = points[nextIndex(points, center)];
function nextLine(points, center=0) = [centerPoint(points, center), nextPoint(points, center)];

function leftIndex(points, center=0) = nextIndex(points, center);
function leftPoint(points, center=0) = points[leftIndex(points, center)];
function leftLine(points, center=0) = [centerPoint(points, center), leftPoint(points, center)];

function rightIndex(points, center=0) = nextIndex(points, center=nextIndex(points, center));
function rightPoint(points, center=0) = points[rightIndex(points, center)];
function rightLine(points, center=0) = [centerPoint(points, center), rightPoint(points, center)];

module centerLeftRightTest(points) {
    for (i=[0: 1 : len(points) - 1]) {
        //echo("i=",i);
        assert(centerIndex(points, i) == i);
        assert(centerPoint(points, i) == points[i]);

        left_index = i+1 >= len(points) ? 0 : i+1;
        //echo("left_index=", left_index);
        //echo("leftIndex=", leftIndex(points, i));
        assert(leftIndex(points, i) == left_index);
        assert(leftPoint(points, i) == points[left_index]);

        right_index = left_index+1 >= len(points) ? 0 : left_index+1;
        //echo("right_index=", right_index);
        //echo("rightIndex=", rightIndex(points, i));
        assert(rightIndex(points, i) == right_index);
        assert(rightPoint(points, i) == points[right_index]);
    }
}
centerLeftRightTest(trih1b2);
centerLeftRightTest(trih1b4);

// Returns a point = points[pt2Idx] - points[pt1Idx]
function pointDiff(points, pt1Idx, pt2Idx) =
    points[pt2Idx] - points[pt1Idx];


// Returns the length of the formed by center and its left point.
// By our nomenclature that is the left line.
function lineLength(points, center=0) =
    let (
        ptDiff = pointDiff(points, center, nextIndex(points, center)),
        ll=sqrt(ptDiff[0] * ptDiff[0] + ptDiff[1] * ptDiff[1])) ll;

// Return the length of the left line
function leftLineLength(points, center=0) =
    let (line=leftLine(points, center), len=lineLength(line)) len;

// Return the length of the right line
function rightLineLength(points, center=0) =
    let (line=rightLine(points, center), len=lineLength(line)) len;

// Return the length of the opposite line
function oppositeLineLength(points, center=0) =
    let (line=oppositeLine(points, center), len=lineLength(line)) len;

module lineLengthTest() {
    let (line=[[0, 0], [0, 0]]) assert(lineLength(line) == 0);
    let (line=[[0, 0], [0, 1]]) assert(lineLength(line) == 1);
    let (line=[[0, 0], [1, 0]]) assert(lineLength(line) == 1);
    let (line=[[0, 0], [1, 1]]) assert(lineLength(line) == sqrt(2));
    let (line=[[0, 0], [0, -1]]) assert(lineLength(line) == 1);
    let (line=[[0, 0], [-1, 0]]) assert(lineLength(line) == 1);
    let (line=[[0, 0], [-1, -1]]) assert(lineLength(line) == sqrt(2));

    let (line=leftLine(trih1b2, center=0)) assert(lineLength(line, 0) == sqrt(2));
    let (len=leftLineLength(trih1b2, center=0)) assert(len == sqrt(2));
    let (line=rightLine(trih1b2, center=0)) assert(lineLength(line, 0) == sqrt(2));
    let (len=rightLineLength(trih1b2, center=0)) assert(len == sqrt(2));
    let (line=oppositeLine(trih1b2, center=0)) assert(lineLength(line, 0) == 2);
    let (len=oppositeLineLength(trih1b2, center=0)) assert(len == 2);

    let (line=leftLine(trih1b2, center=1)) assert(lineLength(line, 0) == 2);
    let (len=leftLineLength(trih1b2, center=1)) assert(len == 2);
    let (line=rightLine(trih1b2, center=1)) assert(lineLength(line, 0) == sqrt(2));
    let (len=rightLineLength(trih1b2, center=1)) assert(len == sqrt(2));
    let (line=oppositeLine(trih1b2, center=1)) assert(lineLength(line, 0) == sqrt(2));
    let (len=oppositeLineLength(trih1b2, center=1)) assert(len == sqrt(2));

    let (line=leftLine(trih1b2, center=2)) assert(lineLength(line, 0) == sqrt(2));
    let (len=leftLineLength(trih1b2, center=2)) assert(len == sqrt(2));
    let (line=rightLine(trih1b2, center=2)) assert(lineLength(line, 0) == 2);
    let (len=rightLineLength(trih1b2, center=2)) assert(len == 2);
    let (line=oppositeLine(trih1b2, center=2)) assert(lineLength(line, 0) == sqrt(2));
    let (len=oppositeLineLength(trih1b2, center=2)) assert(len == sqrt(2));

    let (line=leftLine(trih1b4, center=0)) assert(lineLength(line, 0) == sqrt(2));
    let (len=leftLineLength(trih1b4, center=0)) assert(len == sqrt(2));
    let (line=rightLine(trih1b4, center=0)) assert(approx_equal(lineLength(line, 0), sqrt((1*1) + (3*3))));
    let (len=rightLineLength(trih1b4, center=0)) assert(approx_equal(len, sqrt((1*1) + (3*3))));
    let (line=oppositeLine(trih1b4, center=0)) assert(lineLength(line, 0) == 4);
    let (len=oppositeLineLength(trih1b4, center=0)) assert(len == 4);

    let (line=leftLine(trih1b4, center=1)) assert(lineLength(line, 0) == 4);
    let (len=leftLineLength(trih1b4, center=1)) assert(len == 4);
    let (line=rightLine(trih1b4, center=1)) assert(lineLength(line, 0) == sqrt(2));
    let (len=rightLineLength(trih1b4, center=1)) assert(len == sqrt(2));
    let (line=oppositeLine(trih1b4, center=1)) assert(approx_equal(lineLength(line, 0), sqrt((1*1) + (3*3))));
    let (len=oppositeLineLength(trih1b4, center=1)) assert(approx_equal(len, sqrt((1*1) + (3*3))));

    let (line=leftLine(trih1b4, center=2)) assert(approx_equal(lineLength(line, 0), sqrt((1*1) + (3*3))));
    let (len=leftLineLength(trih1b4, center=2)) assert(approx_equal(len, sqrt((1*1) + (3*3))));
    let (line=rightLine(trih1b4, center=2)) assert(lineLength(line, 0) == 4);
    let (len=rightLineLength(trih1b4, center=2)) assert(len == 4);
    let (line=oppositeLine(trih1b4, center=2)) assert(lineLength(line, 0) == sqrt(2));
    let (len=oppositeLineLength(trih1b4, center=2)) assert(len == sqrt(2));
}
lineLengthTest();

// Returns the perimeter of the triangle
function triPerimeter(points, center=0) =
    lineLength(leftLine(points,center)) + lineLength(rightLine(points,center)) + lineLength(oppositeLine(points,center));

module triPerimeterTest() {
    assert(triPerimeter(trih1b2) == (2 * sqrt(2)) + 2);
    assert(triPerimeter(trih1b2,0) == (2 * sqrt(2)) + 2);
    assert(triPerimeter(trih1b2,1) == (2 * sqrt(2)) + 2);
    assert(triPerimeter(trih1b2,2) == (2 * sqrt(2)) + 2);

    assert(approx_equal(triPerimeter(trih1b4), (sqrt((1*1) + (3*3)) + sqrt(2) + 4)));
    assert(approx_equal(triPerimeter(trih1b4, 0), (sqrt((1*1) + (3*3)) + sqrt(2) + 4)));
    assert(approx_equal(triPerimeter(trih1b4, 1), (sqrt((1*1) + (3*3)) + sqrt(2) + 4)));
    assert(approx_equal(triPerimeter(trih1b4, 2), (sqrt((1*1) + (3*3)) + sqrt(2) + 4)));
}
triPerimeterTest();

// Returns the area of the triangle
function triArea(points, center=0) =
    // Heron's formula
    let(s=triPerimeter(points) / 2,
        area=sqrt(s *
                (s - lineLength(leftLine(points, center))) *
                (s - lineLength(rightLine(points, center))) *
                (s - lineLength(oppositeLine(points, center))))) area;

module triAreaTest() {
    assert(approx_equal(triArea(trih1b2), 1));
    assert(approx_equal(triArea(trih1b2, 0), 1));
    assert(approx_equal(triArea(trih1b2, 1), 1));
    assert(approx_equal(triArea(trih1b2, 2), 1));

    assert(approx_equal(triArea(trih1b4), 2));
    assert(approx_equal(triArea(trih1b4, 0), 2));
    assert(approx_equal(triArea(trih1b4, 1), 2));
    assert(approx_equal(triArea(trih1b4, 2), 2));
}
triAreaTest();

// Returns the height of the triangle from center pt
// to opposiite line
function triHeight(points, center=0) =
    //let (
    //    area=triArea(points, center),
    //    //earea=echo("triHeight: area=", area),
    //    ol=oppositeLine(points, center),
    //    //eol=echo("triHeight: ol=", ol),
    //    length=lineLength(ol),
    //    //elength=echo("triHeight: length=", length),
    //    height=2 * area / length,
    //    eheight=echo("triHeight: height=", height)) height;
    2 * triArea(points, center) / lineLength(oppositeLine(points, center));

module triHeightTest() {
    assert(approx_equal(triHeight(points=trih1b2), 1));
    assert(approx_equal(triHeight(points=trih1b2, center=0), 1));
    assert(approx_equal(triHeight(points=trih1b2, center=1), sqrt(2)));
    assert(approx_equal(triHeight(points=trih1b2, center=2), sqrt(2)));

    assert(approx_equal(triHeight(points=trih1b4), 1));
    assert(approx_equal(triHeight(points=trih1b4, center=0), 1));
    assert(approx_equal(triHeight(points=trih1b4, center=1), let(cpa1=45+atan(1/3), h1=sqrt(2) * sin(cpa1)) h1));
    assert(approx_equal(triHeight(points=trih1b4, center=2), 4 * 1/sqrt(2)));
}
triHeightTest();


// Returns the angle at the center point formed by the
// left and right lines.
function triAngle(points, center) =
    // Use "law of cosines" https://en.wikipedia.org/wiki/Law_of_cosines
    //  ol^2 = ll^2 + rl^2 - (2 * ll * rl * cos(cpAngle))
    //  cpAngle = acos((ll^2 + rl^2 + ol^2) / (2 * ll * rl))
   let(
        ol=lineLength(oppositeLine(points, center)),
        //eol=echo("ol=",ol),
        ll=lineLength(leftLine(points, center)),
        //ell=echo("ll=",ll),
        rl=lineLength(rightLine(points, center)),
        //erl=echo("rl=",rl),
        ol2=ol*ol,
        //eol2=echo("ol2=",ol2),
        ll2=ll*ll,
        //ell2=echo("ll2=",ll2),
        rl2=rl*rl,
        //erl2=echo("rl2=",rl2),
        cpAngle=acos((ll2 + rl2 - ol2)/(2 * ll * rl))
        //eangle=echo("cpAngle=", cpAngle)
    ) cpAngle;

module angleTest() {
    precision=0.0000000000001;
    assert(approx_equal(triAngle(trih1b2, 0), 90, precision));
    assert(approx_equal(triAngle(trih1b2, 1), 45, precision));
    assert(approx_equal(triAngle(trih1b2, 2), 45, precision));

    a0=triAngle(trih1b4, 0);
    a1=triAngle(trih1b4, 1);
    a2=triAngle(trih1b4, 2);
    assert(approx_equal(a0 + a1 + a2, 180, precision));
}
angleTest();