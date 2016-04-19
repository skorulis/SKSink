//  Created by Alexander Skorulis on 19/04/2016.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

#import "SKPathHelper.h"

@implementation SKPathHelper

+ (NSString*) appDocumentsDirectoryPath {
    NSURL* url = [self applicationDocumentsDirectory];
    return [url.absoluteString substringFromIndex:7];
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
