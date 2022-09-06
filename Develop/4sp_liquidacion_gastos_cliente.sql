DELIMITER $$

create procedure liquidacion_gastos_cliente(in id_cli int, in id_pro int, in mes int)
begin

	declare total int;

	declare gastos_cliente cursor for

	select sum(r.rol_paga_hora * h.hor_horas_dia)
	from rol r 
		inner join hora h on r.rol_id_rol = h.rol_id_rol
		where h.cli_id_cliente = id_cli and month(h.hor_fecha) = mes;

	declare continue handler for not found set @hecho = true;

	open gastos_cliente;

	loop1: loop

	fetch gastos_cliente into total;

	if @hecho then
		leave loop1;
	end if;

	end loop loop1;

	close gastos_cliente;
    
    insert into liquidaciones(cli_id_cliente, pro_id_proyecto, liq_fecha_consulta, liq_mes_target, liq_total)
    values(id_cli, id_pro, sysdate(), mes, total);
    
    create temporary table result(
		cli_id_cliente int,
		pro_id_proyecto int,
        liq_fecha_consulta datetime,
        liq_mes_target int,
        liq_total int);
	
	insert into result(cli_id_cliente, pro_id_proyecto, liq_fecha_consulta, liq_mes_target, liq_total)
    values(id_cli, id_pro, sysdate(), mes, total);
    
    select *
    from result;

end;

$$