We need to put options of the WA in this "General Options" WA because we want
to share options between multiple WAs.
Options defined in one WA can only be accessed inside it through `aura_env.config`
object.

Custom Grow function in each group shares the same code.
We could basically edit one and copy and paste to others.

## Description in Options

To add a group, first you need to duplicate an existing config group.

1. Each dynamic group must have an corresponding config group.
2. Each dynamic group's name must be "XXX - JWA - CLASS", and its config group's "Group Key" must be "yyy_icon_settings".
3. In each dynamic group's settings, choose "Custom" in "Grow", copy custom grow from the first template group, and paste here.

XXX and yyy must be the same word(s), XXX must capitalize the first letter in each word, and yyy must use lowercase letters and underscores only. Spaces in XXX will be transformed to underscores in yyy.
Example: "General Options" <-> "general_options". The reason is that code infers group name from option name and vice versa.
