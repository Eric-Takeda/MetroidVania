// Inherit the parent event
event_inherited();

//Adicionando os atributos do boss
vida_max = 25;
vida_atual = vida_max;

max_velh = 3;
max_velv = 3;

timer_estado = 0;

ataque = 2;
massa = 3;

taunt_delay = room_speed * 2;
taunt_timer = taunt_delay;

//Substate
ataque = irandom(2); //O, 1 ou 2