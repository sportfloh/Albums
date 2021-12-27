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

@implementation NetworkImageSource (CreateImage)

+ (CGImageRef _Nullable (*_Nonnull)(CGImageSourceRef _Nonnull, size_t, CFDictionaryRef _Nullable))createImage {
  return CGImageSourceCreateImageAtIndex;
}

@end
