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

var find_max=func(vec){
    var res=-1;
    foreach(var i;vec){
        if(i>res)
            res=i;
    }
    return res;
}

var find_min=func(vec){
    var res=0xffffffff;
    foreach(var i;vec){
        if(i<res)
            res=i;
    }
    return res;
}

var summary=func(vec){
    var sum=0;
    foreach(var i;vec)
        sum+=num(i);
    return int(sum);
}

var avg=func(vec){
    return int(summary(vec)/size(vec));
}

var variance=func(vec){
    var average=avg(vec);
    var vec_size=size(vec);
    var sum=0;
    foreach(var i;vec){
        var tmp=num(i)-average;
        sum+=tmp*tmp;
    }
    return sum/vec_size;
}

var std_deviation=func(vec){
    return math.sqrt(variance(vec));
}

var reserve_one=func(number){
    var s=str(number);
    for(var i=0;i<size(s);i+=1)
        if(s[i]=='.'[0])
            break;
    return substr(s,0,i+2);
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

var csv=read_csv("./wows-data/wows_republique_ap.csv");

var generate_column_data_frame=func(csv_struct){
    var line_size=size(csv_struct.property);
    var column_size=size(csv_struct.data);
    var res={};
    forindex(var i;csv_struct.property){
        var key=csv_struct.property[i];
        res[key]=[];
        setsize(res[key],column_size);
        forindex(var j;csv_struct.data){
            res[key][j]=num(csv_struct.data[j][i]);
        }
    }
    res.half_rate=[];
    setsize(res.half_rate,column_size);
    res.avg_dmg=[];
    setsize(res.avg_dmg,column_size);
    res.avg_all=[];
    setsize(res.avg_all,column_size);
    for(var i=0;i<column_size;i+=1){
        var half_rate=res.half_dmg[i]/(res.over_pen[i]+res.half_dmg[i]+res.no_pen[i]+res.hit_torp[i]+res.ricochet[i])*100;
        var avg_damage_per_valid_shell=res.damage[i]/(res.over_pen[i]+res.half_dmg[i]);
        var avg_damage_per_all_shell=res.damage[i]/(res.over_pen[i]+res.half_dmg[i]+res.no_pen[i]+res.hit_torp[i]+res.ricochet[i]);
        res.half_rate[i]=int(half_rate);
        res.avg_dmg[i]=int(avg_damage_per_valid_shell);
        res.avg_all[i]=int(avg_damage_per_all_shell);
    }
    return res;
}
var col_data=generate_column_data_frame(csv);

# make sure the print order
append(csv.property,"half_rate","avg_dmg","avg_all");
var max_key_len=func(){
    var res=0;
    foreach(var key;csv.property){
        if(res<size(key))
            res=size(key);
    }
    return res;
}();

var divider_print=func(vsize=nil){
    if(vsize==nil)
        vsize=size(csv.property);
    var s="+-";
    for(var i=0;i<vsize-1;i+=1)
        s~=rightpad(max_key_len,"","-")~"-+-";
    s~=rightpad(max_key_len,"","-")~"-+";
    print(s,"\n");
}

var keys_print=func(end="\n"){
    print("| ");
    foreach(var key;csv.property){
        print(rightpad(max_key_len,key)," | ");
    }
    print(end);
};

divider_print();
keys_print();
divider_print();

var main_data_print=func(){
    for(var i=0;i<size(csv.data);i+=1){
        var line=[];
        foreach(var key;csv.property){
            if(key=="half_rate")
                append(line,col_data[key][i]~"%");
            else
                append(line,col_data[key][i]);
        }
        print("| ");
        forindex(var j;line){
            print(rightpad(max_key_len,str(line[j]))," | ");
        }
        print("\n");
    }
}

main_data_print();
divider_print(size(col_data)+1);

# summary
print("| ");
print(rightpad(max_key_len,str(summary(col_data.over_pen)))," | ");
print(rightpad(max_key_len,str(summary(col_data.half_dmg)))," | ");
print(rightpad(max_key_len,str(summary(col_data.no_pen)))," | ");
print(rightpad(max_key_len,str(summary(col_data.hit_torp)))," | ");
print(rightpad(max_key_len,str(summary(col_data.ricochet)))," | ");
print(rightpad(max_key_len,str(summary(col_data.citadel)))," | ");
print(rightpad(max_key_len,str(int(summary(col_data.damage)/1000))~"k")," | ");
func(){
    var victory=0;
    foreach(var i;col_data.win){
        victory+=i;
    }
    print(rightpad(max_key_len,str(int(victory/size(col_data.win)*100)~"%"))," | ");
}();
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,"sum")," |\n");
divider_print(size(col_data)+1);

# average
print("| ");
print(rightpad(max_key_len,str(avg(col_data.over_pen)))," | ");
print(rightpad(max_key_len,str(avg(col_data.half_dmg)))," | ");
print(rightpad(max_key_len,str(avg(col_data.no_pen)))," | ");
print(rightpad(max_key_len,str(avg(col_data.hit_torp)))," | ");
print(rightpad(max_key_len,str(avg(col_data.ricochet)))," | ");
print(rightpad(max_key_len,str(avg(col_data.citadel)))," | ");
print(rightpad(max_key_len,str(avg(col_data.damage)))," | ");
func(){
    var victory=0;
    foreach(var i;col_data.win){
        victory+=i;
    }
    print(rightpad(max_key_len,str(int(victory/size(col_data.win)*100))~"%")," | ");
}();
func(){
    var res=col_data;
    var avg_half_rate=summary(res.half_dmg)/(summary(res.over_pen)+summary(res.half_dmg)+summary(res.no_pen)+summary(res.hit_torp)+summary(res.ricochet))*100;
    var avg_avg_damage_per_valid_shell=summary(res.damage)/(summary(res.over_pen)+summary(res.half_dmg));
    var avg_avg_damage_per_all_shell=summary(res.damage)/(summary(res.over_pen)+summary(res.half_dmg)+summary(res.no_pen)+summary(res.hit_torp)+summary(res.ricochet));
    print(rightpad(max_key_len,str(int(avg_half_rate))~"%")," | ");
    print(rightpad(max_key_len,str(int(avg_avg_damage_per_valid_shell)))," | ");
    print(rightpad(max_key_len,str(int(avg_avg_damage_per_all_shell)))," | ");
}();
print(rightpad(max_key_len,"avg")," |\n");
divider_print(size(col_data)+1);

# min
print("| ");
print(rightpad(max_key_len,str(find_min(col_data.over_pen)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.half_dmg)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.no_pen)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.hit_torp)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.ricochet)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.citadel)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.damage)))," | ");
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,str(find_min(col_data.half_rate))~"%")," | ");
print(rightpad(max_key_len,str(find_min(col_data.avg_dmg)))," | ");
print(rightpad(max_key_len,str(find_min(col_data.avg_all)))," | ");
print(rightpad(max_key_len,"min")," |\n");
divider_print(size(col_data)+1);

# max
print("| ");
print(rightpad(max_key_len,str(find_max(col_data.over_pen)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.half_dmg)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.no_pen)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.hit_torp)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.ricochet)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.citadel)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.damage)))," | ");
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,str(find_max(col_data.half_rate))~"%")," | ");
print(rightpad(max_key_len,str(find_max(col_data.avg_dmg)))," | ");
print(rightpad(max_key_len,str(find_max(col_data.avg_all)))," | ");
print(rightpad(max_key_len,"max")," |\n");
divider_print(size(col_data)+1);

#std_deviation
print("| ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.over_pen)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.half_dmg)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.no_pen)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.hit_torp)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.ricochet)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.citadel)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.damage)))," | ");
print(rightpad(max_key_len,"N/A")," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.half_rate))~"%")," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.avg_dmg)))," | ");
print(rightpad(max_key_len,reserve_one(std_deviation(col_data.avg_all)))," | ");
print(rightpad(max_key_len,"deviat")," |\n");
divider_print(size(col_data)+1);
keys_print(end:rightpad(max_key_len,"type")~" |\n");
divider_print(size(col_data)+1);

println("Data size: ",size(col_data.win));
println("LET WG KNOW THE FRENCH BATTLESHIP REPUBQLIQUE IS TOTALLY A BULL SHIT!");