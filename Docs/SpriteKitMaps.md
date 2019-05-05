<p align="center">
    <img src="glide_logo_transparent.png" width="128" max-width="80%" alt="Glide"/>
</p>

# Creating a `GlideScene` from a SpriteKit scene(sks) file:

### 1. Create some tile sets:
- [Use the collider tile set provided by Glide for 16x16 tiles.](Sks/GlideColliderTileSet.sks.zip)
- Create another SpriteKit Tile Set file for decoration tiles.
- Populate the tile sets with your custom tile images from your assets folder.
- You can also create and use a single Tile Set file for both.

### 2. Create a scene file:
- Create a SpriteKit Scene file within your Xcode project.
- Create two tile map nodes under your scene, both positioned at zero.
- Specify their tile size and map size. Tile size should be same for both.
- Name your tile maps as you wish, but you need to name them to reach them back after loading the sks file to populate your `GlideScene`.
- Populate your tile map nodes with the tile sets you created in previous step. Populate one of them as collidable tile map, and the other one as decoration tile map. Feel free to create more than one decoration tile map nodes.

### 3. Create a `GlideScene`

Having your sks map and tile set files included in your Xcode project, use the below snippet to create a `GlideScene`.

```swift
// Load a SKScene with your scene file.
let sks = SKScene(fileNamed: <#T##name of your sks file#>)
guard let collisionTileMap = sks?.childNode(withName: <#T##name of your collision tile map#>) as? SKTileMapNode else {
	fatalError("Couldn't load the collision tile map")
}
var decorationTileMaps: [SKTileMapNode] = []
// Remove nodes from loaded scene to prevent double parent crash.
if let decorationTileMap = sks?.childNode(withName: <#T##name of your decoration tile map#>) as? SKTileMapNode {
	decorationTileMap.removeFromParent()
	decorationTileMaps.append(decorationTileMap)
}
collisionTileMap.removeFromParent()

// Create your scene
let scene = GlideScene(collisionTileMapNode: collisionTileMap, zPositionContainers: <#T##[ZPositionContainer]#>)

/// Add your decoration tile maps in appropriate z position container nodes.
/// e.g. addChild(frontDecorationBackground, in: DemoZPositionContainer.frontDecoration)
/// Alternatively, do this in a custom `GlideScene` subclass.

/// Then present your scene
skView.presentScene(scene)
```
