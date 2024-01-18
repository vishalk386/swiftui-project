from os import mkdir
from os.path import abspath, basename, exists, expanduser, getsize, join
from shutil import move, rmtree
from subprocess import DEVNULL, run
from typing import Tuple

from rich.console import Console
from PIL import Image
import io

console = Console()

# Modify these to use on other platform
cache_folder = expanduser("~/Library/Caches/compress-office/")

def convert_size(size_in_byte: int) -> str:
    units = ("B", "KB", "MB", "GB")
    for unit in units:
        if size_in_byte < 1024:
            return f"{round(size_in_byte, 2)}{unit}"
        size_in_byte /= 1024
    return f"{round(size_in_byte, 2)}TB"

def compress_image(image_path: str, quality: int = 75) -> bytes:
    with open(image_path, 'rb') as img_file:
        img_data = img_file.read()
        img = Image.open(io.BytesIO(img_data))
        img.save(image_path, 'JPEG', quality=quality)
    
    with open(image_path, 'rb') as img_file:
        return img_file.read()

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
    with console.status("[bold green]Unzipping Document..."):
        run(
            ["unzip", file_path, "-d", cache_folder],
            stdout=DEVNULL,
        ).check_returncode()

    # Compress Images
    with console.status("[bold green]Compressing Images..."):
        for root, _, files in os.walk(cache_folder):
            for file in files:
                if file.lower().endswith(('.jpg', '.jpeg', '.png')):
                    image_path = os.path.join(root, file)
                    compressed_image_data = compress_image(image_path)
                    with open(image_path, 'wb') as img_file:
                        img_file.write(compressed_image_data)

    # Rezip file
    with console.status("[bold green]Packing Document..."):
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

