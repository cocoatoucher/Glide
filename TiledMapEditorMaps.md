<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/glide_logo_transparent.png" width="128" max-width="80%" alt="glide"/>
</p>

# Creating a `GlideScene` from a Tiled Map Editor map file:

### 1. Create a map in Tiled Map Editor:
- Download [Tiled Map Editor](https://www.mapeditor.org). Tested and working versions are `1.2.1`, `1.2.2` and `1.2.3`.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/1.1.newMap.png" width="200" max-width="80%"/>
</p>
- Create a new map file with your desired setup. Map orientation should be `Orthogonal`.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/1.2.mapJson.png" width="200" max-width="80%"/>
</p>
- Make sure to save your new map file as a json file in the next step.
- Place the map file in your Xcode project.

### 2. Create a collidable layer in your Tiled map:

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/collidableLayer.png" width="200" max-width="80%"/>
</p>
- Download [Glide collider tile set](https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/GlideColliderTileset.zip) that is created for you and unzip it. This tile set is created with 16x16 tiles and can be used with 16x16 tile maps. To see how to create a new tile set from scratch see below section for decoration layer.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/2.1.dragColliderTileset.png" width="200" max-width="80%"/>
</p>
- Drag `GlideColliderTileSet.json` onto the `Tilesets` pane in Tiled Map Editor.

- Now that you have your collidable tiles defined, you can start painting with them, but you need a `Ground` layer to paint on.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/2.2.createTileLayer.png" width="200" max-width="80%"/>
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/2.3.newGroundLayer.png" width="200" max-width="80%"/>
</p>
- Create a new layer under the `Layers` pane of Tiled Map Editor and name it `Ground`. Note that glide supports one tile layer called `Ground` per map.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/2.4.paintTiles.png" width="200" max-width="80%"/>
</p>
- Start painting with your collider tiles. Here is what `Type` field means for each collider tile:

 - `ground`: regular ground collider.
 
 - `one_way`: one way ground collider. Note that, this kind of tile is not intended to be stacked up vertically and can be used as horizontal platforms in 1 tile height.

 - `jump_wall_right`: jump walls facing left.

 - `jump_wall_left`: jump walls facing right.

 - `slope_0_3`, `slope_4_7`, `slope_8_11`, `slope_12_15`: slope with a proportional angle of 1:4 climbing down to the right.

 - `slope_15_12`, `slope_11_8`, `slope_7_4`, `slope_3_0`: slope with a proportional angle of 1:4 climbing up to the right.

 - `slope_0_7`, `slope_8_15`: slope with a proportional angle of 1:2 climbing down to the right.

 - `slope_15_8`, `slope_7_0`: slope with a proportional angle of 1:2 climbing up to the right.

 - `slope_0_15`: slope with a proportional angle of 1 climbing down to the right.

 - `slope_15_0`: slope with a proportional angle of 1 climbing up to the right.

- Collidable layer in your map is for collision handling purposes and not meant to be visible. However, you can see your collidable layer in debug mode. See `GlideScene` for more details.

### 3. Create some decoration layers in your map file:

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/decorationLayer.png" width="200" max-width="80%"/>
</p>
- Decoration layers are the layers that meant to make your maps visible and meaningful. Those are the layers that will be visible to your players in the end.

- You need to create a custom tileset in Tiled Map Editor in order to create and paint a decoration layer.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.1.newTileset.png" width="200" max-width="80%"/>
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.2.newTileset.png" width="200" max-width="80%"/>
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.3.newTileset.png" width="200" max-width="80%"/>
</p>
- Create a new tile set from `Tilesets` pane of Tiled Map Editor. Make sure to not select `Embed in map` option, as this is not currently supported by glide. Save this tile set as a json file in your Xcode project directory.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.4.editTileSet.png" width="200" max-width="80%"/>
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.5.populate_tileset.png" width="200" max-width="80%"/>
</p>
- Start editing your new tile set via the `Tileset` pane and drag your custom tile images. Decoration layer tile images should be in same dimensions as collider tiles. Those images should typically be dragged from your Xcode project's assets folder. Just keep in mind that, it is not easy to update the file references when changing the location of your tile set file, so decide the final location of your tile set file before connecting your custom tile images with it.

- Now that you have a decoration tile set created and defined you can start painting a decoration layer in your map.

- Create a new `Tile Layer` under the `Layers` pane of Tiled Map Editor and name it anything you want.

- Start painting your new layer with the tiles in your decoration tile set.

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.6.shouldSkip.png" width="200" max-width="80%"/>
</p>
- Create as many decoration layers as you want to make your levels beautiful.

- By default, all the layers in your map that are not named `Ground` will be added to your `GlideScene` instance. To prevent a layer from showing up in your scene, set a custom `shouldSkip`(int) field as `1` in `Properties` pane for this layer in Tiled Map Editor.

- By default, all tile layers in your map are positioned at the same center by the scene by default. However, you can customize that behavior in your `GlideScene` subclasses.

#### Collidable layer offsets

<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/Screenshots/3.7.collidableLayerOffsets.png" width="200" max-width="80%"/>
</p>
- If your collidable layer's size is smaller than your decoration layers you can define horizontal and vertical offset values for the collision tile map's position. This is also recommended because when camera is at the edges of your collision tile map, you'll want the space on the edges of screen to be filled with a decoration tile map to not display empty spaces. This is an optimization towards not having to have a huge collidable layer with a lot of unused tiles.

 - horizontalOffset(int): Amount of tiles that will be cut from left and right sides of the collision tile map. Should be a positive value.

 - verticalOffset(int): Amount of tiles that will be cut from top and bottom sides of the collision tile map. Should be a positive value.


### 4. Create a `GlideScene`

Having your tile set and tile map json files included in your Xcode project, use the below snippet to create a `GlideScene`.

```swift
// Create a loader with your json file
let loader = TiledMapEditorSceneLoader(fileName: <#T##json map file name#>,
                                       bundle: Bundle.main,
                                       collisionTilesTextureAtlas: <#T##collisionTilesAtlas#>,
									   decorationTilesTextureAtlas: <#T##decorationTilesAtlas#>)
guard let sceneTileMaps = loader.tileMaps else {
	fatalError("Couldn't load the level file")
}

// Create your scene
let scene = GlideScene(collisionTileMapNode: sceneTileMaps.collisionTileMap, zPositionContainers: <#T##[ZPositionContainer]#>)
/// Add your decoration tile maps in appropriate z position container nodes.
/// e.g. addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
/// Alternatively, do this in a custom `GlideScene` subclass.

/// Then present your scene
skView.presentScene(scene)
```
