//
//  DiskWriter.h
//  windiskwriter
//
//  Created by Macintosh on 26.01.2023.
//  Copyright © 2023 TechUnRestricted. All rights reserved.
//

#import "FileSystems.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiskWriter: NSObject {
    NSString *_mountedWindowsISO;
    NSString *_destinationDevice;
}

@property(nonatomic) enum FileSystems fileSystem;
@property(nonatomic) bool doNotErase;

- (NSString *)getMountedWindowsISO;
- (NSString *)getDestinationDevice;

+ (NSString *)getWindowsSourceMountPath: (NSString *)isoPath;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithWindowsISO: (NSString *)mountedWindowsISO
                 destinationDevice: (NSString *)destinationDevice;

@end

NS_ASSUME_NONNULL_END
