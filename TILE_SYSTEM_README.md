# Tile System Documentation

## New Simplified System

The tile system has been simplified to use pre-made 3D scenes instead of complex configurations.

## How It Works

1. **Create a 3D Scene**: Make a new 3D scene with your models arranged as you want
2. **Save as .tscn**: Save the scene in `scenes/tile_scenes/`
3. **Assign to Tile**: Set the `tile_scene` property in your tile to point to your scene

## Creating a Tile Scene

1. Create new 3D Scene in Godot
2. Add your 3D models as children
3. Position, rotate, and scale them as needed
4. Save as `.tscn` file in `scenes/tile_scenes/`

## Example Structure

```
scenes/tile_scenes/
├── cars_collection.tscn     # Collection of cars
├── single_car.tscn          # Just one car
└── tanks_formation.tscn     # Tank formation
```

## Using in Tiles

In your tile scene:
1. Select the tile node
2. In Inspector, find "Model Configuration" group
3. Set "Tile Scene" to your created scene file

## Animation

The entire scene will rotate as one unit - no need to configure individual model animations.

## Benefits

- ✅ Visual scene editor - see exactly how models are positioned
- ✅ No complex configuration files
- ✅ Easy to duplicate and modify
- ✅ Full control over positioning, rotation, scaling
- ✅ Can add lights, effects, or other 3D nodes to scenes
