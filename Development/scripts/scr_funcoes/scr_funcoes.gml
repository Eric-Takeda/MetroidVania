function scr_funcoes(){

}


//Enumerator para definir as minhas ações possíveis
enum menu_acoes
{
	roda_metodo,
	carrega_menu,
	ajustes_menu
}

enum menus_lista
{
	principal, 
	opcoes,
	tela,
	elenco
}


//Screenshake
///@function screenshake(valor_da_tremida)
///@arg força_da_tremida
///@arg [dir_mode]
///@arg [direcao]
function screenshake(_treme, _dir_mode, _direcao)
{
	var shake = instance_create_layer(0, 0, "instances", obj_screenshake);
	shake.shake = _treme;
	shake.dir_mode = _dir_mode;
	shake.dir = _direcao;
}


//Define align
///@function define_align(vertical, horizontal)
function define_align(_ver, _hor)
{
	draw_set_halign(_hor);
	draw_set_valign(_ver);
}

//Pegar o valor da curva de animação
///@function valor_ac(animation_curve, animar, [canal])
function valor_ac(_anim, _animar = false, _chan = 0)
{
	//Posição da animação
	static _pos = 0, _val = 0;
	
	//Aumentando o valor do _pos
	//Em um segundo o pos vai do 0 até o 1 (final da animação)
	_pos += delta_time / 1000000
	
	if(_animar) _pos = 0;
	
	//Pegando o valor do canal
	var _canal = animcurve_get_channel(_anim, _chan);
	_val = animcurve_channel_evaluate(_canal, _pos);
	
	show_debug_message(_val);
	
	return _val;
}