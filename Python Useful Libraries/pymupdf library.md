If you're learning PyMuPDF for **PDF processing / document ML**, the important thing is to understand the difference between **PDF objects, text, embedded images, and rasterized page images**.

# PyMuPDF Quick Notes

PyMuPDF is a Python library for working with PDFs and other document formats. The current API is generally imported as:

```python
import pymupdf
```

Older code may use:

```python
import fitz
```

but `pymupdf` is the clearer modern name.

---

## 1. Opening a PDF

```python
import pymupdf

doc = pymupdf.open("document.pdf")
```

`doc` represents the entire PDF.

### Number of pages

```python
len(doc)
```

### Access a page

```python
page = doc[0]
```

Remember: **page indexing starts at 0**.

```text
doc[0] → page 1
doc[1] → page 2
doc[2] → page 3
```

You can also iterate:

```python
for page in doc:
    print(page)
```

---

# 2. Extracting Text

The simplest operation:

```python
text = page.get_text()
print(text)
```

For the entire PDF:

```python
for page in doc:
    text = page.get_text()
    print(text)
```

You can also ask for different formats:

```python
page.get_text("text")
page.get_text("blocks")
page.get_text("words")
page.get_text("html")
page.get_text("markdown")
```

For example:

```python
words = page.get_text("words")
```

gives information about individual words, including their positions.

This is useful if you need to know **where on the page** a word occurs.

---

# 3. The Important Difference: Embedded Images vs Rasterized Page

This is probably the most important concept for what you're asking.

Suppose your PDF looks like:

```text
┌──────────────────────────────┐
│        My PDF Page           │
│                              │
│  Some text                  │
│                              │
│       ┌──────────┐           │
│       │  CHART   │           │
│       └──────────┘           │
│                              │
└──────────────────────────────┘
```

There are two different things you might mean by "get the image."

### A. Extract an image embedded inside the PDF

```python
images = page.get_images()
```

This looks for **embedded raster images**.

For example, a JPEG photograph that was inserted into the PDF.

### B. Turn the entire PDF page into an image

```python
pix = page.get_pixmap()
```

This **renders the entire page into a raster image**.

That means text, vector graphics, charts, images, etc. all get rendered into pixels. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/page.html?utm_source=chatgpt.com "Page - PyMuPDF documentation"))

This distinction is particularly important because something that visually looks like an image—such as a chart created in Excel, R, or Matplotlib—may actually be **vector graphics**, so `get_images()` won't find it. `get_pixmap()` will capture it because it rasterizes the page. ([GitHub](https://github.com/pymupdf/pymupdf?utm_source=chatgpt.com "GitHub - pymupdf/PyMuPDF: PyMuPDF is a high performance Python library for data extraction, analysis, conversion & manipulation of PDF (and other) documents. · GitHub"))

---

# 4. What is a Pixmap?

A `Pixmap` is essentially PyMuPDF's representation of a **raster image**.

```python
pix = page.get_pixmap()
```

Now:

```python
pix
```

contains pixels representing the rendered page.

You can save it:

```python
pix.save("page.png")
```

So:

```python
page
  ↓
get_pixmap()
  ↓
Pixmap
  ↓
PNG/JPEG/etc.
```

A Pixmap has useful properties such as:

```python
pix.width
pix.height
pix.samples
```

where `width` and `height` are the image dimensions in pixels. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/tutorial.html?utm_source=chatgpt.com "Tutorial - PyMuPDF documentation"))

---

# 5. Raster Images

A **raster image** is an image made of pixels.

For example:

```text
1920 × 1080
```

means:

```text
1920 pixels wide
1080 pixels high
```

When you do:

```python
pix = page.get_pixmap()
```

you're taking the PDF—which may contain text and vector graphics—and **rasterizing** it into pixels.

Conceptually:

```text
PDF
 ├── Text
 ├── Vector graphics
 ├── Images
 └── Shapes
       ↓
   get_pixmap()
       ↓
Raster image
       ↓
Pixels
```

This is extremely useful for:

- OCR
    
- Computer vision
    
- Document classification
    
- Vision models
    
- Page previews
    
- Extracting charts/diagrams
    
- Processing scanned PDFs
    

---

# 6. The Zoom Concept

This is where `Matrix` becomes important.

```python
mat = pymupdf.Matrix(2, 2)
pix = page.get_pixmap(matrix=mat)
```

The two numbers are:

```python
Matrix(xzoom, yzoom)
```

So:

```python
Matrix(2, 2)
```

means:

```text
2× horizontal
2× vertical
```

The result has **twice as many pixels in each direction**.

Therefore, if the original rendered page is:

```text
595 × 842
```

then approximately:

```python
Matrix(2, 2)
```

produces:

```text
1190 × 1684
```

So the dimensions double in both directions, meaning roughly **4× as many pixels overall**. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/recipes-images.html?utm_source=chatgpt.com "Images - PyMuPDF documentation"))

---

# 7. Why Does Zoom Increase Quality?

Imagine the original page is:

```text
500 × 700 pixels
```

At:

```python
Matrix(1, 1)
```

you get:

```text
500 × 700
```

At:

```python
Matrix(2, 2)
```

you get approximately:

```text
1000 × 1400
```

At:

```python
Matrix(3, 3)
```

you get:

```text
1500 × 2100
```

So you're essentially asking PyMuPDF:

> "Render this PDF page at a higher resolution."

It's not merely enlarging an already-created PNG. **The PDF is being rendered at the requested resolution**, which is important because PDF text and vector graphics can be rendered sharply at the higher resolution.

---

# 8. A Simple Example

```python
import pymupdf

doc = pymupdf.open("document.pdf")

page = doc[0]

mat = pymupdf.Matrix(2, 2)

pix = page.get_pixmap(matrix=mat)

pix.save("page.png")
```

Pipeline:

```text
document.pdf
     ↓
   doc
     ↓
   page 0
     ↓
Matrix(2, 2)
     ↓
get_pixmap()
     ↓
   Pixmap
     ↓
  page.png
```

---

# 9. Zoom vs DPI

You can specify resolution in two ways.

### Matrix

```python
mat = pymupdf.Matrix(2, 2)

pix = page.get_pixmap(matrix=mat)
```

### DPI

```python
pix = page.get_pixmap(dpi=300)
```

`dpi` is often easier to understand when you're thinking in terms of image resolution. PyMuPDF supports specifying DPI directly, and when `dpi` is supplied, it takes precedence over `matrix`. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/page.html?utm_source=chatgpt.com "Page - PyMuPDF documentation"))

For example:

```python
pix = page.get_pixmap(dpi=300)
pix.save("page.png")
```

---

# 10. Why Would I Use Zoom?

Suppose you're doing OCR.

At low resolution:

```python
pix = page.get_pixmap()
```

small text might become difficult for OCR to recognize.

You could render at higher resolution:

```python
pix = page.get_pixmap(dpi=300)
```

and then perform OCR on that image.

Conceptually:

```text
PDF
 ↓
Rasterize at 300 DPI
 ↓
High-resolution image
 ↓
OCR
 ↓
Text
```

This is especially relevant for scanned PDFs.

PyMuPDF also has built-in OCR functionality:

```python
tp = page.get_textpage_ocr()
text = page.get_text(textpage=tp)
```

although OCR requires access to the appropriate Tesseract language data. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/the-basics.html?utm_source=chatgpt.com "The Basics - PyMuPDF documentation"))

---

# 11. Extracting Embedded Images

If you specifically want the images **inside** a PDF:

```python
for page in doc:
    images = page.get_images()

    for img in images:
        xref = img[0]

        pix = pymupdf.Pixmap(doc, xref)

        pix.save("image.png")
```

Here you're doing something different:

```text
PDF
 ├── Text
 ├── Image A  ← get_images()
 ├── Image B  ← get_images()
 └── Chart
```

Whereas:

```python
page.get_pixmap()
```

does:

```text
PDF PAGE
 ├── Text
 ├── Image A
 ├── Image B
 └── Chart
       ↓
   RENDER EVERYTHING
       ↓
    One raster image
```

---

# 12. Cropping / `clip`

You don't always need to rasterize the entire page.

You can specify a region:

```python
clip = pymupdf.Rect(100, 100, 500, 500)

pix = page.get_pixmap(
    matrix=pymupdf.Matrix(2, 2),
    clip=clip
)
```

This means:

> Take only this rectangular portion of the page and render it at 2× resolution.

This is useful when, for example, you want to extract a chart or a particular region rather than the entire page. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/recipes-images.html?utm_source=chatgpt.com "Images - PyMuPDF documentation"))

---

# 13. `page.rect`

You can get the page dimensions:

```python
rect = page.rect

print(rect.width)
print(rect.height)
```

You can also use its coordinates:

```python
rect.tl   # top-left
rect.br   # bottom-right
```

This becomes useful for cropping and positioning.

---

# 14. Rotation

`Matrix` doesn't only do zoom.

For example:

```python
mat = pymupdf.Matrix(2, 2)
mat = mat.prerotate(90)
```

You can combine transformations such as:

- scaling/zooming
    
- rotation
    
- mirroring
    
- shearing
    

The Matrix controls how the page is transformed when rendered. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/page.html?utm_source=chatgpt.com "Page - PyMuPDF documentation"))

---

# 15. A Typical PDF → Image Pipeline

For document processing, you'll often see something like:

```python
import pymupdf

doc = pymupdf.open("document.pdf")

for page_number, page in enumerate(doc):

    pix = page.get_pixmap(dpi=300)

    pix.save(f"page_{page_number}.png")
```

Result:

```text
document.pdf
     │
     ├── Page 0 → page_0.png
     ├── Page 1 → page_1.png
     ├── Page 2 → page_2.png
     └── Page 3 → page_3.png
```

Each PNG is a **rasterized representation of the entire PDF page**.

---

## The important things to remember

|Concept|PyMuPDF|
|---|---|
|Open PDF|`pymupdf.open()`|
|Number of pages|`len(doc)`|
|Get page|`doc[0]`|
|Extract text|`page.get_text()`|
|Find embedded images|`page.get_images()`|
|Render entire page|`page.get_pixmap()`|
|Raster image representation|`Pixmap`|
|Save raster image|`pix.save()`|
|Zoom|`Matrix(xzoom, yzoom)`|
|Resolution directly|`dpi=300`|
|Page dimensions|`page.rect`|
|Crop region|`clip=Rect(...)`|
|OCR|`page.get_textpage_ocr()`|

### One distinction to really remember

**`get_images()` ≠ `get_pixmap()`**

```text
get_images()
    ↓
"Give me the actual embedded images in this PDF."

get_pixmap()
    ↓
"Render this entire PDF page as a raster image."
```

And:

```python
Matrix(2, 2)
```

basically means:

> **Render at 2× the normal resolution in both directions.**

So if you're working with PDFs for **OCR, computer vision, or feeding pages into a vision model**, `get_pixmap()` + understanding `Matrix`/`dpi` is probably the most important part to know. ([PyMuPDF](https://pymupdf.readthedocs.io/en/latest/recipes-images.html?utm_source=chatgpt.com "Images - PyMuPDF documentation"))