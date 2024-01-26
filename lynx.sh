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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.lynx_config"

read_api_key() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo $(curl -sS https://raw.githubusercontent.com/SwarJagdale/LynxCLI/main/.lynx_config) > "$CONFIG_FILE"
        echo -e "\033[1;32mConfig file created. Please replace 'YOUR_GOOGLE_API_KEY' with your actual API key by running lynxcli config Google APIKey <YOUR_GOOGLE_API_KEY>\033[0m"
    fi
    if [ -f "$CONFIG_FILE" ]; then
        GOOGLE_API_KEY=$(grep -Eo 'GOOGLE_API_KEY=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        if [ -n "$GOOGLE_API_KEY" ]; then
            echo "$GOOGLE_API_KEY"
            return
        fi
    fi
    return 1
}

update_lynxcli() {
    REPO_URL="https://github.com/SwarJagdale/LynxCLI.git"
    REPO_DIR="$HOME/LynxCLI"

    # Check if the repository directory exists
    if [ -d "$REPO_DIR" ]; then
        # Repository directory exists, so delete it

        rm -rf "$REPO_DIR"
    fi

    # Clone the GitHub repository
    echo "Updating to the latest version..."
    git clone "$REPO_URL" "$REPO_DIR"

    # Check if the repository was cloned successfully
    if [ $? -eq 0 ]; then
        echo "Updated successfully."

        # Make all shell scripts executable within the repository directory
        find "$REPO_DIR" -type f -name "*.sh" -exec chmod +x {} \;

        # Update alias for running ./lynx.sh as 'lynxcli'
        echo "alias lynxcli='$REPO_DIR/lynx.sh'" > ~/.bashrc

        source ~/.bashrc

        echo "Environment variable and alias updated. You can now use 'lynxcli' to run ./lynx.sh."

    else
        echo "Error: Cloning repository failed."
    fi
}


echo
if [[ "$1" == "" ]]; then
echo -e "\033[1;33mRun \033[1;34mlynxcli run\033[1;34m \033[1;33mto run it \033[1;33m"
echo -e "\033[1;33mRun \033[1;34mlynxcli config\033[1;34m \033[1;33mto change configuration\033[1;0m"
fi
if [[ "$1" == "update" ]]; then
echo -e "\033[1;31mWarning!! Your config file will be reset. It is recommended that you have your information saved elsewhere too.\033[1;0m"
    echo "To confirm the update, type 'confirm update': "
    read -r confirm_update
    if [[ "$confirm_update" == "confirm update" ]]; then
        update_lynxcli
    else
        echo "Update canceled."
    fi
fi

if [[ "$1" == "config" ]]; then
    if [[ "$2" == "Show" ]]; then
	echo -e -n "\033[1;35mConfiguration File is shown below:\n\n\033[1;35m"
	cat "$CONFIG_FILE"
	echo -e -n "\033[1;0m\033[1;0m"
    
    elif [[ "$2" == "Google" ]]; then
        if [[ "$3" == "" ]]; then
            echo -e "\033[1;31mUsage: lynxcli config Google <parameter> <value> \033[0m"
            
            echo -e "\033[1;36mParameters are: 1)APIKey 2)temperature 3)maxOutputTokens  4)topP 5)topK "
        fi
        if [[ "$3" == "APIKey" ]]; then
        if [[ "$4" != "" ]]; then
            echo -e "\033[1;33mSetting GOOGLE_API_KEY in configuration file...\033[0m"
            sed -i "s/GOOGLE_API_KEY=.*/GOOGLE_API_KEY=$4/" "$CONFIG_FILE"
            echo -e "\033[1;32mConfiguration complete.\033[0m"
	   
        else
            echo -e "\033[1;31mUsage: lynxcli config Google APIKey <YOUR_GOOGLE_API_KEY>\033[0m"
	        echo -e "\033[1;33mGet your own API key at https://makersuite.google.com/app/apikey\033[0m"
            fi
        elif [[ "$3" == "temperature" ]]; then
            if [[ "$4" != "" ]]; then
                echo -e "\033[1;33mSetting temperature in configuration file...\033[0m"
                sed -i "s/Google_temperature=.*/Google_temperature=$4/" "$CONFIG_FILE"
                echo -e "\033[1;32mConfiguration complete.\033[0m"
            else
                echo -e "\033[1;31mUsage: lynxcli config Google temperature <YOUR_TEMPERATURE>\033[0m"
            fi
        elif [[ "$3" == "maxOutputTokens" ]]; then
            if [[ "$4" != "" ]]; then
                echo -e "\033[1;33mSetting maxOutputTokens in configuration file...\033[0m"
                sed -i "s/Google_maxOutputTokens=.*/Google_maxOutputTokens=$4/" "$CONFIG_FILE"
                echo -e "\033[1;32mConfiguration complete.\033[0m"
            else
                echo -e "\033[1;31mUsage: lynxcli config Google maxOutputTokens <YOUR_MAX_OUTPUT_TOKENS>\033[0m"
            fi
        elif [[ "$3" == "topP" ]]; then
            if [[ "$4" != "" ]]; then
                echo -e "\033[1;33mSetting topP in configuration file...\033[0m"
                sed -i "s/Google_topP=.*/Google_topP=$4/" "$CONFIG_FILE"
                echo -e "\033[1;32mConfiguration complete.\033[0m"
            else
                echo -e "\033[1;31mUsage: lynxcli config Google topP <YOUR_TOP_P>\033[0m"
            fi
        elif [[ "$3" == "topK" ]]; then
            if [[ "$4" != "" ]]; then
                echo -e "\033[1;33mSetting topK in configuration file...\033[0m"
                sed -i "s/Google_topK=.*/Google_topK=$4/" "$CONFIG_FILE"
                echo -e "\033[1;32mConfiguration complete.\033[0m"
            else
                echo -e "\033[1;31mUsage: lynxcli config Google topK <YOUR_TOP_K>\033[0m"
            fi
        else
            echo -e "\033[1;31mUsage\033[1;0m"
        fi
    elif [[ "$2" == "Openai" ]]; then
        if [[ "$3" != "" ]]; then
            echo -e "\033[1;33mSetting OPENAI_API_KEY in configuration file...\033[0m"
            sed -i "s/OPENAI_API_KEY=YOUR_OPENAI_API_KEY/OPENAI_API_KEY=$3/" "$CONFIG_FILE"
            echo -e "\033[1;32mConfiguration complete.\033[0m"
        else
            echo -e "\033[1;31mUsage: lynxcli config Openai <YOUR_OPENAI_API_KEY>\033[0m"
	    echo -e "\033[1;33mGet your own API key at https://platform.openai.com/api-keys\033[0m"
        fi
    else
        echo -e "\033[1;31mUsage: lynxcli config <parameter> <value>\033[0m"
        echo -e "\033[1;36mTo view your config file run lynxcli config Show \033[0m"
        echo -e "\033[1;36mFor Google run lynxcli config Google \033[0m"
        echo -e "\033[1;36mFor OpenAI run lynxcli config Openai \033[0m"
    fi
fi
if [[ "$1" == "run" ]];then
    if [[ "$2" == "" ]]; then
        echo -e "\033[1;33mRun \033[1;34mlynxcli run gemini\033[1;34m \033[1;33mto run Google's Gemini \033[0m"
        echo -e "\033[1;33mRun \033[1;34mlynxcli run openai\033[1;34m \033[1;33mto run OpenAI's API \033[0m"
        fi
    if [[ "$2" == "openai" ]]; then
        openai_api=$(grep -Eo 'OPENAI_API_KEY=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_temperature=$(grep -Eo 'Openai_temperature=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_maxTokens=$(grep -Eo 'Openai_maxTokens=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_model=$(grep -Eo 'Openai_model=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        echo -e "\033[33mRunning OpenAI...\033[33m"
        echo
        choice=0
         while [ $choice -eq 0 ]; do
            echo -n -e "\033[1;35m>>\033[1;35m"
            echo -n -e "\033[32m\033[32m"
            read -r prompt
            echo -n -e "\033[33mThinking...\033[33m"
         
            response=$(curl -s https://api.openai.com/v1/chat/completions \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $openai_api" \
            -d '{
                "model": "'"$Openai_model"'",
                "messages": [{"role": "user", "content": "'"$prompt"'"}],
                "temperature": '"$Openai_temperature"',
                "max_tokens": '"$Openai_maxTokens"'
            }')
            echo -n -e "\r\033[K"
         
            if command -v jq &> /dev/null; then
                text=$(echo "$response" | jq -r '.choices[0].message.content')
                if [ "$text" != "null" ]; then
                    echo -n -e "\033[1;34mOpenAI: \033[1;34m"
                    while IFS= read -r -d $'\n' line; do
                        if [[ "$line" == '```'* ]]; then
                            continue
                        fi
                        IFS=' ' read -r -a words <<< "$line"

                        for word in "${words[@]}"; do
                            echo -n -e "\033[33m$word \033[33m"
                            sleep 0.05
                        done

                        echo
                    done <<< "$text"
                else
                    if [[ "$response" == *"Invalid API key"* ]]; then
                        echo -e "\033[1;31mError: API key is not valid. Please pass a valid API key. Configure your API Key by running lynxcli config Openai <YOUR_API_KEY> or by configuring OPENAI_API_KEY in .lynx_config file. \n\033[35mYou can get your api key at \033[35m\033[33mhttps://platform.openai.com/api-keys\033[33m\033[0m"
                    else
                        echo -e "\033[1;33m$response\033[1;33m"
                    fi
                fi
            else
                echo "jq is not installed. Please install jq to process the response."
                echo -e "\033[1;33m$response\033[1;33m"
            fi
        
         echo

            buffer 1
        done
        echo -n -e "\033[0m\033[0m"

        fi
    if [[ "$2" == "openai_conv" ]];then
        openai_api=$(grep -Eo 'OPENAI_API_KEY=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_temperature=$(grep -Eo 'Openai_temperature=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_maxTokens=$(grep -Eo 'Openai_maxTokens=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Openai_model=$(grep -Eo 'Openai_model=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        echo -e "\033[33mRunning OpenAI...\033[33m"
        echo
        conversation=()
        choice=0
         while [ $choice -eq 0 ]; do
            echo -n -e "\033[1;35m>>\033[1;35m"
            echo -n -e "\033[32m\033[32m"
            read -r prompt
            echo -n -e "\033[33mThinking...\033[33m"
      
            conversation+=("{\"role\": \"user\", \"content\": \"$(echo "$prompt")\"}")

            content=""
            for i in "${conversation[@]}"; do
                content+="$i"
            done
            echo "$content"
            echo "$conversation"
           response=$(curl -s https://api.openai.com/v1/chat/completions \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $openai_api" \
            -d '{
                "model": "'"$Openai_model"'",
                "messages": ['"$content"'],
                "temperature": '"$Openai_temperature"',
                "max_tokens": '"$Openai_maxTokens"'
            }')
            echo -n -e "\r\033[K"

             if command -v jq &> /dev/null; then
                text=$(echo "$response" | jq -r '.choices[0].message.content')
                conversation+=(", {\"role\": \"assistant\", \"content\": \""$text"\"}, ")
                
                if [ "$text" != "null" ]; then
                    echo -n -e "\033[1;34mOpenAI: \033[1;34m"
                    
                    while IFS= read -r -d $'\n' line; do
                        if [[ "$line" == '```'* ]]; then
                            continue
                        fi
                        IFS=' ' read -r -a words <<< "$line"

                        for word in "${words[@]}"; do
                            echo -n -e "\033[33m$word \033[33m"
                            sleep 0.05
                        done

                        echo
                    done <<< "$text"
                else
                    if [[ "$response" == *"Invalid API key"* ]]; then
                        echo -e "\033[1;31mError: API key is not valid. Please pass a valid API key. Configure your API Key by running lynxcli config Openai <YOUR_API_KEY> or by configuring OPENAI_API_KEY in .lynx_config file. \n\033[35mYou can get your api key at \033[35m\033[33mhttps://platform.openai.com/api-keys\033[33m\033[0m"
                    else
                        echo -e "\033[1;33m$response\033[1;33m"
                    fi
                fi
            else
                echo "jq is not installed. Please install jq to process the response."
                echo -e "\033[1;33m$response\033[1;33m"
            fi
        
         echo

            buffer 1
        done
        echo -n -e "\033[0m\033[0m"

        fi

    if  [[ "$2" == "gemini" ]]; then
        gemini_api_key=$(read_api_key)   #"YOUR_API_KEY"
        Google_temperature=$(grep -Eo 'Google_temperature=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_maxOutputTokens=$(grep -Eo 'Google_maxOutputTokens=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_topP=$(grep -Eo 'Google_topP=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_topK=$(grep -Eo 'Google_topK=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)

        # echo "$configs"
        echo -e "\033[33mRunning Google Gemini...\033[33m"
        echo
        
        choice=0
        # temp, maxwords, topp, topk
        
        while [ $choice -eq 0 ]; do
            echo -n -e "\033[1;35m>>\033[1;35m"
            echo -n -e "\033[32m\033[32m"
            read -r prompt
            echo -n -e "\033[33mThinking...\033[33m"

            response=$(curl -s -H 'Content-Type: application/json' \
                -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${gemini_api_key}" \
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
                        "temperature": '"$Google_temperature"',
                        "maxOutputTokens": '"$Google_maxOutputTokens"',
                        "topP": '"$Google_topP"',
                        "topK": '"$Google_topK"'
                    }
                }')

            echo -n -e "\r\033[K"
            if command -v jq &> /dev/null; then
                text=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')
                if [ "$text" != "null" ]; then
                    echo -n -e "\033[1;34mGemini: \033[1;34m"

                    while IFS= read -r -d $'\n' line; do
                        if [[ "$line" == '```'* ]]; then
                            continue
                        fi
                        IFS=' ' read -r -a words <<< "$line"

                        for word in "${words[@]}"; do
                            echo -n -e "\033[33m$word \033[33m"
                            sleep 0.05
                        done

                        echo
                    done <<< "$text"
                else
                    if [[ "$response" == *"API key not valid. Please pass a valid API key."* ]]; then
                        echo -e "\033[1;31mError: API key is not valid. Please pass a valid API key. Configure your API Key by running lynxcli config Google APIKey <YOUR_API_KEY> or by configuring GOOGLE_API_KEY in .lynx_config file. \n\033[35mYou can get your api key at \033[35m\033[33mhttps://makersuite.google.com/app/apikey\033[33m\033[0m"
                echo "$gemini_api_key"
                    else
                        echo -e "\033[1;33m$response\033[1;33m"
                    fi
                fi
            else
                echo "jq is not installed. Please install jq to process the response."
                echo -e "\033[1;33m$response\033[1;33m"
            fi

            echo

            buffer 1
        done
        echo -n -e "\033[0m\033[0m"

        fi



    if [[ "$2" == "gemini_conv" ]]; then
        gemini_api_key=$(read_api_key)   #"YOUR_API_KEY"

        echo -e "\033[33mRunning Google Gemini...\033[0m"
        echo
       
        conversation=()
         Google_temperature=$(grep -Eo 'Google_temperature=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_maxOutputTokens=$(grep -Eo 'Google_maxOutputTokens=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_topP=$(grep -Eo 'Google_topP=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        Google_topK=$(grep -Eo 'Google_topK=[^ ]+' "$CONFIG_FILE" | cut -d'=' -f2)
        choice=0


        while [ $choice -eq 0 ]; do
            echo -n -e "\033[1;35m>>\033[1;35m"
            echo -n -e "\033[32m\033[32m"
            read -r prompt
            echo -n -e "\033[33mThinking...\033[33m"
            conversation+=("{\"role\": \"user\",\"parts\": [{\"text\": \"${prompt}\"}]}")
            content=""
            for i in "${conversation[@]}"; do
                content+="$i,"
            done
        
            
          
              
            response=$(curl -s -H 'Content-Type: application/json' \
                -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${gemini_api_key}" \
                -d '{
        "contents": [
        '"$content"'
        ],
        "safety_settings": [
            {"category": "HARM_CATEGORY_SEXUALLY_EXPLICIT","threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_HATE_SPEECH","threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_HARASSMENT","threshold": "BLOCK_NONE"},
            {"category": "HARM_CATEGORY_DANGEROUS_CONTENT","threshold": "BLOCK_NONE"}
        ],
            "generationConfig": {
                        "stopSequences": ["Title"],
                        "temperature": '"$Google_temperature"',
                        "maxOutputTokens": '"$Google_maxOutputTokens"',
                        "topP": '"$Google_topP"',
                        "topK": '"$Google_topK"'
                    }

    }') 

            echo -n -e "\r\033[K"
            if command -v jq &> /dev/null; then
                text=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text')
                if [ "$text" != "null" ]; then
                    echo -n -e "\033[1;34mGemini: \033[1;34m"
                    conversation+=("{\"role\": \"model\",\"parts\": [{\"text\": \"${text}\"}]}")
                    while IFS= read -r -d $'\n' line; do
                        if [[ "$line" == '```'* ]]; then
                            continue
                        fi
                        IFS=' ' read -r -a words <<< "$line"

                        for word in "${words[@]}"; do
                            echo -n -e "\033[33m$word \033[33m"
                            sleep 0.05
                        done

                        echo
                    done <<< "$text"
                else
                    if [[ "$response" == *"API key not valid. Please pass a valid API key."* ]]; then
                        echo -e "\033[1;31mError: API key is not valid. Please pass a valid API key. Configure your API Key by running lynxcli config Google APIKey <YOUR_API_KEY> or by configuring GOOGLE_API_KEY in .lynx_config file. \n\033[35mYou can get your api key at \033[35m\033[33mhttps://makersuite.google.com/app/apikey\033[33m\033[0m"
                echo "$gemini_api_key"
                    else
                        echo -e "\033[1;33m$response\033[1;33m"
                    fi
                fi
            else
                echo "jq is not installed. Please install jq to process the response."
                echo -e "\033[1;33m$response\033[1;33m"

            fi

            echo

            buffer 1
        done
        echo -n -e "\033[0m\033[0m"

        fi
fi
