# ExamPrepAI
ExamAI is a mobile application where you can ask a chatbot to summarize lessons and ask question related to the documents you upload. We have used LLama-3.2-1B for document summarization.

## SetUp
- View the flutter documentation to set up environment for flutter (https://docs.flutter.dev/get-started/install)
- Install android studio for Smart phone emulators(android) (https://developer.android.com)
- Use python 3.10 for running the backend

## Running the project
- Don't run the project on localhost or 127.0.0.1 instead run it on network IP
- Activate a virtual environment on VSCode (.venv) and install the following:
    - flask (pip install flask)
    - groq (pip install groq)
    - flask_cors (pip install flask-cors)
    - langchain, langchain_text_splitters (pip install langchain)
    - langchain-hugging face (pip install langchain[hub])
    - langchain-core (pip install langchain-core)
    - langchain-chroma (for Vector DB)

- Choose the device on the bottom right corner (Where you could see Windows(windows-x64) or something else based on OS)
- Create a .env file and add groq api key, change the model in api.py according to your needs
- Run by using command `python api.py`
- For flutter application once the emulator (or physical device) is connected hit the run and debug button.

## Future Development
- Use multimodal for image generation

# Happy Coding




