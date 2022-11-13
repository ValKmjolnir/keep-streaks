import.stl.process_bar;
import.module.libkey;

var bar=process_bar.high_resolution_bar(40);

var feeling_state_gen=func(rate){
    if(rate>0.75){
        return "\e[92;1m"~bar.bar(rate)~" happy  \e[0m";
    }elsif(0.25<rate and rate<=0.75){
        return "\e[93;1m"~bar.bar(rate)~" fine   \e[0m";
    }else{
        return "\e[91;1m"~bar.bar(rate)~" sad    \e[0m";
    }
}

var satiation_state_gen=func(rate){
    if(rate>0.75){
        return "\e[92;1m"~bar.bar(rate)~" full   \e[0m";
    }elsif(0.25<rate and rate<=0.75){
        return "\e[93;1m"~bar.bar(rate)~" fine   \e[0m";
    }else{
        return "\e[91;1m"~bar.bar(rate)~" hungry \e[0m";
    }
}

var thirst_state_gen=func(rate){
    if(rate>0.75){
        return "\e[92;1m"~bar.bar(rate)~" full   \e[0m";
    }elsif(0.25<rate and rate<=0.75){
        return "\e[93;1m"~bar.bar(rate)~" fine   \e[0m";
    }else{
        return "\e[91;1m"~bar.bar(rate)~" thirsty\e[0m";
    }
}

var status={
    feeling:0.5,   # 0% sad     25%~75% fine 100% happy
    satiation:0.5, # 0% hungry  25%~75% fine 100% full
    thirst:0.5,    # 0% thirsty 25%~75% fine 100% full
    f_decl:1e-4,
    s_decl:3.5e-5,
    t_decl:3.5e-5
};

var init=func(){
    srand();
    status.feeling=rand();
    status.satiation=rand();
    status.thirst=rand();
}

var get_count_down=func(n){
    n=int(n);
    var h=int(n/3600);
    n-=h*3600;
    var m=int(n/60);
    n-=m*60;
    if(h>0)
        return h~"h:"~m~"m:"~n~"s";
    if(m>0)
        return m~"m:"~n~"s";
    return n~"s";
}

var display=func(){
    println("\ec");
    println("\e[1;1H\e[1m ^ ^");
    println("\e[2;1H\e[1m Feeling  \e[0m ",feeling_state_gen(status.feeling)," ",get_count_down(status.feeling/status.f_decl));
    println("\e[3;1H\e[1m Satiation\e[0m ",satiation_state_gen(status.satiation)," ",get_count_down(status.satiation/status.s_decl));
    println("\e[4;1H\e[1m Thirst   \e[0m ",thirst_state_gen(status.thirst)," ",get_count_down(status.thirst/status.t_decl));
    println("\e[5;1H\e[1m Press 'q' to exit.");
    println("\e[6;1H\e[1m Press 'e' to give food.");
    println("\e[7;1H\e[1m Press 'w' to give water.");
    println("\e[8;1H\e[1m Press 'r' to pet.");
}

var status_update=func(){
    status.feeling-=status.f_decl;
    status.satiation-=status.s_decl;
    status.thirst-=status.t_decl;
}

var main_loop=func(){
    var first_in=1;
    while(1){
        if(first_in){
            init();
            display();
            first_in=0;
            coroutine.yield(1);
            continue;
        }
        for(var i=0;i<100;i+=1){
            unix.sleep(0.01);
            coroutine.yield(nil);
        }
        status_update();
        display();
        coroutine.yield(1);
    }
}

var main=func(){
    var co=coroutine.create(main_loop);
    while(1){
        while(coroutine.resume(co)[0]==nil){
            var key=libkey.nonblock();
            if(key==nil)
                continue;
            if(char(key)=="q"){
                return;
            }elsif(char(key)=="w"){
                status.thirst=1;
            }elsif(char(key)=="e"){
                status.satiation=1;
            }elsif(char(key)=="r"){
                status.feeling+=0.05;
                status.feeling=status.feeling>1?1:status.feeling;
            }
            display();
        }
    }
}

main();