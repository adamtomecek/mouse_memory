//
//  MouseMemoryAppDelegate.m
//  MouseMemory
//
//  Created by Adam Tomeček on 7/3/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import "MouseMemoryAppDelegate.h"
#import "HIDSystem.h"
#import "Defaults.h"
#include <IOKit/IOKitLib.h>
#include <IOKit/hidsystem/IOHIDLib.h>
#include <IOKit/hidsystem/IOHIDParameter.h>
#include <IOKit/hidsystem/event_status_driver.h>

@implementation MouseMemoryAppDelegate

@synthesize window;
@synthesize about;
@synthesize slider;
@synthesize text;
@synthesize menuProfiles;
@synthesize menuProfilesDelete;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	openConnectionToHIDSystem(&HIDSystem);
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"profiles" ofType:@"plist"];
	profiles = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
	
	[self createMenu];
}

- (void)awakeFromNib{	
	[window setReleasedWhenClosed:NO];
	
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[statusItem setMenu:statusMenu];
	
	[statusItem setImage:[NSImage imageNamed:@"m.png"]];
	[statusItem setAlternateImage:[NSImage imageNamed:@"ma.png"]];
	[statusItem setHighlightMode:YES];
}

- (void)createMenu{	
	NSArray *names = [profiles allKeys];
	int numberOfProfiles = [names count];
	
	if (numberOfProfiles > 0) {
		[menuProfiles removeAllItems];
		[menuProfilesDelete removeAllItems];
		
		for(int i = 0; i < numberOfProfiles; i++){
			NSDictionary *array = [profiles objectForKey:[names objectAtIndex:i]];
			
			NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[array objectForKey:[NSString stringWithFormat:@"name"]] action:@selector(setMouseSpeed:) keyEquivalent:@""];
			
			NSMenuItem *item2 = [[NSMenuItem alloc] initWithTitle:[array objectForKey:[NSString stringWithFormat:@"name"]] action:@selector(deleteProfile:) keyEquivalent:@""];
			
			[menuProfiles insertItem:item atIndex:i];
			[menuProfilesDelete insertItem:item2 atIndex:i];
		}
	}	
}

- (void)testMouseSpeed:(id)sender{
	[self mouseSpeed:[slider floatValue]];
}

- (void)deleteProfile:(id)sender{	
	NSMenuItem *item = (NSMenuItem *)sender;
	
	[profiles removeObjectForKey:[item title]];
	[self createMenu];
}

- (void)setMouseSpeed:(id)sender{	
	NSMenuItem *item = (NSMenuItem *)sender;
	
	NSDictionary *dictionary = [profiles objectForKey:[item title]];
	
	[self mouseSpeed:[[dictionary objectForKey:@"sensitivity"] floatValue]];
}

- (void)mouseSpeed:(float)value{	
	IOHIDSetAccelerationWithKey(HIDSystem, CFSTR(kIOHIDMouseAccelerationType), value);
}

- (void)createProfile:(id)sender{
	[window close];
	
	NSString *name = [text stringValue];
	text.stringValue = @"";
	
	NSDictionary *array = [[NSDictionary alloc] initWithObjectsAndKeys:
						   name,@"name",
						   [NSNumber numberWithFloat:[slider floatValue]], @"sensitivity",
						   nil];
	
	[profiles setValue:array forKey:name];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"profiles" ofType:@"plist"];
	[profiles writeToFile:path atomically:YES];
	
	NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:name action:@selector(setMouseSpeed:) keyEquivalent:@""];
	[menuProfiles addItem:item]; 
}

- (void)openWindow:(id)sender{
	[window orderFrontRegardless];
}

- (void)openAbout:(id)sender{
	[about orderFrontRegardless];
}

- (void)quit:(id)sender{
	[NSApp terminate:sender];
}

- (void)dealloc{
	[slider release];
	[text release];
	[profiles release];
	[menuProfiles release];
	[about release];
	
	[super dealloc];
}

@end
