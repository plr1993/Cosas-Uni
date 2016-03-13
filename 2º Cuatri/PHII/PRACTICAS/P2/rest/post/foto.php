<?php
// FICHERO: rest/post/foto.php

$METODO = $_SERVER['REQUEST_METHOD'];
// EL METODO DEBE SER POST. SI NO LO ES, NO SE HACE NADA.
if($METODO<>'POST') exit();
// PETICIONES POST ADMITIDAS:
//   rest/foto/

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
// Se supone que si llega aquí es porque todo ha ido bien y tenemos los datos correctos:
$PARAMS      = $_POST;
$login       = sanatize($PARAMS['login']);
$clave       = sanatize($PARAMS['clave']);
$id_viaje    = sanatize($PARAMS['id_viaje']);
$descripcion = sanatize($PARAMS['descripcion']);
$fecha       = sanatize($PARAMS['fecha']);

if( !comprobarSesion($login,$clave) )
{
  $RESPONSE_CODE = 401;
    $R = array('RESULTADO' => 'ok',  "CODIGO" => '401', 'DESCRIPCION' => 'Tiempo de sesión agotado.');
}
else
{
  try{

    // Se sube el fichero:
    // SI HAY FOTO, HAY QUE COPIARLA
    if( count($_FILES['foto']['name']) == 1)
    {
      if($_FILES['foto']['size'] > $max_uploaded_file_size)
      {
        //CONTROLAR TAMAÑO DE FICHERO
        $R = array('RESULTADO' => 'error', 'CODIGO' => '401', 'TAMANYO_FICHERO' => $_FILES['foto']['size'], 'MAX_TAMANYO' => $max_uploaded_file_size,'DESCRIPCION' => $_FILES["foto"]["error"]);
      }
      else
      {
        // ===================
        // HAY FOTO
        // ===================
        if( mysqli_query($link,'BEGIN') )
        {
          $mysql  ='insert into foto(DESCRIPCION,FECHA,ID_VIAJE) values("' . $descripcion;
          $mysql .= '",CONVERT("' . $fecha . '",DATE),' . $id_viaje . ')';
          if( mysqli_query( $link, $mysql ) )
          {
            $mysql = 'select MAX(ID) as ID from foto';
            if( $res=mysqli_query( $link, $mysql ) )
            {
              $row = mysqli_fetch_assoc($res);
              $ID = $row['ID'];
              // Se copia el fichero
              $ext = pathinfo($_FILES['foto']['name'], PATHINFO_EXTENSION); // extensión del fichero
              $uploadfile = $uploaddir . $id_viaje . '/' . $ID . '.' . $ext; // path fichero destino
              // Se crea el directorio si no existe
              if (!file_exists($uploaddir . $id_viaje)) {
                  mkdir($uploaddir . $id_viaje, 0777, true);
              }
              if(move_uploaded_file($_FILES['foto']['tmp_name'], $uploadfile)) // se sube el fichero
              {
                $mysql = 'update foto set FICHERO="' . $ID . '.' . $ext . '" where ID=' . $ID;
                if( $res=mysqli_query( $link, $mysql ) )
                {
                  // ===============================================================
                    // Se ha subido la foto correctamente.
                      //$R['foto'] = $uploadfile;
                    $R = array('RESULTADO' => 'ok', 'CODIGO' => '200', 'ID_FOTO' => $ID , 'FICHERO' => $uploadfile);
                }
                // ===============================================================
              }
              else // if(move_uploaded_file($_FILES['foto']['tmp_name'], $uploadfile))
              {
                //echo "Not uploaded because of error #".$_FILES["foto"]["error"];
                $mysql = 'delete from foto where ID=' . $ID; // se borrar el registro
                mysqli_query( $link, $mysql );
                $R = array('RESULTADO' => 'error', 'CODIGO' => '500', 'ID_FOTO' => $ID , 'DESCRIPCION' => $_FILES["foto"]["error"]);
              }
            }

          }
          // ******** FIN DE TRANSACCION **********
          mysqli_query($link,'COMMIT');
        }
        else
        {
          mysqli_query($link,'ROLLBACK');
        }
      } // if($_FILES['foto']['size'] > $max_uploaded_file_size)
    } // if( count($_FILES['f']['name']) == 1)
  } catch(Exception $e){
    // Se ha producido un error, se cancela la transacción.
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