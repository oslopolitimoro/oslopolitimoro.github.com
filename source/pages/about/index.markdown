---
layout: page
title: "About"
date: 2012-09-22 13:50
comments: true
sharing: true
footer: true
---
Oslo politimoro er en privat webside som samler de morsomste tweets fra [Twitter](https://twitter.com/oslopolitiops) for å vise de fram.

Av og til sitter noen bak twitter-accounten hos Oslo Politiet som har en helt jævlig morsomt humor og han/hun sende ut noen tweets full med svart humor.   For at de beste tweets ikke blir mistet, sammler jeg de her på websiden. 

Hvis du lurer på noe og vil vite mer om det ta gjerne [kontakt](mailto://kontakt@oslopolitimoro.no).

Jeg har gått gjennom alle tweets fra 25. februar 2012, men har ikke funnet noen tidligere. Hvis noen har tilgang til tidligere tweets eller vet om en tweet som mangler og burde vær her: send inn!


# Links
* [2012-10-17: Han er Oslo-politiets Twitter-sjef](http://www.vg.no/teknologi/artikkel.php?artid=10047021)

----
<!-- Statistical data-->
Når var Oslopolitiet morsomst?

<script type="text/javascript" src="/javascripts/Chart.js"></script>
<meta name = "viewport" content = "initial-scale = 1, user-scalable = no">
<canvas id="canvas1" height="450" width="1024"></canvas>
<canvas id="canvas2" height="450" width="1024"></canvas>
<script type="text/javascript">
    var lineChartData2012 = {
            labels : ["Januar","Februar","Mars","April","Mai","Juni","Juli","August","September","Oktober","November","Desember"],
            datasets : [
                    {
                            fillColor : "rgba(151,187,205,0.5)",
                            strokeColor : "rgba(151,187,205,1)",
                            pointColor : "rgba(151,187,205,1)",
                            pointStrokeColor : "#fff",
                            data : [0,0,7,5,17,3,18,17,9,14,14,7],
                            
                            scaleOverride : true,    
                            scaleSteps : "50",
                            scaleStepWidth : "1",
                            scaleStartValue : "0",
                    },
            ]
    }
    var lineChartData2013 = {
            labels : ["Januar","Februar","Mars","April","Mai","Juni","Juli","August","September","Oktober","November","Desember"],
            datasets : [
                    {
                            fillColor : "rgba(151,187,205,0.5)",
                            strokeColor : "rgba(151,187,205,1)",
                            pointColor : "rgba(151,187,205,1)",
                            pointStrokeColor : "#fff",
                            data : [11,16,10,18,29,24,34,29,20,1,0,0]
                    },
            ]
    }

    var myLine = new Chart(document.getElementById("canvas1").getContext("2d")).Line(lineChartData2012);
    var myLine = new Chart(document.getElementById("canvas2").getContext("2d")).Line(lineChartData2013);

</script>	
