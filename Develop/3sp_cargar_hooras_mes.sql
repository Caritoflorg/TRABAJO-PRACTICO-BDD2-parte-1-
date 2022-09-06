DELIMITER $$
    
create procedure cargar_horas_mes(in emp_id int, in pro_id int, in rol_id int, in cli_id int, in horas int)
begin
	
	set @cont = 0;
	set @target = dayofmonth(last_day(sysdate()));
    
    select sum(hor_horas_dia) into @suma_horas
    from hora
    where emp_legajo = emp_id;
	
    if @sum_horas <= 310 then
    
		while @cont <= @target do
			
			set @fecha = DATE_ADD(SYSDATE(), INTERVAL +@cont DAY);
			
			if weekday(@fecha) != 6 then
        
				insert into hora(emp_legajo, pro_id_proyecto, rol_id_rol, cli_id_cliente, hor_fecha, hor_horas_dia)
				values (emp_id, pro_id, rol_id, cli_id, @fecha, horas);
				set @cont = @cont + 1;
			else
				set @cont = @cont + 1;
				set @target = @target +1;
			end if;
            
		end while;
	else
		select 'Excedio el limite maximo de horas por mes (310).' as Advertencia;
	end if;
    
end;
        
$$