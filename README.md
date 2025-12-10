# AutoCAD Point Alignment & Linear Regression Tools (LISP)

This repository contains custom AutoLISP (`.lsp`) routines designed for surveyors, civil engineers, and drafters using AutoCAD. These tools automate the process of aligning points and objects to lines while **strictly preserving their original Z-coordinates (Elevation)**.

![Demo Animation](main_large.gif)

## 🚀 Features

* **Z-Coordinate Preservation:** Unlike standard AutoCAD alignment methods, these tools modify only the X and Y coordinates. The elevation (Z) of every point remains untouched.
* **Linear Regression (Best Fit):** Automatically calculates and draws a "best fit" line through a scattered cloud of points using the Least Squares method.
* **2D Projection:** Projects objects perpendicularly onto a target line or polyline.
* **Batch Processing:** Works on multiple selected objects (Points, Blocks, Text, etc.) simultaneously.

## 📂 Included Scripts

### 1. `YakınaHizala.lsp` (Align to Existing Line)
This script projects selected objects onto a **user-selected reference line**.

* **Command:** `YAKINAHIZALA`
* **How it works:**
    1.  Prompts the user to select a reference line (Line, Polyline, etc.).
    2.  Prompts the user to select the objects to be aligned.
    3.  Moves the objects to the nearest point on the reference line in the X-Y plane.
    4.  **Crucial:** The object's original Z value is kept constant.

### 2. `OtoHizala.LSP` (Auto-Regression & Align)
This script calculates the mathematical average path of scattered points, draws that path, and aligns the points to it.

* **Command:** `OTOHIZALA`
* **How it works:**
    1.  Prompts the user to select a group of scattered points.
    2.  Calculates the **Linear Regression (Least Squares)** line based on the coordinates.
    3.  Draws the calculated "Best Fit" line (Color: Red).
    4.  Automatically projects all selected points onto this new line.
    5.  **Crucial:** Preserves original Z values.

## 📦 Installation

1.  Download the `.lsp` files from this repository.
2.  Open AutoCAD.
3.  Type `APPLOAD` in the command line and press Enter.
4.  Navigate to the folder where you downloaded the files.
5.  Select `YakınaHizala.lsp` and `OtoHizala.LSP` and click **Load**.
    * *Optional:* Add them to the "Startup Suite" contents to load them automatically every time AutoCAD starts.

## 🛠 Usage

**To align to an existing line:**
1.  Type `YAKINAHIZALA` and press Enter.
2.  Select the target curve/line.
3.  Select the objects you want to move.

**To create a best-fit line and align:**
1.  Type `OTOHIZALA` and press Enter.
2.  Select the scattered points.
3.  The script will draw a red line and align the points to it instantly.

## ⚠️ Requirements

* **Software:** AutoCAD (Full Version). AutoCAD LT does not support LISP routines.
* **Supported Objects:** Points, Blocks, Text, MText, Circles (Insertion points are used for alignment).

## 📝 License

This project is open-source. Feel free to modify and use it for your projects.
