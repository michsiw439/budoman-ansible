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

# Construct the payload using jq
payload=$(jq -n \
  --arg q "$graphql_query" \
  --arg cpu "$cpu_usage" \
  --arg mem "$mem_info" \
  --arg swap "$swap_info" \
  --arg users "$logged_users" \
  --arg actions "$recent_actions" \
  --arg p_ip "$private_ip" \
  --arg pub_ip "$public_ip" \
  '{
    query: $q,
    variables: {
      input: {
        cpuUsage: $cpu,
        memInfo: $mem,
        swapInfo: $swap,
        loggedUsers: $users,
        recentActions: $actions,
        privateIp: $p_ip,
        publicIp: $pub_ip
      }
    }
  }')

endpoint_url=$1

# Send Payload with curl
curl -X POST -H "Content-Type: application/json" -d "$payload" "$endpoint_url"
