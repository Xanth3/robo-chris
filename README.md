# 🤖 Robo Chris

**Robo Chris** is a lightweight, fast, and privacy-conscious tool designed to analyse proprietary code blocks (written in a C-like in-house language) and generate natural language summaries describing their functionality. ***Please note this is still early in development, essentially at proof of concept stage.***

This project consists of:
- A **Zig-based CLI frontend** that pipes code files
- A **Python-based backend service** that uses local ML models (CodeT5)
- An optional fallback to the **OpenAI GPT API** if local models fail - not fully implemented

---

## 📌 Use Case

Robo Chris is intended for internal developer tooling where you want to:

- Quickly understand unfamiliar code blocks
- Review proprietary logic without exposing it externally
- Automate internal documentation or comment generation

---

## 🚀 Quickstart

### 1. Clone the Repository

```bash
git clone https://github.com/Xanth3/robo-chris.git
cd robo-chris
```

### 2. Start the Python Backend

```bash
cd python-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python server.py
```

> The backend runs at `http://127.0.0.1:5000`.

### 3. Build and Run the Zig CLI

```bash
cd ../zig-frontend
zig build -Drelease-safe
./zig-out/bin/code-summariser ../example_code/sample.myc
```

---

## 🧠 How It Works

1. You point the CLI to a proprietary code file.
2. The CLI sends the code to the Python backend via HTTP.
3. The backend:
   - Attempts to summarise using a local ML model (CodeT5)
   - Falls back to the OpenAI API if enabled and necessary
4. The CLI displays the summary result.

---

## 🔒 Privacy & Security

- All summarisation is performed locally by default.
- No code is sent to external services unless the OpenAI fallback is explicitly enabled.
- Ideal for proprietary or internal source code.

---

## 🧪 Example

**Input (`sample.myc`):**

```c
int checkUsers(userList) {
  for (i = 0; i < userList.length; i++) {
    if (userList[i].isActive) {
      log("Active user found");
    }
  }
  return 0;
}
```

**CLI Output:**

```
Summary:
This function checks a list of users and logs those who are marked as active.
```

---

## 🛠️ Requirements

- Zig 0.12 or later
- Python 3.9 or later
- Optional: OpenAI API key (set in `summariser.py`)

---

## 🤝 Contributing

Contributions are welcome! Especially for:

- Improving summarisation accuracy
- Adding support for more languages or models
- Enhancing the CLI interface

---

## 📄 License

MIT License (or your internal license if this is a private project)

---

## 👀 See Also

- [CodeT5 on HuggingFace](https://huggingface.co/Salesforce/codet5-small)
- [OpenAI GPT API](https://platform.openai.com/docs)

---