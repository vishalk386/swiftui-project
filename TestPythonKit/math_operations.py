# math_operations.py
from os import mkdir, walk
from os.path import abspath, basename, exists, expanduser, getsize, join
from shutil import move, rmtree
from subprocess import DEVNULL, run
from typing import Tuple
from PIL import Image
import io

cache_folder = expanduser("~/Library/Caches/compress-office/")

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def convert_size(size_in_byte: int) -> str:
    units = ("B", "KB", "MB", "GB")
    for unit in units:
        if size_in_byte < 1024:
            return f"{round(size_in_byte, 2)}{unit}"
        size_in_byte /= 1024
    return f"{round(size_in_byte, 2)}TB"



def compress(file_path: str) -> Tuple:
    file_path = abspath(file_path)
    file_name = basename(file_path)
    before_size = getsize(file_path)

    # Delete old files
    if exists(cache_folder):
        rmtree(cache_folder)

    # Create cache folder
    mkdir(cache_folder)

    # Unzip file
    print("Unzipping Document...")
    run(
        ["unzip", file_path, "-d", cache_folder],
        stdout=DEVNULL,
    ).check_returncode()

    # Compress Images
    print("Compressing Images...")
    for root, _, files in walk(cache_folder):
        for file in files:
            if file.lower().endswith(('.jpg', '.jpeg', '.png')):
                image_path = join(root, file)
                compressed_image_data = compress_image(image_path)
                with open(image_path, 'wb') as img_file:
                    img_file.write(compressed_image_data)

    # Rezip file
    print("Packing Document...")
    run(
        ["zip", file_name, "-r", "."],
        stdout=DEVNULL,
        cwd=cache_folder,
    ).check_returncode()
    after_size = getsize(file_path)

    if after_size >= before_size:
        print("File size unchanged")
        return (before_size, before_size)

    # Move new file to origin place
    run(
        ["trash", file_path],
    ).check_returncode()
    move(join(cache_folder, file_name), file_path)

    # Delete caches
    if exists(cache_folder):
        rmtree(cache_folder)

    print(f"Successfully compressed {convert_size(before_size)} -> {convert_size(after_size)}")

    return (before_size, after_size)

def compress_image(image_path, quality=75):
    try:
        # Open the image using Pillow
        with open(image_path, 'rb') as img_file:
            img_data = img_file.read()
            img = Image.open(io.BytesIO(img_data))

        # Compress the image
        output_buffer = io.BytesIO()
        img.save(output_buffer, 'JPEG', quality=quality)

        # Get the compressed image data
        compressed_image_data = output_buffer.getvalue()

        return compressed_image_data
    except Exception as e:
        print(f"Error compressing image: {str(e)}")
        return None
