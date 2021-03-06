param(
	$DestShare,
	$DestServer,
    $XDVersion
)        

if($XDVersion -eq "XD76") {
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_6.iso" -Destination "\\$DestServer\$DestShare\"
} 
elseif ($XDVersion -eq "XD75") {
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_5.iso" -Destination  "\\$DestServer\$DestShare\"
}
elseif ($XDVersion -eq "XD77") {
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_7.iso" -Destination  "\\$DestServer\$DestShare\"
}
elseif ($XDVersion -eq "XD78") {
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_8.iso" -Destination  "\\$DestServer\$DestShare\"
}
elseif ($XDVersion -eq "XD79") {
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_9.iso" -Destination  "\\$DestServer\$DestShare\"
}
elseif ($XDVersion -eq "XD711") {
    Start-BitsTransfer -Source "https://s3-ap-southeast-2.amazonaws.com/tommcm-cf-xendesktop/ISO/XenApp_and_XenDesktop_7_11.iso" -Destination  "\\$DestServer\$DestShare\"
}
 else 
{
    Start-BitsTransfer -Source "https://s3.amazonaws.com/cf-XenDesktop/ISO/XenApp_and_XenDesktop_7_11.iso" -Destination  "\\$DestServer\$DestShare\"
}
