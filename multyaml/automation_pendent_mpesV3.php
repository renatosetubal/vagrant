<?php
$DB = "";
date_default_timezone_set('America/Fortaleza');

// Função para atualizar tickets pendentes
function attTicketsPendents()
{
    $server = "localhost";
    $user = "root";
    $password = "root";
    $dbname = "GLPI";

    // Conexão com o banco de dados
    $DB = new mysqli($server, $user, $password, $dbname);

    if ($DB->connect_error) {
        die("Conexão falhou: " . $DB->connect_error);
    } else {
        echo "####Iniciando Script####\n";
    }

    $sqlTickets = 'SELECT id, begin_waiting_date FROM glpi_tickets WHERE status = 4';
    $result = $DB->query($sqlTickets);

    if (!$result) {
        return;
    }

    $aData = date_create(date('Y-m-d H:i:s'));
    $aDate = $aData->format('Y-m-d H:i:s');

    foreach ($result as $value) {
        $id = $value["id"];
        $begin_waiting_date = $value["begin_waiting_date"];

        if ($begin_waiting_date === NULL) {
            continue;
        }

        $dataPend = date_create($begin_waiting_date);
        $delay_time = date_diff($aData, $dataPend);

        $total_minutes = ($delay_time->days * 24 * 60) + ($delay_time->h * 60) + $delay_time->i + intval($delay_time->s / 60);
        $total_hours = intval($total_minutes / 60);
        $remaining_minutes = $total_minutes % 60;

        $formatted_time = sprintf("%02d:%02d", $total_hours, $remaining_minutes);
        $time_diff = $formatted_time;

        if ($total_hours > 24) {
            $sqlLog = "SELECT COUNT(*) as contador FROM glpi_logs WHERE (items_id='$id' AND DATE(date_mod) = CURDATE()) AND (itemtype_link='ITILFollowup' OR itemtype_link='TicketTask');";
            $resultLog = $DB->query($sqlLog);
            $item = $resultLog->fetch_assoc();
            if ($item['contador'] != 0) {
                echo $id . " - Chamado possui andamento no dia. \n";
            }else{
                 $sqlUpdateTickets = "UPDATE glpi_tickets SET date_mod='$aDate', users_id_lastupdater=2, status=2, begin_waiting_date=NULL WHERE id=$id";
                 $execUpdate = $DB->query($sqlUpdateTickets);
                 $slqSelectTec = "SELECT id FROM glpi_tickets_users WHERE tickets_id = $id AND `type` = 2";
                 $execSelectTec = $DB->query($slqSelectTec);
                 if ($execSelectTec) {
                     foreach ($execSelectTec as $val) {
                         $ticket = $val["id"];
                         $sqlDeleteTec = "DELETE FROM glpi_tickets_users WHERE id=$ticket";
                         $execDelete = $DB->query($sqlDeleteTec);
                     }
                 }
            }
        }
    }
    $DB->close();
    echo "####Final de Script#### \n";
}
attTicketsPendents();
?>