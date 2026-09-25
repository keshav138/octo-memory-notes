```python
# pip install pymupdf
import fitz 
import os

def extract_manual_images(pdf_dir="manuals", output_dir="extracted_images"):
    os.makedirs(output_dir, exist_ok=True)
    
    for filename in os.listdir(pdf_dir):
        if not filename.endswith(".pdf"): continue
        
        doc = fitz.open(os.path.join(pdf_dir, filename))
        print(f"Processing {filename}...")
        
        for page_num, page in enumerate(doc):
            images = page.get_images(full=True)
            for img_idx, img in enumerate(images):
                xref = img[0]
                base_image = doc.extract_image(xref)
                image_bytes = base_image["image"]
                
                # Skip tiny icons/logos (under 30KB)
                if len(image_bytes) < 30720: 
                    continue
                    
                ext = base_image["ext"]
                # Naming convention: filename_page_imgIndex for easy citation later
                out_name = f"{filename.replace('.pdf', '')}_p{page_num+1}_{img_idx}.{ext}"
                
                with open(os.path.join(output_dir, out_name), "wb") as f:
                    f.write(image_bytes)

if __name__ == "__main__":
    extract_manual_images()
```

---

## 1. File & Directory Setup Functions (`os` module)

- `os.makedirs(output_dir, exist_ok=True)`
    
    - What it does: Safely creates the target folder where images will be saved.
    - Why it matters: Setting `exist_ok=True` ensures the script doesn't crash if the folder already exists.
    
- `os.listdir(pdf_dir)`
    
    - What it does: Reads the input directory and returns a list of all filenames inside it.
    
- `os.path.join(pdf_dir, filename)`
    
    - What it does: Glues the folder path and filename together using the correct slash (`/` or `\`) depending on whether you are running this on Mac, Windows, or Linux.
    

---

## 2. PyMuPDF Core Functions (`fitz` module)

- `fitz.open(...)`
    
    - What it does: Opens the PDF file and loads it into system memory as a Document object (`doc`).
    - Why it matters: This acts as the master key that allows you to read pages, text, metadata, and graphics from that specific PDF.
    
- `enumerate(doc)`
    
    - What it does: Standard Python loop tracking. In `fitz`, looping directly over `doc` yields individual `Page` objects one by one. `enumerate` keeps count, giving you `page_num` (starting at 0) alongside the `page` object.
    
- `page.get_images(full=True)`
    
    - What it does: Scans the specific page and returns a list of metadata details for every image found on it.
    - Why it matters: Passing `full=True` retrieves the full specification list. Crucially, each item in this list is a tuple where the very first element (`img[0]`) is the `xref`.
    
- `xref = img[0]`
    
    - What it does: Extracts the XML Reference ID (`xref`). This is an internal, unique serial number the PDF engine assigns to that specific asset.
    
- `doc.extract_image(xref)`
    
    - What it does: Takes that serial number and pulls the raw data block out of the PDF structure.
    - What it returns: A Python dictionary containing key details about the image:
        
        - `base_image["image"]`: The actual raw binary data (bytes) of the picture.
        - `base_image["ext"]`: The file extension string (e.g., `"png"`, `"jpeg"`).
        
    

---

## 3. Logic & Filtering

- `if len(image_bytes) < 30720:`
    
    - What it does: This calculates the size of the image file in bytes. Because 1 KB = 1024 bytes, the value `30720` translates precisely to 30 KB (30 × 1024).
    - Why it matters: If the file size is less than 30 KB, the script hits `continue`, skipping the rest of the loop block. This saves you from cluttering your folder with UI checkmarks, tiny social media footer logos, or decorative lines.
    

---

## 4. File Output Functions

- `with open(..., "wb") as f:`
    
    - What it does: Opens up a file stream on your computer hard drive in Write Binary (`"wb"`) mode.
    - Why it matters: Images must be written using binary mode (`"wb"`) rather than standard text mode (`"w"`), otherwise the underlying image file format will break and become corrupt.
    

---

If you plan to run this on your own documents, tell me:

- Do your manuals contain scanned pages (where the entire page is an image) or digital PDFs with floating images?
- Would you like to modify the script to also extract the text context surrounding each image to see what the image is referring to?