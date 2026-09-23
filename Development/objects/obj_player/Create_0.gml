randomize();

//Criando a câmera
var cam = instance_create_layer(x, y, layer, obj_camera);
cam.alvo = id;

// Inherit the parent event
event_inherited();

vida_max = 7;
vida_atual = vida_max;

max_velh = 4;
max_velv = 6;
dash_vel = 5;
mostra_estado = true;

combo = 0;
img_spd = 30;
dano = noone;
ataque = 1;
posso = true;
ataque_mult = 1;
ataque_buff = room_speed;
ataque_down = false;

invencivel = false;
invencivel_timer = room_speed * 3;
tempo_invencivel = invencivel_timer;

dash_delay = room_speed * .5;
dash_timer = 0;
dash_aereo_timer = 0;
dash_aereo = true;

//Metodo para iniciar o ataque
///@method inicia_ataque(chao)
///@arg {bool} chao
inicia_ataque = function(chao)
{
	if(chao)
	{
		estado = "ataque";
		velh = 0;
		image_index = 0;
	}
	else //Não estou no chão
	{
		if(keyboard_check(ord("S")))
		{
			estado = "ataque aereo down";
			velh = 0;
			image_index = 0;
		}
		else
		{
			estado = "ataque aereo";
			image_index = 0;
		}
	}
}

finaliza_ataque = function()
{
	posso = true;
	if(dano)
	{
		instance_destroy(dano, false);
		dano = noone;
	}
}

//Aplicando gravidade
aplica_gravidade = function()
{
	var chao = place_meeting(x, y + 1, obj_block);
	if(!chao)
	{
		if(velv < max_velv * 2)
		{
		velv += GRAVIDADE * massa * global.vel_mult;
		}
	}
}