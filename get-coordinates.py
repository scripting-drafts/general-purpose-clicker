import time
import pyautogui

while True:
    x, y = pyautogui.position()
    print(f"\rX: {x} | Y: {y}", end="", flush=True)
    time.sleep(0.05)
