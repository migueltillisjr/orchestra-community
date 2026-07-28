import argparse
import mimetypes
import os
import sys
import time
from pathlib import Path
from typing import List, Optional

from dotenv import load_dotenv
from google import genai
from google.genai import types


DEFAULT_MODEL = "veo-3.1-generate-preview"


def load_text_file(path: Path) -> str:
    if not path.exists():
        raise FileNotFoundError(f"Prompt file not found: {path}")

    text = path.read_text(encoding="utf-8").strip()

    if not text:
        raise ValueError(f"Prompt file is empty: {path}")

    return text


def guess_mime_type(path: Path) -> str:
    mime_type, _ = mimetypes.guess_type(str(path))

    if mime_type:
        return mime_type

    suffix = path.suffix.lower()

    if suffix in [".jpg", ".jpeg"]:
        return "image/jpeg"

    if suffix == ".png":
        return "image/png"

    if suffix == ".webp":
        return "image/webp"

    raise ValueError(
        f"Could not determine MIME type for {path}. "
        "Use .jpg, .jpeg, .png, or .webp."
    )


def load_reference_image(path: Path):
    if not path.exists():
        raise FileNotFoundError(f"Reference image not found: {path}")

    mime_type = guess_mime_type(path)
    image_bytes = path.read_bytes()

    return types.Image(
        image_bytes=image_bytes,
        mime_type=mime_type,
    )


def load_reference_images(image_paths: List[Path]):
    if not image_paths:
        return []

    if len(image_paths) > 3:
        raise ValueError("Veo reference image workflows support up to 3 reference images.")

    return [load_reference_image(path) for path in image_paths]


def wait_for_operation(client, operation, poll_seconds: int = 10):
    print("Generation started.")
    print("Polling until video is complete...")

    while not operation.done:
        time.sleep(poll_seconds)
        operation = client.operations.get(operation)
        print(".", end="", flush=True)

    print("\nGeneration finished.")
    return operation


def save_generated_video(client, generated_video, output_path: Path):
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Depending on SDK/version, the returned video may need to be downloaded first.
    client.files.download(file=generated_video.video)

    video_bytes = getattr(generated_video.video, "video_bytes", None)

    if not video_bytes:
        raise RuntimeError(
            "No video bytes returned by the SDK. "
            "The SDK response format may have changed. "
            "Inspect operation.response.generated_videos[0]."
        )

    output_path.write_bytes(video_bytes)
    return output_path


def generate_video(
    prompt_path: Path,
    output_path: Path,
    image_paths: Optional[List[Path]] = None,
    model: str = DEFAULT_MODEL,
    poll_seconds: int = 10,
):
    load_dotenv()

    api_key = os.getenv("GEMINI_API_KEY")

    if not api_key:
        raise EnvironmentError(
            "Missing GEMINI_API_KEY. Add it to your .env file or export it in your shell."
        )

    client = genai.Client(api_key=api_key)

    prompt = load_text_file(prompt_path)
    reference_images = load_reference_images(image_paths or [])

    print(f"Model: {model}")
    print(f"Prompt: {prompt_path}")
    print(f"Output: {output_path}")

    if reference_images:
        print(f"Reference images: {len(reference_images)}")
    else:
        print("Reference images: none")

    if reference_images:
        operation = client.models.generate_videos(
            model=model,
            prompt=prompt,
            config=types.GenerateVideosConfig(
                reference_images=reference_images,
            ),
        )
    else:
        operation = client.models.generate_videos(
            model=model,
            prompt=prompt,
        )

    operation = wait_for_operation(
        client=client,
        operation=operation,
        poll_seconds=poll_seconds,
    )

    if not getattr(operation, "response", None):
        raise RuntimeError(f"No response returned. Full operation: {operation}")

    generated_videos = getattr(operation.response, "generated_videos", None)

    if not generated_videos:
        raise RuntimeError(f"No generated videos returned. Full response: {operation.response}")

    final_path = save_generated_video(
        client=client,
        generated_video=generated_videos[0],
        output_path=output_path,
    )

    print(f"Saved video: {final_path}")
    return final_path


def parse_args():
    parser = argparse.ArgumentParser(
        description="Generate a Google Veo video using a prompt and optional reference images."
    )

    parser.add_argument(
        "--prompt",
        default="prompts/founder_video.txt",
        help="Path to prompt text file.",
    )

    parser.add_argument(
        "--output",
        default="outputs/veo_output.mp4",
        help="Path where the generated MP4 should be saved.",
    )

    parser.add_argument(
        "--images",
        nargs="*",
        default=[],
        help="Optional reference images. Use up to 3 images.",
    )

    parser.add_argument(
        "--model",
        default=DEFAULT_MODEL,
        help="Video model to use.",
    )

    parser.add_argument(
        "--poll-seconds",
        type=int,
        default=10,
        help="Seconds between status checks.",
    )

    return parser.parse_args()


if __name__ == "__main__":
    try:
        args = parse_args()

        generate_video(
            prompt_path=Path(args.prompt),
            output_path=Path(args.output),
            image_paths=[Path(p) for p in args.images],
            model=args.model,
            poll_seconds=args.poll_seconds,
        )

    except Exception as exc:
        print(f"\nError: {exc}", file=sys.stderr)
        sys.exit(1)
