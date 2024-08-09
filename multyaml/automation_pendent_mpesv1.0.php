<?php

date_default_timezone_set('America/Fortaleza');

// Checar todos os chamados com status pendente, no caso do MPES ainda está decidindo, caso não mude nada
// Considerar status 4, no Toki considerar status 101

function attTicketsPendents() {
	
    global $DB;
    
    $server = "localhost";
    $user="root";
    $password="root";
    $dbname="GLPI";

    $DB=new mysqli($server,$user,$password,$dbname);

    if($DB->connect_error){
        die("Conexão falhou: ". $BD->connect_error);
    }else{
       echo "Conexão bem sucedida";
    }


    $sqlTickets = 'SELECT id,status,begin_waiting_date FROM glpi_tickets WHERE status = 4';

    $result = $DB->query($sqlTickets);
    
    #$aData = date_create($_SESSION["glpi_currenttime"]); // Convertendo a sessão para DateTime

    $aData = date_create(date('Y-m-d H:i:s'));

 
    $aDate = $aData->format('Y-m-d H:i:s');
   

    foreach ($result as $value) {
        $id = $value["id"];
        $status = $value["status"];
        $begin_waiting_date = $value["begin_waiting_date"];

        if ($begin_waiting_date === NULL) {
            // Se a data for NULL, não faça o cálculo de horas
            continue;
        }

        $dataPend = date_create($begin_waiting_date); // Convertendo a data do banco de dados para DateTime

	$delay_time = date_diff($aData, $dataPend);

        // Calcular o total de minutos
        $total_minutes = ($delay_time->days * 24 * 60) + ($delay_time->h * 60) + $delay_time->i + intval($delay_time->s / 60);

        // Converter para horas e minutos
        $total_hours = intval($total_minutes / 60);
        $remaining_minutes = $total_minutes % 60;

        // Formatar a diferença no formato HH:MM
        $formatted_time = sprintf("%02d:%02d", $total_hours, $remaining_minutes);

        // Atribuir o valor formatado a uma variável
        $time_diff = $formatted_time;

        // Comparar com 23:00
        if ($total_hours > 24) {

            $sqlUpdateTickets = "UPDATE glpi_tickets SET date_mod='".$aDate."', users_id_lastupdater=2, status=2, begin_waiting_date=NULL WHERE id=".$id.";"; 

            $execUpdate = $DB->query($sqlUpdateTickets);

            $slqSelectTec = "SELECT id FROM glpi_tickets_users WHERE tickets_id = ".$id." AND `type` = 2;";

            $execSelectTec = $DB->query($slqSelectTec);

            foreach ($execSelectTec as $val) {
                $ticket = $val["id"];
            }

            $sqlDeleteTec = "DELETE FROM glpi_tickets_users WHERE id=".$ticket.";";

            $execDelete = $DB->query($sqlDeleteTec);

        }
    }

}
attTicketsPendents();
?>
