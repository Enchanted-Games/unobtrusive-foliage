from math import e
import os
from PIL import Image, ImageEnhance

def getScriptRelativePath():
    return os.path.dirname(os.path.realpath(__file__))

def main():
    # this will add the saturation filter to ANY png in this path, and in any subfolders
    # make a copy of the pack in case of errors
    texturesPath = getScriptRelativePath()

    failedImgs = []

    for subdir, dirs, files in os.walk(texturesPath):
        subdir = subdir + "/"

        for fileName in files:
            if fileName.endswith(".png") | fileName.endswith(".tga"):
                try:
                    img = Image.open(subdir + fileName)
                    print("Alphaifying", fileName, img.size, img.mode)
                    # img.mode = "RGBA"
                    if img.mode == "P":
                        # handle indexed colours image
                        img = img.convert("RGBA")

                    img2 = img.copy()
                    img2.putalpha(249)
                    img.paste(img2, img)

                    img.save(subdir + fileName)
                except e:
                    print(e)
                    failedImgs.append([fileName, subdir + fileName])

    if len(failedImgs) > 0:
        for file in failedImgs:
            print(
                "WARNING: There was an error trying to modify '",
                file[0],
                "'. Image path: '",
                file[1],
                "'",
                sep="",
            )


if __name__ == "__main__":
    main()
