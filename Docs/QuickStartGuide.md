<p align="center">
    <img src="https://github.com/cocoatoucher/Glide/raw/master/Docs/glide_logo_transparent.png" width="128" max-width="80%" alt="glide"/>
</p>

# glide quick start guide

## 1. Create some map files and tile sets:
- First step is to create your custom Tiled Map Editor map files to be a base for your game scene. See how [here](https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditorMaps.md). Or unzip and add these [sample ones](https://github.com/cocoatoucher/Glide/raw/master/Docs/TiledMapEditor/GlideColliderTileset.zip) to your Xcode project if you just want to see how it works.
- Alternatively, create some SpriteKit scene files and tile sets to be used within your scene. See how [here](https://github.com/cocoatoucher/Glide/raw/master/Docs/SpriteKitMaps.md).

## 2. Have a view controller with a SKView
- Depending on your target platform, setup a UIViewController or an NSViewController whose view is a SKView, or whose view has a SKView subview.

## 3. Initialize and present a `GlideScene`
- If you chose to use Tiled Map Editor map files, add those files into your Xcode project and use the below snippet to initialize a `GlideScene`

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
- If you chose to use SpriteKit scene files, refer to [this document](https://github.com/cocoatoucher/Glide/raw/master/Docs/SpriteKitMaps.md) to initialize your `GlideScene`, don't worry it's even easier than Tiled Map Editor map files.
- It's recommended to implement a subclass of `GlideScene` and contain your level related logic and entities in there instead of directly initializing a `GlideScene`. However, for the sake of this short tutorial, we are directly instantiating it.

## 4. Add your first playable entity to your scene

With below code snippet, you'll add an entity to your scene that can be controlled horizontally and vertically with player input. It will not be a collidable entity for the sake of simplicity.

```swift
// Initialize your entity in a suitable position of your collidable tile map
let myEntity = GlideEntity(initialNodePosition: TiledPoint(x: 10, y: 10).point(with: scene.tileSize))
        
// Give it a sprite and color it blue
let spriteNodeComponent = SpriteNodeComponent(nodeSize: CGSize(width: 24, height: 24))
// Don't forget to specify a z position for it, if you have a lot of nodes
spriteNodeComponent.zPositionContainer = <#T##ZPositionContainer#>
spriteNodeComponent.spriteNode.color = .blue
myEntity.addComponent(spriteNodeComponent)

// Make it an entity that can move
let kinematicsBodyComponent = KinematicsBodyComponent()
myEntity.addComponent(kinematicsBodyComponent)

// Make it an entity that can move horizontally      
let horizontalMovementComponent = HorizontalMovementComponent(movementStyle: MovementStyle.fixedVelocity)
myEntity.addComponent(horizontalMovementComponent)

// Make it an entity that can move vertically
let verticalMovementComponent = VerticalMovementComponent(movementStyle: MovementStyle.fixedVelocity)
myEntity.addComponent(verticalMovementComponent)

// Make it a collidable entity
let colliderComponent = ColliderComponent(categoryMask: DemoCategoryMask.chestItem,
                                                  size: CGSize(width: 24, height: 24),
                                                  offset: .zero,
                                                  leftHitPointsOffsets: (5, 5),
                                                  rightHitPointsOffsets: (5, 5),
                                                  topHitPointsOffsets: (5, 5),
                                                  bottomHitPointsOffsets: (5, 5))
        myEntity.addComponent(colliderComponent)

// Make it be able to collide with your collidable tile map
let colliderTileHolderComponent = ColliderTileHolderComponent()
myEntity.addComponent(colliderTileHolderComponent)

// Make it playable
// Use w,a,s,d on keyboard, or direction keys on 🎮 to play with it.
let playableCharacterComponent = PlayableCharacterComponent(playerIndex: 0)
myEntity.addComponent(playableCharacterComponent)

// Add it to the scene
scene.addEntity(myEntity)
```
