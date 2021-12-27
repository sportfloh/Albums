//
//  NetworkImageSource.m
//  Albums
//
//  Created by Florian Bruder on 27.12.21.
//

#import "NetworkImageSource.h"

@implementation NetworkImageSource

@end

@implementation NetworkImageSource (CreateImageSource)

+ (CGImageSourceRef _Nullable (*_Nonnull)(CFDataRef _Nonnull, CFDictionaryRef _Nullable))createImageSource {
    return CGImageSourceCreateWithData;
}
@end

