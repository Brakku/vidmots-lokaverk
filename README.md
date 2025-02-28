# LuaMQTT Display client fyrir Minecraft

# english translation bellow

### Lokaverkefni í Viðmótsforritun – Breki Hlynsson 2025  
Tækniskólinn – Upplýsingatæknibraut  

## Verkefnalýsing  
Verkefnið snýst um að búa til kerfi sem sýnir handarstöðu í Minecraft með því að nota vefmyndavél og hreyfiviðurkenni. Kerfið notar MQTT til að senda handarstöðu frá vefmyndavélinni til Minecraft tölvunnar. Handarstaðan er síðan sýnd á skjánum í Minecraft með ASCII list.  

Kerfið er skipt í tvo hluta:  
1. **Lua Client** – Sýnir handarstöðuna í Minecraft með ASCII list.  
2. **Vefclient** – Les handarstöðuna með vefmyndavélinni og sendir hana til Lua clients með MQTT.  

## Hugmyndin að verkefninu  
Ég fékk hugmyndina frá mismunandi sýningum sem ég hef séð á netinu. Ég hafði þegar búið til kóðann fyrir vefsíðuna í öðru verkefni, þannig að ég var þegar með *landmark data* tilbúin til notkunar. Ég vissi af *ComputerCraft* en hafði ekki unnið mikið með það áður, svo ég sá þetta sem tækifæri til að prófa stærra verkefni í því umhverfi.  

## Helstu áskoranir  
Aðalvandamálið var að koma gögnum til tölvunnar. Ég vissi að hægt væri að vinna með HTTP til að sækja gögn, en ég var ekki viss um hvort það væri nógu hratt. Ég fann síðan út að ég gæti notað MQTT til að senda gögn á milli tölvunnar og vefsíðunnar. Ég fann *luaMQTT*, sem er Lua client fyrir MQTT, og notaði það til að koma gögnum á milli.  

## Notuð tól og söfn  
- **ComputerCraft** (Minecraft mod fyrir Lua forritun)  
- **luaMQTT** (MQTT client fyrir Lua)  
- **Vefmyndavél og hreyfiviðurkenni** (t.d. Mediapipe fyrir handarstöðu)  
- **HTML/CSS/JavaScript** (vefclient til að lesa handarstöðu)  
- **MQTT Broker** (t.d. Mosquitto fyrir miðlun gagna)  

## Skref í þróun  
1. Setja upp vefclient til að lesa handarstöðu með vefmyndavél.  
2. Tengja vefclient við MQTT til að senda gögn.  
3. Búa til Lua client í ComputerCraft til að taka við gögnum og birta þau í Minecraft.  
4. Prófanir og fínstilling á hraða gagnaflutnings.  

## Útkoma og næstu skref  
Verkefnið tókst vel og tókst mér að fá handarstöðu til að birtast í Minecraft í rauntíma með ASCII list. Ef ég myndi halda áfram með verkefnið myndi ég vilja:  
- Betrumbæta myndbirtingu í Minecraft, t.d. með *pixels* mögulega notandi [pixelbox](https://github.com/9551-dev/pixelbox_lite).  
- Bæta við fleiri höndunum og hreyfiviðurkenni fyrir fjölbreyttari samskipti.  
- Gera notendaviðmótið meira straumlínulagað.  

## Skjöl og heimildir  
- [GitHub geymsla með kóða](#) *(Bættu við slóð þegar tiltæk)*  
- Myndir og myndband af frumgerð *(Bættu við slóð þegar tiltæk)*  
- LuaMQTT: [https://github.com/geekscape/lua-mqtt](https://github.com/geekscape/lua-mqtt)  
- ComputerCraft: [https://tweaked.cc/](https://tweaked.cc/) 



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


### Final Project in UI Programming – Breki Hlynsson 2025  
Tækniskólinn – Information Technology Program  

## Project Description  
The project involves creating a system that displays hand positions in Minecraft using a webcam and motion recognition. The system uses MQTT to transmit hand position data from the webcam to the Minecraft computer. The hand position is then displayed on the Minecraft screen using ASCII art.  

The system consists of two parts:  
1. **Lua Client** – Displays the hand position in Minecraft using ASCII art.  
2. **Web Client** – Reads the hand position using the webcam and sends it to the Lua client via MQTT.  

## Project Idea  
I got the idea from various demonstrations I’ve seen online. I had already written the code for the web client in another project, so I already had landmark data ready to be used for something. I was aware of *ComputerCraft* but hadn’t worked with it much before, so I saw this as an opportunity to try a larger project using it.  

## Main Challenges  
The biggest challenge was transferring the data to the computer. I knew that HTTP could be used to fetch data, but I wasn’t sure if it would be fast enough. Eventually, I discovered that I could use MQTT to transmit data between the computer and the web client. I found *luaMQTT*, a Lua client for MQTT, and used it to send data between the two.  

## Tools and Libraries Used  
- **ComputerCraft** (Minecraft mod for Lua programming)  
- **luaMQTT** (MQTT client for Lua)  
- **Webcam and motion recognition** (e.g., Mediapipe for hand tracking)  
- **HTML/CSS/JavaScript** (web client for reading hand position)  
- **MQTT Broker** (e.g., Mosquitto for data transmission)  

## Development Steps  
1. Set up the web client to detect hand position using the webcam.  
2. Connect the web client to MQTT for data transmission.  
3. Develop the Lua client in ComputerCraft to receive data and display it in Minecraft.  
4. Test and optimize data transfer speed.  

## Outcome and Next Steps  
The project was successful, and I was able to display hand positions in Minecraft in real-time using ASCII art. If I were to continue developing the project, I would:  
- Improve the image rendering in Minecraft, possibly using [pixelbox](https://github.com/9551-dev/pixelbox_lite).  
- Add support for multiple hands and more advanced motion recognition.   

## Documentation and References  
- [GitHub repository with source code](#) *(Add link when available)*  
- Images and video demonstration *(Add link when available)*  
- LuaMQTT: [https://github.com/geekscape/lua-mqtt](https://github.com/geekscape/lua-mqtt)  
- ComputerCraft: [https://tweaked.cc/](https://tweaked.cc/)  





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

## Breki Hlynsson 2025
