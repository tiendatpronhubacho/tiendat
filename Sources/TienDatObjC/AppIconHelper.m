#import "AppIconHelper.h"
// Safe standard-sandbox stubs: no other-app enumeration or launching.
NSDictionary<NSString *, NSDictionary *> *installedAppInfo(void) { return @{}; }
UIImage *iconForBundleID(NSString *bundleID) { (void)bundleID; return nil; }
NSDictionary *appInfoForBundleID(NSString *bundleID) { (void)bundleID; return @{}; }
BOOL openApplicationForBundleID(NSString *bundleID) { (void)bundleID; return NO; }
