#!/usr/bin/env python3

import argparse
import datetime as dt
import json
import plistlib
import re
import sqlite3
import subprocess
import sys
import urllib.parse
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Any, Optional


APPLE_EPOCH = dt.datetime(2001, 1, 1, tzinfo=dt.timezone.utc)


@dataclass
class IMessage:
    rowid: int
    guid: str
    sender: str
    chat_id: Optional[str]
    message: str
    message_source: str
    received_at: str
    is_read: int
    service: Optional[str]
    account: Optional[str]
    is_from_me: int
    imessage_url: str


def applescript_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def build_imessage_url(sender: str) -> str:
    """
    Builds a Messages deep link that opens the conversation.

    Note:
    macOS supports opening a conversation with imessage://,
    but it does not reliably support deep-linking to an exact message row.
    """

    if not sender:
        return ""

    encoded_sender = urllib.parse.quote(sender, safe="+@.")
    return f"imessage://{encoded_sender}"


def open_imessage_conversation(sender: str) -> bool:
    """
    Opens the Messages conversation for a specific phone number or Apple ID email.
    """

    imessage_url = build_imessage_url(sender)

    if not imessage_url:
        print("No sender provided.", file=sys.stderr)
        return False

    result = subprocess.run(
        ["open", imessage_url],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        print(f"Failed to open iMessage conversation: {imessage_url}", file=sys.stderr)
        print(result.stderr.strip(), file=sys.stderr)
        return False

    print(f"Opened iMessage conversation: {imessage_url}")
    return True


def clean_text(value: Optional[str]) -> str:
    if not value:
        return ""

    value = value.replace("\x00", " ")

    # Remove most control characters, but keep normal whitespace.
    value = re.sub(r"[\x01-\x08\x0B\x0C\x0E-\x1F\x7F]", " ", value)

    # Remove common Apple archive/class-name noise.
    noise = [
        "NSString",
        "NSNumber",
        "NSDictionary",
        "NSArray",
        "NSObject",
        "NSAttributedString",
        "NSMutableAttributedString",
        "NSKeyedArchiver",
        "NS.objects",
        "NS.keys",
        "NS.string",
        "NS.attributes",
        "NSMutableString",
    ]

    for item in noise:
        value = value.replace(item, " ")

    value = " ".join(value.split())
    return value.strip()


def send_imessage(recipient: str, message: str) -> bool:
    recipient = applescript_escape(recipient)
    message = applescript_escape(message)

    applescript = f'''
    tell application "Messages"
        set targetService to 1st service whose service type = iMessage
        set targetBuddy to buddy "{recipient}" of targetService
        send "{message}" to targetBuddy
    end tell
    '''

    result = subprocess.run(
        ["osascript", "-e", applescript],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        print("Failed to send iMessage.", file=sys.stderr)
        print(result.stderr.strip(), file=sys.stderr)
        return False

    print("iMessage sent successfully.")
    return True


def get_messages_db_path() -> Path:
    return Path.home() / "Library" / "Messages" / "chat.db"


def apple_timestamp_to_iso(value: Optional[int]) -> str:
    if value is None:
        return ""

    try:
        value = int(value)
    except Exception:
        return ""

    if value > 10_000_000_000:
        seconds = value / 1_000_000_000
    else:
        seconds = value

    timestamp = APPLE_EPOCH + dt.timedelta(seconds=seconds)
    return timestamp.astimezone().isoformat(timespec="seconds")


def collect_strings_from_obj(obj: Any) -> list[str]:
    """
    Recursively collects strings from plist / NSKeyedArchiver-style objects.
    """

    strings: list[str] = []

    if isinstance(obj, str):
        cleaned = clean_text(obj)
        if cleaned:
            strings.append(cleaned)

    elif isinstance(obj, bytes):
        decoded = decode_bytes_best_effort(obj)
        if decoded:
            strings.append(decoded)

    elif isinstance(obj, dict):
        for value in obj.values():
            strings.extend(collect_strings_from_obj(value))

    elif isinstance(obj, list):
        for value in obj:
            strings.extend(collect_strings_from_obj(value))

    elif isinstance(obj, tuple):
        for value in obj:
            strings.extend(collect_strings_from_obj(value))

    return strings


def decode_bytes_best_effort(blob: bytes) -> str:
    """
    Fallback decoder for message blobs.
    Tries UTF-8, UTF-16, and printable text extraction.
    """

    candidates: list[str] = []

    for encoding in ("utf-8", "utf-16", "utf-16-le", "utf-16-be"):
        try:
            text = blob.decode(encoding, errors="ignore")
            text = clean_text(text)
            if text:
                candidates.append(text)
        except Exception:
            pass

    # Extract readable ASCII/UTF-8-ish runs from the binary.
    try:
        ascii_runs = re.findall(rb"[\x20-\x7E]{3,}", blob)
        for run in ascii_runs:
            text = run.decode("utf-8", errors="ignore")
            text = clean_text(text)
            if text:
                candidates.append(text)
    except Exception:
        pass

    return choose_best_message_candidate(candidates)


def choose_best_message_candidate(candidates: list[str]) -> str:
    """
    Picks the most human-readable candidate and filters out archive metadata.
    """

    cleaned_candidates = []

    bad_fragments = [
        "$archiver",
        "$objects",
        "$top",
        "$version",
        "NSKeyedArchive",
        "NSMutableAttributedString",
        "NSDictionary",
        "NSNumber",
        "NSString",
        "NSObject",
    ]

    for candidate in candidates:
        candidate = clean_text(candidate)

        if not candidate:
            continue

        if len(candidate) < 2:
            continue

        # Skip strings that are mostly archive metadata.
        if any(fragment in candidate for fragment in bad_fragments):
            if len(candidate) < 80:
                continue

        # Prefer strings with normal message-like content.
        alpha_count = sum(ch.isalpha() for ch in candidate)
        digit_count = sum(ch.isdigit() for ch in candidate)
        useful_count = alpha_count + digit_count

        if useful_count == 0:
            continue

        cleaned_candidates.append(candidate)

    if not cleaned_candidates:
        return ""

    # Usually the actual message is one of the shorter clean human strings,
    # not the giant decoded archive blob.
    cleaned_candidates = sorted(
        set(cleaned_candidates),
        key=lambda value: (
            " " not in value,
            len(value) > 500,
            -len(value),
        ),
    )

    best = cleaned_candidates[0]

    if len(best) > 1000:
        best = best[:1000].strip()

    return best


def decode_attributed_body(blob: Optional[bytes]) -> str:
    """
    Decode Apple's attributedBody field into readable text.

    attributedBody is often a binary plist / NSKeyedArchiver payload,
    not a plain UTF-8 string.
    """

    if not blob:
        return ""

    candidates: list[str] = []

    # Best path: parse as binary plist.
    try:
        plist_obj = plistlib.loads(blob)
        candidates.extend(collect_strings_from_obj(plist_obj))
    except Exception:
        pass

    # Fallback path: decode raw bytes.
    fallback = decode_bytes_best_effort(blob)
    if fallback:
        candidates.append(fallback)

    return choose_best_message_candidate(candidates)


def extract_message_body(
    text: Optional[str],
    attributed_body: Optional[bytes],
) -> tuple[str, str]:
    """
    Returns: (message, message_source)
    """

    cleaned_text = clean_text(text)

    if cleaned_text:
        return cleaned_text, "message.text"

    decoded_attributed = decode_attributed_body(attributed_body)

    if decoded_attributed:
        return decoded_attributed, "message.attributedBody"

    return "", "none"


def row_to_imessage(row: tuple) -> IMessage:
    (
        rowid,
        guid,
        sender,
        chat_id,
        text,
        attributed_body,
        date_value,
        is_read,
        service,
        account,
        is_from_me,
    ) = row

    body, body_source = extract_message_body(text, attributed_body)
    received_at = apple_timestamp_to_iso(date_value)
    sender_value = sender or ""

    return IMessage(
        rowid=rowid,
        guid=guid or "",
        sender=sender_value,
        chat_id=chat_id,
        message=body,
        message_source=body_source,
        received_at=received_at,
        is_read=is_read,
        service=service,
        account=account,
        is_from_me=is_from_me,
        imessage_url=build_imessage_url(sender_value),
    )


def get_message_rows(
    *,
    limit: int = 20,
    sender: Optional[str] = None,
    unread_only: bool = False,
) -> list[IMessage]:
    """
    Reads iMessages from ~/Library/Messages/chat.db.

    Args:
        limit:
            Maximum number of messages to return.
        sender:
            Optional phone number or Apple ID email to filter by.
            Example: +16197045891
        unread_only:
            When True, only returns unread incoming messages.

    Notes:
        This does not open Messages.
        This does not mark messages as read.
    """

    db_path = get_messages_db_path()

    if not db_path.exists():
        raise FileNotFoundError(f"Messages database not found: {db_path}")

    db_uri = f"file:{db_path}?mode=ro"

    where_clauses = [
        "handle.id IS NOT NULL",
    ]
    params: list[Any] = []

    if unread_only:
        where_clauses.extend(
            [
                "message.is_from_me = 0",
                "message.is_read = 0",
            ]
        )

    if sender:
        where_clauses.append("handle.id = ?")
        params.append(sender)

    params.append(limit)

    where_sql = " AND ".join(where_clauses)

    query = f"""
    SELECT
        message.ROWID,
        message.guid,
        handle.id AS sender,
        chat.chat_identifier AS chat_id,
        message.text,
        message.attributedBody,
        message.date,
        message.is_read,
        message.service,
        message.account,
        message.is_from_me
    FROM message
    LEFT JOIN handle
        ON message.handle_id = handle.ROWID
    LEFT JOIN chat_message_join
        ON message.ROWID = chat_message_join.message_id
    LEFT JOIN chat
        ON chat_message_join.chat_id = chat.ROWID
    WHERE
        {where_sql}
    ORDER BY message.date DESC
    LIMIT ?
    """

    messages: list[IMessage] = []

    with sqlite3.connect(db_uri, uri=True) as conn:
        cursor = conn.cursor()
        rows = cursor.execute(query, params).fetchall()

    for row in rows:
        messages.append(row_to_imessage(row))

    return messages


def get_unread_imessages(limit: int = 20) -> list[IMessage]:
    return get_message_rows(
        limit=limit,
        unread_only=True,
    )


def get_messages_for_sender(sender: str, limit: int = 5) -> list[IMessage]:
    """
    Returns the latest messages for a specific phone number or Apple ID email.

    This returns both inbound and outbound messages for that sender.
    """

    return get_message_rows(
        limit=limit,
        sender=sender,
        unread_only=False,
    )


def messages_to_dict(messages: list[IMessage]) -> list[dict]:
    return [asdict(message) for message in messages]


def print_messages_json(messages: list[IMessage], compact: bool = False) -> bool:
    message_data = messages_to_dict(messages)

    if compact:
        print(json.dumps(message_data, ensure_ascii=False))
    else:
        print(json.dumps(message_data, indent=2, ensure_ascii=False))

    return True


def get_unread_messages_as_dict(limit: int = 20) -> list[dict]:
    messages = get_unread_imessages(limit=limit)
    return messages_to_dict(messages)


def print_unread_messages_json(limit: int, compact: bool = False) -> bool:
    unread_messages = get_unread_imessages(limit=limit)
    return print_messages_json(unread_messages, compact=compact)


def main():
    parser = argparse.ArgumentParser(
        description="Send an iMessage, return unread iMessages, or return messages for a specific sender."
    )

    parser.add_argument(
        "recipient",
        nargs="?",
        help="Recipient phone number or Apple ID email. Example: +16197045891",
    )

    parser.add_argument(
        "message",
        nargs="?",
        help="Message body to send.",
    )

    parser.add_argument(
        "--get-unread",
        action="store_true",
        help="Return unread incoming iMessages as JSON instead of sending a message.",
    )

    parser.add_argument(
        "--get-messages-for",
        metavar="PHONE_OR_EMAIL",
        help="Return the latest messages for a specific phone number or Apple ID email as JSON.",
    )

    parser.add_argument(
        "--open-messages-for",
        metavar="PHONE_OR_EMAIL",
        help="Open the Messages conversation for a specific phone number or Apple ID email.",
    )

    parser.add_argument(
        "--limit",
        type=int,
        default=20,
        help="Maximum number of messages to return. Default: 20.",
    )

    parser.add_argument(
        "--compact",
        action="store_true",
        help="Return compact JSON when using --get-unread or --get-messages-for.",
    )

    args = parser.parse_args()

    try:
        if args.get_unread:
            success = print_unread_messages_json(
                limit=args.limit,
                compact=args.compact,
            )

        elif args.get_messages_for:
            messages = get_messages_for_sender(
                sender=args.get_messages_for,
                limit=args.limit,
            )
            success = print_messages_json(
                messages,
                compact=args.compact,
            )

        elif args.open_messages_for:
            success = open_imessage_conversation(args.open_messages_for)

        else:
            # Support safe multiline sends by allowing message input from stdin
            # when recipient is provided and positional message is omitted.
            message_to_send = args.message

            if args.recipient and not message_to_send and not sys.stdin.isatty():
                message_to_send = sys.stdin.read().rstrip("\n")

            if not args.recipient or not message_to_send:
                parser.error(
                    "recipient and message are required unless using "
                    "--get-unread, --get-messages-for, or --open-messages-for. "
                    "You can also pass the message via stdin when recipient is provided."
                )

            success = send_imessage(args.recipient, message_to_send)

    except sqlite3.OperationalError as error:
        print("Could not read the Messages database.", file=sys.stderr)
        print(error, file=sys.stderr)
        print(file=sys.stderr)
        print("You may need to grant Full Disk Access to your terminal app:", file=sys.stderr)
        print("System Settings -> Privacy & Security -> Full Disk Access", file=sys.stderr)
        success = False

    except Exception as error:
        print(f"Error: {error}", file=sys.stderr)
        success = False

    if not success:
        sys.exit(1)


if __name__ == "__main__":
    main()