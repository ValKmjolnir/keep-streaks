var task=func(){
    println("[",os.time(),"] auto push...");
    system("git status");
    println("[",os.time(),"] git push successfully.");
}
system("git status");
var t=maketimestamp();
t.stamp();

while(1){
    unix.sleep(60);
    if(t.elapsedMSec()>=1000*60*5){
        task();
        t.stamp();
    }else{
        println("[",os.time(),"] streak keeper is running...");
    }
}