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
            $sqlLogs = "SELECT id, itemtype_link, date_mod FROM glpi_logs WHERE items_id = $id AND date_mod <= '$aDate' ORDER BY id DESC";
            $resLogs = $DB->query($sqlLogs);
            if ($resLogs && !empty($resLogs)) {
                foreach ($resLogs as $logs) {
                    $logId = $logs["id"];
                    $logType = $logs["itemtype_link"];
                    $logLastUp = $logs["date_mod"];
                    $dataLastMod = date_create($logLastUp);
                    if ($logType == "TicketTask" || $logType == "ITILFollowup") {
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
        }
    }
    $DB->close();
    echo "####Final de Script#### \n";
}
attTicketsPendents();
?>