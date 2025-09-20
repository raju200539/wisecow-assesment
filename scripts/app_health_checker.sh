#!/bin/bash

TARGET_URL="http://www.google.com"

HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" $TARGET_URL)

echo "Checking status of $TARGET_URL..."

if [ $HTTP_STATUS -eq 200 ]; then
    echo "Status Code: $HTTP_STATUS"
    echo "Application is UP! 👍"
else
    echo "Status Code: $HTTP_STATUS"
    echo "Application is DOWN! 👎"
fi
