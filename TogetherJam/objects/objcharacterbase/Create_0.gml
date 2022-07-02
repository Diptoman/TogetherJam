/// @description Insert description here

//Restrictions
upperYLimit = 0;
lowerYLimit = 1080;
upperXLimit = 1920;
lowerXLimit = 0;

//Health
hp = 100;
canBeHit = true;
damageTween = -1;

//Shooting
bulletSpeed = 16;
bulletGapTime = 10; //frames
currentBulletGapTime = bulletGapTime;
bulletSprite = sprKITTBullet;
bulletDamage = 10;

function Shoot(xOffset, yOffset, spread = 0)
{
	bDepth = layer_get_depth("Characters") - 1;
	if (currentBulletGapTime <= 0)
	{
		bull = instance_create_depth(x + xOffset, y + yOffset, bDepth, objBullet);
		bull.InitializeBullet(0, bulletSpeed, bulletSprite, bulletDamage, spread);
		currentBulletGapTime = bulletGapTime;
	}
}