# LynxCLI

LynxCLI is a command-line interface tool designed to interact with various AI models, including Google's Gemini and OpenAI's GPT-3.5. It provides a convenient way to generate text based on user input, making it useful for tasks like content generation, conversation simulation, and more.

## Features

- **Support for Multiple AI Models**: LynxCLI supports Google's Gemini and OpenAI's GPT-3.5 models, allowing users to choose the AI model they prefer for text generation.
- **Customizable Configuration**: Users can configure various parameters for text generation, such as temperature, maximum output tokens, top-p, and top-k values.
- **Interactive Conversations**: LynxCLI supports interactive conversations with AI models, enabling users to engage in dialogues and receive responses in real-time.
- **User-friendly Interface**: LynxCLI provides a simple and intuitive command-line interface, making it easy to use for both beginners and experienced users.

## Setup

To set up LynxCLI on your system, follow these steps:

1. Clone the LynxCLI repository from GitHub:

    ```bash
    bash <(curl -sS https://raw.githubusercontent.com/SwarJagdale/LynxCLI/main/LynxSetup.sh)

    ```
2. Update the `.lynx_config` file with your parameters using lynxcli config.

## Usage

Once you have set up LynxCLI, you can use it to generate text and engage in conversations with AI models. Here are some examples of how to use LynxCLI:

- **Generate Text with Google Gemini**:

    ```bash
    lynxcli run gemini
    ```

- **Generate Text with OpenAI's GPT-3.5**:

    ```bash
    lynxcli run openai
    ```

- **Engage in Interactive Conversations**:

    ```bash
    lynxcli run openai_conv
    ```

    ```bash
    lynxcli run gemini_conv
    ```

For more information on available commands and options, refer to the LynxCLI documentation or run `lynxcli` without any arguments to display usage instructions.

## Configuration

The `.lynx_config` file contains configuration settings for LynxCLI, including API keys and model parameters. Ensure that you update this file with your actual API keys and desired parameters before using LynxCLI.
