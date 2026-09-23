var outro = instance_place(x, y, obj_entidade);
var outro_lista = ds_list_create();
var quantidade = instance_place_list(x, y, obj_entidade, outro_lista, 0);


//Adicionando todo mundo que eu toquei na lista de aplica dano
for (var i = 0; i < quantidade; i++)
{
	//Checando o atual
	var atual = outro_lista[| i];
	
	//Checando se o atual está invencível
	if(atual.invencivel)
	{
		continue;
	}
	
	//show_message(object_get_name(atual.object_index));
	//Checando se a colisão não é com um filho do meu pai
	if(object_get_parent(atual.object_index) != object_get_parent(pai.object_index))
	{
		//Isso só vai rodar SE eu puder dar dano nos inimigos
		
		
		//Checar se eu realmente posso dar dano
		
		//Checar se o atual já está na lista
		var pos = ds_list_find_index(aplicar_dano, atual);
		if(pos == -1)
		{
			//O atual ainda não está na minha de dano
			//Adiciono o atual a lista de dano
			ds_list_add(aplicar_dano, atual);
		}
	}
}

//Aplicando o dano
var tam = ds_list_size(aplicar_dano);
for (var i = 0; i < tam; i++)
{
	outro = aplicar_dano[| i].id;
	if(outro.vida_atual > 0)
	{
		if(outro.delay <= 0)
		{
			outro.estado = "hit";
			outro.image_index = 0;
		}
		outro.vida_atual -= dano;
		
		//Preciso checar se estou acertando o inimigo
		//Checando se sou filho do inimigo pai
		if(object_get_parent(outro.object_index) == obj_inimigo_pai)
		{
			//Dando um screenshake apenas para inimigos
			screenshake(2);
			
			//Garantindo que irão morrer
			if(outro.vida_atual <= 0)
			{
				outro.estado = "dead";
			}
		}
	}
}

//Destruindo as minhas listas
ds_list_destroy(aplicar_dano);
ds_list_destroy(outro_lista);

if(morrer)
{
	instance_destroy();
}
else
{
	y = pai.y - pai.sprite_height/4;
	
	if(quantidade)
	{
		instance_destroy();
	}
}

/*
//Se eu estou tocando em alguém
if(outro)
{
	//Se eu estou tocando em mim
	if(outro.id != pai)
	{
		
		//Checando quem é o pai do outro
		var papi = object_get_parent(outro.object_index);
		if(papi != object_get_parent(pai.object_index))
		{
			if(outro.vida_atual > 0)
			{
				outro.estado = "hit";
				outro.image_index = 0;
				outro.vida_atual -= dano;
				instance_destroy();
			}
		}
	}
}
*/