# Shamen
A game about two shamans made in 72 hours during the "GameFest" GameJam Tbilisi
![Shamen](https://i.imgur.com/MGCT25a.gif)


## Download
You can download the game from the [releases](https://github.com/Nikaoto/Shamen/releases) page. 
Right now, only the .exe and .love files have been built.

### Launching the game
To start the game, just unzip and launch it.

If there is no executable file for your OS, simply download [LOVE2D](https://love2d.org/) and 
install it on your computer. You'll then be able to launch `Shamen.love` to play the game.

**You MUST connect at least two joysticks to play the game. The game won't work without them**

## How to play?
**Shamen requires two gamepads to play**
Shamen is a two player action-strategy game about two shamans (shamen if you will) who are taksed
with defeating each other. 

Use the left stick to move your shaman

Use the right stick to move your target around.

Both shamans have four types of totems which can be used with the joystick triggers and bumpers.

### Fire Totem (Right Bumper, R1)
![Shamen - Fire Totem](https://i.imgur.com/eOYhdYH.png)
Constantly fires fireballs in its active radius at the enemy.


### Healing Totem (Right Trigger, R2)
![Shamen - Healing Totem](https://i.imgur.com/Qb2Q702.png)
Standing in its areal constantly heals you.


### Root Totem (Left Trigger, L2)
![Shamen - Root Totem](https://i.imgur.com/uyZZwuE.png)
Roots totems and the enemy player in its areal. Counters the wind totem.


### Wind Totem (Left Bumper, L1)
![Shamen - Wind Totem](https://i.imgur.com/s0oMEti.png)
Knocks everything out of its areal including totems. Wind totems have no effect on rooted entities,
 including the root totem itself.

Each totem stays and applies their efect FOREVER only in their active radius, unless the enemy hits 
it with their totem to destroy it.

* You can stack your totems on top of each other to combo their effects.
* Casting totems drains mana (blue bar in the UI), which slowly regenarates all the time.
* The red bar represents your health.
* When a totem hits you, it breaks, but you take damage. 
* The game works with every type of joystick (generic, ps, xbox...)

## NOTE
I will update the README with more gifs and info soon...

## Credits
Code by me and [gugakatsi](https://github.com/gugakatsi)

Art by [Misho Otiashvili](https://twitter.com/corbyere) and Rati Tsikolia

Sounds by [Nika Inashvili](https://soundcloud.com/sehnmusic)

Music by [@Markymark665](https://twitter.com/Markymark665)


# Using
* [DEEP](https://github.com/Nikaoto/DEEP) - my own love2d library to use the Z axis for the 2.5D 
effect. Although, I had to drastically edit it during the jam, because it was malfunctioning.
* [tween.lua](https://github.com/kikito/tween.lua) - for timers and interpolation
* [Shack](https://github.com/Ulydev/shack) - for screen shakes
* [Classic](https://github.com/rxi/classic/) - for object orientation in lua
