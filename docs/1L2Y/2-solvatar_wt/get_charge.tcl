# Declara una función para obtener la carga de un sistema ("top" por defecto)
proc get_total_charge {{molid top}} {
	eval "vecadd [[atomselect $molid all] get charge]"
}

puts "Para calcular la carga usar: 'get_total_charge top"