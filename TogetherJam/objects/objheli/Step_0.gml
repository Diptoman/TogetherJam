//Movement
/*baseAttachSpeed = random_range(0.2, 0.35);
attachSpeed = baseAttachSpeed / attachRing;*/
targetX = finalTarget.x + lengthdir_x(finalTarget.attachDistanceX * attachRing, 90 + (attachNumber - 1) * 360 / spaceInCurrentRing);
targetY = finalTarget.y + lengthdir_y(finalTarget.attachDistanceY * attachRing, 90 + (attachNumber - 1) * 360 / spaceInCurrentRing);
x = lerp(x, targetX, attachSpeed);
y = lerp(y, targetY, attachSpeed);