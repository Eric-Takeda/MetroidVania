// Inherit the parent event
event_inherited();


///@method leva_dano(sprite, image_index_ir_para_dead)
leva_dano = function(_sprite, _image_index)
{
	//Iniciando o meu delay
	delay = room_speed * 2;
	velh = 0;
		
	mid_velh = 0;
	
	//Checando seu estou com a sprite certa
	if(sprite_index != _sprite)
	{
		//Iniciando o que for preciso para este estado
		image_index = 0;
	}
		
	sprite_index = _sprite;
		
	//Condição para sair do estado
	if(vida_atual > 0)
	{
		if(image_index > image_number-1)
		{
			estado = "parado";
		}
	}
	else
	{
		if (image_index >= _image_index)
		{
			estado = "dead";
		}
	}
}

//Criando o método de ataque
///@method atacando()
///@args sprite_index image_index_min image_index_max dist_x dist_y, [xscale_dano], [yscale_dano], [proximo_estado]
atacando = function(_sprite_index, _image_index_min, _image_index_max, _dist_x, _dist_y, _xscale_dano, _yscale_dano, _proximo_estado)
{
	//Caso a pessoa não passe o xscale eu defino como 1
	if(!_xscale_dano) _xscale_dano = 1;
	if(!_xscale_dano) _yscale_dano = 1;
	if(_proximo_estado == undefined) _proximo_estado = "parado";
	
	mid_velh = 0;
	velh = 0;
	if(sprite_index != _sprite_index)
	{
		sprite_index = _sprite_index;
		image_index = 0;
		posso = true;
		dano = noone;
	}
		
	if(image_index > image_number-1)
	{
		estado =_proximo_estado;
	}
		
	//Criando o dano
	if(image_index >= _image_index_min && dano == noone && image_index < _image_index_max && posso)
	{
		dano = instance_create_layer(x + _dist_x, y + _dist_y, layer, obj_dano);
		dano.dano = ataque;
		dano.pai = id;
		dano.image_xscale = _xscale_dano;
		dano.image_yscale = _yscale_dano;
		posso = false;
	}
		
	//Destruindo o dano
	if(dano != noone && image_index >= _image_index_max)
	{
		instance_destroy(dano);
		dano = noone;
	}
}

///@method morrendo(sprite)
morrendo = function(_sprite)
{
	
	mid_velh = 0;
	if(sprite_index != _sprite)
	{
		//Iniciando o que for preciso para este estado
		image_index = 0;
	}
	sprite_index = _sprite;
		
	//Morrendo de verdade
	if(image_index > image_number-1)
	{
		image_speed = 0;
		image_alpha -= .01;
			
		if(image_alpha <= 0) instance_destroy();
	}
}