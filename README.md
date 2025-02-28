# LuaMQTT Display client fyrir Minecraft

# english translation bellow

[luaMQTT](https://github.com/WhyKickAmooCow/luamqtt-computercraft) er notaður sem grunn fyrir lua client.


## Kröfur
Til að nota kerfið þarftu að hafa:
- Minecraft á tölvunni
- Modloader ([CurseForge appið](https://www.curseforge.com/download/app) er mælt með)
- [CC:Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked)
- að hafa mosquitto broker, ég hafði á raspberry pi

## Uppsetning
1. Búðu til nýtt world í Minecraft.
2. Settu niður "advanced computer" og "advanced monitor" hliðiná (númer af monitors mun hækka gæðina).
3. Opnaðu tölvuna og skrifaðu eftirfarandi í terminalinn:
```sh
wget https://raw.githubusercontent.com/Brakku/vidmots-lokaverk/refs/heads/main/installer.lua installer.lua
```
4. Keyrðu installerinn með því að skrifa:
```sh
installer
```
Þetta mun ná í allt sem þarf.

## Keyrsla
Til að byrja forritið, skrifaðu:
```sh
luaclient.lua
```

Fyrir handa data-ið þá þarf að keira website-ið sem er í "webclient" sem live server og það þarf að hafa myndavél.

# english translation

# LuaMQTT Display client for Minecraft

[luaMQTT](https://github.com/WhyKickAmooCow/luamqtt-computercraft) is used as the base for the lua client.


## Requirements
To use the system, you need:
- Minecraft on your computer
- Modloader ([CurseForge app](https://www.curseforge.com/download/app) is recommended)
- [CC:Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked)
- having mosquitto broker, i had on raspberry pi on the local network, not tested on having a local broker

## Setup
1. Create a new world in Minecraft.
2. Place an "advanced computer" and an "advanced monitor" next to each other (the number of monitors will increase the quality).
3. Open the computer and type the following in the terminal:
```sh
wget https://raw.githubusercontent.com/Brakku/vidmots-lokaverk/refs/heads/main/installer.lua installer.lua
```
4. Run the installer by typing:
```sh
installer
```
This will fetch everything needed.

## Running
To start the program, type:
```sh
luaclient.lua
```


## For the hand data, you need to run the website in the "webclient" as a live server and have a camera and a mosquitto broker.



https://github.com/user-attachments/assets/c8147b7f-9f41-44df-b776-9813e5b85b4e

