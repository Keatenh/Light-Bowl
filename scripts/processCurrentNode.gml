//Run through A* process on current node

//add to closed list
ds_list_add(C,getKey(curX,curY));

//analyze adjacent nodes/blocks/grid locations
var distFromStartToCurrent=ds_map_find_value(G,getKey(curX,curY));
//max() & min() to insure no negative or out of bounds x,y values
for(var i=max(0,curX-1);i<=min(oAStar.fieldWidth-1,curX+1);i++){ //max(0,...) to insure no negative x,y values
    for(var j=max(0,curY-1);j<=min(oAStar.fieldHeight-1,curY+1);j++){
        if(i==curX && j==curY)
            continue;  //skip next stuff
        var closed=ds_list_find_index(C,getKey(i,j))!=-1;
        //sum of coords are both even or odd (parity) for nodes diagonal to each other
        var diagonal=((i+j)%2 == (curX+curY)%2); 
        var canWalk=false;
        var distFromCurrentToIJ=0; 
        if(diagonal){
            //current node & nodes adjacent to diagonal (up to 2) must be walkable
            canWalk=oAStar.walkable[i,j] &&
                oAStar.walkable[curX,j] &&
                oAStar.walkable[i,curY];
            distFromCurrentToIJ=1.414; //sqrt 2 (from distance formula)
        }else{
            canWalk=oAStar.walkable[i,j];
            distFromCurrentToIJ=1;
        }
        if(!closed && canWalk){
            //calculated G,H and F
            var tempG=distFromStartToCurrent+distFromCurrentToIJ;
            var tempH=abs(i-endX)+abs(j-endY)//insert heuristic of choice (we use Manhattan)
            //NOTE : you could also use point_distance(i,j,endX,endY);
            var tempF=tempG+tempH;
            //update if necessary
            var processed=ds_map_exists(G,getKey(i,j));
            if(processed){
                var lowerG=(ds_map_find_value(G,getKey(i,j))>tempG);
                if(lowerG){
                    ds_map_replace(G,getKey(i,j),tempG);
                    ds_map_replace(H,getKey(i,j),tempH);
                    ds_priority_change_priority(F,getKey(i,j),tempF); 
                    ds_map_replace(P,getKey(i,j),getKey(curX,curY));
                }            
            }else{
            //go ahead and add values
                ds_map_add(G,getKey(i,j),tempG);
                ds_map_add(H,getKey(i,j),tempH);
                ds_priority_add(F,getKey(i,j),tempF); //can find min/max values in priority quickly
                ds_map_add(P,getKey(i,j),getKey(curX,curY));
                
            }
        }
    }
}

//find best option
var minF=-1;
var empty=ds_priority_empty(F);
if(!empty)
    minF=ds_priority_delete_min(F); //gives smallest val then deletes it from priority
//decide what to do
if(minF==-1){
    searching=false; //calling from aStarGetPath
    found=false;
}else{
    curX=getKeyX(minF);
    curY=getKeyY(minF);
}
//check whether we're at the end
if(curX==endX && curY==endY){
    searching=false;
    found=true;
}
