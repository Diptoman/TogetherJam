//Movement
targetX = target.x + lengthdir_x(32 * attachRing, 90 + (attachNumber - 1) * 360 / currentSpace);
targetY = target.y + lengthdir_y(32 * attachRing, 90 + (attachNumber - 1) * 360 / currentSpace);
x = lerp(x, targetX, attachSpeed);
y = lerp(y, targetY, attachSpeed);