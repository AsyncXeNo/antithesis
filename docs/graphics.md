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

## Transitions

```lua
{
    -- Default state is the first state provided in the states table
    -- All variables mentioned in condition have to be provided in the variables table
    {
        ["from"] = <str>,
        ["to"] = <str>,
        ["condition"] = {
            <str> -- [[
                (variable operator value)
                ([!]boolean variable)
            ]]
            <str> -- [[
                Seperate using "AND"s and "OR"s
                OR > AND (Precedence)
            ]]
            ...
            <str> -- [[
                (variable operator value)
                ([!]boolean variable)
            ]]
        }
    },
    ...
}
```
