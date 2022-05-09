# Big Shot Library by vitellary
A yellow soul library for [Kristal](https://github.com/KristalTeam/Kristal), recreating the mode from Deltarune's Spamton NEO fight. This repository contains an example mod too, giving example code for how to use the library.

## How to use

### The Soul
To make a wave or encounter use the yellow soul, you'll want to follow the process detailed at the bottom of the [Enemy Attacks wiki page](https://github.com/KristalTeam/Kristal/wiki/Enemy-Attacks#soul) on the Kristal wiki, creating a `YellowSoul` instance. The constructor for YellowSoul takes the arguments `x`, `y`, and `angle`, with angle defining which way the soul will face for the wave (defaulting to the right).

### Bullets
To make bullets that react to being shot, you'll want to either define `onYellowShot(shot, damage)` for your bullet (see below for how to use it), or extend the [`YellowShotBullet` object](https://github.com/vitellaryjr/BigShotLibrary/blob/main/libraries/YellowSoul/scripts/objects/YellowSoulBullet.lua) provided with the library. The YellowShotBullet object can use, define or override the following functions:

`shot_health`: How much "health" the bullet will have. Normal shots do 1 damage to health, and big shots do 4 damage. Defaults to 1, meaning the bullet will be destroyed in 1 hit.  
`shot_tp`: How much TP the player will get when the bullet is destroyed. Defaults to 1%.  

`onYellowShot(shot, damage)`: Called when the bullet is hit with a shot (either normal or big). `shot` is the [`YellowSoulShot`](https://github.com/vitellaryjr/BigShotLibrary/blob/main/libraries/YellowSoul/scripts/objects/YellowSoulShot.lua) or [`YellowSoulBigShot`](https://github.com/vitellaryjr/BigShotLibrary/blob/main/libraries/YellowSoul/scripts/objects/YellowSoulBigShot.lua) instance that's hitting the bullet, and `damage` is the amount of damage the shot deals. Should return 2 values: the first defining whether normal shots should be destroyed upon collision, and how; and the second defining the same thing for big shots. If a value returned is a boolean, it will determine whether the bullet should remove itself; if a value is a string, it will destroy the bullet, and either play a sprite with the image path specified by the string, or, if the string is simply `a`, `b`, or `c`, it will play the associated animation [provided in the library's assets](https://github.com/vitellaryjr/BigShotLibrary/tree/main/libraries/YellowSoul/assets/sprites/player/shot/hit). By default, this function reduces the bullet's `shot_health` by `damage`, and, if `shot_health` is reduced to 0, calls `destroy()`; it then returns `"a", false`, which will destroy and play an animation for normal bullets, but not destroy large bullets.
`destroy(shot)`: Called by `onYellowShot()` when the bullet's `shot_health` is reduced to 0. `shot` is the `YellowSoulShot` or `YellowSoulBigShot` instance that's hitting the bullet. By default, adds `shot_tp` to the player's TP, and removes the bullet.  

### Configuration
The library contains config values that can be defined by the user to control certain aspects of the code across the mod. These values are:

`allowcheat`: Whether the player is allowed to rapidly fire big shots by holding one confirm button and pressing another. Defaults to true.  

## YellowSoul
The YellowSoul object has a lot of variables and functions that can be used or altered to change its behavior. These are:

`can_use_bigshot`: Whether the soul is allowed to fire big shots. Defaults to true.  
`can_use_shots`: Whether the soul is allowed to fire normal shots. Defaults to true.  
`can_shoot`: Whether the soul is allowed to shoot. Defaults to true.  
`teaching`: If true, big shots will charge slower. Defaults to false.  
`allow_cheat`: Whether the player is allowed to rapidly fire big shots by holding one confirm button and pressing another. Defaults to the config value.  

`getChargeSpeed()`: Returns how fast big shots should charge. By default, returns 1 if `teaching` is true, and 2 otherwise.  
`canUseBigShot()`, `canUseShots()`, `canShoot()`, `canCheat()`, `isTeaching()`: Returns their respective values.  
`fireShot(big)`: Called when the player fires a shot. `big` is a boolean defining whether the shot is a big shot or not. Responsible for creating YellowSoulShot or YellowSoulBigShot objects.
`onCheat()`: Called each time the player fire a big shot without consuming the charge. By default, increases the encounter's `funnycheat` value by 1, which can be checked by other code to perform actions when the player cheats, if desired. Remember that `funnycheat` will be nil until the player cheats.  
