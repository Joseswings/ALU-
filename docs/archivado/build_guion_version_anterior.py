from pathlib import Path
from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.section import WD_SECTION
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt

root = Path(r"C:\Users\Jose Alas\Projects\ALU +")
source = root / "GUION_PRESENTACION_ALU.md"
output = root / "Guion Presentacion ALU Plus.docx"

doc = Document()
section = doc.sections[0]
section.top_margin = Inches(0.75)
section.bottom_margin = Inches(0.7)
section.left_margin = Inches(0.8)
section.right_margin = Inches(0.8)

styles = doc.styles
styles["Normal"].font.name = "Aptos"
styles["Normal"]._element.rPr.rFonts.set(qn("w:ascii"), "Aptos")
styles["Normal"]._element.rPr.rFonts.set(qn("w:hAnsi"), "Aptos")
styles["Normal"].font.size = Pt(10.5)
styles["Normal"].paragraph_format.space_after = Pt(6)
for name, size in [("Title", 20), ("Heading 1", 15), ("Heading 2", 12), ("Heading 3", 11)]:
    style = styles[name]
    style.font.name = "Aptos Display" if name != "Heading 3" else "Aptos"
    style._element.rPr.rFonts.set(qn("w:ascii"), style.font.name)
    style._element.rPr.rFonts.set(qn("w:hAnsi"), style.font.name)
    style.font.size = Pt(size)
    style.font.color.rgb = None

footer = section.footer.paragraphs[0]
footer.alignment = WD_ALIGN_PARAGRAPH.CENTER
run = footer.add_run("ALU Plus  Guion de presentacion")
run.font.size = Pt(8)

def add_text(text, style=None, bold=False, italic=False, code=False):
    p = doc.add_paragraph(style=style)
    r = p.add_run(text)
    r.bold = bold
    r.italic = italic
    if code:
        r.font.name = "Consolas"
        r._element.rPr.rFonts.set(qn("w:ascii"), "Consolas")
        r._element.rPr.rFonts.set(qn("w:hAnsi"), "Consolas")
        r.font.size = Pt(8.5)
    return p

in_code = False
for raw in source.read_text(encoding="utf-8").splitlines():
    line = raw.rstrip()
    if line.startswith("```"):
        in_code = not in_code
        continue
    if in_code:
        add_text(line or " ", code=True)
        continue
    if not line:
        continue
    if line.startswith("# "):
        p = add_text(line[2:], "Title")
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    elif line.startswith("## "):
        add_text(line[3:], "Heading 1")
    elif line.startswith("### "):
        add_text(line[4:], "Heading 2")
    elif line.startswith("- "):
        add_text(line[2:], "List Bullet")
    elif line.startswith("> "):
        p = add_text(line[2:], italic=True)
        p.paragraph_format.left_indent = Inches(0.25)
        p.paragraph_format.right_indent = Inches(0.2)
    elif line.startswith("**") and line.endswith("**"):
        add_text(line[2:-2], bold=True)
    elif line.startswith("|"):
        add_text(line.replace("|", "  |  ").strip(), code=True)
    else:
        add_text(line)

doc.save(output)
print(output)
