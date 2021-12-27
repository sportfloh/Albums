//
//  NetworkImageSource.h
//  Albums
//
//  Created by Florian Bruder on 27.12.21.
//

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkImageSource: NSObject

@end

@interface NetworkImageSource (CreateImageSource)

+ (CGImageSourceRef _Nullable (*_Nonnull)(CFDataRef _Nonnull, CFDictionaryRef _Nullable))createImageSource;

@end

NS_ASSUME_NONNULL_END
