var chao = place_meeting(x, y + 1, obj_block);

if(!chao)
{
	velv +=  GRAVIDADE * massa * global.vel_mult;
}

switch(estado)
{
	#region Parado
	case "parado":
	{
		velh = 0;
		mid_velh = 0;
		timer_estado++;
		
		//Ajustando a sprite
		if(sprite_index != spr_monstro_idle)
		{
			sprite_index = spr_monstro_idle;
			image_index = 0;
		}	
			
		//Saindo do estado
		if(random(timer_estado) > 200)
		{
			estado = choose("movendo", "parado");
			timer_estado = 0;
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
			
		break;
	}
	#endregion
	
	case "movendo":
	{
		timer_estado++;
		if(sprite_index != spr_monstro_walk)
		{
			sprite_index = spr_monstro_walk;
			image_index = 0;
		}
		
		//Bater na parede e inveter a direção
		if(place_meeting(x + mid_velh, y, obj_block))
		{
			//Invertendo o mid_velh
			mid_velh *= -1;
		}
		
		if(mid_velh == 0)
		{
			mid_velh = choose(-1.5, 1.5)
		}
		
		if(random(timer_estado) > 200)
		{
			estado = choose("parado",, "movendo");
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
		
		break;
	}
	
	case "attack":
	{
		atacando(spr_monstro_ataque, 2, 8, sprite_width/4, -sprite_height/3, 1, 1);
		
		break;
	}
	
	case "hit":
	{
		leva_dano(spr_monstro_hit, 2);
		break;
	}
	
	case "dead":
	{
		morrendo(spr_monstro_dead);
		break;
	}
	
}