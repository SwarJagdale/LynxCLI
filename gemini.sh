#!/bin/bash

buffer() {
    local num1=$1
    for ((i=0; i<num1; i++)); do
        for ((j=0; j<10; j++)); do
            echo -n "▉"
            sleep 0.1
        done
        for ((j=0; j<10; j++)); do
            echo -n -e "\b \b"
            sleep 0.1
        done
    done
}

echo
echo -e "\033[33mRunning Google Gemini...\033[33m"
echo

choice=0
api_key="YOUR_API_KEY"

while [ $choice -eq 0 ]; do
    echo -n -e "\033[1;35m>>\033[1;35m"
    echo -n -e "\033[32m\033[32m"
    read -r prompt
    echo -n -e "\033[33mThinking...\033[33m"

    response=$(curl -s -H 'Content-Type: application/json' \
        -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${api_key}" \
        -d '{
            "contents": [{
                "parts": [{"text": "'"${prompt}"'"}]
            }],
            "safety_settings": [
                {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT","threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_HATE_SPEECH","threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_HARASSMENT","threshold": "BLOCK_NONE"},
                {"category": "HARM_CATEGORY_DANGEROUS_CONTENT","threshold": "BLOCK_NONE"}
            ],
            "generationConfig": {
                "stopSequences": ["Title"],
                "temperature": 1,
                "maxOutputTokens": 800,
                "topP": 0.8,
                "topK": 10
            }
        }')

    echo -n -e "\r\033[K"
    if command -v jq &> /dev/null; then
        text=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')
        if [ "$text" != "null" ]; then
            echo -n -e "\033[1;34mGemini: \033[1;34m"

            IFS=' ' read -ra words <<< "$text"
            for word in "${words[@]}"; do
                echo -n -e "\033[33m$word \033[33m"
                sleep 0.05
            done

            echo
        else
            echo -e "\033[1;33m$response\033[1;33m"
        fi
    else
        echo "jq is not installed. Please install jq to process the response."
        echo -e "\033[1;33m$response\033[1;33m"
    fi

    echo 

    buffer 1
done
echo -n -e "\033[0m\033[0m"
