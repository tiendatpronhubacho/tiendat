#import "MCMBridge.h"
// Safe standard-sandbox stubs: no cross-app container access.
NSArray<NSString *> *MCMEnumerateIdentifiersForClass(uint64_t cls, NSUInteger limit, NSString **error) { (void)cls; (void)limit; if (error) *error = @"Unavailable in standard iOS sandbox"; return @[]; }
NSString *MCMContainerPathForIdentifier(uint64_t cls, NSString *identifier, BOOL group, NSString **error) { (void)cls; (void)identifier; (void)group; if (error) *error = @"Unavailable in standard iOS sandbox"; return nil; }
NSString *MCMActivateContainerPath(uint64_t cls, NSString *identifier, BOOL group, NSString **error) { (void)cls; (void)identifier; (void)group; if (error) *error = @"Unavailable in standard iOS sandbox"; return nil; }
BOOL MCMBridgeAvailable(void) { return NO; }
int64_t MCMActivateContainer(uint64_t cls, NSString *identifier, BOOL group, NSString **error) { (void)cls; (void)identifier; (void)group; if (error) *error = @"Unavailable in standard iOS sandbox"; return -1; }
