# wows republique ap shell
# 2022 ValKmjolnir
# using data from wows server: ASIA

var rightpad=func(len,string,fill=" "){
    if(size(string)>=len)
        return string;
    while(size(string)<len)
        string~=fill;
    return string;
}

var leftpad=func(len,string,fill=" "){
    if(size(string)>=len)
        return string;
    while(size(string)<len)
        string=fill~string;
    return string;
}

var read_csv=func(path){
    var context=io.fin(path);
    context=split("\n",context);
    forindex(var i;context){
        context[i]=split(",",context[i]);
    }
    return {
        property:context[0],
        data:context[1:]
    };
}

var csv=read_csv("./data/wows_republique_ap.csv");

func(){
    var res=[];
    setsize(res,size(csv.property));
    forindex(var i;res){
        res[i]=0;
        foreach(var d;csv.data)
            res[i]+=d[i];
        res[i]=str(res[i]);
    }
    append(csv.data,res);
}();

var max_key_len=func(){
    var res=0;
    foreach(var key;csv.property){
        if(res<size(key))
            res=size(key);
    }
    return res;
}();

append(csv.property,"half_rate","avg_dmg","rate");
var ht_print=func(){
    var s="+-";
    for(var i=0;i<size(csv.property)-1;i+=1)
        s~=rightpad(max_key_len,"","-")~"-+-";
    s~=rightpad(max_key_len,"","-")~"-+";
    print(s,"\n");
}
func(){
    ht_print();
    print("| ");
    foreach(var key;csv.property){
        print(rightpad(max_key_len,key)," | ");
    }
    print("\n");
    ht_print();
}();

var data=csv.data;
forindex(var i;data){
    var d=data[i];
    if(i==size(data)-1){
        ht_print();
    }
    print("| ");
    forindex(var j;d){
        if(i==size(data)-1){
            print(rightpad(max_key_len,str(int(num(d[j])/(size(data)-1))))," | ");
        }else{
            print(rightpad(max_key_len,d[j])," | ");
        }
    }
    var half_rate=d[1]/(d[0]+d[1]+d[2]+d[3]+d[4])*100;
    var avg_damage_per_valid_shell=d[5]/(d[0]+d[1]);
    var valid_rate=(d[0]+d[1])/(d[0]+d[1]+d[2]+d[3]+d[4])*100;

    print(rightpad(max_key_len,str(int(half_rate))~"%")," | ");
    print(rightpad(max_key_len,str(int(avg_damage_per_valid_shell)))," | ");
    print(rightpad(max_key_len,str(int(valid_rate))~"%")," |\n");
}
ht_print();
println(" data size: ",size(csv.data));