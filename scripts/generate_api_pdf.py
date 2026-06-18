from __future__ import annotations

import subprocess
from pathlib import Path
from textwrap import wrap


ROOT = Path(__file__).resolve().parents[1]
OUT_PDF = ROOT / "HOSTINGER_API_FULL_GUIDE.pdf"


def get_route_list() -> list[str]:
    proc = subprocess.run(
        ["php", "artisan", "route:list", "--path=api"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=True,
    )
    lines = [line.rstrip() for line in proc.stdout.splitlines()]
    return [line for line in lines if line.strip()]


def build_lines() -> list[str]:
    base = "https://lightgreen-crane-116703.hostingersite.com"
    lines: list[str] = [
        "SteelScan Backend API Guide (Hostinger)",
        "",
        f"Base URL: {base}",
        "API Prefix: /api",
        "",
        "All protected endpoints require:",
        "Authorization: Bearer YOUR_TOKEN",
        "Accept: application/json",
        "",
        "1) LOGIN",
        f"URL: POST {base}/api/auth/login",
        "JSON Body:",
        '{ "email": "user@example.com", "password": "Password123" }',
        "Success (200):",
        '{ "message": "Login successful", "user": { ... }, "token": "1|xxxxx",',
        '  "requires_email_verification": true, "requires_phone_verification": true }',
        "",
        "2) LOGOUT",
        f"URL: POST {base}/api/auth/logout",
        "Headers:",
        "Authorization: Bearer YOUR_TOKEN",
        "Accept: application/json",
        "JSON Body: {}",
        'Success (200): { "message": "Logged out successfully" }',
        "",
        "REGISTER (for Flutter onboarding)",
        f"URL: POST {base}/api/auth/register",
        "JSON Body:",
        '{ "full_name":"Ahmed Mohamed", "email":"ahmed@gmail.com", "phone":"01123123",',
        '  "password":"ahmed1234", "password_confirmation":"ahmed1234" }',
        "Note: Send fields in Body (JSON or form-data), not Query Params.",
        "",
        "NEW APIs (Latest Updates)",
        "GET /api/scans/{scan}/flutter-report",
        "Returns scan details in Flutter-ready shape (statistics + scanData).",
        "",
        "GET /api/user-statistics/analytics",
        "Returns aggregated user statistics:",
        "passedCount, defectCount, totalDefects, accuracy, successRate.",
        "",
        "GET /api/user-statistics/dashboard",
        "Returns the same analytics payload as an alternative endpoint for dashboard screens.",
        "",
        "GET /api/user-statistics/history",
        "Returns defect categories distribution (cases + percentage) for History card.",
        "",
        "GET /api/user-statistics/recent_activity",
        "Returns recent activity feed (latest scan results).",
        "",
        "FULL ROUTE LIST",
        "Method + Path + Controller Action:",
        "",
    ]
    lines.extend(get_route_list())
    lines.extend(
        [
            "",
            "Flutter quick flow:",
            "1. Login -> save token.",
            "2. Send token in Authorization header for protected routes.",
            "3. Use /api/user-statistics/dashboard + /api/user-statistics/history + /api/user-statistics/recent_activity.",
            "4. Logout -> remove token locally.",
        ]
    )
    return lines


def pdf_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def write_simple_pdf(lines: list[str], out_path: Path) -> None:
    page_width = 612
    page_height = 792
    left_margin = 40
    top_start = 760
    line_height = 14
    font_size = 10
    max_chars = 95

    wrapped: list[str] = []
    for line in lines:
        if not line:
            wrapped.append("")
            continue
        parts = wrap(line, width=max_chars, break_long_words=True, break_on_hyphens=False)
        wrapped.extend(parts if parts else [""])

    lines_per_page = int((top_start - 40) / line_height)
    pages: list[list[str]] = []
    for i in range(0, len(wrapped), lines_per_page):
        pages.append(wrapped[i : i + lines_per_page])

    objects: list[bytes] = []

    # 1: Catalog (filled later), 2: Pages (filled later), 3: Font
    objects.append(b"")  # 1
    objects.append(b"")  # 2
    objects.append(b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>")  # 3

    page_obj_ids: list[int] = []
    content_obj_ids: list[int] = []

    for page_lines in pages:
        content_lines = ["BT", f"/F1 {font_size} Tf", f"{left_margin} {top_start} Td"]
        for idx, line in enumerate(page_lines):
            text = pdf_escape(line)
            if idx == 0:
                content_lines.append(f"({text}) Tj")
            else:
                content_lines.append(f"0 -{line_height} Td ({text}) Tj")
        content_lines.append("ET")
        content_bytes = "\n".join(content_lines).encode("latin-1", errors="replace")
        content_obj = f"<< /Length {len(content_bytes)} >>\nstream\n".encode("latin-1") + content_bytes + b"\nendstream"

        objects.append(content_obj)
        content_id = len(objects)
        content_obj_ids.append(content_id)

        page_dict = (
            f"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 {page_width} {page_height}] "
            f"/Resources << /Font << /F1 3 0 R >> >> /Contents {content_id} 0 R >>"
        ).encode("latin-1")
        objects.append(page_dict)
        page_id = len(objects)
        page_obj_ids.append(page_id)

    kids = " ".join(f"{pid} 0 R" for pid in page_obj_ids)
    objects[1] = f"<< /Type /Pages /Kids [ {kids} ] /Count {len(page_obj_ids)} >>".encode("latin-1")
    objects[0] = b"<< /Type /Catalog /Pages 2 0 R >>"

    pdf = bytearray(b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n")
    offsets = [0]

    for i, obj in enumerate(objects, start=1):
        offsets.append(len(pdf))
        pdf.extend(f"{i} 0 obj\n".encode("latin-1"))
        pdf.extend(obj)
        pdf.extend(b"\nendobj\n")

    xref_start = len(pdf)
    pdf.extend(f"xref\n0 {len(objects)+1}\n".encode("latin-1"))
    pdf.extend(b"0000000000 65535 f \n")
    for off in offsets[1:]:
        pdf.extend(f"{off:010d} 00000 n \n".encode("latin-1"))

    trailer = (
        f"trailer\n<< /Size {len(objects)+1} /Root 1 0 R >>\n"
        f"startxref\n{xref_start}\n%%EOF\n"
    )
    pdf.extend(trailer.encode("latin-1"))

    out_path.write_bytes(pdf)


if __name__ == "__main__":
    lines = build_lines()
    write_simple_pdf(lines, OUT_PDF)
    print(f"Generated: {OUT_PDF}")
