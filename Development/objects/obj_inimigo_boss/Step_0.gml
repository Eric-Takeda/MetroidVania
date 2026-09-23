var chao = place_meeting(x, y + 1, obj_block);

if(!chao)
{
	velv += GRAVIDADE * massa * global.vel_mult;
}

//State machine do boss

switch(estado)
{
	case "parado":
	{
		//Criando a lógica do estado parado
		//Ajustando a sprite
		if(sprite_index != spr_boss_idle)
		{
			sprite_index = spr_boss_idle;
			image_index = 0;
		}
		
		//Condições para trocar de estado
		//Checando se o player está na tela
		if(instance_exists(obj_player))
		{
			var _dist = point_distance(x, y, obj_player.x, obj_player.y);
			//Se o player estiver muito perto, eu vou atrás dele
			if(_dist < 300)
			{
				estado = "movendo";
			}
		}
		
		break;
	}
	
	#region Movendo
	case "movendo":
	{
		
		//Criando a lógica do estado movendo
		//Nesse estado que irá caçar o player
		if(sprite_index != spr_boss_walk)
		{
			sprite_index = spr_boss_walk;
			image_index = 0;
		}
		
		//Perseguindo o player
		if(instance_exists(obj_player))
		{
			//Minha distância para o player
			var _dist = point_distance(x, y, obj_player.x, obj_player.y);
			var _dir = point_direction(x, y, obj_player.x, obj_player.y);
			
			if(_dist > 40)
			{
			//Definindo minha velocidade
			velh = lengthdir_x(max_velh, _dir);
			}
			else
			{
				//Chegou muito perto, ele para e ataca
				velh = 0;
				estado = "attack";
				
				//Escolhendo o ataque
				ataque = irandom(2);
			}
		}
		
		break;
	}
	#endregion
	
	#region Ataque
	case "attack":
	{
		//Criando o substate dos ataques dos boss
		switch(ataque)
		{
			//Primeiro ataque
			case 0:
				atacando(spr_boss_attack1, 2, 5, sprite_width/2, - sprite_height/3, 2, 2, "taunt");
				break;
				
			//Segundo ataque	
			case 1:
				atacando(spr_boss_attack2, 4, 7, sprite_width/2, - sprite_height/3, 3, 1, "taunt");
				break;
				
			//Terceiro ataque
			case 2:
				atacando(spr_boss_attack3, 6, 9, 0, - sprite_height/3, 5, 2, "taunt");
				break;
		}
		break;
	}
	#endregion
	
	#region Toma dano
	case "hit":
	{
		leva_dano(spr_boss_hit, 2);
		break;
	}
	#endregion
	
	#region Provocação
	case "taunt":
	{
		taunt_timer--;
		//Definindo a sprite
		if(sprite_index != spr_boss_taunt)
		{
			sprite_index = spr_boss_taunt;
			image_index = 0;
		}
		
		//Condição para sair do estado
		//Player atacou
		if(taunt_timer <= 0)
		{
			taunt_timer = taunt_delay;
			estado = "parado";
		}
		break;
	}
	
	#endregion
	
	#region Morto
	case "dead":
	{
		morrendo(spr_boss_dead);
		
		//Adicionando um screenshake
		screenshake(7);
		
		break;
	}
	#endregion
}