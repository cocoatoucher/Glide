<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/glide_logo_transparent.png" width="128" max-width="80%" alt="Glide"/>
</p>

## Input methods supported by glide

Input support in glide engine is designed to be all inclusive and intuitive at the same time for game developers. Among the missions are to provide a common interface among different input methods and ensure a smooth transition between them for both the player and the developer.

- You can see an see an example of those transitions in this [video](https://www.youtube.com/watch?v=TaX98tooTVg). 
- Watch a quick tutorial [here](https://www.youtube.com/watch?v=Ru87AxgsLKQ) to learn to support different input methods in your games with glide engine.


*Here's a glance of different input methods supported by glide:*

### 🎮 Game controllers
You can use game controllers within both gameplay and game menus developed with glide.

**- MFI certified game controllers on iOS, macOS and tvOS**

glide uses GameController framework of iOS and macOS SDKs to support those officially recognized controllers.

SteelSeries Nimbus | Siri Remote
:-------------------------:|:-------------------------:
![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/steelSeries_nimbus.png "SteelSeries Nimbus")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/siri_remote.png "Siri Remote")

**- Other controllers via USB on macOS**

glide includes an inner framework that communicates directly with non-MFI controllers via IOKit frameworks of macOS. That approach is only supported to work with controllers connected via USB. Although some of those controllers has Bluetooth support, making them work via those frameworks over Bluetooth is rather complicated *. Keep an eye for future changes on this though.

No Brand USB Controller | 8BitDo SN30 via USB | 8BitDo SN30 Pro via USB | Joy-Cons via Bluetooth**
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/generic_usb.png "No brand USB game controller")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/8BitDo_sn30.png "8BitDo SN30 connected via USB")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/8BitDo_sn30pro.png "8BitDo SN30 Pro connected via USB")  |  ![alt text](https://github.com/cocoatoucher/Glide/raw/master/Docs/Controllers/nintendo_joyCons.png "Joy-Cons individually connected via Bluetooth")

\* You could notice that GameController framework of Apple, also attempts to support those controllers when they are connected over Bluetooth. However, that works only for a button or two of the controller. Access of GameController fwk to those controllers is therefore prevented for known brands within glide, in order to prevent conflicts.

\** Although the support is intended only for USB controllers, there is an exception made for Joy-Cons when they are connected separately via Bluetooth, as they behave pretty much like USB controllers.

### ⌨️ Keyboard on macOS

Keyboard is supported on macOS in both gameplay and game menus. You can map keyboard keys using predefined key codes to different input profiles, or just use the existing profiles. There is no known unsupported capabilities of keyboard as of now.

### 🖱 Mouse on macOS
Currently there is some basic support for reading mouse position and delta on Mac screens. As glide engine is currently focused on 2d platformer games, and those games are usually not controlled via mouse, support could be expanded via introduction of other game genres to the engine. Feel free to create issues for support requests.

In your game menu buttons made with glide's `NavigatableButton`s, selection with mouse clicks are supported by default.

### 🔲 Touch input on iOS:

On iOS devices, you can add SpriteKit nodes in your game scene and map them to your preferred input profiles. 

There is also a `NavigatableButton` of glide's game menu UI framework which supports touch inputs by default.


> ### Keyboard on iPad / `UIKeyCommand`
Unfortunately iOS SDK, as of iOS 13, is missing some basic functionality of informing framework users with released key events. This is crucial for a game and without it UIKeyCommand support won't be there for glide. Some tried solutions like using js and a `WKWebView` introduces delays and not suitable for professional games. Let's hope that support will be there with upcoming iOS/iPadOS releases.
