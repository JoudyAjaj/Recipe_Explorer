from pathlib import Path

from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import cm
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer

ROOT = Path(r"c:\practices\recipe_explorer_app")
md_path = ROOT / "daily_report_2026-04-20.md"
pdf_path = ROOT / "daily_report_2026-04-20.pdf"

text = md_path.read_text(encoding="utf-8")

styles = getSampleStyleSheet()
normal = ParagraphStyle(
    "Body",
    parent=styles["Normal"],
    fontName="Helvetica",
    fontSize=11,
    leading=16,
    spaceAfter=8,
)
heading = ParagraphStyle(
    "Heading",
    parent=styles["Heading2"],
    fontName="Helvetica-Bold",
    fontSize=14,
    leading=18,
    spaceBefore=8,
    spaceAfter=8,
)

story = []
for raw_line in text.splitlines():
    line = raw_line.strip()
    if not line:
        story.append(Spacer(1, 0.2 * cm))
        continue

    if line.startswith("# "):
        story.append(Paragraph(line[2:].strip(), heading))
    elif line.startswith("## "):
        story.append(Paragraph(line[3:].strip(), heading))
    else:
        safe = (
            line.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
        )
        if safe.startswith("- "):
            safe = "• " + safe[2:]
        story.append(Paragraph(safe, normal))

doc = SimpleDocTemplate(
    str(pdf_path),
    pagesize=A4,
    rightMargin=2 * cm,
    leftMargin=2 * cm,
    topMargin=2 * cm,
    bottomMargin=2 * cm,
)
doc.build(story)
print(str(pdf_path))
