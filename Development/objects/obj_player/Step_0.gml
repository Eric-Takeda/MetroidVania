//Checando se o objeto transição existe
if(instance_exists(obj_transicao)) exit;

//Controlando a minha invencibilidade
if(invencivel && tempo_invencivel > 0)
{
	tempo_invencivel --;
	image_alpha = max(sin(get_timer()/100000), 0.2);
}
else
{
	invencivel = false;
	image_alpha = 1;
}

//Iniciando variáveis
var right, left, jump, attack, dash;
var chao = place_meeting(x, y + 1, obj_block);

right = keyboard_check(ord("D"));
left = keyboard_check(ord("A"));
jump = keyboard_check_pressed(ord("K"));
attack = keyboard_check_pressed(ord("J"));
dash = keyboard_check_pressed(ord("L"));

if(ataque_buff > 0) ataque_buff -= 1;

//Diminuindo o dash_timer
if(dash_timer > 0) dash_timer--;

//Código de Movimentação
velh = (right - left) * max_velh * global.vel_mult;


//Iniciando a máquina de estados
switch(estado)
{
	#region Parado
	case "parado":
	{
		//Checando se eu toquei no chão
		if(chao) dash_aereo = true;
		
		//Parando o mid_velh
		mid_velh = 0;
		
		//Comportamento do estado
		sprite_index = spr_player_parado;
		
		//Condição de troca de estado
		//Movendo
		if(velh != 0)
		{
			estado = "movendo";
		}
		else if (jump || !chao)
		{	
			estado = "pulando";
			velv = (-max_velv * jump);
			image_index = 0;
		}
		else if(attack)
		{
			inicia_ataque(chao);
		}
		else if(dash && dash_timer <= 0)
		{
			estado = "dash";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region Movendo
	case "movendo":
	{
		//Comportamento do estado de movimento
		sprite_index = spr_player_run;
		
		//Condição de troca de estado
		//Parado
		if(abs(velh) < .1)
		{
			estado = "parado";
			velh = 0;
		}
		else if (jump || !chao)
		{
			estado = "pulando";
			velv = (-max_velv * jump);
			image_index = 0;
		}
		else if(attack)
		{
			inicia_ataque(chao);
		}
		else if(dash && dash_timer <= 0)
		{
			estado = "dash";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region Pulando
	case "pulando":
	{
		
		//Caindo
		if(velv > 0)
		{
			sprite_index = spr_player_caindo
		}
		//Pulando
		else
		{
			sprite_index = spr_player_pulo
			//Garantindo que a animação não se repeta
			if (image_index >= image_number-1)
			{
				image_index = image_number-1;
			}
		}
		
		//Condição de troca de estado
		if(attack)
		{
			inicia_ataque(chao);
		}
		
		if(chao)
		{
			estado = "parado";
			velh = 0;
		}
		
		//Trocando de sprite SE eu toquei na parede
		var wall = place_meeting(x + sign(velh), y, obj_block);
		if(wall)
		{
			//Fazendo eu pular ao apertar o espaço (jump)
			if(jump)
			{
				//Indo para cima
				velv = -max_velv;
				//Indo para a direção certa
				mid_velh = (max_velh * 2) * sign(velh) * -1;
			}
			
			//Trocando de sprite
			sprite_index = spr_player_wall;
			//Só altera o velv se eu tô caindo
			if(velv > 1)
			{
				velv = 1;
			}
			else
			{
				aplica_gravidade();
			}
		}
		else
		{
			aplica_gravidade();
			
			//Diminuindo o valor do mid_velh
			mid_velh = lerp(mid_velh, 0, 0.05);
			
		}
		
		//Indo para o dash aéreo
		if(dash && dash_aereo == true)
		{
			estado = "dash aereo";
		}
		
		break;
	}
	#endregion
	
	#region Dash Aéreo
	case "dash aereo":
	{
		//Não posso dar dash aéreo
		dash_aereo = false;
		
		//Arrumar a sprite
		if(sprite_index != spr_player_dash_aereo)
		{
			sprite_index = spr_player_dash_aereo;
			
			//Dando um valor para o dash aereo
			dash_aereo_timer = room_speed/4;
		}
		
		//Diminuindo o timer
		dash_aereo_timer--;
		
		if(dash_aereo_timer <= 0)
		{
			estado = "parado";
		}
		
		//Velocidade horizontal
		velh = 0;
		
		//Ir para a direção que eu estou olhando
		mid_velh = dash_vel * image_xscale;
		
		//Velocidade vertical
		velv = 0;
		
		break;
	}
	
	#endregion
	
	#region Ataque Aéreo para Baixo
	case "ataque aereo down":
	{
		aplica_gravidade();
		
		velv += .5;
		if(!ataque_down)
		{
			sprite_index = spr_player_ataque_ar_down_ready;
			image_index = 0;
			ataque_down = true;
		}
		
		//Indo para o loop
		if(sprite_index == spr_player_ataque_ar_down_ready)
		{
			//Checar se já passou bastante tempo da animação
			if(image_index > image_number - .07)
			{
				sprite_index = spr_player_ataque_ar_down_loop;
				image_index = 0;
			}
		}
		
		//Encerrando a animação
		if(chao)
		{
			if(sprite_index != spr_player_ataque_ar_down_end)
			{
				sprite_index = spr_player_ataque_ar_down_end;
				image_index = 0;
				
				//Criando o screenshake direcional
				screenshake(8, true, 270);
			}
			else
			{
				if(image_index >= image_number - .2)
				{
					estado = "parado";
					ataque_down = false;
					finaliza_ataque();
				}
			}
		}
		
		//Criando o dano
		if(sprite_index == spr_player_ataque_ar_down_ready && dano == noone && posso)
		{
			dano		= instance_create_layer(x + sprite_width/2 + velh * 3, y - sprite_height/3, layer, obj_dano);
			dano.dano	= ataque;
			dano.pai	= id;
			dano.morrer = false;
			posso		= false;
		}
		
		
		break;
	}
	
	#endregion
	
	#region Ataque Aéreo
	case "ataque aereo":
	{
		aplica_gravidade();
		
		//Checando se troquei de estado
		if(sprite_index != spr_player_attack_ar1)
		{
			sprite_index = spr_player_attack_ar1;
			image_index = 0;
		}
		
		//Criando o objeto de dano
		if(image_index >= 1 && dano == noone && posso)
		{
			dano		= instance_create_layer(x + sprite_width/2 + velh * 2, y - sprite_height/2, layer, obj_dano);
			dano.dano	= ataque;
			dano.pai	= id;
			posso		= false;
		}
		
		//Saindo do estado
		if(image_index >= image_number - 1)
		{
			estado = "pulando";
			finaliza_ataque();
		}
		if(chao)
		{
			estado = "parado";
			posso = true;	
			if(dano)
			{
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		
		break;
	}
	#endregion
	
	#region Ataque
	case "ataque":
	{
		velh = 0;
		
		if(combo == 0)
		{
		sprite_index = spr_player_ataque01;
		}
		else if(combo == 1)
		{
			sprite_index = spr_player_ataque02;
		}
		else if(combo == 2)
		{
			sprite_index = spr_player_ataque03;
		}
		
		//Criando o objeto de dano
		if(image_index >= 2 && dano == noone && posso)
		{
			dano		= instance_create_layer(x + sprite_width/2, y - sprite_height/2, layer, obj_dano);
			dano.dano	= ataque * ataque_mult;
			dano.pai	= id;
			posso		= false;
		}
		
		//Configurando com o buff
		if(attack && combo < 2)
		{
			ataque_buff = room_speed;
		}
		
		if(ataque_buff && combo < 2 && image_index >= image_number-1)
		{
			combo ++;
			image_index = 0;
			posso = true;
			ataque_mult += .6;
			if(dano)
			{
				instance_destroy(dano, false);
				dano = noone;
			}
			
			//Zerar o buff
			ataque_buff = 0;
		}
		
		if(image_index > image_number-1)
		{
			estado = "parado";
			velh = 0;
			combo = 0;
			posso = true;
			ataque_mult = 1;
			finaliza_ataque();
		}
		if(dash && dash_timer <= 0)
		{
			estado = "dash";
			image_index = 0;
			combo = 0;
			if(dano)
			{
				instance_destroy(dano, false);
				dano = noone;
			}
		}
		if (velv != 0)
		{
			estado = "pulando";
			image_index = 0;
		}
		
		break;
	}
	#endregion
	
	#region Dash
	case "dash":
	{
		if(sprite_index != spr_player_dash)
		{
			sprite_index = spr_player_dash;
			image_index = 0;
		}
		
		//Velocidade
		mid_velh = image_xscale * dash_vel;
		velh = 0;
		
		//Saindo do estado
		if(image_index >= image_number-1 || !chao)
		{
			estado = "parado";
			mid_velh = 0;
			
			//Resetando o timer do dash
			dash_timer = dash_delay;
		}
		
		break;
	}
	#endregion
	
	case "hit":
	{
		if(sprite_index != spr_player_hit)
		{
			sprite_index = spr_player_hit;
			image_index = 0;
			
			//Tremendo a tela
			screenshake(5);
			
			//Deixando invencível
			invencivel = true;
			tempo_invencivel = invencivel_timer;
		}
		
		//Ficando parado ao levar dano
		velh = 0;
		mid_velh = 0;
		
		//Saindo do estado
		
		//Checando se eu devo 
		
		if(vida_atual > 0)
		{
			if(image_index >= image_number-1)
			{
				estado = "parado";
			}
		}
		else
		{
			if(image_index >= image_number-1)
			{
				estado = "dead";
			}
		}
		
		break;
	}
	
	case "dead":
	{
		//Checando se o controlador existe
		if (instance_exists(obj_game_controller))
		{
			with(obj_game_controller)
			{
				game_over = true;
			}
		}
		
		velh = 0;		
		if(sprite_index != spr_player_dead)
		{
			image_index = 0;
			sprite_index = spr_player_dead;
		}
		
		//Ficando para no final da animação
		if(image_index >= image_number-1)
		{
			image_index = image_number-1;
		}
		
		break;
	}
	
	//Estado padrão
	default:
	{
		estado = "parado";
	}
}

show_debug_message(tempo_invencivel);

if(keyboard_check(vk_enter)) game_restart();