# generate_higgsfield_image.py

import os
import sys
import mimetypes
from pathlib import Path
from urllib.parse import urlparse

import requests
import higgsfield_client


OUTPUT_DIR = Path("higgsfield_outputs")
OUTPUT_DIR.mkdir(exist_ok=True)


def download_file(url: str, output_dir: Path = OUTPUT_DIR) -> Path:
    """
    Downloads an image from a URL and saves it locally.
    """
    response = requests.get(url, timeout=60)
    response.raise_for_status()

    content_type = response.headers.get("Content-Type", "")
    extension = mimetypes.guess_extension(content_type.split(";")[0]) or ".png"

    parsed = urlparse(url)
    filename = Path(parsed.path).name

    if not filename or "." not in filename:
        filename = f"higgsfield_image{extension}"

    output_path = output_dir / filename

    with open(output_path, "wb") as file:
        file.write(response.content)

    return output_path


MODEL = os.getenv("HF_MODEL", "seedream_v4_5")


def generate_image(prompt: str) -> dict:
    """
    Sends a text-to-image request to Higgsfield and waits for the result.
    """
    result = higgsfield_client.subscribe(
        MODEL,
        arguments={
            "prompt": prompt,
            "resolution": "2K",
            "aspect_ratio": "16:9",
            "camera_fixed": False,
        },
    )

    return result


def main():
    if not os.getenv("HF_KEY") and not (
        os.getenv("HF_API_KEY") and os.getenv("HF_API_SECRET")
    ):
        print(
            "Missing Higgsfield credentials.\n\n"
            "Set one of these:\n"
            '  export HF_KEY="your-api-key:your-api-secret"\n\n'
            "Or:\n"
            '  export HF_API_KEY="your-api-key"\n'
            '  export HF_API_SECRET="your-api-secret"\n'
        )
        sys.exit(1)

    prompt = " ".join(sys.argv[1:]).strip()

    if not prompt:
        # Check if a file was passed instead
        if len(sys.argv) > 1 and Path(sys.argv[1]).exists():
            prompt = Path(sys.argv[1]).read_text(encoding="utf-8").strip()
        else:
            prompt = "A cinematic image of a futuristic cybersecurity operations center, realistic lighting, professional, high detail"

    print("Generating image...")
    result = generate_image(prompt)

    images = result.get("images", [])

    if not images:
        print("No images returned.")
        print(result)
        sys.exit(1)

    print(f"Retrieved {len(images)} image(s).")

    for index, image in enumerate(images, start=1):
        image_url = image.get("url")

        if not image_url:
            print(f"Image {index} did not include a URL.")
            continue

        print(f"Image {index} URL: {image_url}")

        saved_path = download_file(image_url)
        print(f"Saved image {index} to: {saved_path}")


if __name__ == "__main__":
    main()