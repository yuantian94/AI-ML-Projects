# AI-ML-Projects

**LLM, Agentic Framework, RAG and MLOps** — a collection of hands-on projects in AI/ML systems, agentic workflows, retrieval-augmented generation, and production MLOps.

This repository contains two main projects:

| Project | Description |
|--------|-------------|
| [RAG and Agentic AI Project](./RAG%20and%20Agentic%20AI%20Project) | Multi-agent deal-discovery and pricing system using RAG (ChromaDB) and an agentic orchestration framework. |
| [MLOps-resume-chatbot](./MLOps-resume-chatbot) | Production-ready personal site with an AI “digital twin” chatbot, deployed on AWS with Terraform, Lambda, and Bedrock. |

---

## 1. RAG and Agentic AI Project

A **multi-agent system** that finds deals from RSS feeds, estimates product prices using an ensemble of models (including RAG over a product vector store), and surfaces the best opportunities. It demonstrates **RAG** (retrieval-augmented generation), **agentic design** (planning, specialists, messaging), and **ML pipelines** (preprocessing, ensemble pricing).

### What this project does

- **Deal discovery:** A **Scanner Agent** parses deal RSS feeds (e.g. dealnews.com), scrapes product descriptions, and builds a shortlist of deals.
- **Pricing ensemble:** A **Planning Agent** coordinates a pipeline that:
  - Preprocesses product text.
  - Runs a **Specialist Agent**, a **Frontier Agent** (RAG over ChromaDB product embeddings), and a **Neural Network Agent** to estimate prices.
  - Combines their outputs (e.g. weighted average) into a single price estimate and computes discount vs. listed price.
- **RAG:** ChromaDB stores product embeddings; the Frontier Agent uses this vector store for retrieval-augmented price estimation.
- **Orchestration:** The planner runs scan → price → rank, and a **Messaging Agent** can alert when a deal exceeds a discount threshold.
- **UI:** A **Gradio** app (“The Price is Right”) lets you run the pipeline, stream logs, and view a table of deals with estimates and discounts.
- **Extras:** Modal-based “Hello” serverless example; pricer services and notebooks for experimentation.

### What I did in this project

- Implemented the **agentic framework**: planning agent, scanner, ensemble (specialist + RAG frontier + neural network), and messaging.
- Built **RAG over product data** with ChromaDB for the frontier (retrieval-based) pricer.
- Wired preprocessing, multiple pricing models, and ensemble logic into a single pipeline.
- Added the **Gradio** UI for interactive runs and result tables.
- Integrated RSS scraping, deal parsing, and persistence (e.g. `memory.json`) for the workflow.
- Explored **Modal** for serverless functions (e.g. `hello.py`).

### Tech stack

Python, ChromaDB, Gradio, scikit-learn, NumPy, Plotly, Beautiful Soup, feedparser, Modal, Pydantic.

---

## 2. MLOps-resume-chatbot

A **personal portfolio site** with an AI **“digital twin”** chatbot that represents me (Yuan Tian) using my resume, summary, and facts. The system is built for production: **Next.js** frontend, **FastAPI** backend with **AWS Bedrock** (Amazon Nova), **S3** for conversation memory, and **Terraform** for full AWS infrastructure (S3, Lambda, API Gateway, CloudFront, etc.). It showcases **MLOps** practices: infra as code, serverless backend, and a repeatable deployment pipeline.

### What this project does

- **Personal site:** A simple, clean page with profile, title (e.g. CS PhD candidate @ University of Houston), and an embedded chat widget.
- **Digital twin chatbot:** The chat agent is prompted to speak in first person as me, using structured context (resume summary, facts, style). It answers questions about my background, skills, and experience without inventing information.
- **Backend:** FastAPI service that calls **Bedrock** (Nova) for chat completions, reads/writes conversation history to **S3** (memory bucket), and supports CORS for the frontend. The same app runs as **AWS Lambda** via Mangum for serverless deployment.
- **Frontend:** Next.js app that hosts the profile and a chat component (“Twin”) talking to the backend API.
- **Infrastructure:** Terraform defines S3 buckets (memory + frontend static site), Lambda, API Gateway, CloudFront, and related resources so the whole stack can be deployed and torn down in a consistent way.

### What I did in this project

- Designed the **digital twin** system prompt and context (resume, summary, facts, style) so the model stays on-persona and accurate.
- Implemented the **FastAPI** backend with Bedrock runtime integration and S3-backed conversation memory.
- Built the **Next.js** frontend (profile + chat UI) and wired it to the backend.
- Wrote **Terraform** for AWS: S3 (memory + static site), Lambda, API Gateway, CloudFront, and necessary IAM and configuration.
- Set up **Lambda** deployment (Mangum) and scripts (e.g. deploy/destroy) for MLOps-style lifecycle management.
- Ensured the chatbot is recruiter-friendly: maps skills to roles, highlights impact, and stays concise and professional.

### Tech stack

Next.js, React, TypeScript, FastAPI, AWS (Bedrock, S3, Lambda, API Gateway, CloudFront), Terraform, Python (Pydantic, boto3, Mangum).

---

## Repository structure

```
.
├── README.md                          # This file
├── RAG and Agentic AI Project/        # RAG + agentic deal pipeline & Gradio UI
│   ├── agents/                        # Scanner, Planner, Ensemble, Specialist, Frontier, etc.
│   ├── deal_agent_framework.py        # Main framework (ChromaDB, memory, planner)
│   ├── price_is_right.py              # Gradio app
│   ├── hello.py                       # Modal serverless example
│   └── ...
└── MLOps-resume-chatbot/              # Digital twin site + AWS MLOps
    ├── frontend/                      # Next.js app
    ├── backend/                       # FastAPI + Bedrock + S3 memory
    ├── terraform/                     # AWS infra (S3, Lambda, API GW, CloudFront)
    ├── scripts/                       # Deploy/destroy helpers
    └── memory/                        # Local/sample conversation data
```

---

## Summary

- **RAG and Agentic AI Project:** RAG (ChromaDB) + multi-agent orchestration for deal scanning and ensemble-based price estimation, with a Gradio UI and Modal usage.
- **MLOps-resume-chatbot:** Production personal site with a resume-grounded “digital twin” chatbot on Bedrock, deployed on AWS with Terraform and Lambda.

Both projects reflect practical work in **LLMs, agentic systems, RAG, and MLOps** — from research-style agent frameworks to production deployment.
