var rightpad=func(len,string){
    if(size(string)>=len)
        return string;
    while(size(string)<len)
        string~=" ";
    return string;
}
var leftpad=func(len,string){
    if(size(string)>=len)
        return string;
    while(size(string)<len)
        string=" "~string;
    return string;
}

var context=io.fin("./data/wows_republique_ap.csv");
context=split("\n",context);
forindex(var i;context){
    context[i]=split(",",context[i]);
}
var key=context[0];
append(key,"avg_dmg","rate");
var max_key_len=0;
foreach(var k;key){
    if(max_key_len<size(k))
        max_key_len=size(k);
}
var data=context[1:];
print("| ");
foreach(var k;key){
    print(rightpad(max_key_len,k)," | ");
}
print("\n");
foreach(var d;data){
    print("| ");
    foreach(var i;d){
        print(rightpad(max_key_len,i)," | ");
    }
    var avg_damage_per_valid_shell=d[5]/(d[0]+d[1]);
    print(rightpad(max_key_len,str(int(avg_damage_per_valid_shell)))," | ");
    var valid_hit=d[0]+d[1];
    var all_hit=d[0]+d[1]+d[2]+d[3]+d[4];
    print(rightpad(max_key_len,str(int(valid_hit/all_hit*100))~"%")," |\n");
}