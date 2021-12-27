//
//  NetworkImageSource.h
//  Albums
//
//  Created by Florian Bruder on 27.12.21.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

@interface NetworkImageSource: NSObject

@end

@interface NetworkImageSource (CreateImageSource)

+ (CGImageSourceRef _Nullable (*_Nonnull)(CFDataRef _Nonnull, CFDictionaryRef _Nullable))createImageSource;
+ (CGImageSourceRef _Nullable)createImageSourceWithData:(CFDataRef _Nonnull)data options:(CFDictionaryRef _Nullable)options CF_RETURNS_RETAINED;

@end

@interface NetworkImageSource (CreateImage)

+ (CGImageRef _Nullable (*_Nonnull)(CGImageSourceRef _Nonnull, size_t, CFDictionaryRef _Nullable))createImage;
+ (CGImageRef _Nullable)createImageWithImageSource:(CGImageSourceRef _Nonnull)imageSource atIndex:(size_t)index options:(CFDictionaryRef _Nullable)options CF_RETURNS_RETAINED;

@end

