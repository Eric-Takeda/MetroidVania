var chao = place_meeting(x, y + 1, obj_block);

if(!chao)
{
	velv += GRAVIDADE * massa * global.vel_mult;
}



switch(estado)
{
	case "parado":
	{
		mid_velh = 0;
		velh = 0;
		timer_estado++;
		if(sprite_index != spr_inimigo_esqueleto_idle)
		{
			image_index = 0;
		}
		sprite_index = spr_inimigo_esqueleto_idle;
		
		//Condição de troca de estado
		if(position_meeting(mouse_x, mouse_y, self))
		{
			if(mouse_check_button_pressed(mb_right))
			{
				estado = "hit";
			}
		}
		//Indo para o estado de patrulha
		if(irandom(timer_estado) > 300)
		{
			estado = choose("walk", "parado", "walk");
			timer_estado = 0;
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
		
		break;
	}
	
	case "walk":
	{
		timer_estado++;
		if(sprite_index != spr_inimigo_esqueleto_walk)
		{
			image_index = 0;
			mid_velh = choose(1, -1) * global.vel_mult;
		}
		sprite_index = spr_inimigo_esqueleto_walk;
		
		//Bater na parede e inveter a direção
		if(place_meeting(x + mid_velh, y, obj_block))
		if(place_meeting(x + mid_velh, y, obj_block))
		{
			//Invertendo o mid_velh
			mid_velh *= -1;
		}
		
		//Condição de saída de estado
		if(irandom(timer_estado) > 300)
		{
			estado = choose("parado", "walk", "parado");
			timer_estado = 0;
		}
		scr_ataca_player_melee(obj_player, dist, xscale);
		
		break;
	}
	
	case "attack":
	{
		atacando(spr_inimigo_esqueleto_attack, 8, 15, sprite_width/2, -sprite_height/3, 1, 1);
		
		//Saindo do estado
		break;
	}
	
	case "hit":
	{
		leva_dano(spr_inimigo_esqueleto_hit, 3);
		
		break;
	}
	
	case "dead":
	{
		morrendo(spr_inimigo_esqueleto_dead);
	}
}