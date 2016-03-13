<?php
// ============================================================
// PARAMETROS GENERALES DE CONFIGURACION
// ============================================================
$uploaddir = '../../fotos/'; // La carpeta fotos se encuentra en la misma carpeta que la carpeta rest
$uploaddir_fotos_usu = '../../fotos/usu/'; // La carpeta fotos se encuentra en la misma carpeta que la carpeta rest
$max_uploaded_file_size = 2000 * 1024; // en Bytes (2MB)
$tiempo_de_sesion = 1800000; // 30 minutos * 60 segundos = 1800 segundos
// ============================================================
// COMPROBAR SI ES FECHA
// ============================================================
function es_fecha( $str ){
    $stamp = strtotime( $str );
    if (!is_numeric($stamp) || !preg_match("^\d{4}-\d{2}-\d{2}^", $str))
        return FALSE;
    $month = date( 'm', $stamp );
    $day   = date( 'd', $stamp );
    $year  = date( 'Y', $stamp );
    if (checkdate($month, $day, $year))
        return TRUE;
    return FALSE;
}
?>
