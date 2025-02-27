# LuaMQTT Client fyrir Minecraft

[luaMQTT](https://github.com/WhyKickAmooCow/luamqtt-computercraft) er notaður sem grunn fyrir lua client.

## Takmarkanir
Það er ekki hægt að tengjast við brokerinn minn frá external tengingu.

## Kröfur
Til að nota kerfið þarftu að hafa:
- Minecraft á tölvunni
- Modloader ([CurseForge appið](https://www.curseforge.com/download/app) er mælt með)
- [CC:Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked)

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

https://github.com/user-attachments/assets/c8147b7f-9f41-44df-b776-9813e5b85b4e

