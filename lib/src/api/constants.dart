const BASE_URL = "https://api.paybox.money/";
const GET_STATUS = "get_status.php";
const INIT_PAYMENT = "init_payment.php";
const REVOKE = "revoke.php";
const CANCEL = "cancel.php";
const CLEARING = "do_capture.php";
const RECURRING = "make_recurring_payment.php";

const STATUS_URL = BASE_URL + GET_STATUS;
const INIT_PAYMENT_URL = BASE_URL + INIT_PAYMENT;
const REVOKE_URL = BASE_URL + REVOKE;
const CANCEL_URL = BASE_URL + CANCEL;
const CLEARING_URL = BASE_URL + CLEARING;
const RECURRING_URL = BASE_URL + RECURRING;

const CARDSTORAGE = "/cardstorage/";
const CARD = "/card/";
const LISTCARD_URL = "list";
const CARDINITPAY = "init";
const ADDCARD_URL = "add";
const PAY = "pay";
const REMOVECARD_URL = "remove";

String buildCardPayUrl(String merchantId) {
  return BASE_URL + "v1/merchant/" + merchantId + CARD;
}

String buildCardMerchantUrl(String merchantId) {
  return BASE_URL + "v1/merchant/" + merchantId + CARDSTORAGE;
}

const RECURRING_PROFILE_ID = "pg_recurring_profile_id";
const CARD_CREATED_AT = "created_at";
const RESPONSE = "response";
const PAYMENT_FAILURE = "Не удалось оплатить";
const UNKNOWN_ERROR = "Неизвестная ошибка";
const CONNECTION_ERROR = "Ошибка подключения";
const FORMAT_ERROR = "Неправильный формат ответа";
const RECURRING_PROFILE_EXPIRY = "pg_recurring_profile_expiry_date";
const CLEARING_AMOUNT = "pg_clearing_amount";
const REFUND_AMOUNT = "pg_refund_amount";
const ERROR_CODE = "pg_error_code";
const ERROR_DESCRIPTION = "pg_error_description";
const CAPTURED = "pg_captured";
const CARD_PAN = "pg_card_pan";
const CREATED_AT = "pg_create_date";
const TRANSACTION_STATUS = "pg_transaction_status";
const CAN_REJECT = "pg_can_reject";
const REDIRECT_URL = "pg_redirect_url";
const MERCHANT_ID = "pg_merchant_id";
const SIG = "pg_sig";
const SALT = "pg_salt";
const STATUS = "pg_status";
const CARD_ID = "pg_card_id";
const CARD_HASH = "pg_card_hash";
const TEST_MODE = "pg_testing_mode";
const RECURRING_START = "pg_recurring_start";
const AUTOCLEARING = "pg_auto_clearing";
const REQUEST_METHOD = "pg_request_method";
const CURRENCY = "pg_currency";
const LIFETIME = "pg_lifetime";
const ENCODING = "pg_encoding";
const RECURRING_LIFETIME = "pg_recurring_lifetime";
const PAYMENT_SYSTEM = "pg_payment_system";
const SUCCESS_METHOD = "pg_success_url_method";
const FAILURE_METHOD = "pg_failure_url_method";
const SUCCESS_URL = "pg_success_url";
const FAILURE_URL = "pg_failure_url";
const BACK_LINK = "pg_back_link";
const POST_LINK = "pg_post_link";
const LANGUAGE = "pg_language";
const USER_PHONE = "pg_user_phone";
const USER_CONTACT_EMAIL = "pg_user_contact_email";
const USER_EMAIL = "pg_user_email";
const CAPTURE_URL = "pg_capture_url";
const REFUND_URL = "pg_refund_url";
const RESULT_URL = "pg_result_url";
const CHECK_URL = "pg_check_url";
const USER_ID = "pg_user_id";
const ORDER_ID = "pg_order_id";
const DESCRIPTION = "pg_description";
const RECURRING_PROFILE = "pg_recurring_profile";
const AMOUNT = "pg_amount";
const PAYMENT_ID = "pg_payment_id";
