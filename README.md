<p align="center">
<img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/glide_logo_transparent.png" width="128" max-width="80%" alt="glide"/>
</p>

# glide engine

glide is a SpriteKit and GameplayKit based engine for building 2d games easily, with a focus on side scrollers. glide is developed with Swift and works on iOS, macOS and tvOS. 

- Download the macOS demo app [here](https://github.com/cocoatoucher/Glide/raw/master/Docs/GlideDemo.zip) to give it a try. 
- or watch a video of the features [here](https://vimeo.com/334243593). 

<p align="center">
<a target="_blank" rel="noopener noreferrer" href="https://vimeo.com/334243593">
<img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/jump.gif" width="400" max-width="80%" alt="A glimpse of the glide's features">
</a>
</p>

<p align="center">
<a href="https://app.bitrise.io/app/b14b754f747dc2fa">
<img src="https://app.bitrise.io/app/b14b754f747dc2fa/status.svg?token=2DJHooo6_IVnbLRAFbfxzQ" alt="iOS Build status"/>
</a>
<a href="https://app.bitrise.io/app/a302dd2ce8710bf2">
<img src="https://app.bitrise.io/app/a302dd2ce8710bf2/status.svg?token=I5JPNr5-g_hAj2kR6mtZaA" alt="macOS Build status"/>
</a>
<img src="https://img.shields.io/badge/Swift-5.0-orange.svg"/>
<a href="https://cocoapods.org/pods/GlideEngine">
<img src="https://img.shields.io/cocoapods/v/GlideEngine.svg" alt="cocoapods"/>
</a>
</p>
<p align="center">
<a href="https://twitter.com/intent/follow?screen_name=glideengine">
<img src="https://img.shields.io/twitter/follow/glideengine.svg?label=Follow"/>
</a>
<img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square"/>
<a href="mailto:cocoatoucher@posteo.se">
<img src="https://img.shields.io/badge/contact-cocoatoucher-yellow.svg?style=flat"/>
</a>
</p>

<p align="center">
<img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/devices.png" max-width="80%" alt="glide devices"/>
</p>

## What is in glide?

### 1. Entity component system
glide is developed with Entity-Component-System architecture. In short, this makes it easy to manage the code of your game. Loads of building components common to 2d platformers that will get you quickly started is also included in the engine. 

#### See all the components [here](https://github.com/cocoatoucher/Glide/blob/master/Docs/Components.md). 👾

### 2. Tight collisions and contacts
glide has its own collision and contact algorithms which is more suitable for precise platformer mechanics compared to using SpriteKit's physicsBody.

### 3. Input 🎮⌨️🖱🔲
Support for Bluetooth and USB game controllers, keyboard, mouse, and touch controls comes out of the box with glide and it is pretty intuitive to use them.

### 4. Native game menus

<p align="center">
<img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/navigatable.gif" width="444" max-width="80%"/>
</p>

You can't imagine a game without menus in most cases. A UIKit / AppKit based user interface library for making game menus is included in glide, so you don't have to give up from native Apple components in your games. Of course, those menus are controllable via game controllers on iOS, macOS and tvOS 🎮💃

### 5. Audio and music 🔊
There is currently a work in progress for playing audio and music with ready made components in glide. In the mean time, you can go ahead and use `SKAudioNode`s directly with your entities and components as glide is seamlessly integrated with SpriteKit.

## Get your hands on glide

### Demo scenes
glide comes with a fully fledged demo project. Download this repository and run it in your favorite platform. Running on release configuration with a real device is recommended for experiencing the actual performance.

### Quick start guide
Create your first scene with your first entity [here.](https://github.com/cocoatoucher/Glide/blob/master/Docs/QuickStartGuide.md)

### Update loops
Here are the update loop charts of glide that you might need as a handy reference.

Scene update loop       |  Entity update loop     |  Component update loop
:-------------------------:|:-------------------------:|:-------------------------:
![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/glide-update-cycle-scene.png "Update cycle of a scene")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/glide-update-cycle-entity.png "Update cycle of an entity")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/glide-update-cycle-component.png "Update cycle of a component")

### Game genres
Supporting other types of 2d games(e.g. top down) with glide is totally possible. However, that is not tested with enough demos yet, and side scrollers are the initial focus for the engine. Please feel free to contribute with your own demos and changes to glide for supporting other games.

### 🐞🐜
Bugs are expected since glide is in its early days and this is currently a solo developer project. Please report the bugs you find and give some patience 🙏

### Credits:

- Animated Pixel Adventurer: https://rvros.itch.io/animated-pixel-hero
- Classical ruin tiles: https://opengameart.org/content/classical-ruin-tiles
- [All credits](https://github.com/cocoatoucher/Glide/blob/master/Docs/AssetCredits.md)
