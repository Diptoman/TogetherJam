/// @description Init
airwolf = instance_create_layer(72, 72, "Characters", objAirwolf);
kitt = instance_create_layer(72, 840, "Characters", objKITT);
viewSelector = instance_create_layer(kitt.x, kitt.y, "Controllers", objViewSelector);
viewSelector.Initialize(airwolf, kitt);