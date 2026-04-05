"""
evaluation/scripts/generate_data.py

[TEMPLATE] Generate synthetic evaluation queries using an LLM (Gemini / OpenAI).

This is a placeholder script. To use it:
    1. Install the google-generativeai SDK:  pip install google-generativeai
    2. Set the GEMINI_API_KEY environment variable
    3. Run:  python -m evaluation.scripts.generate_data --num-queries 50

TODO: Implement the actual generation logic when ready.
"""

from __future__ import annotations

import argparse
import json
import os
import sys

ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
sys.path.insert(0, ROOT_DIR)

from config import settings

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------
EVAL_DIR = os.path.join(ROOT_DIR, "evaluation")
DATASETS_DIR = os.path.join(EVAL_DIR, "datasets")
PROMPT_TEMPLATES_PATH = os.path.join(DATASETS_DIR, "prompt_templates.txt")
SERVICES_PATH = settings.SERVICE_JSON_PATH


def load_services() -> list[dict]:
    """Load the services catalog."""
    with open(SERVICES_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def load_prompt_template(template_name: str = "TEMPLATE 1") -> str:
    """Load a prompt template from prompt_templates.txt."""
    with open(PROMPT_TEMPLATES_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    # Simple extraction: find the template section
    sections = content.split("=" * 80)
    for i, section in enumerate(sections):
        if template_name in section and i + 1 < len(sections):
            return sections[i + 1].strip()

    raise ValueError(f"Template '{template_name}' not found in prompt_templates.txt")


def generate_chatbot_queries(num_queries: int = 50) -> list[dict]:
    """
    [TEMPLATE] Generate synthetic chatbot queries using Gemini.

    Replace this with your actual LLM API call.
    """
    # TODO: Implement when ready
    #
    # Example implementation:
    #
    # import google.generativeai as genai
    #
    # genai.configure(api_key=os.environ["GEMINI_API_KEY"])
    # model = genai.GenerativeModel("gemini-1.5-pro")
    #
    # services = load_services()
    # services_json = json.dumps(services, ensure_ascii=False, indent=2)
    # prompt = load_prompt_template("TEMPLATE 1")
    # prompt = prompt.replace("{SERVICES_JSON}", services_json)
    # prompt = prompt.replace("{N}", str(num_queries))
    #
    # response = model.generate_content(prompt)
    # queries = json.loads(response.text)
    # return queries

    raise NotImplementedError(
        "Synthetic generation not yet implemented. "
        "See the TODO comments in this file for a Gemini API template."
    )


def generate_home_profiles(num_profiles: int = 30) -> list[dict]:
    """
    [TEMPLATE] Generate synthetic home profiles using Gemini.

    Replace this with your actual LLM API call.
    """
    # TODO: Implement when ready — similar to generate_chatbot_queries
    # but using TEMPLATE 2 from prompt_templates.txt.

    raise NotImplementedError(
        "Synthetic generation not yet implemented. "
        "See the TODO comments in this file for a Gemini API template."
    )


def main():
    parser = argparse.ArgumentParser(
        description="[TEMPLATE] Generate synthetic evaluation data using LLMs"
    )
    parser.add_argument(
        "--type", choices=["chatbot", "home"], default="chatbot",
        help="Type of data to generate"
    )
    parser.add_argument(
        "--num-queries", type=int, default=50,
        help="Number of queries/profiles to generate"
    )
    parser.add_argument(
        "--output", type=str, default=None,
        help="Output path (default: datasets/<type>_eval_synthetic.json)"
    )
    args = parser.parse_args()

    output_path = args.output or os.path.join(
        DATASETS_DIR, f"{args.type}_eval_synthetic.json"
    )

    print(f"🤖 Generating {args.num_queries} synthetic {args.type} queries...")

    try:
        if args.type == "chatbot":
            data = generate_chatbot_queries(args.num_queries)
        else:
            data = generate_home_profiles(args.num_queries)

        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)

        print(f"✅ Saved {len(data)} items to {output_path}")

    except NotImplementedError as e:
        print(f"⚠️  {e}")
        print("   To implement, install google-generativeai and set GEMINI_API_KEY,")
        print("   then complete the TODO sections in this script.")


if __name__ == "__main__":
    main()
