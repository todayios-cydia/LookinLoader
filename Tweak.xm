#import <UIKit/UIKit.h>
#include <objc/runtime.h>
#include <dlfcn.h>

%group UIDebug

%hook UIResponder
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 0;
        alertView.title = @"Lookin UIDebug";
        [alertView addButtonWithTitle:@"2D Inspection"];
        [alertView addButtonWithTitle:@"3D Inspection"];
        [alertView addButtonWithTitle:@"Export"];
        [alertView addButtonWithTitle:@"Cancel"];
        [alertView show];
    }
}
%new
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_2D" object:nil];
        } else if (buttonIndex == 1) {
			[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_3D" object:nil];
        }else if (buttonIndex == 2) {
        	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
				
				[[NSNotificationCenter defaultCenter] postNotificationName:@"Lookin_Export" object:nil];
			});
        }
    }
}
%end
%end

%ctor{

	@autoreleasepool {
		NSDictionary *pref = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.todayios-cydia.lookinloader.plist"];
	
		NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
		NSArray *selectedApplications = [pref objectForKey:@"selectedApplications"];

		BOOL appEnabled = [selectedApplications containsObject:bundleIdentifier];
		HBLogDebug(@"LookinLoader selectedApplications:%@ contains %@", selectedApplications, bundleIdentifier);
		if (appEnabled) {
			NSFileManager* fileManager = [NSFileManager defaultManager];
			NSString *libPath = @"/Library/Application Support/LookinLoader/LookinServer.framework/LookinServer";

			if([fileManager fileExistsAtPath:libPath]) {
				void *lib = dlopen([libPath UTF8String], RTLD_NOW);
				if (lib) {
					%init(UIDebug)
					HBLogDebug(@"[+] LookinLoader loaded!");
				}else {
					char* err = dlerror();
					HBLogDebug(@"[+] LookinLoader load failed:%s",err);
				}
			}
		}

	}

}