---

name: eternalai-openai
description: Integrate and use Eternal AI's OpenAI‑compatible API for text, chat, embeddings, and model execution. Provides a fully OpenAI‑standard interface, works with any existing OpenAI client or library by switching the base URL and API key. Supports streaming, tools, structured outputs, assistants, and Claude models via EternalAI routing. Use this skill when building AI apps capable of interacting with EternalAI’s decentralized compute network or when you want to run Claude/OpenAI‑style calls at lower cost.
license: MIT
allowed-tools:

* Bash
* Read
* Write
* Edit

---

# Eternal AI OpenAI-Compatible Skill

A unified skill for calling **EternalAI’s OpenAI‑compatible API**, which lets you run prompts, chat completions, embeddings, and AI agents using a decentralized compute network. Fully compatible with OpenAI SDKs and Claude routing.

---

## Core Features

### ✅ OpenAI-Compatible Endpoints

* `/v1/chat/completions` – Chat models, system prompts, streaming
* `/v1/completions` – Text completion
* `/v1/embeddings` – Embeddings generation
* `/v1/models` – List available models
* `/v1/files` – File operations (where supported)

### ✅ Claude via EternalAI

Supports Claude messages using OpenAI-compatible format.

### ✅ Decentralized Compute

* Routes requests across EternalAI’s decentralized compute nodes
* Automatically selects fastest/available route
* Optional deterministic routing

### ✅ Streaming Support

* Event-stream (`text/event-stream`) compatible
* Works with OpenAI SDK, Curl, and JS clients

### ✅ Assistant / Tools Support

* Supports function calling
* Supports JSON mode
* Supports structured output

---

## Setup

### Install the OpenAI Client

Python:

```bash
pip install openai
```

Node.js:

```bash
npm install openai
```

### Configure API Base URL + Key

EternalAI requires two variables:

* `EAI_API_KEY` – your EternalAI API key
* Base URL: `https://open.eternalai.org/openai` (OpenAI-compatible)

### Python Example

```python
from openai import OpenAI

client = OpenAI(
    api_key=os.getenv("EAI_API_KEY"),
    base_url="https://open.eternalai.org/openai/v1"
)
```

### Node.js Example

```js
import OpenAI from "openai";

const client = new OpenAI({
  apiKey: process.env.EAI_API_KEY,
  baseURL: "https://open.eternalai.org/openai/v1"
});
```

---

## Using Chat Completions

### Python

```python
resp = client.chat.completions.create({
    "model": "claude-3.5-sonnet",  # or any EternalAI-supported model
    "messages": [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Explain quantum computing simply."}
    ]
})

print(resp.choices[0].message.content)
```

### Node.js

```js
const resp = await client.chat.completions.create({
  model: "claude-3.5-sonnet",
  messages: [
    { role: "system", content: "You are a helpful assistant." },
    { role: "user", content: "Explain blockchains simply." }
  ]
});

console.log(resp.choices[0].message.content);
```

---

## Streaming

### Python

```python
for event in client.chat.completions.create(
    model="claude-3.5-sonnet",
    messages=[{"role": "user", "content": "Write a poem."}],
    stream=True
):
    print(event.choices[0].delta.content or "", end="")
```

### Node.js

```js
const stream = await client.chat.completions.create({
  model: "gpt-4o-mini",
  messages: [{ role: "user", content: "Stream something." }],
  stream: true
});

for await (const chunk of stream) {
  process.stdout.write(chunk.choices?.[0]?.delta?.content || "");
}
```

---

## Function Calling (Tools)

```python
resp = client.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [{"role": "user", "content": "What’s the weather in Paris?"}],
    tools=[
        {
            "type": "function",
            "function": {
                "name": "get_weather",
                "parameters": {
                    "type": "object",
                    "properties": {"city": {"type": "string"}},
                    "required": ["city"]
                }
            }
        }
    ]
})
```

---

## Embeddings

```python
resp = client.embeddings.create({
    model: "text-embedding-3-small",
    input: "Hello EternalAI"
})
```

---

## Model List

```python
models = client.models.list()
for m in models.data:
    print(m.id)
```

---

## CURL Examples

### Chat

```bash
curl https://open.eternalai.org/openai/v1/chat/completions \
  -H "Authorization: Bearer $EAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-3.5-sonnet",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Stream

```bash
curl https://open.eternalai.org/openai/v1/chat/completions \
  -N \
  -H "Authorization: Bearer $EAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o-mini",
    "stream": true,
    "messages": [{"role": "user", "content": "Stream demo"}]
  }'
```

---

## Rate Limits & Notes

* Your throughput depends on EternalAI network load
* Some Claude models may queue slightly longer
* Streaming is strongly recommended for large outputs

---

## Best Practices

1. Use streaming for fast first-token response
2. Prefer smaller models for utility tasks
3. Retry on `429` with exponential backoff
4. Cache embeddings locally to reduce compute cost
5. Set timeouts generously for long‑running models

---

## Additional Resources

* EternalAI API Docs
* OpenAI Compatibility Specification
* Claude via OpenAI Format Guide
* Example Projects (agents, bots, RAG)

---

This skill allows you to use EternalAI in any existing OpenAI/Claude workflow by simply switching base URL + API key.
