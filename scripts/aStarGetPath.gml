//creates a path from (startX,startY) to (endX,endY)
// param0 = startX : starting x position
// param1 = startY : starting y position
// param2 = endX : ending x position
// param3 = endY : ending y position

//NOTE: Inputs are in terms of room positions.
//      All other positions will be in terms of grid(2D array)

var startRoomX=argument0;
var startRoomY=argument1;
var endRoomX=argument2;
var endRoomY=argument3;

//____PRE-ALGOR_____
//convert vars into grid
startX=startRoomX div oAStar.blockSize;
startY=startRoomY div oAStar.blockSize;
endX=endRoomX div oAStar.blockSize;
endY=endRoomY div oAStar.blockSize; //not var bc they are used outside of script

//create data structures
G=ds_map_create(); //in map key doesnt have to be numbered
H=ds_map_create();
F=ds_priority_create();
P=ds_map_create(); //parent
C=ds_list_create(); //closeness

//ar[0]=5; ar[key]=val;
//<key,value>
//<whichNode,G/H/P> using node and block interchangibly
//init first G value
ds_map_add(G,getKey(startX,startY),0); //script bc want each block to have 1 unique ID #


//____ALGOR_____
searching=true;
found=false;
curX=startX; //initialize current analyzed x & y values
curY=startY;
while(searching){
    processCurrentNode();
}

var path=-1; //init @ -1
if(found){
    path=path_add();
    var curNode=getKey(endX,endY);
    while(curNode!=getKey(startX,startY)){ //following backwards from end
        path_add_point(path,getKeyX(curNode)*oAStar.blockSize,
            getKeyY(curNode)*oAStar.blockSize,100); //create new series of points
        curNode=ds_map_find_value(P,curNode); //makes curnode value of parent 
    }
    //draw in the point for the start
    path_add_point(path,startX*oAStar.blockSize,startY*oAStar.blockSize,100);
    path_reverse(path); //go start to finish for found path
    path_set_closed(path,false); //gm assumes paths are closed but we dont want that
}

//____POST-ALGOR_____
//destroy data structures

ds_map_destroy(G);
ds_map_destroy(H);
ds_priority_destroy(F);
ds_map_destroy(P);
ds_list_destroy(C);

//return our result
return path;
