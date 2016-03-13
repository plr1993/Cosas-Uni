<?php
// FICHERO: rest/post/viaje.php
// FUNCIÓN: Realiza el alta de viaje

$METODO = $_SERVER['REQUEST_METHOD'];
// EL METODO DEBE SER POST. SI NO LO ES, NO SE HACE NADA.
if($METODO<>'POST') exit();
// PETICIONES POST ADMITIDAS:
//   rest/viaje/

// =================================================================================
// =================================================================================
// INCLUSION DE LA CONEXION A LA BD
require_once('../configbd.php');
// =================================================================================
// =================================================================================

$PARAMS   = $_POST;
$FICHEROS = $_FILES;

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
// Se supone que si llega aquí es porque todo ha ido bien y tenemos los datos correctos
// del nuevo viaje, NO LAS FOTOS. Las fotos se suben por separado una vez se haya 
// confirmado la creación correcta del viaje.
$PARAMS      = $_POST;
$clave       = sanatize($PARAMS['clave']);
$login       = sanatize($PARAMS['login']);
$nombre      = sanatize($PARAMS['nombre']);
$descripcion = sanatize(nl2br($PARAMS['descripcion'],false));
$valoracion  = sanatize($PARAMS['v']);
$fi          = sanatize($PARAMS['fi']); // fecha inicio
$ff          = sanatize($PARAMS['ff']); // fecha fin

if( !comprobarSesion($login,$clave) )
  $R = array('RESULTADO' => 'ok', 'CODIGO' => '200', 'DESCRIPCION' => 'Tiempo de sesión agotado.');
else
{
    // =================================================================================
    try{
      mysqli_query($link, "BEGIN");
      $mysql  = 'insert into viaje(NOMBRE,DESCRIPCION,FECHA_INICIO, FECHA_FIN,VALORACION,LOGIN) ';
      $mysql .= 'values("' . $nombre . '","' . $descripcion . '",CONVERT("' . $fi . '",DATE),CONVERT("' . $ff . '",DATE),' . $valoracion . ',"' . $login . '")';

      if( mysqli_query($link,$mysql) )
      { // Se han insertado los datos de la ruta.
        // Se saca el id de la ruta
        $mysql = "select MAX(ID) as ID from viaje";
        if( $res = mysqli_query($link,$mysql) )
        {
          $viaje = mysqli_fetch_assoc($res);
          $ID_VIAJE = $viaje['ID'];
        }
        $R = array('RESULTADO' => 'ok', 'CODIGO' => '200', 'ID_VIAJE' => $ID_VIAJE);
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
} // if( !comprobarSesion($login,$clave) )

// =================================================================================
// SE HACE LA CONSULTA
// =================================================================================
if( count($R)==0 && $res = mysqli_query( $link, $mysql ) )
{
  if( substr($mysql, 0, 6) == "select" )
  {
    while( $row = mysqli_fetch_assoc( $res ) )
      $R[] = $row;
    mysqli_free_result( $res );
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
// =================================================================================
?>