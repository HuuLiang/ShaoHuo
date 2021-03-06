//
//  UIImage+GPrint.m
//  cmallcms
//
//  Created by vicoo on 2017/6/28.
//  Copyright © 2017年 vicoo. All rights reserved.
//

#import "UIImage+GPrint.h"

@implementation UIImage (GPrint)

typedef struct ARGBPixel{
    u_int8_t red;
    u_int8_t green;
    u_int8_t blue;
    u_int8_t alpha;
}ARGBPixel;

- (NSData *)getDataForPrint:(UIImage *)m_image {
    
    NSDictionary* bi = [self getBitmapImageData:m_image];
    const char* bytes = [bi[@"bitmap"] bytes];
    NSMutableData* dd = [[NSMutableData alloc] init];
    //横向点数计算需要除以8
    NSInteger w8 = [bi[@"width"] integerValue] / 8;
    //如果有余数，点数+1
    NSInteger remain8 = [bi[@"width"] integerValue] % 8;
    if (remain8 > 0) {
        w8 = w8 + 1;
    }
    /**
     根据公式计算出 打印指令需要的参数
     指令:十六进制码 1D 76 30 m xL xH yL yH d1...dk
     m为模式，如果是58毫秒打印机，m=1即可
     xL 为宽度/256的余数，由于横向点数计算为像素数/8，因此需要 xL = width/(8*256)
     xH 为宽度/256的整数
     yL 为高度/256的余数
     yH 为高度/256的整数
     **/
    //    NSInteger xL = w8 % 256;
    //    NSInteger xH = [bi[@"width"] integerValue] / (8 * 256);
    //    NSInteger yL = [bi[@"height"] integerValue] % 256;
    //    NSInteger yH = [bi[@"height"] integerValue] / 256;
    //
    //    const char cmd[] = {0x1d,0x76,0x30,0,xL,xH,yL,yH};
    //    [dd appendBytes:cmd length:8];
    
    for (int h = 0; h < [bi[@"height"] intValue]; h++) {
        for (int w = 0; w < w8; w++) {
            u_int8_t n = 0;
            for (int i=0; i<8; i++) {
                int x = i + w * 8;
                u_int8_t ch;
                if (x < [bi[@"width"] intValue]) {
                    int pindex = h * [bi[@"width"] intValue] + x;
                    ch = bytes[pindex];
                }
                else{
                    ch = 0x00;
                }
                ch = !ch;
                n = n << 1;
                n = n | ch;
            }
            [dd appendBytes:&n length:1];
        }
    }
    return dd;

}

- (NSDictionary *)getBitmapImageData:(UIImage *)m_image{
    CGImageRef cgImage = [m_image CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    NSInteger psize = sizeof(ARGBPixel);
    ARGBPixel * pixels = malloc(width * height * psize);
    NSMutableData* data = [[NSMutableData alloc] init];
    [self ManipulateImagePixelDataWithCGImageRef:cgImage imageData:pixels];
    for (int h = 0; h < height; h++) {
        for (int w = 0; w < width; w++) {
            int pIndex = [self PixelIndexWithX:w y:h width:(u_int32_t)width];
            ARGBPixel pixel = pixels[pIndex];
            if ([self PixelBrightnessWithRed:pixel.red green:pixel.green blue:pixel.blue] <= 127) {
                u_int8_t ch = 0x01;
                [data appendBytes:&ch length:1];
            }
            else{
                u_int8_t ch = 0x00;
                [data appendBytes:&ch length:1];
            }
        }
    }
    
    return @{@"bitmap":data,@"width":@(width),@"height":@(height)};
}

-(void)ManipulateImagePixelDataWithCGImageRef:(CGImageRef)inImage imageData:(void*)oimageData
{
    // Create the bitmap context
    CGContextRef cgctx = [self CreateARGBBitmapContextWithCGImageRef:inImage];
    if (cgctx == NULL)
    {
        // error creating context
        return;
    }
    
    // Get image width, height. We'll use the entire image.
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    void *data = CGBitmapContextGetData(cgctx);
    if (data != NULL)
    {
        CGContextRelease(cgctx);
        memcpy(oimageData, data, w * h * sizeof(u_int8_t) * 4);
        free(data);
        return;
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data)
    {
        free(data);
    }
    
    return;
}

-(CGContextRef)CreateARGBBitmapContextWithCGImageRef:(CGImageRef)inImage
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (int)(pixelsWide * 4);
    bitmapByteCount     = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace =CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

-(u_int8_t)PixelBrightnessWithRed:(u_int8_t)red green:(u_int8_t)green blue:(u_int8_t)blue
{
    int level = ((int)red + (int)green + (int)blue)/3;
    return level;
}

-(u_int32_t)PixelIndexWithX:(u_int32_t)x y:(u_int32_t)y width:(u_int32_t)width
{
    return (x + (y * width));
}

-(UIImage*)ScaleImageWithImage:(UIImage*)image width:(NSInteger)width height:(NSInteger)height
{
    CGSize size;
    size.width = width;
    size.height = height;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(NSInteger)GetGreyLevelWithARGBPixel:(ARGBPixel)source intensity:(float)intensity
{
    if (source.alpha == 0)
    {
        return 255;
    }
    //source.red;
    
    int32_t gray = (int)(((source.red + source.green +  source.blue) / 3) * intensity);
    
    if (gray > 255)
        gray = 255;
    
    return (u_int8_t)gray;
}

@end
