//
//  TiledMapEditorSceneLoader.swift
//  glide
//
//  Copyright (c) 2019 cocoatoucher user on github.com (https://github.com/cocoatoucher/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import SpriteKit

/// Loader used to parse json map files from Tiled Map Editor (https://github.com/bjorn/tiled)
///
/// Tested Tiled versions:
/// - 1.2.1
/// - 1.2.2
/// - 1.2.3
///
/// How to prepare your Tiled Map Editor map files:
/// - Your map files should be in json format. Tiled Map Editor supports saving as json by default.
/// - Your tile sets used in your map layers should be external tile set files and in json format.
/// Tile sets that are embedded in maps are currently not supported.
/// - Tiles in the tile set used for your collision tile map should have special `Type` values set
/// in the Tiled Map Editor. That is required for your tiles to be recognized as collidable.
/// See `ColliderTile.swift` for more information.
/// - Collision tile map and decoration tile maps which will be provided to your scene are read
/// from your map editor map files.
/// - Map file should contain only one collision tile map layer and it can contain as many decoration
/// tile map layers as needed.
/// - Collision tile map layer should be named `"Ground"`.
/// - All tile layers are positioned at the same center by the scene by default. However, you can
/// customize that behavior in your custom scene files.
/// - If your collidable layer's size is smaller than your decoration layers you can define
/// horizontal and vertical offset values for the collision tile map's position. This is also
/// recommended because when camera is at the edges of your collision tile map, you'll want
/// the space on the edges of screen to be filled with a decoration tile map to not display
/// empty spaces.
/// - horizontalOffset: Amount of tiles that will be cut from left and right sides of the collision
/// tile map. Should be a positive value.
/// - verticalOffset: Amount of tiles that will be cut from top and bottom sides of the collision
/// tile map. Should be a positive value.
public class TiledMapEditorSceneLoader {
    
    /// Loaded tile maps from the map file.
    public private(set) var tileMaps: SceneTileMaps?
    
    // MARK: - Initialize
    
    /// Create a tiled map editor scene loader.
    ///
    /// - Parameters:
    ///     - fileName: json map file created in Tiled Map Editor.
    ///     - bundle: Bundle in which the map file is located.
    ///     - collisionTilesTextureAtlas: Texture atlas to be used to create the tile set of
    /// collision tile map. This is typically loaded from an assets folder of an app.
    ///     - decorationTilesTextureAtlas: Texture atlas to be used to create the tile set of
    /// decoration tile maps. This is typically loaded from an assets folder of an app.
    public init(fileName: String,
                bundle: Bundle,
                collisionTilesTextureAtlas: SKTextureAtlas?,
                decorationTilesTextureAtlas: SKTextureAtlas?) {
        self.bundle = bundle
        self.collisionTilesTextureAtlas = collisionTilesTextureAtlas
        self.decorationTilesTextureAtlas = decorationTilesTextureAtlas
        loadMap(fileName: fileName)
    }
    
    // MARK: - Private
    
    private let collisionTileMapLayerName: String = "Ground"
    private let propertyNameForShouldSkipTileMap: String = "shouldSkip"
    private let propertyNameForHorizontalOffset: String = "horizontalOffset"
    private let propertyNameForVerticalOffset: String = "verticalOffset"
    
    private let bundle: Bundle
    private let collisionTilesTextureAtlas: SKTextureAtlas?
    private let decorationTilesTextureAtlas: SKTextureAtlas?
    
    private var collisionLayerOffsets = TiledPoint(0, 0)
    private var collisionLayerSize = TiledSize(0, 0)
    
    private func loadMap(fileName: String) {
        guard let url = bundle.url(forResource: fileName, withExtension: ".json") else {
            fatalError("Can't load Tiled Map Editor map file \(fileName).json")
        }
        
        do {
            let jsonData = try Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped)
            let decoder = JSONDecoder()
            
            let map = try decoder.decode(Map.self, from: jsonData)
            
            let tileSets = loadTileSets(map.tilesets)
            
            let tileSize = CGSize(width: CGFloat(map.tilewidth), height: CGFloat(map.tileheight))
            let loadedTileMaps = tileMapNodes(from: map, tileSets: tileSets, tileSize: tileSize)
            
            let collisionTileMap = loadedTileMaps.filter { $0.name == collisionTileMapLayerName }.first
            guard let collisionMap = collisionTileMap else {
                fatalError("Collision tile map named \(collisionTileMapLayerName) can't be found in Tiled Map Editor map file.")
            }
            
            let decorationTileMaps = loadedTileMaps.filter { $0.name != collisionTileMapLayerName }.map { $0.node }
            
            tileMaps = SceneTileMaps(collisionTileMap: collisionMap.node, decorationTileMaps: decorationTileMaps)
            
        } catch {
            fatalError("Can't load map within Tiled Map Editor map file \(error)")
        }
    }
    
    /// Create `SKTileMapNode`s from the loaded map with given tile sets.
    private func tileMapNodes(from map: Map, tileSets: [LoadedTileSet], tileSize: CGSize) -> [(name: String, node: SKTileMapNode)] {
        var result: [(String, SKTileMapNode)] = []
        
        for layer in map.layers {
            guard let rawData = layer.data else {
                continue
            }
            
            let properties = layer.properties
            
            let shouldSkipTileMap = (properties?.first { $0.name == propertyNameForShouldSkipTileMap })?.value
            guard shouldSkipTileMap != 1 else {
                if layer.name == collisionTileMapLayerName {
                    fatalError("`shouldSkip` should not be `1` for collision tile map in Tiled Map Editor map file.")
                }
                continue
            }
            
            if
                let horizontalOffset = (properties?.first { $0.name == propertyNameForHorizontalOffset })?.value,
                let verticalOffset = (properties?.first { $0.name == propertyNameForVerticalOffset })?.value,
                horizontalOffset > 0, verticalOffset > 0
            {
                layer.data = clampedData(with: rawData,
                                         offsets: (horizontalOffset, verticalOffset),
                                         mapSize: TiledSize(map.width, map.height))
                let collisionLayerWidth = map.width - horizontalOffset * 2
                let collisionLayerHeight = map.height - verticalOffset * 2
                layer.width = collisionLayerWidth
                layer.height = collisionLayerHeight
                
                if layer.name == collisionTileMapLayerName {
                    collisionLayerOffsets = TiledPoint(horizontalOffset, -verticalOffset)
                    collisionLayerSize = TiledSize(collisionLayerWidth, collisionLayerHeight)
                }
            }
            
            if let tileMap = tileMap(with: layer, tileSets: tileSets, tileSize: tileSize) {
                result.append((layer.name, tileMap))
            }
        }
        
        return result
    }
    
    /// Create `SKTileSet`s from tile set references in the map file.
    private func loadTileSets(_ setReferences: [Map.TileSetReference]) -> [LoadedTileSet] {
        let tileSets: [TileSet] = setReferences.compactMap { loadTileSet(with: $0) }
        
        var result: [LoadedTileSet] = []
        for set in tileSets {
            guard let firstGid = set.firstGid else {
                continue
            }
            
            var nextGid: Int?
            
            for otherSet in tileSets {
                guard let otherFirstGid = otherSet.firstGid else {
                    continue
                }
                guard otherSet.firstGid != firstGid else {
                    continue
                }
                
                if let nextId = nextGid {
                    if nextId < otherFirstGid {
                        nextGid = otherFirstGid
                    }
                } else if firstGid < otherFirstGid {
                    nextGid = otherFirstGid
                }
            }
            
            var tileGroups: [SKTileGroup] = []
            var tileIdToTileGroupIndex: [Int: Int] = [:]
            for i in 0 ..< set.tiles.count {
                let tile = set.tiles[i]
                
                let imageName = URL(fileURLWithPath: tile.image).lastPathComponent
                guard let rawTextureName = imageName.split(separator: ".").first else {
                    continue
                }
                let textureName = String(rawTextureName)
                let textureFromAtlas = collisionTilesTextureAtlas?.textureNamed(textureName) ?? decorationTilesTextureAtlas?.textureNamed(textureName)
                let texture = textureFromAtlas ?? SKTexture(imageNamed: textureName)
                texture.filteringMode = .nearest
                
                let tileDefinition = SKTileDefinition(texture: texture)
                tileDefinition.name = tile.type
                
                tileIdToTileGroupIndex[tile.id] = tileGroups.count
                let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
                tileGroups.append(tileGroup)
            }
            
            let tileSet = SKTileSet(tileGroups: tileGroups)
            
            let loadedTileSet = LoadedTileSet(tileSet: tileSet,
                                              tileIdToTileGroupIndex: tileIdToTileGroupIndex,
                                              range: 0 ..< (nextGid ?? Int.max),
                                              firstGid: firstGid,
                                              source: set.source)
            result.append(loadedTileSet)
        }
        
        return result
    }
    
    /// Load the tile set file for the referenced tile set in the map file.
    private func loadTileSet(with reference: Map.TileSetReference) -> TileSet? {
        let fileName = URL(fileURLWithPath: reference.source).lastPathComponent
        guard let url = bundle.url(forResource: fileName, withExtension: "") else {
            fatalError("Can't load tileset file '\(reference.source)' in Tiled Map Editor map file.")
        }
        
        do {
            let jsonData = try Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped)
            let decoder = JSONDecoder()
            
            var tileSet = try decoder.decode(TileSet.self, from: jsonData)
            tileSet.firstGid = reference.firstgid
            tileSet.source = reference.source
            
            return tileSet
        } catch {
            fatalError("Error while loading tileset file '\(reference.source)' in Tiled Map Editor map file. \(error)")
        }
    }
    
    /// Create `SKTileMapNode` for a given layer with provided tile sets in the map file.
    private func tileMap(with layer: Map.Layer, tileSets: [LoadedTileSet], tileSize: CGSize) -> SKTileMapNode? {
        guard let layerData = layer.data else {
            return nil
        }
        var i: Int = 0
        while i < layerData.count, layerData[i] == 0 {
            i += 1
        }
        if i >= layerData.count {
            return nil
        }
        let firstNonEmptyTileIndex = layerData[i]
        
        var matchingTileSet: LoadedTileSet?
        for tileSet in tileSets {
            let tileIndex = firstNonEmptyTileIndex - tileSet.firstGid
            if case tileSet.range = tileIndex {
                matchingTileSet = tileSet
                break
            }
        }
        guard let tileSet = matchingTileSet else {
            return nil
        }
        
        let mapWidth = layer.width ?? 0
        let mapHeight = layer.height ?? 0
        
        let tileMap = SKTileMapNode(tileSet: tileSet.tileSet,
                                    columns: mapWidth,
                                    rows: mapHeight,
                                    tileSize: tileSize)
        
        populateTileGroups(for: tileMap,
                           layer: layer,
                           tileSet: tileSet)
        
        tileMap.name = layer.name
        
        return tileMap
    }
    
    private func populateTileGroups(for tileMap: SKTileMapNode,
                                    layer: Map.Layer,
                                    tileSet: LoadedTileSet) {
        var currentRow = 0
        var currentColumn = 0
        
        let rows = (layer.data ?? []).chunks(ofSize: layer.width ?? 0)
        
        func switchToNextRowOrNextColumn(currentIndex: Int) {
            if currentIndex == tileMap.numberOfColumns - 1 {
                currentColumn = 0
                currentRow += 1
            } else {
                currentColumn += 1
            }
        }
        
        for row in rows.reversed() {
            for (index, tileId) in row.enumerated() {
                guard tileId > 0 else {
                    switchToNextRowOrNextColumn(currentIndex: index)
                    continue
                }
                
                let mappedTileId = tileId - tileSet.firstGid
                guard let tileGroupIndex = tileSet.tileIdToTileGroupIndex[mappedTileId] else {
                    continue
                }
                let tileGroup = tileSet.tileSet.tileGroups[tileGroupIndex]
                tileMap.setTileGroup(tileGroup, forColumn: currentColumn, row: currentRow)
                
                switchToNextRowOrNextColumn(currentIndex: index)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func clampedData(with data: [Int], offsets: (Int, Int), mapSize: TiledSize) -> [Int] {
        var newData = data
        newData.removeSubrange(0 ..< (offsets.1 * mapSize.width))
        newData.removeSubrange((newData.count - (offsets.1 * mapSize.width)) ..< newData.count)
        
        var result: [Int] = []
        var currentRow = 0
        var currentColumn = 0
        for value in newData {
            if currentColumn >= (offsets.0) && currentColumn < mapSize.width - (offsets.0) {
                result.append(value)
            }
            
            if currentColumn == mapSize.width - 1 {
                currentColumn = 0
                currentRow += 1
            } else {
                currentColumn += 1
            }
        }
        
        return result
    }
}

extension Array {
    fileprivate func chunks(ofSize chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
        }
    }
}
