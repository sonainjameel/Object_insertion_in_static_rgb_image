# This script ensures necessary libraries are installed.
import subprocess
import sys

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

# List of required packages
required_packages = [
    'pillow',  # For image processing with PIL
    'opencv-python',  # For image processing with OpenCV
    'tensorflow'  # For deep learning
]

for package in required_packages:
    install(package)
