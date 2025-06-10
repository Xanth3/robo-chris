import openai
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, pipeline

# Configure local model
tokenizer = AutoTokenizer.from_pretrained("Salesforce/codet5-small")
model = AutoModelForSeq2SeqLM.from_pretrained("Salesforce/codet5-small")
summariser = pipeline("summarisation", model=model, tokenizer=tokenizer)

# Optional OpenAI fallback - work to do here
USE_API = False
openai.api_key = "sk-..."  # Set via env or securely

def summarise_code(code: str) -> str:
    try:
        local_summary = summariser(code, max_length=64, min_length=10, do_sample=False)
        return local_summary[0]["summary_text"]
    except Exception as e:
        if USE_API:
            return summarise_with_openai(code)
        raise e

def summarise_with_openai(code: str) -> str:
    prompt = f"Summarise what the following function does:\n\n{code}"
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.2,
        max_tokens=150
    )
    return response['choices'][0]['message']['content'].strip()
