hp = 100;
isAlive = true;

initialSpeed = 0;
finalSpeed = 0;
initialX = x;
finalX = 0;
initialY = y;
finalY = 0;
moveType = "";
targetGravity = 0;

//Movement functions
function MoveToScaling(targetX, targetY, initSpeed, finSpeed)
{
	initialSpeed = initSpeed;
	finalSpeed = finSpeed;
	initialX = x;
	finalX = targetX;
	initialY = y;
	finalY = targetY;
	
	moveType = "Scaling";
}

function Jump(amount)
{
	targetGravity = 0.5;
	vspeed = -amount;
	
	moveType = "Jumping";
}