/*
 *  HIDSystem.m
 *  Mouse Acceleration
 *
 *  Created by Peter Hosey on 2010-02-28.
 *  Copyright 2010 Peter Hosey. All rights reserved.
 *
 */

#include "HIDSystem.h"

#import <IOKit/hid/IOHIDKeys.h>
#import <IOKit/hidsystem/IOHIDShared.h>

kern_return_t openConnectionToHIDSystem(io_connect_t *HIDSystem_p) {
	kern_return_t err;
	mach_port_t masterPort = MACH_PORT_NULL;
	err = IOMasterPort(/*bootstrapPort*/ MACH_PORT_NULL, &masterPort);
	if (err == kIOReturnSuccess) {
		CFDictionaryRef classDescription = IOServiceMatching("IOHIDSystem");
		if (classDescription) {
			io_service_t HIDSystemService = IOServiceGetMatchingService(masterPort, classDescription);
			if (HIDSystemService != MACH_PORT_NULL) {
				err = IOServiceOpen(HIDSystemService, mach_task_self(), kIOHIDParamConnectType, &(*HIDSystem_p));
			}
		}
	}
	return err;
}
