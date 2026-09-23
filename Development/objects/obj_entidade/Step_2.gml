//Passando o mid_velh para o velh enquanto ele for menor do que o limite
if(abs(velh) <= max_velh)
{
	velh += mid_velh;
}
else
{
	velh = 0;
}

//Sistema de colisão e movimentação
var _velh = sign(velh);
var _velv = sign(velv);

repeat(abs(velh))
{
	if(place_meeting(x + _velh, y, obj_block))
	{
		velh = 0;
		break;
	}
	x += _velh;
}

//Vertical
repeat(abs(velv))
{
	if(place_meeting(x, y + _velv, obj_block))
	{
		velv = 0;
		break;
	}
	y += _velv;
}