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
    system("git push");
    println("[",os.time(),"] git push successfully.");
}

task();