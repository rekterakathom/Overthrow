import os
import sys


def main():
    addon_base_path = os.path.dirname(os.getcwd())
    for root, _dirs, files in os.walk(addon_base_path):
        for file in files:
            if file.endswith(".sqfc"):
                os.remove(os.path.join(root, file))


if __name__ == "__main__":
    sys.exit(main())