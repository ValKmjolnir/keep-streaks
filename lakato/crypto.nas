var encode=func(c) {
    c^=0xfe;
    if (c>255) {
        c=0;
    }
    return char(c);
}

var decode=func(c) {
    c^=0xfe;
    if (c<0) {
        c=255;
    }
    return char(c);
}

var encry=func(s) {
    if (typeof(s)!="str") {
        return "";
    }
    var len=size(s);
    var res="";
    for(var i=0;i<len;i+=1) {
        res~=encode(s[i]);
    }
    return res;
}

var decry=func(s) {
    if (typeof(s)!="str") {
        return "";
    }
    var len=size(s);
    var res="";
    for(var i=0;i<len;i+=1) {
        res~=decode(s[i]);
    }
    return res;
}

# println(encry("aaaaaa"));
# println(decry("bbbbbb"));
println(decry(encry("abcdefghijlmnopqrstuvwxyz")));