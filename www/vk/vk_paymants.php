<?php
header("Content-Type: application/json; encoding=utf-8");

//$secret_key = ''; // Защищенный ключ приложения

require_once ('../config.php');

$secret_key = $api_secret['vk'];

$input = $_POST;

// Проверка подписи
$sig = $input['sig'];
unset($input['sig']);
ksort($input);
$str = '';
foreach ($input as $k => $v) {
  $str .= $k.'='.$v;
}

if ($sig != md5($str.$secret_key)) {
  $response['error'] = array(
    'error_code' => 10,
    'error_msg' => 'Несовпадение вычисленной и переданной подписи запроса.',
    'critical' => true
  );
} else {
  // Подпись правильная
  switch ($input['notification_type']) {
    case 'get_item':
      // Получение информации о товаре
      $item = explode('_' ,$input['item']); // наименование товара
//credits_num
   
$item_name = $item[0];
$item_num  = intval($item[1]);

if ($item_name == 'credits') {
        if ($item_num>0) {
            $response['response'] = array(
                'item_id' => $item_num,
                'title' => $item_num.' кредитов',
                'photo_url' => 'http://unlexx.no-ip.org/vk/credits_icon.jpg',
                'price' => $item_num
            );
        } else {
            $response['error'] = array(
                'error_code' => 20,
                'error_msg' => 'Вы хотите купить 0 кредитов',
                'critical' => true
            );
        }
      } else {
        $response['error'] = array(
          'error_code' => 20,
          'error_msg' => 'Товара не существует.',
          'critical' => true
        );
      }
      break;

case 'get_item_test':
      // Получение информации о товаре в тестовом режиме
      $item = explode('_' ,$input['item']);
      $item_name = $item[0];
      $item_num  = intval($item[1]);

if ($item_name == 'credits') {
        if ($item_num>0) {
            $response['response'] = array(
                'item_id' => $item_num,
                'title' => $item_num.' кредитов (тестовый режим)',
                'photo_url' => 'http://unlexx.no-ip.org/vk/credits_icon.jpg',
                'price' => $item_num
            );
        } else {
            $response['error'] = array(
                'error_code' => 20,
                'error_msg' => 'Вы хотите купить 0 кредитов',
                'critical' => true
            );
        }
      } else {
        $response['error'] = array(
          'error_code' => 20,
          'error_msg' => 'Товара не существует.',
          'critical' => true
        );
      }
      break;

case 'order_status_change':
      // Изменение статуса заказа
      if ($input['status'] == 'chargeable') {
        $order_id = intval($input['order_id']);

// Код проверки товара, включая его стоимость
        //$app_order_id = 1; // Получающийся у вас идентификатор заказа.

        $user_id     = intval($input['user_id']); // кто покупает
        $receiver_id = intval($input['receiver_id']);  // кому покупают
        $item_id     = intval($input['item_id']);  // что покупают. в данном случае id = количеству кредитов, а при курсе 1/1 и цене
        $item_price  = intval($input['item_price']); // цена.. всеж заведем.

        include('vk_functions.php');

        $app_order_id = buyCredits($order_id, $receiver_id, $item_id, $item_price); // Тут фактического заказа может не быть - тестовый режим.

        $fp = fopen('/tmp/vkp_log.txt', 'a+');
        fwrite($fp, "возвращаюсь к ответам. app_order_id= ".$app_order_id." \n");


        switch ($app_order_id) {

        case 0: 
                $response['error'] = array(
                    'error_code' => 404,
                    'error_msg' => 'Транзакция уже обрабатывалась ранее',
                    'critical' => true
                );
                break;
        case ($app_order_id<0) : 
                $response['error'] = array(
                    'error_code' => abs($app_order_id),
                    'error_msg' => 'Ошибка',
                    'critical' => true
                );
                break;
        default:
                $response['response'] = array(
                    'order_id' => $order_id,
                    'app_order_id' => $app_order_id,
                );
        }

        fwrite($fp, "шлю ответ: ".json_encode($response)." \n");
        fclose($fp);
      } else {
        $response['error'] = array(
          'error_code' => 100,
          'error_msg' => 'Передано непонятно что вместо chargeable.',
          'critical' => true
        );
      }
      break;

case 'order_status_change_test':
      // Изменение статуса заказа в тестовом режиме
      if ($input['status'] == 'chargeable') {
        $order_id = intval($input['order_id']);

        $user_id     = intval($input['user_id']); // кто покупает
        $receiver_id = intval($input['receiver_id']);  // кому покупают
        $item_id     = intval($input['item_id']);  // что покупают. в данном случае id = количеству кредитов, а при курсе 1/1 и цене
        $item_price  = intval($input['item_price']); // цена.. всеж заведем.

        include('vk_functions.php');

        $app_order_id = buyCredits($order_id, $receiver_id, $item_id, $item_price); // Тут фактического заказа может не быть - тестовый режим.

        $fp = fopen('/tmp/vkp_log.txt', 'a+');
        fwrite($fp, "возвращаюсь к ответам. app_order_id= ".$app_order_id." \n");


        switch ($app_order_id) {

        case 0: 
                $response['error'] = array(
                    'error_code' => 404,
                    'error_msg' => 'Транзакция уже обрабатывалась ранее',
                    'critical' => true
                );
                break;
        case ($app_order_id<0) : 
                $response['error'] = array(
                    'error_code' => abs($app_order_id),
                    'error_msg' => 'Ошибка',
                    'critical' => true
                );
                break;
        default:
                $response['response'] = array(
                    'order_id' => $order_id,
                    'app_order_id' => $app_order_id,
                );
        }

        fwrite($fp, "шлю ответ: ".json_encode($response)." \n");
        fclose($fp);

      } else {
        $response['error'] = array(
          'error_code' => 100,
          'error_msg' => 'Передано непонятно что вместо chargeable.',
          'critical' => true
        );
      }
      break;
  }
}

echo json_encode($response);
?> 