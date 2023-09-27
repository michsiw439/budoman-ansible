#!/bin/bash

# Capture CPU Info
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print "us:" $2 " sy:" $4}')

# Capture Memory Info
mem_info=$(free -h | grep "Mem" | awk '{print "total:" $2 " used:" $3 " free:" $4}')
swap_info=$(free -h | grep "Swap" | awk '{print "total:" $2 " used:" $3 " free:" $4}')

# Capture Logged Users
logged_users=$(who)

# Capture Recent Actions
recent_actions=$(tail -10 ~/.bash_history)

# Capture IP addresses
private_ip=$(hostname -I)
public_ip=$(curl -s http://ipinfo.io/ip)

# Define your GraphQL mutation
graphql_query="mutation monitorResources(\$input: MonitorResourcesInput!) {
  monitorResources(input: \$input)
}"

# Construct the payload
payload="{
    \"query\": \"$graphql_query\",
    \"variables\": {
        \"input\": {
            \"cpuUsage\": \"$cpu_usage\",
            \"memInfo\": \"$mem_info\",
            \"swapInfo\": \"$swap_info\",
            \"loggedUsers\": \"$logged_users\",
            \"recentActions\": \"$recent_actions\",
            \"privateIp\": \"$private_ip\",
            \"publicIp\": \"$public_ip\"
        }
    }
}"

endpoint_url=$1

# Ensure that the payload does not contain any newline characters (this can break the JSON parsing on the server side)
payload=$(echo "$payload" | tr -d '\n')

# Send Payload with curl
curl -X POST -H "Content-Type: application/json" -d "$payload" "$endpoint_url"
