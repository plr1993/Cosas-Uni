<?php
// FICHERO: rest/get/viaje.php
// =================================================================================
// =================================================================================
// INCLUSION DE LA CONEXION A LA BD
   require_once('../configbd.php');
// =================================================================================
// =================================================================================
$METODO = $_SERVER['REQUEST_METHOD'];
// EL METODO DEBE SER GET. SI NO LO ES, NO SE HACE NADA.
if($METODO<>'GET') exit();
// PETICIONES GET ADMITIDAS:
//   rest/viaje/{ID_VIAJE}  -> devuelve toda la información de la ruta
//	 rest/viaje/?u={número}	-> devuelve los últimos 'número' viajes, ordenados de más a menos recientes
//	 rest/viaje/?bt={texto}	-> busca el texto en nombre del viaje y en la descripción
//	 rest/viaje/?n={nombre}
//	 rest/viaje/?d={descripción}
//	 rest/viaje/?l={login}
//   rest/viaje/?vi={número_de1_a_5} -> valoración inicial
//   rest/viaje/?vf={número_de1_a_5} -> valoración final
//   rest/viaje/?fi={aaaa-mm-dd} -> viajes con fecha de inicio posterior o igual a fi
//   rest/viaje/?ff={aaaa-mm-dd} -> viajes con fecha de fin anterior o igual a ff
//	 rest/viaje/?pag={pagina}&lpag={número de registros por pagina} -> devuelve los registros que están en la página que se le pide, tomando como tamaño de página el valor de lpag

$RECURSO = array();
$RECURSO = explode("/", $_GET['prm']);
$PARAMS = array_slice($_GET, 1, count($_GET) - 1,true);
$ID = $RECURSO[0];

// =================================================================================
// CONFIGURACION DE SALIDA JSON Y CORS PARA PETICIONES AJAX
// =================================================================================
header("Access-Control-Allow-Orgin: *");
header("Access-Control-Allow-Methods: *");
header("Content-Type: application/json");
// =================================================================================
// Se prepara la respuesta
// =================================================================================
$R = [];                    // Almacenará el resultado.
$RESPONSE_CODE = 200;       // código de respuesta por defecto: 200 - OK
$mysql='';                  // para el SQL
$TOTAL_COINCIDENCIAS = -1;  // Total de coincidencias en la BD

// =================================================================================
if(is_numeric($ID))
{ // Se debe devolver la información del viaje
    $mysql  = 'select * from viaje where ID=' . sanatize($ID);
}
else 
{ // Se utilizan parámetros
    $mysql  = 'select v.*,';
    $mysql .= '(select f.FICHERO from foto f where f.ID_VIAJE=v.ID order by f.ID LIMIT 0,1) as FOTO,';
    $mysql .= '(select f.DESCRIPCION from foto f where f.ID_VIAJE=v.ID order by f.ID LIMIT 0,1) as DESCRIPCION_FOTO,';
    $mysql .= '(select count(*) from foto f where f.ID_VIAJE=v.ID) as NFOTOS,';
    $mysql .= '(select count(*) from comentario c where c.ID_VIAJE=v.ID) as NCOMENTARIOS';
    $mysql .= ' FROM viaje v';

	// Se piden los últimos viajes subidos
	if(isset($PARAMS['u']) && is_numeric($PARAMS['u'])){
		$mysql .= ' order by v.FECHA_INICIO desc';
		$PARAMS['pag'] = 0;
		$PARAMS['lpag'] = sanatize($PARAMS['u']);
	}
	else if(isset($PARAMS['bt'])){
		// Búsqueda por texto en todos los campos
		$mysql .= ' where NOMBRE like "%' . sanatize($PARAMS['bt']) . '%" or DESCRIPCION like "%' . sanatize($PARAMS['bt']) . '%"';
	}
	else
	{
		$mysql .= ' where';
		// BÚSQUEDA POR NOMBRE
		if( isset($PARAMS['n']) )
			$mysql .= ' NOMBRE like "%' . sanatize($PARAMS['n']) . '%"';
		// BÚSQUEDA POR DESCRIPCIÓN
		if( isset($PARAMS['d']) )
		{
			if(substr($mysql, -5) != 'where') $mysql .= ' and';
				$mysql .= ' DESCRIPCION like "%' . sanatize($PARAMS['d']) . '%"';
		}
		// BÚSQUEDA POR AUTOR (LOGIN)
		if( isset($PARAMS['l']) )
		{
			if(substr($mysql, -5) != 'where') $mysql .= ' and';
			$mysql .= ' LOGIN like "%' . sanatize($PARAMS['l']) . '%"';
		}
        // BÚSQUEDA POR VALORACION
        if( isset($PARAMS['vi']) ) // VALORACION INICIAL
        {
            if(substr($mysql, -5) != 'where') $mysql .= ' and';
            $mysql .= ' valoracion >= ' . sanatize($PARAMS['vi']);
        }
        if( isset($PARAMS['vf']) ) // VALORACION FINAL
        {
            if(substr($mysql, -5) != 'where') $mysql .= ' and';
            $mysql .= ' valoracion <= ' . sanatize($PARAMS['vf']);
        }
		// BÚSQUEDA POR FECHA
		if(isset($PARAMS['fi']) && es_fecha($PARAMS['fi']) )
		{
			if(substr($mysql, -5) != 'where') $mysql .= ' and';
			$mysql .= ' (CONVERT("' . sanatize($PARAMS['fi']) . '",DATE) <= FECHA_FIN)';
		}
		if(isset($PARAMS['ff']) && es_fecha($PARAMS['ff']) )
		{
			if(substr($mysql, -5) != 'where') $mysql .= ' and';
			$mysql .= ' (CONVERT("' . sanatize($PARAMS['ff']) . '",DATE) >= FECHA_INICIO)';
		}
	}

    // Para la paginación
	if(isset($PARAMS['pag']) && is_numeric($PARAMS['pag']) 		// Página a listar
		&& isset($PARAMS['lpag']) && is_numeric($PARAMS['lpag']))	// Tamaño de la página
	{
        $pagina = sanatize($PARAMS['pag']);
        $regsPorPagina = sanatize($PARAMS['lpag']);
        $ELEMENTO_INICIAL = $pagina * $regsPorPagina;
        
        if(substr($mysql, -5) == 'where')
            $mysql = substr($mysql,0,strlen($mysql) - 6);

        // =================================================================================
        // Para sacar el total de coincidencias que hay en la BD:
        // =================================================================================
        if( $res = mysqli_query( $link, $mysql ) )
        {
            $TOTAL_COINCIDENCIAS = mysqli_num_rows($res);
            mysqli_free_result( $res );
        }
        
        $mysql .= ' LIMIT ' . $ELEMENTO_INICIAL . ',' . $regsPorPagina;
    }   
}

// =================================================================================
// SE HACE LA CONSULTA
// =================================================================================
if( strlen($mysql)>0 && count($R)==0 && $res = mysqli_query( $link, $mysql ) )
{
    $AA = array('RESULTADO' => 'ok', 'CODIGO' => '200');
    if($TOTAL_COINCIDENCIAS>-1)
    {
        $AA['TOTAL_COINCIDENCIAS'] = $TOTAL_COINCIDENCIAS;
        $AA['PAGINA'] = $pagina;
        $AA['REGISTROS_POR_PAGINA'] = $regsPorPagina;
    }
    if( substr($mysql, 0, 6) == 'select' )
    {
        while( $row = mysqli_fetch_assoc( $res ) )
          $R[] = $row;
        mysqli_free_result( $res );

        $R = array_merge( $AA, array('FILAS' => $R) );
    }
    else $R[] = $res;
}

// =================================================================================
// SE CIERRA LA CONEXION CON LA BD
// =================================================================================
mysqli_close($link);
// =================================================================================
// SE DEVUELVE EL RESULTADO DE LA CONSULTA
// =================================================================================
try {
    // Here: everything went ok. So before returning JSON, you can setup HTTP status code too
    http_response_code($RESPONSE_CODE);
    print json_encode($R);
}
catch (SomeException $ex) {
    $rtn = array('RESULTADO' => 'error', 'CODIGO' => '500', 'DESCRIPCION' => "Se ha producido un error al devolver los datos.");
    http_response_code(500);
    print json_encode($rtn);
}

?>