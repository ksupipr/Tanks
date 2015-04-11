<?

$target_path = '/tmp/';
$target_path = $target_path . time() );
if ( move_uploaded_file( $_FILES['Filedata']['tmp_name'], $target_path ) ) {
echo '<result><err code="0" comm="ok" /></result>';
}
else {
echo '<result><err code="1" comm="fail" /></result>';
}