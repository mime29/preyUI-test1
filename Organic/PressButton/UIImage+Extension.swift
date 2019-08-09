//
//  UIImage+Extension.swift
//  Organic
//
//  Created by Mime on 2019/08/05.
//  Copyright © 2019 Mikael. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

// From apple Obj-c example:
// https://developer.apple.com/library/archive/samplecode/UIImageEffects/Introduction/Intro.html#//apple_ref/doc/uid/DTS40013396-Intro-DontLinkElementID_2

extension UIImage {
    func blurred(with radius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat?, maskImage: UIImage? = nil) -> UIImage? {

        // Check pre-conditions.
        guard !(self.size.width < 1 || self.size.height < 1) else {
            print("🧯 error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self)
            return nil
        }
        guard let inputCGImage = self.cgImage else {
            print("🧯 error: self must be backed by a cgImage: %@", self)
            return nil
        }
        guard maskImage == nil || (maskImage != nil && maskImage?.cgImage != nil) else
        {
            print("🧯 error: effectMaskImage must be backed by a cgImage: %@", maskImage as Any)
            return nil
        }

        let hasBlur = radius > CGFloat.ulpOfOne
        let hasSaturationChange = saturationDeltaFactor == nil ? false : abs(saturationDeltaFactor! - 1) > CGFloat.ulpOfOne

        let selfScale = self.scale
        let selfBitmapInfo = inputCGImage.bitmapInfo
        let selfAlphaInfo = CGImageAlphaInfo(rawValue: selfBitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue) //not sure about the code conversion here

        let outputImageSizeInPoints = self.size
        let outputImageRectInPoints = CGRect(origin: .zero, size: outputImageSizeInPoints)

        // Set up output context.
        let useOpaqueContext: Bool
        if selfAlphaInfo == CGImageAlphaInfo.none
            || selfAlphaInfo == CGImageAlphaInfo.noneSkipLast
            || selfAlphaInfo == CGImageAlphaInfo.noneSkipFirst {
            useOpaqueContext = true
        } else {
            useOpaqueContext = false
        }
        UIGraphicsBeginImageContextWithOptions(outputImageRectInPoints.size, useOpaqueContext, selfScale)
        guard let outputContext = UIGraphicsGetCurrentContext() else {
            print("🧯 error: graphic current context is nil, check your code")
            return nil
        }
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -outputImageRectInPoints.size.height)

        if (hasBlur || hasSaturationChange)
        {
            var effectInBuffer = vImage_Buffer()
            var scratchBuffer1 = vImage_Buffer()

            var inputBuffer = vImage_Buffer()
            var outputBuffer = vImage_Buffer()

            var format = vImage_CGImageFormat(bitsPerComponent: 8,
                                              bitsPerPixel: 32,
                                              colorSpace: nil,
                                              bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue |  CGBitmapInfo.byteOrder32Little.rawValue),
                                              version: 0,
                                              decode: nil,
                                              renderingIntent: CGColorRenderingIntent.defaultIntent)

            let error = vImageBuffer_InitWithCGImage(&effectInBuffer, &format, nil, self.cgImage!, vImage_Flags(kvImagePrintDiagnosticsToConsole))
            if (error != kvImageNoError)
            {
                print("🧯 error: vImageBuffer_InitWithCGImage returned error code %zi for self: %@", error, self)
                UIGraphicsEndImageContext()
                return nil
            }

            vImageBuffer_Init(&scratchBuffer1, effectInBuffer.height, effectInBuffer.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
            inputBuffer = effectInBuffer
            outputBuffer = scratchBuffer1

            #if ENABLE_BLUR
            if (hasBlur)
            {
                // A description of how to compute the box kernel width from the Gaussian
                // radius (aka standard deviation) appears in the SVG spec:
                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
                //
                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
                // successive box-blurs build a piece-wise quadratic convolution kernel, which
                // approximates the Gaussian kernel to within roughly 3%.
                //
                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
                //
                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
                //
                let inputRadius = radius * selfScale
                if inputRadius - 2 < CGFloat.ulpOfOne {
                    inputRadius = 2
                }
                let radius = floor((inputRadius * 3 * sqrt(2 * .pi) / 4 + 0.5) / 2) //uint32_t

                radius |= 1 // force radius to be odd so that the three box-blur methodology works.

                let tempBufferSize = vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, NULL, 0, 0, radius, radius, NULL, kvImageGetTempBufferSize | kvImageEdgeExtend) //NSInteger
                var tempBuffer = malloc(tempBufferSize)

                vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(outputBuffer, inputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend)
                vImageBoxConvolve_ARGB8888(inputBuffer, outputBuffer, tempBuffer, 0, 0, radius, radius, NULL, kvImageEdgeExtend)

                free(tempBuffer)

                let temp = inputBuffer
                inputBuffer = outputBuffer
                outputBuffer = temp
            }
            #endif

            #if ENABLE_SATURATION_ADJUSTMENT
            if (hasSaturationChange)
            {
                let s = saturationDeltaFactor
                // These values appear in the W3C Filter Effects spec:
                // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/index.html#grayscaleEquivalent
                //
                let floatingPointSaturationMatrix: [CGFloat] = [
                    0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
                    0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
                    0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
                    0,                    0,                    0,                    1,
                ]
                let divisor = 256 //int32_t
                let matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]) //NSUInteger
                var saturationMatrix = [Int](repeating: 0, count: matrixSize) //[matrixSize]() //int16_t
                for i in 0..<matrixSize {
                    saturationMatrix[i] = round(floatingPointSaturationMatrix[i] * divisor)
                }

                vImageMatrixMultiply_ARGB8888(inputBuffer, outputBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags)

                let temp = inputBuffer
                inputBuffer = outputBuffer
                outputBuffer = temp
            }
            #endif

            let effectCGImage: CGImage

            if let effectCGImageTmp = vImageCreateCGImageFromBuffer(&inputBuffer, &format, { free($1) }, nil, vImage_Flags(kvImageNoAllocate), nil)?.takeUnretainedValue() {
                effectCGImage = effectCGImageTmp
            } else {
                effectCGImage = vImageCreateCGImageFromBuffer(&inputBuffer, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil)!.takeUnretainedValue()
                free(inputBuffer.data)
            }
            if maskImage != nil {
                // Only need to draw the base image if the effect image will be masked.
                outputContext.draw(inputCGImage, in: outputImageRectInPoints)
            }

            // draw effect image
            outputContext.saveGState()
            if let maskCGImage = maskImage?.cgImage {
                outputContext.clip(to: outputImageRectInPoints, mask: maskCGImage)
            }
            outputContext.draw(effectCGImage, in: outputImageRectInPoints)
            outputContext.restoreGState()

            // Cleanup
            free(outputBuffer.data)
        }
        else
        {
            // draw base image
            outputContext.draw(inputCGImage, in: outputImageRectInPoints)
        }

        #if ENABLE_TINT
        // Add in color tint.
        if (tintColor)
        {
            CGContextSaveGState(outputContext)
            CGContextSetFillColorWithColor(outputContext, tintColor.CGColor)
            CGContextFillRect(outputContext, outputImageRectInPoints)
            CGContextRestoreGState(outputContext)
        }
        #endif

        // Output image is ready.
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return outputImage

    }
}
