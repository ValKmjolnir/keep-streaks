var task=func(){
    println("[",os.time(),"] auto push...");
    var fd=io.open(".task","a");
    io.write(fd,"["~os.time()~"] auto commit.\n");
    io.close(fd);
    system("git add .");
    system("git commit -m \""~os.time()~" auto update\"");
    #system("git push");
    println("[",os.time(),"] git push successfully.");
}

var t=maketimestamp();
t.stamp();

while(1){
    # sleep 60 sec
    unix.sleep(5);
    # trigger 5 min
    if(t.elapsedMSec()>=1000*20){
        task();
        t.stamp();
    }else{
        println("[",os.time(),"] streak keeper is running...");
    }
}