/*
 * dim.m
 * author: william setterberg
 * date: 23 April 2021
 *
 * dims display when external monitor is connected.
 * private API code adapted from `brightness` package, available on Homebrew.
 *
 */

#include <unistd.h>
#include <ApplicationServices/ApplicationServices.h>
#include <Cocoa/Cocoa.h>
#include <Foundation/Foundation.h>
#include <IOKit/graphics/IOGraphicsLib.h>

// this one works for me
extern void CoreDisplay_Display_SetUserBrightness(CGDirectDisplayID id, double brightness) __attribute__((weak_import));
// use this one for Apple Silicon processors (see line 39)
extern int DisplayServicesSetBrightness(CGDirectDisplayID id, float brightness) __attribute__((weak_import));

void setAllBrightness(double);
void displayChangedCallback(CGDirectDisplayID, CGDisplayChangeSummaryFlags, void*);

const int maxDisp = 16;
const unsigned DIM_TIME = 15;

// code adapted from https://github.com/nriley/brightness/blob/master/brightness.c
void setAllBrightness(double bright) {
	CGDirectDisplayID dispAry[maxDisp];
	CGDisplayCount numDisplays;
	CGDisplayErr e = CGGetOnlineDisplayList(maxDisp, dispAry, &numDisplays);
	assert(e == 0);
	if (numDisplays == 1)
		return; // quit if only built-in
	for (int i = 0; i < numDisplays; ++i) {
		// dim them all (only really dims the internal one i believe)
		CoreDisplay_Display_SetUserBrightness(dispAry[i], bright);
	}
}

void displayChangedCallback(CGDirectDisplayID display, CGDisplayChangeSummaryFlags flags, void *userInfo) {
	if (flags & kCGDisplayAddFlag) {
		NSLog(@"Display connected");
		setAllBrightness(0.0);
	}
}

int main(int argc, char* argv[]) {
	@autoreleasepool {
		// set up timer to check if monitor still connected intermittently
		CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(
				kCFAllocatorDefault, 0, DIM_TIME, 0, 0, ^(CFRunLoopTimerRef ref) {
					setAllBrightness(0.0);	
				});

		CGError e = CGDisplayRegisterReconfigurationCallback(&displayChangedCallback, NULL);
		// die if not successful
		assert(e == 0);

		NSApplicationLoad();
		CFRunLoopRef rl = CFRunLoopGetMain();
		CFRunLoopAddTimer(rl, timer, kCFRunLoopCommonModes);
		NSLog(@"Running");
		CFRunLoopRun();
	}
	return 0;
}
