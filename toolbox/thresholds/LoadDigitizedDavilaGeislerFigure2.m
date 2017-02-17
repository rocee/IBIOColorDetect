function [A] = LoadDigitizedDavilaGeislerFigure2
%LoadDigitizedDavilaGeislerFigure2   Load ideal observer curve from Figure 2.
%    [A] = LoadDigitizedDavilaGeislerFigure2
%
%    This returns a digitized version of the ideal observer curve in Figure
%    2 (upper left panel, observer WG), from Davila and Geisler (1991),
%    Vision Research, 31, pp. 1369-1380.
%
%    The ideal observer data in the figure curve was shifted up to match the
%    subject data.  The average shift is 1.13 log units, but this differed
%    a bit across observers.  None-the-less, we shift the answer back down by
%    1.13 log units just to make it about right.


digitizedData = [2.233505916813E-1	8.815882843300E0
2.686999802496E-1	8.809811741621E0
3.450223807069E-1	8.726403196171E0
4.383389977575E-1	8.869543179106E0
4.995156662788E-1	9.018685007960E0
6.009866689630E-1	9.090140870685E0
6.998636088268E-1	9.163276789375E0
8.062594148999E-1	9.316980203824E0
9.596289429950E-1	9.472110229022E0
1.154660372025E0	9.629432985406E0
1.315596981932E0	9.624751553300E0
1.450973637829E0	9.704154763857E0
1.635596382178E0	9.867730492471E0
2.100857356852E0	1.011561366566E1
1.905000571410E0	1.011930358013E1
2.368363629163E0	1.037476759241E1
2.640843215771E0	1.055007485612E1
2.976624415665E0	1.063624982681E1
3.318546284745E0	1.063194056486E1
3.823663472237E0	1.099740100867E1
4.405664738240E0	1.137542372513E1
5.187436555597E0	1.166496202378E1
6.175710522454E0	1.216843231129E1
6.961511584054E0	1.237354653605E1
8.020475845200E0	1.268951841775E1
9.342310602840E0	1.312517379549E1
1.088199367275E1	1.357578605354E1
1.254037858709E1	1.428550706314E1
1.476682739843E1	1.477535702109E1
1.664981497324E1	1.541619800560E1
1.939382973803E1	1.594546549585E1
2.234758302335E1	1.663570844307E1
2.465317204806E1	1.721033077745E1
2.810299469091E1	1.811079403034E1
3.203556560826E1	1.905837050146E1
3.612935453267E1	2.040350563755E1
4.210080104371E1	2.202914285260E1
4.904727932304E1	2.317985288841E1
5.713990112669E1	2.439067119060E1
6.585853398950E1	2.611004260322E1
8.103154793172E1	2.818463354958E1
7.345339745264E1	2.724359876453E1
8.939877755884E1	2.940944891300E1
1.019087266422E2	3.094818331481E1
1.136793547535E2	3.285074397225E1
1.267786815510E2	3.398408080002E1
1.398583750662E2	3.515794194984E1
1.509683669925E2	3.637529798351E1
1.683645246290E2	3.763023043986E1
1.878109083867E2	3.994357449748E1
2.117767231338E2	4.203516918398E1
2.361989991767E2	4.386010780030E1
2.692949713079E2	4.695384074615E1
3.036340389525E2	4.899033607328E1
3.278336503812E2	5.200837259824E1
4.499516310747E2	5.959202252231E1
3.656397122906E2	5.426629350991E1
4.078386545765E2	5.711019347009E1
4.804419552693E2	6.165791565716E1
5.358469397292E2	6.433476729042E1
5.911779127162E2	6.713055355602E1
6.594599488819E2	7.125745007879E1
7.435507868340E2	7.434804845802E1
8.384323917706E2	7.824118984716E1
9.150784067639E2	8.234820105181E1
9.770873769705E2	8.520298892474E1
1.054790184596E3	8.891284809758E1
1.113905620618E3	9.043357113722E1];

A = digitizedData;
A(:,2) = (10^-1.13)*A(:,2);

