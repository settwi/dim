# "dim" utility

Use this to dim your Mac screen when you plug in a monitor.

Connects a callback using [`CGDisplayRegisterReconfigurationCallback`](https://developer.apple.com/documentation/coregraphics/1455336-cgdisplayregisterreconfiguration?language=objc) to dim the built-in screen down to zero only when an external monitor is plugged in.

Then, every fifteen seconds, the screen is re-dimmed if the monitor is still connected. Not sure why this is necessary, but the screen will go back to normal brightness if this check isn't implemented.

I recommend registering this file as a daemon that starts when you log in. To do this, do the following:

```
$ cd path-to-dim-clone
$ make
$ mkdir -p ~/Library/LaunchAgents
```

Now, open `local.dim.plist` and edit the line underneath the `Program` key to point to the correct executible path. Then,

```
$ cp local.dim.plist ~/Library/LaunchAgents
```

Log out and log back in. The daemon will automatically run in the background.
