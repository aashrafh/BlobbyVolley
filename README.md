<p align="center">
  <a href="" rel="noopener">
 <img width=400px height=210px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/logo.png" alt="BlobbyVolley logo"></a>
</p>

<div align="center">

  [![Status](https://img.shields.io/badge/status-active-success.svg)]()
  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> :baseball: Multiplayer Assembly 8086 Clone of BlobbyVolley Game
    <br> 
</p>

## 📝 Table of Contents
- [About](#about)
- [Demo](#demo)
- [Install](#Install)
- [How To Play](#play)
- [Built Using](#tech)

## 🧐 About <a name = "about"></a>
It is the well-known game named ```Blobby Volley``` coded in assembly language with x86 instruction set, 8086 version. The game can be played in multiplayer mode using UART serial communication through the dos emulator ```DOSBox``` with two modes the ```Play``` mode and the ```Chat``` mode in which you can talk with the other player.

The rules used in Blobby Volley are derived from the standard volleyball rules. Unlike real volleyball, the movements of the players are limited to the two-dimensional space of the screen. The borders of the screen acts as an invisible wall which the ball bounces off, which is completely legal to use. Since there is only one player on each side of the field, it is permitted for the player to touch the ball several times in a row.

## 🎥 Demo 
<div name="demo" align="center" width=1189px>
  <p align="center">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-1.png" alt="Image Demo">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-2.png" alt="Image Demo">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-6.png" alt="Image Demo">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-3.png" alt="Image Demo">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-4.png" alt="Image Demo">
    <img width=800px height=410px src="https://github.com/aashrafh/BlobbyVolley/blob/master/demo/demo-img-5.png" alt="Image Demo">
  </p>
  </div>

## 🏁 Install <a name = "Install"></a>
1. Install [DOSBox](https://www.dosbox.com/).
2. Open ```DOSBox Options```.
3. Add the following lines to the end of the text file.
```
mount c Z:\Workspaces\GitHub\BlobbyVolley\project
c:
masm project;
masm objects;
link project+objects;
project
```
**Note:** do not forget to replace ```Z:\Workspaces\GitHub\BlobbyVolley\project``` with your local directory.

## 💭 How To Play <a name = "play"></a>
Each of the players tries to make the ball touches the other player ground so you can serve and score points. To move the player you can use:
* ```W``` to move ```UP```
* ```S``` to move ```DOWN```
* ```A``` to move ```LEFT```
* ```D``` to move ```RIGHT```

## ⛏️ Built Using <a name = "tech"></a>
- [Assembly8086](https://en.wikipedia.org/wiki/X86_assembly_language) - low level programming language.
- [DOSBox](https://www.dosbox.com/) - emulator program.
