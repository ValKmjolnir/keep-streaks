use std.os;
use std.io;
use std.unix;

var task=func(){
    println("[",os.time(),"] add new line.");
    var fd=io.open(".task","a");
    io.write(fd,"["~os.time()~"] auto commit.\n");
    io.close(fd);
    println("[",os.time(),"] auto git add.");
    system("git add .");
    println("[",os.time(),"] auto git commit.");
    system("git commit -m \""~os.time()~" auto update\"");
    println("[",os.time(),"] auto git push.");
    var res=-1;
    while(res!=0){
        res=system("git push");
        if(res!=0){
            println("[",os.time(),"] push failed, retrying...");
        }
    }
    println("[",os.time(),"] git push successfully.");
}

var t=maketimestamp();
t.stamp();

while(1){
    # sleep 10 min
    unix.sleep(60*10);
    # trigger 1 day
    if(t.elapsedMSec()>=1000*60*60*24){
        task();
        t.stamp();
    }else{
        println("[",os.time(),"] streak keeper is running.");
    }
}