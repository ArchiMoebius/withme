# Remove Event Filters
try {
Get-WMIObject -Filter "Name='SCM Event Log Fi1ter'" -Class __EventFilter -Namespace 'root/Subscription' | Remove-WmiObject -Verbose
}catch{}

# Remove Consumers
try{
Get-WMIObject -Filter "Name='SCM Event Log Fi1ter'" -Class CommandLineEventConsumer -Namespace 'root/Subscription' | Remove-WmiObject -Verbose
}catch{}

# Remove Bindings
try{
Get-WMIObject -Filter "Filter = ""__eventfilter.name='SCM Event Log Fi1ter'""" -Class __FilterToConsumerBinding -Namespace 'root/Subscription' | Remove-WmiObject -Verbose
}catch{}