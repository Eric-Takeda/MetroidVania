//Criando o menu

//Seleção do menu
sel = 0;
marg_val = 32;
marg_total = 32;

//Controlando a página do menu
pag = 0;

#region MÉTODOS

//Desenha menu
desenha_menu = function(_menu)
{
	//Definindo a fonte
	draw_set_font(fnt_menu);
	//Alinhando o texto
	define_align(1, 0);

	//Desenhando o meu menu
	//Pegando o tamanho do meu menu
	var _qtd = array_length(_menu);
	//Pegando a altura da minha tela
	var _alt = display_get_gui_height();
	//Pegando a largura
	var _larg = display_get_gui_width();

	//Definindo o espaço entre linhas
	var _espaco_y = string_height("I") + 16;
	var _alt_menu = _espaco_y * _qtd;

	//Desenhando as opções
	for(var i = 0; i < _qtd; i++)
	{
		var _cor = c_white, _marg_x = 0;
		//Desenhando o item do menu
		var _texto = _menu[i][0];
	
		//Checando se a seleção está no texto atual
		if(menus_sel[pag] == i)
		{
			_cor = c_red;
			_marg_x = marg_val;
		}
	
		draw_text_color(50 + _marg_x, (_alt / 2) - _alt_menu/2 + (i * _espaco_y), _texto, _cor, _cor, _cor, _cor, 1);
	}
	
	//Desenha o outro lado do menu (As opções quando elas existirem)
	//Rodando meu vetor
	for(var i = 0; i < _qtd; i++)
	{
		//Checar se eu preciso desenhar as opções
		switch(_menu[i][1])
		{
			case menu_acoes.ajustes_menu:
			{
				//Desenhando as opções do lado direito
				//Salvando o indice que eu estou
				var _indice = _menu[i][3];
				var _txt = _menu[i][4][_indice];
				
				//Eu só posso ir para a esquerda SE somente SE eu não estou no índice 0
				var _esq = _indice > 0 ? "-" : "";
				
				//Eu só posso ir para a direita Se somente Se eu não estou no final do vetor
				var _dir = _indice < array_length(_menu[i][4]) - 1 ? "-" : "";
				
				
				var _cor = c_white;
				//Se eu estou mexendo nessa opção, e mudo de cor
				if(alterando && menus_sel[pag] == i) _cor = c_red;
				
				draw_text_color(_larg / 2, (_alt / 2) - _alt_menu/2 + (i * _espaco_y), _esq + _txt + _dir, _cor, _cor, _cor, _cor, 1);
				
				break;
			}
		}
	}

	//Resetando os meus draw_sets
	draw_set_font(-1);
	define_align(-1, -1);
}

//Controlando o menu
controla_menu = function(_menu)
{
	//Pegando as teclas
	var _up, _down, _avanca, _recua, _left, _right;
	
	var _sel = menus_sel[pag];
	
	static _animar = false;

	_up = keyboard_check_pressed(vk_up);
	_down = keyboard_check_pressed(vk_down);
	_avanca = keyboard_check_released(vk_enter) || keyboard_check_pressed(vk_space);
	_recua = keyboard_check_released(vk_escape);
	_left = keyboard_check(vk_left);
	_right = keyboard_check_pressed(vk_right)

	//Checando se eu não estou alterando as opções do jogo
	if(!alterando)
	{
		if(_up || _down)
		{
			//Mudando o valor do sel
			menus_sel[pag] += _down - _up;
	
			//Limitando o sel dentro do vetor
			var _tam = array_length(_menu) - 1;
			menus_sel[pag] = clamp(menus_sel[pag], 0, _tam);
		
			//Avisando que ele pode animar
			_animar  = true;
		}
	}
	else
	{
		//Ou seja, eu estou alterando as opções
		_animar = false;
		
		//Se eu apertar para a esquerda ou para a direita eu mexo nas opções
		if(_right or _left)
		{
			//Achando o meu limite
			var _limite = array_length(_menu[_sel][4]) - 1;
			//Mudando o meu indice dentro do menu que eu estou
			menus[pag][_sel][3] += _right - _left;
			//Garantindo que eu não vou sair do limite
			menus[pag][_sel][3] = clamp(menus[pag][_sel][3], 0, _limite);
		}
	}
	
	//O que fazer quando eu apertar o enter
	if(_avanca)
	{
		switch(_menu[_sel][1])
		{
			//Caso seja 0, ele roda um método
			case menu_acoes.roda_metodo: _menu[_sel][2](); break;
			//Mudar o valor da pag
			case menu_acoes.carrega_menu: pag = _menu[_sel][2]; break;
			case menu_acoes.ajustes_menu: 
				alterando = !alterando; 
				
				//Rodando o método
				if(!alterando)
				{
					//Salvando o argumento do método
					var _arg = _menu[_sel][3]
					_menu[_sel][2](_arg);
				}
				
				break;
		}
	}
	
	//Aumentando sempre o marg_val
	if(_animar)
	{
		marg_val = marg_total * valor_ac(ac_margem, _up ^^ _down);
	}
}

inicia_jogo = function()
{
	//Indo para a room inicial do jogo
	//Transição
	room_goto(Room0);
}

teste = function()
{

}

fecha_jogo = function()
{
	game_end();
}

ajusta_tela = function(_valor)
{
	//Checar se ewu mandei a tela ficar cheia ou restaurada
	switch(_valor)
	{
		//Tela Cheia
		case 0: window_set_fullscreen(true); break;
		//Restaurada
		case 1: window_set_fullscreen(false); break;
	}
}

#endregion

//Quando eu apertar enter no iniciar, ele roda um método
//Quando clicar enter no opções, ele carrega elas, igualmente a equipe
//Quando eu clicar enter no sair, ele fecha o jogo

//Texto - Ação - Conteúdo da Ação

menu_principal = [
					["Iniciar", menu_acoes.roda_metodo, inicia_jogo],
					["Ajustes", menu_acoes.carrega_menu, menus_lista.opcoes],
					["Sair", menu_acoes.roda_metodo, fecha_jogo]
				];

menu_opcoes = [
					["Tipo de Janela", menu_acoes.carrega_menu, menus_lista.tela],
					["Elenco", menu_acoes.carrega_menu, menus_lista.elenco],
					["Voltar", menu_acoes.carrega_menu, menus_lista.principal],
				];

menu_elenco = [
					["Elenco", menu_acoes.ajustes_menu, teste, 0, ["Eric Takeda", "Leandro Benigno", "Miguel Neris"]],
					["Voltar", menu_acoes.carrega_menu, menus_lista.opcoes]
				];

menu_tela =	  [
					["Tipo de Tela", menu_acoes.ajustes_menu, ajusta_tela, 1, ["Tela cheia", "Janela"]],
					["Voltar", menu_acoes.carrega_menu, menus_lista.opcoes]
				];

//Salvando todos os meus menus
menus = [menu_principal, menu_opcoes, menu_tela, menu_elenco];

//Salvando a seleção de cada menu
menus_sel = array_create(array_length(menus), 0);

alterando = false;