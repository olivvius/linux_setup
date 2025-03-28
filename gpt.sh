#!/bin/bash

check_api_key() {
    if [ -z "$OPENAI_API_KEY" ]; then
        echo "API key is not set in the environment variable."
        read -p "Please enter your OpenAI API key: " OPENAI_API_KEY
        echo "export OPENAI_API_KEY=\"$OPENAI_API_KEY\"" >> ~/.bashrc
        source ~/.bashrc
        echo "API key has been set and saved for future use."
    fi
}

check_model() {
    if [ -z "$OPENAI_MODEL" ]; then
        OPENAI_MODEL="gpt-4o-mini"
        echo "export OPENAI_MODEL=\"$OPENAI_MODEL\"" >> ~/.bashrc
        echo "No model set, defaulting to: $OPENAI_MODEL (saved in ~/.bashrc)"
	source ~/.bashrc
    fi
}

list_models() {
    models=$(curl -s https://api.openai.com/v1/models -H "Authorization: Bearer $OPENAI_API_KEY" | jq -r '.data[].id')
    if [ -z "$models" ]; then
        echo "Error: Could not retrieve the list of models. Check your API key or your internet connection."
        exit 1
    fi
    echo "Available models:"
    echo "$models"
}

# Function to execute the last saved response
execute_last_response() {
    if [ ! -f "$GPT_LAST_RESPONSE" ]; then
        echo "No saved response to exec ute."
        exit 1
    fi
    echo "Executing the last saved response..."
    last_response=$(cat "$GPT_LAST_RESPONSE")
    eval "$last_response"
}

set_model() {
    list_models  # Display available models
    echo "Please enter a model name from the available models:"
    read -p "Enter model: " user_input
    
    # Check if the model entered by the user is in the list
    if echo "$models" | grep -q "^$user_input$"; then
        echo "Selected model: $user_input"

        # Remove previous OPENAI_MODEL entry if it exists and add the new one
        sed -i '/^export OPENAI_MODEL=/d' ~/.bashrc
        echo "export OPENAI_MODEL=\"$user_input\"" >> ~/.bashrc

        # Apply changes
        export OPENAI_MODEL="$user_input"
        echo "Model set to: $OPENAI_MODEL (saved in ~/.bashrc)"
    else
        echo "Error: Invalid model name. Please choose a valid model from the list."
        exit 1
    fi
}

make_request() {
    if [ -z "$1" ]; then
        read -p "You: " user_input
    else
        user_input="$*"
    fi

    response=$(curl -s https://api.openai.com/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -d "{
        \"model\": \"$OPENAI_MODEL\",
        \"messages\": [
          {\"role\": \"system\", \"content\": \"$PRE_PROMPT\"},
          {\"role\": \"user\", \"content\": \"$user_input\"}
        ]
      }")

    if [ $? -ne 0 ]; then
        echo "Error: Failed to make the API request. Check your network connection or API key."
        exit 1
    fi

    response_content=$(echo "$response" | jq -r '.choices[0].message.content')

    # Check if the response contains content
    if [ -z "$response_content" ]; then
        echo "Error: No valid response received from the API."
        exit 1
    fi

    echo "$response_content"

    echo "$response_content" > "$GPT_LAST_RESPONSE"
}

MODEL="gpt-4o-mini"
HISTORY_FILE="$HOME/gpt_responses.txt"
PRE_PROMPT="You are an expert in development. Provide high-quality answers without unnecessary fluff or comments. Do not use apostrophes or backticks, commands must be executable directly as your answer will be included in automatisation pipeline."
GPT_LAST_RESPONSE="$HOME/gpt_last_response.txt"

check_api_key
check_model
source ~/.bashrc

case "$1" in
    -m)
        list_models
        ;;
    -e)
        execute_last_response
        ;;
    -M)
        set_model
        ;;
    -h | --help)
        echo "This is gpt in cmd line, dedicated to increase your work productivty while working/coding"
	echo "Usage: gpt \"your question here\""
        echo "Or: gpt"
        echo "Options:"
	echo "  -m              List available models"
        echo "  -e              Execute the last saved response"
        echo "  -M		Set a custom model (default is gpt-4o-mini)"
        echo "  -h, --help      Display this help message"
        ;;
    *)
        # Call make_request if the user provides an input, even if no option is specified
        make_request "$@"
        ;;
esac
