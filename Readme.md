# "dim" utility

Use this to dim your Mac screen when you plug in a monitor.

Connects a callback using [`CGDisplayRegisterReconfigurationCallback`](https://developer.apple.com/documentation/coregraphics/1455336-cgdisplayregisterreconfiguration?language=objc) to dim the built-in screen down to zero when an external monitor is plugged in.

Then, every thirty seconds, the screen is re-dimmed if the monitor is still connected. Not sure why this is necessary, but the screen will go back to normal brightness if this check isn't implemented.

To run the program, open a Terminal and just do this:

```
$ make
...
$ ./dim
```

That's it. Minimize the window and quit it with ctrl + c if you want to shut it off.
