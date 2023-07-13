# Timeline

## Action

```lua
{
    ["type"] = "move",
    ["args"] = {
        ...,
        ...,
        ...,
        ...
    }
}
```

## Action Types

### Simple Burst Shoot

```lua
{
    ["type"] = "shoot",
    ["args"] = {
        ["type"] = "burst",
        ["bullet_type"] = "simple",
        ["start_angle"] = <type:int>,
        ["end_angle"] = <type:int>,
        ["lines"] = <type:int>,
        ["speed"] = <type:int>,
        ["start_radius"] = <type:int>,
        ["duration"] = <type:int>,
        ["interval"] = <type:int>,
        ["radius"] = <type:int>,
        ["color"] = {<type:int>, <type:int>, <type:int>, <type:int>},
        ["mode"] = <type:str>
    }
}
```

### Fancy Burst Shoot

```lua
{
    ["type"] = "shoot",
    ["args"] = {
        ["type"] = "burst",
        ["bullet_type"] = "fancy",
        ["start_angle"] = <type:int>,
        ["end_angle"] = <type:int>,
        ["lines"] = <type:int>,
        ["speed"] = <type:int>,
        ["start_radius"] = <type:int>,
        ["duration"] = <type:int>,
        ["interval"] = <type:int>,
        ["sprite"] = <type:str>,
        ["anim_speed"] = <type:int> 
    }
}
```
