# Code Style Guide

If you want to contribute to the plugin by opening a PR then it is helpfull that everyone who works on the plugin follows a predetermined code style. This short guide will give several code examples to help you on your way to create awesome additions to the plugin!

## Examples

### Basic script setup

All the scripts in the plugin follow the following conventions when setting up:
* The node type that gets extended is placed before the class name.
* Class names should have the **MarchingSquares** prefix attached to them.
* Variables/Functions/etc... should use snakecase.
* Private functions should have a '_' in front of their function name.
  * Normal variables do not follow this rule.
* The script_wide variable section and all functions should have 2 whitelines between them.
* Typing for variables should have a space in front of the ':'. 
  * (e.g. "variable_name : float" instead of "variable_name: float")
  * However, typing for functions should follow normal conventions.
* Exported variables should follow the below structure.
* There should be tabs instead of blanks between code parts. The opposite of gdshaders.
  * These tabs should go until the next line's starting tab. 

```
@tool
extends ExampleNode3D
class_name MarchingSquaresExampleClass


enum Enum_Variable {1, 2, 3, 4, 5}

const CONSTANT_VARIABLE : int = 1

var variable : float = 1.0

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_STORAGE) var export_variable : String = "example":
    set(value):
        export_variable = value
        # other code that affects e.g. the terrain shader


func _example_private_function(parameter_variable: int) -> int:
    var mult_val := 5
    return parameter_variable * mult_val


func example_public_function(parameter_variable: float) -> void:
    variable = parameter_variable
```
