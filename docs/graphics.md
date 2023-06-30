# Table Formats

## Spritesheets
```lua
{
    ["path"] = <str>,
    ["size"] = {
        ["x"] = <int>
        ["y"] = <int>
    },
    ["padding"] = {
        ["x"] = <int>
        ["y"] = <int>
    },
    ["frames"] = <int>
}
```

## States
```lua
{
    ["name1"] = {
        ["spritesheet"] = <str>,
        ["fps"] = <int>, 
    },
    ["name2"] = {
        --Entry state
        ["spritesheet"] = <str>,
        ["fps"] = <int>, 
    },
    ...

    constants.ENTRY_STATE = {
        --name2's entry
        ["spritesheet"] = <str>,
        ["fps"] = <int>
    },
}
```