<?php
// FICHERO: rest/post/comentario.php

$METODO = $_SERVER['REQUEST_METHOD'];
// EL METODO DEBE SER POST. SI NO LO ES, NO SE HACE NADA.
if($METODO<>'POST') exit();
// PETICIONES POST ADMITIDAS:
//   rest/comentario/

// =================================================================================
// =================================================================================
// INCLUSION DE LA CONEXION A LA BD
   require_once('../configbd.php');
// =================================================================================
// =================================================================================

// =================================================================================
// CONFIGURACION DE SALIDA JSON Y CORS PARA PETICIONES AJAX
// =================================================================================
header("Access-Control-Allow-Orgin: *");
header("Access-Control-Allow-Methods: *");
header("Content-Type: application/json");
// =================================================================================
// Se prepara la respuesta
// =================================================================================
$R = []; // Almacenará el resultado.
$RESPONSE_CODE = 200; // código de respuesta por defecto: 200 - OK
// =================================================================================
// =================================================================================
$PARAMS   = $_POST;
$login    = sanatize($PARAMS['login']);
$clave    = sanatize($PARAMS['clave']);
$titulo   = sanatize($PARAMS['titulo']);
$texto    = sanatize(nl2br($PARAMS['texto'],false));
$id_viaje = sanatize($PARAMS['id_viaje']);

if( !comprobarSesion($login,$clave) )
{
	$RESPONSE_CODE = 401;
  	$R = array('RESULTADO' => 'ok',  "CODIGO" => '401', 'DESCRIPCION' => 'Tiempo de sesión agotado.');
}
else
{
	try{
		mysqli_query($link, 'BEGIN'); // Inicio de transacción
		$mysql  = 'insert into comentario(TITULO,TEXTO,LOGIN,ID_VIAJE) values("' . $titulo;
		$mysql .= '","' . $texto . '","' . $login . '",' . $id_viaje . ')';

		if(mysqli_query($link, $mysql))
		{
			$mysql = 'select MAX(ID) as ID from comentario';
			if( $res = mysqli_query($link,$mysql) )
      		{
		        $row = mysqli_fetch_assoc($res);
		        $ID = $row['ID'];
		  		$R = array('RESULTADO' => 'ok', 'CODIGO' => '200', 'ID_COMENTARIO' => $ID);
		  	}
		}
		else
		{
			$RESPONSE_CODE = 500;
	    	$R = array('RESULTADO' => 'error', 'CODIGO' => '500', 'DESCRIPCION' => 'Error de servidor.');
		}
		mysqli_query($link, "COMMIT");
	}catch(Exception $e){
	  mysqli_query($link, "ROLLBACK");
	}
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

// =================================================================================
?>