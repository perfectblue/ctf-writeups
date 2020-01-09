import pyautogui, os
from pykeyboard import PyKeyboard
##screenWidth, screenHeight = pyautogui.size()
##currentMouseX, currentMouseY = pyautogui.position()
##pyautogui.moveTo(100, 150)
##pyautogui.click()
##pyautogui.moveTo(700, 150)
#import pyscreenshot as ImageGrab
import time, thread, pytesseract
from PIL import Image
import string

keyboard = PyKeyboard()

inputs = (106, 1041)
settings = (46, 1041)
start = (1829, 1012)
flaginp = (1642, 840)
xbutton = (1870, 15)

screenWidth, screenHeight = pyautogui.size()

def move(asdf):
    pyautogui.moveTo(asdf)

def click():
    pyautogui.click()
    time.sleep(0.2)

def doubclick():
    pyautogui.click(clicks=2)
    time.sleep(0.2)


def typeflag(flag):
    for i in flag:
        keyboard.press_key(i)
        time.sleep(0.03)
        keyboard.release_key(i)


flag = "MeepwnCTF{"


while True:
    for i in "_" + string.digits + string.letters + "}{!@#$%^&*()-_=+[]:;?|\\/.,><":
        move(settings)
        click()
        move(inputs)
        click()
        move(flaginp)
        doubclick()
        typeflag(flag + i)
        move(settings)
        click()
        move(start)
        click()
        time.sleep(5)
        prev = pyautogui.screenshot(region=(325, 900, 721-400, 1019-855))
        prev.save("temp.jpg")
        text = pytesseract.image_to_string(Image.open("temp.jpg"))
        print flag + i
        move(xbutton)
        click()
        time.sleep(0.1)
        if "flag" in text.encode("UTF-8") or "Your" in text.encode("UTF-8"):
            flag += i
            break
exit()
        

pyautogui.moveTo(100, 150)
pyautogui.click
#MeepwnCTF{W3llc0m3_2_Th3_Bl4ck_P4r4d3}
