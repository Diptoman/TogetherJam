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

function Shoot(xOffset, yOffset)
{
	if (currentBulletGapTime <= 0)
	{
		bull = instance_create_layer(x + xOffset, y + yOffset, "Characters", objBullet);
		bull.InitializeBullet(0, bulletSpeed, bulletSprite, bulletDamage);
		currentBulletGapTime = bulletGapTime;
	}
}