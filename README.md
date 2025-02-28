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

## Ferli til að ná fram skjámynd

### `luaclient.lua`

1. **Uppsetning skjás**: Skjalið frumstillir skjáinn með `peripheral.find("monitor")` og stillir textaskalann.
2. **Uppsetning MQTT**: Skjalið setur upp MQTT client til að tengjast broker.
3. **Frumstilling striga**: Tómur strigi er búinn til með `createCanvas` fallinu.
4. **Teikniföll**: Skjalið inniheldur föll eins og `drawLine` og `mapLandmarks` til að teikna tengingar og kortleggja kennileiti á skjástærðina.
5. **Birting**: `renderCanvas` fallið birtir ASCII list á skjáinn.
6. **MQTT meðhöndlun**: Skjalið gerist áskrifandi að "landmarks" efni og vinnur úr innkomandi skilaboðum til að búa til og birta hand ASCII list.

### `main.js`

1. **Uppsetning MQTT**: Skjalið frumstillir MQTT client til að tengjast broker.
2. **Uppsetning á hreyfiviðurkenni**: Skjalið setur upp hreyfiviðurkenni með MediaPipe's `GestureRecognizer`.
3. **Uppsetning vefmyndavélar**: Skjalið athugar fyrir stuðning við vefmyndavél og setur upp vefmyndavélarstraum.
4. **Spá**: `predictWebcam` fallið vinnur úr vefmyndavélarstraumnum til að viðurkenna hreyfingar og teikna kennileiti á strigann.
5. **Sending gagna**: Skjalið sendir unnin kennileiti til MQTT broker með `sendMessage` fallinu.

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

## Process to Achieve Display

### `luaclient.lua`

1. **Monitor Setup**: The script initializes the monitor using `peripheral.find("monitor")` and sets the text scale.
2. **MQTT Setup**: The script sets up an MQTT client to connect to the broker.
3. **Canvas Initialization**: A blank canvas is created using the `createCanvas` function.
4. **Drawing Functions**: The script includes functions like `drawLine` and `mapLandmarks` to draw connections and map landmarks to the monitor size.
5. **Rendering**: The `renderCanvas` function renders the ASCII art to the monitor.
6. **MQTT Handling**: The script subscribes to the "landmarks" topic and processes incoming messages to generate and display the hand ASCII art.

### `main.js`

1. **MQTT Setup**: The script initializes an MQTT client to connect to the broker.
2. **Gesture Recognizer Setup**: The script sets up the gesture recognizer using MediaPipe's `GestureRecognizer`.
3. **Webcam Setup**: The script checks for webcam support and sets up the webcam feed.
4. **Prediction**: The `predictWebcam` function processes the webcam feed to recognize gestures and draw landmarks on the canvas.
5. **Sending Data**: The script sends the processed landmarks to the MQTT broker using the `sendMessage` function.

