//
//  MouseMemoryAppDelegate.h
//  MouseMemory
//
//  Created by Adam Tomeček on 7/3/11.
//  Copyright 2011 OwnSoft. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MouseMemoryAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	NSWindow *about;
	
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	
	IBOutlet NSSlider *slider;
	IBOutlet NSTextField *text;
	IBOutlet NSMenu *menuProfiles;
	IBOutlet NSMenu *menuProfilesDelete;
	
	NSMutableDictionary *profiles;
	
	io_connect_t HIDSystem;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSWindow *about;
@property (nonatomic, retain) IBOutlet NSSlider *slider;
@property (nonatomic, retain) IBOutlet NSTextField *text;
@property (nonatomic, retain) IBOutlet NSMenu *menuProfiles;
@property (nonatomic, retain) IBOutlet NSMenu *menuProfilesDelete;

- (IBAction)createProfile:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)openWindow:(id)sender;
- (IBAction)openAbout:(id)sender;
- (IBAction)testMouseSpeed:(id)sender;

- (void)mouseSpeed:(float)value;

@end
