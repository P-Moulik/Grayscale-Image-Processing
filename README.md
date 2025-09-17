# Grayscale Image Processing in Verilog

## 📌 Overview
This project implements a **grayscale image processing** in Verilog.  

- Input: Grayscale image
- Processing: Line buffering + 3×3 convolution (edge detection using Sobel-like kernels)
- Output: Pixel values written to a text file (`output_pixels.txt`)
- Visualization: MATLAB script reshapes and displays the image

---

## 🛠️ Modules
- **`lineBuffer.v`** → Implements row buffering for 2D convolution windows  
- **`imageControl.v`** → Controls line buffers and pixel data flow  
- **`conv.v`** → Convolution with 3×3 Sobel filters (edge detection)  
- **`imageProcessTop.v`** → Top-level module  
- **`tb.v`** → Testbench for simulation (reads input image's pixels, writes output to text file)  
