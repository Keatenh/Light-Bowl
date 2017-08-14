var blockX=x div oAStar.blockSize; //recording the coords of current block
var blockY=y div oAStar.blockSize;

path_speed = oAStar.pathingSpeedArray[blockX,blockY]*OriginalPathingSpeed;
