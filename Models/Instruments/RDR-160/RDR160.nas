# This file should be loaded in the aircraft set file like so:
# <nasal>
#    <radar>
#       <file>Aircraft/MD-80/Models/Instruments/RDR-160/RDR160.nas</file>
#    </radar>
#</nasal>
#
#


    var switch_mode=["off","stby","tst","on"];
    var s_pos =props.globals.initNode("instrumentation/radar/switch-pos",0,"INT");
    var r_rng =props.globals.initNode("instrumentation/radar/range",10,"DOUBLE");
    var r_sw =props.globals.initNode("instrumentation/radar/switch","off");

    var set_range=func(rng){
        var Rng = r_rng.getValue();
        if(rng==1){
            Rng=Rng*2;
            if(Rng >160)Rng=160;
        }elsif(rng==-1){
            Rng=Rng*0.5;
            if(Rng <10)Rng=10;
        }
        r_rng.setValue(Rng);
    };

    var set_switch=func(sw){
        var switchpos=s_pos.getValue() or 0;
        switchpos+=sw;
        if(switchpos>3)switchpos=3;
        if(switchpos<0)switchpos=0;
        s_pos.setValue(switchpos);
        r_sw.setValue(switch_mode[switchpos]);
    };

