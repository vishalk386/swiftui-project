//
//  VideoCompression.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 22/05/23.
//

import AVFoundation
import UIKit
/**
public enum VideoQuality {
    case very_high
    case high
    case medium
    case low
    case very_low
}

public enum CompressionResult {
    case onStart
    case onSuccess(Int, URL)
    case onFailure(Int, CompressionError)
    case onCancelled
   
}


// Compression Interruption Wrapper
public class VideoCompression {
    public init() {}
    
    public var cancel = false
}

// Compression Error Messages
public struct CompressionError: LocalizedError {
    public let title: String
    
    init(title: String = "Compression Error") {
        self.title = title
    }
}

@available(iOS 14.0, *)
public struct LightCompressor {
    public struct Video {
        public struct Configuration {
            public let quality: VideoQuality
            public let isMinBitrateCheckEnabled: Bool
            public let videoBitrateInMbps: Int?
            public let disableAudio: Bool
            public let keepOriginalResolution: Bool
            public let videoSize: CGSize?
            
            public init(
                quality: VideoQuality = .medium,
                isMinBitrateCheckEnabled: Bool = false,
                videoBitrateInMbps: Int? = nil,
                disableAudio: Bool = false,
                keepOriginalResolution: Bool = true,
                videoSize: CGSize? = nil
            ) {
                self.quality = quality
                self.isMinBitrateCheckEnabled = isMinBitrateCheckEnabled
                self.videoBitrateInMbps = videoBitrateInMbps
                self.disableAudio = disableAudio
                self.keepOriginalResolution = keepOriginalResolution
                self.videoSize = videoSize
            }
        }
        
        public let source: URL
        public let destination: URL
        public let configuration: Configuration
        public init(
            source: URL,
            destination: URL,
            configuration: Configuration = Configuration()
        ) {
            self.source = source
            self.destination = destination
            self.configuration = configuration
        }
    }
    
    public init() {}
    
    private let MIN_BITRATE = Float(2000000)
    private let MIN_HEIGHT = 640.0
    private let MIN_WIDTH = 360.0
    
    /**
     * This function compresses a given list of [video]  files and writes the compressed video file at
     * [destination]
     *
     * @param [videos] the list of videos  to be compressed. Each video object should have [source], [destination], and an optional [configuration] where:
     * - [source] is the source path of the video
     * - [destination] the path where the output compressed video file should be saved
     * - [configuration] is the custom configuration to control compression parameters for the video to be compressed. The configurations include:
     *      -  [quality] to allow choosing a video quality that can be [.very_low], [.low], [.medium],  [.high], and [very_high]. This defaults to [.medium]
     *      - [isMinBitrateCheckEnabled] to determine if the checking for a minimum bitrate threshold before compression is enabled or not. This default to `true`
     *      - [videoBitrateInMbps] which is a custom bitrate for the video
     *      - [keepOriginalResolution] to keep the original video height and width when compressing. This defaults to `false`
     *      - [VideoSize] which is a custom height and width for the video
     * @param [progressHandler] a compression progress  listener that listens to compression progress status
     * @param [completion] to return completion status that can be [onStart], [onSuccess], [onFailure],
     * and if the compression was [onCancelled]
     */
    
    public func compressVideo(videos: [Video],
                              progressQueue: DispatchQueue = .main,
                              progressHandler: ((Progress) -> ())?,
                              completion: @escaping (CompressionResult) -> ()) -> VideoCompression {
        let compressionOperation = VideoCompression()
        
        guard !videos.isEmpty else {
            return compressionOperation
        }
        
        var frameCount = 0
        
        for (index, video) in videos.enumerated() {
            let source = video.source
            let destination = video.destination
            let configuration = video.configuration
            
            // Compression started
            completion(.onStart)
            
            let videoAsset = AVURLAsset(url: source)
            guard let videoTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else {
                let error = CompressionError(title: "Cannot find video track")
                completion(.onFailure(index, error))
                continue
            }
            
            let bitrate = videoTrack.estimatedDataRate
            // Check for a min video bitrate before compression
            if configuration.isMinBitrateCheckEnabled && bitrate <= MIN_BITRATE {
                let error = CompressionError(title: "The provided bitrate is smaller than what is needed for compression try to set isMinBitRateEnabled to false")
                completion(.onFailure(index, error))
                continue
            }
            
            // Generate a bitrate based on desired quality
            let newBitrate = configuration.videoBitrateInMbps == nil ?
            getBitrate(bitrate: bitrate, quality: configuration.quality) :
            configuration.videoBitrateInMbps! * 1000000
            
            // Handle new width and height values
            let videoSize = videoTrack.naturalSize
            
            let size: (width: Int, height: Int) = configuration.videoSize == nil ?
            generateWidthAndHeight(width: videoSize.width, height: videoSize.height, keepOriginalResolution: configuration.keepOriginalResolution)
            : (Int(configuration.videoSize!.width), Int(configuration.videoSize!.height))
            
            let newWidth = size.width
            let newHeight = size.height
            
            // Total Frames
            let durationInSeconds = videoAsset.duration.seconds
            let frameRate = videoTrack.nominalFrameRate
            let totalFrames = ceil(durationInSeconds * Double(frameRate))
            
            // Progress
            let totalUnits = Int64(totalFrames)
            let progress = Progress(totalUnitCount: totalUnits)
            
            // Setup video writer input
            let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: getVideoWriterSettings(bitrate: newBitrate, width: newWidth, height: newHeight))
            videoWriterInput.expectsMediaDataInRealTime = true
            videoWriterInput.transform = videoTrack.preferredTransform
            
            let videoWriter = try? AVAssetWriter(outputURL: destination, fileType: AVFileType.mov)
            videoWriter?.add(videoWriterInput)
            
            // Setup video reader output
            let videoReaderSettings:[String : AnyObject] = [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) as AnyObject
            ]
            let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings: videoReaderSettings)
            
            var videoReader: AVAssetReader?
            do {
                videoReader = try AVAssetReader(asset: videoAsset)
            } catch {
                let compressionError = CompressionError(title: error.localizedDescription)
                completion(.onFailure(index, compressionError))
                continue
            }
            
            videoReader?.add(videoReaderOutput)
            //setup audio writer
            let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaType.audio, outputSettings: nil)
            audioWriterInput.expectsMediaDataInRealTime = false
            videoWriter?.add(audioWriterInput)
            //setup audio reader
            let audioTrack = videoAsset.tracks(withMediaType: AVMediaType.audio).first
            var audioReader: AVAssetReader?
            var audioReaderOutput: AVAssetReaderTrackOutput?
            if(audioTrack != nil) {
                audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack!, outputSettings: nil)
                audioReader = try? AVAssetReader(asset: videoAsset)
                audioReader?.add(audioReaderOutput!)
            }
            videoWriter?.startWriting()
            
            //start writing from video reader
            videoReader?.startReading()
            videoWriter?.startSession(atSourceTime: CMTime.zero)
            let processingQueue = DispatchQueue(label: "processingQueue1", qos: .background)
            
            var isFirstBuffer = true
            videoWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {() -> Void in
                while videoWriterInput.isReadyForMoreMediaData {
                    
                    // Observe any cancellation
                    if compressionOperation.cancel {
                        videoReader?.cancelReading()
                        videoWriter?.cancelWriting()
                        completion(.onCancelled)
                        return
                    }
                    
                    // Update progress based on number of processed frames
                    frameCount += 1
                    if let handler = progressHandler {
                        progress.completedUnitCount = Int64(frameCount)
                        progressQueue.async { handler(progress) }
                    }
                    
                    let sampleBuffer: CMSampleBuffer? = videoReaderOutput.copyNextSampleBuffer()
                    
                    if videoReader?.status == .reading && sampleBuffer != nil {
                        videoWriterInput.append(sampleBuffer!)
                    } else {
                        videoWriterInput.markAsFinished()
                        if videoReader?.status == .completed {
                            if audioReader != nil && !configuration.disableAudio {
                                if !(audioReader!.status == .reading) || !(audioReader!.status == .completed) {
                                    //start writing from audio reader
                                    audioReader?.startReading()
                                    videoWriter?.startSession(atSourceTime: CMTime.zero)
                                    let processingQueue = DispatchQueue(label: "processingQueue2", qos: .background)
                                    
                                    audioWriterInput.requestMediaDataWhenReady(on: processingQueue, using: {
                                        while audioWriterInput.isReadyForMoreMediaData {
                                            let sampleBuffer: CMSampleBuffer? = audioReaderOutput?.copyNextSampleBuffer()
                                            if audioReader?.status == .reading && sampleBuffer != nil {
                                                if isFirstBuffer {
                                                    let dict = CMTimeCopyAsDictionary(CMTimeMake(value: 1024, timescale: 44100), allocator: kCFAllocatorDefault);
                                                    CMSetAttachment(sampleBuffer as CMAttachmentBearer, key: kCMSampleBufferAttachmentKey_TrimDurationAtStart, value: dict, attachmentMode: kCMAttachmentMode_ShouldNotPropagate);
                                                    isFirstBuffer = false
                                                }
                                                audioWriterInput.append(sampleBuffer!)
                                            } else {
                                                audioWriterInput.markAsFinished()
                                                
                                                videoWriter?.finishWriting {
                                                    completion(.onSuccess(index, destination))
                                                }
                                            }
                                        }
                                    })
                                }
                            } else {
                                videoWriter?.finishWriting {
                                    completion(.onSuccess(index, destination))
                                }
                            }
                        }
                    }
                }
            })
        }
        return compressionOperation
    }

    private func getBitrate(bitrate: Float, quality: VideoQuality) -> Int {
        switch quality {
        case .very_high:
            return Int(bitrate * 0.6)
        case .high:
            return Int(bitrate * 0.4)
        case .medium:
            return Int(bitrate * 0.3)
        case .low:
            return Int(bitrate * 0.2)
        case .very_low:
            return Int(bitrate * 0.1)
        }
    }
    
    private func generateWidthAndHeight(
        width: CGFloat,
        height: CGFloat,
        keepOriginalResolution: Bool
    ) -> (width: Int, height: Int) {
        
        if (keepOriginalResolution) {
            return (Int(width), Int(height))
        }
        
        var newWidth: Int
        var newHeight: Int
        
        if width >= 1920 || height >= 1920 {
            
            newWidth = Int(width * 0.5 / 16) * 16
            newHeight = Int(height * 0.5 / 16 ) * 16
            
        } else if width >= 1280 || height >= 1280 {
            newWidth = Int(width * 0.75 / 16) * 16
            newHeight = Int(height * 0.75 / 16) * 16
        } else if width >= 960 || height >= 960 {
            if(width > height){
                newWidth = Int(MIN_HEIGHT * 0.95 / 16) * 16
                newHeight = Int(MIN_WIDTH * 0.95 / 16) * 16
            } else {
                newWidth = Int(MIN_WIDTH * 0.95 / 16) * 16
                newHeight = Int(MIN_HEIGHT * 0.95 / 16) * 16
            }
        } else {
            newWidth = Int(width * 0.9 / 16) * 16
            newHeight = Int(height * 0.9 / 16) * 16
        }
        
        return (newWidth, newHeight)
    }
    
    private func getVideoWriterSettings(bitrate: Int, width: Int, height: Int) -> [String : AnyObject] {
        
        let videoWriterCompressionSettings = [
            AVVideoAverageBitRateKey : bitrate
        ]
        
        let videoWriterSettings: [String : AnyObject] = [
            AVVideoCodecKey : AVVideoCodecType.h264 as AnyObject,
            AVVideoCompressionPropertiesKey : videoWriterCompressionSettings as AnyObject,
            AVVideoWidthKey : width as AnyObject,
            AVVideoHeightKey : height as AnyObject
        ]
        
        return videoWriterSettings
    }
    
 }



import AVFoundation
import UIKit

public enum VideoQuality {
    case very_high
    case high
    case medium
    case low
    case very_low
}

public enum CompressionResult {
    case onStart
    case onSuccess(Int, URL)
    case onFailure(Int, CompressionError)
    case onCancelled
}

// Compression Interruption Wrapper
public class VideoCompression {
    public init() {}

    public var cancel = false
}

// Compression Error Messages
public struct CompressionError: LocalizedError {
    public let title: String

    init(title: String = "Compression Error") {
        self.title = title
    }
}

@available(iOS 14.0, *)
public struct LightCompressor {
    public struct Video {
        public struct Configuration {
            public let quality: VideoQuality
            public let isMinBitrateCheckEnabled: Bool
            public let videoBitrateInMbps: Int?
            public let disableAudio: Bool
            public let keepOriginalResolution: Bool
            public let videoSize: CGSize?

            public init(
                quality: VideoQuality = .medium,
                isMinBitrateCheckEnabled: Bool = false,
                videoBitrateInMbps: Int? = nil,
                disableAudio: Bool = false,
                keepOriginalResolution: Bool = true,
                videoSize: CGSize? = nil
            ) {
                self.quality = quality
                self.isMinBitrateCheckEnabled = isMinBitrateCheckEnabled
                self.videoBitrateInMbps = videoBitrateInMbps
                self.disableAudio = disableAudio
                self.keepOriginalResolution = keepOriginalResolution
                self.videoSize = videoSize
            }
        }

        public let source: URL
        public let destination: URL
        public let configuration: Configuration

        public init(
            source: URL,
            destination: URL,
            configuration: Configuration = Configuration()
        ) {
            self.source = source
            self.destination = destination
            self.configuration = configuration
        }
    }

    public init() {}

    private let MIN_BITRATE = Float(2000000)
    private let MIN_HEIGHT = 640.0
    private let MIN_WIDTH = 360.0

    public func compressVideo(
        videos: [Video],
        progressHandler: ((Progress) -> Void)?,
        completion: @escaping ((CompressionResult) -> Void)
    ) {
        let videoCompression = VideoCompression()

        DispatchQueue.global(qos: .background).async {
            var compressionResult: CompressionResult?

            for video in videos {
                guard !videoCompression.cancel else {
                    DispatchQueue.main.async {
                        completion(.onCancelled)
                    }
                    return
                }

                let asset = AVURLAsset(url: video.source)

                // Create video asset writer
                guard let videoWriter = try? AVAssetWriter(outputURL: video.destination, fileType: .mp4) else {
                    compressionResult = .onFailure(-1, CompressionError(title: "Could not create video asset writer"))
                    break
                }

                let videoTrack = asset.tracks(withMediaType: .video).first

                // Create video output settings
                let videoSettings: [String: Any] = [
                    AVVideoCodecKey: AVVideoCodecType.h264,
                    AVVideoWidthKey: videoTrack?.naturalSize.width ?? 0,
                    AVVideoHeightKey: videoTrack?.naturalSize.height ?? 0
                ]

                // Create video writer input
                let videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
                videoWriterInput.expectsMediaDataInRealTime = true

                if videoWriter.canAdd(videoWriterInput) {
                    videoWriter.add(videoWriterInput)
                } else {
                    compressionResult = .onFailure(-1, CompressionError(title: "Could not add video writer input"))
                    break
                }

                // Create video source reader
                let videoReaderSettings: [String: Any] = [
                    kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB
                ]

                let videoReaderOutput = AVAssetReaderTrackOutput(track: videoTrack!, outputSettings: videoReaderSettings)
                let videoReader = try? AVAssetReader(asset: asset)

                if videoReader == nil || !videoReader!.canAdd(videoReaderOutput) {
                    compressionResult = .onFailure(-1, CompressionError(title: "Could not create video asset reader"))
                    break
                }

                videoReader!.add(videoReaderOutput)

                // Create audio output if not disabled
                var audioWriterInput: AVAssetWriterInput?
                var audioReaderOutput: AVAssetReaderOutput?

                if !video.configuration.disableAudio {
                    let audioTracks = asset.tracks(withMediaType: .audio)

                    if audioTracks.count > 0 {
                        let audioTrack = audioTracks[0]

                        // Create audio format description
                        guard let formatDescriptions = audioTrack.formatDescriptions as? [CMAudioFormatDescription], let formatDescription = formatDescriptions.first else {
                            compressionResult = .onFailure(-1, CompressionError(title: "Could not get audio format description"))
                            break
                        }

                        let audioFormat = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription)?.pointee

                        // Create audio output settings
                        let audioSettings: [String: Any] = [
                            AVFormatIDKey: kAudioFormatMPEG4AAC,
                            AVNumberOfChannelsKey: audioFormat?.mChannelsPerFrame ?? 0,
                            AVSampleRateKey: audioFormat?.mSampleRate ?? 0,
                            AVEncoderBitRateKey: 128000
                        ]

                        // Create audio writer input
                        audioWriterInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
                        audioWriterInput!.expectsMediaDataInRealTime = true

                        if videoWriter.canAdd(audioWriterInput!) {
                            videoWriter.add(audioWriterInput!)
                        } else {
                            compressionResult = .onFailure(-1, CompressionError(title: "Could not add audio writer input"))
                            break
                        }

                        // Create audio source reader
                        audioReaderOutput = AVAssetReaderTrackOutput(track: audioTrack, outputSettings: nil)

                        if !videoReader!.canAdd(audioReaderOutput!) {
                            compressionResult = .onFailure(-1, CompressionError(title: "Could not add audio reader output"))
                            break
                        }

                        videoReader!.add(audioReaderOutput!)
                    }
                }


                // Start compression
                videoWriter.startWriting()
                videoReader!.startReading()
                videoWriter.startSession(atSourceTime: .zero)

                let processingQueue = DispatchQueue(label: "processingQueue")

                // Process video frames
                videoWriterInput.requestMediaDataWhenReady(on: processingQueue) {
                    while videoWriterInput.isReadyForMoreMediaData {
                        if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer() {
                            videoWriterInput.append(sampleBuffer)
                        } else {
                            videoWriterInput.markAsFinished()

                            if video.configuration.disableAudio || audioWriterInput == nil {
                                videoWriter.finishWriting(completionHandler: {
                                    completion(compressionResult ?? .onSuccess(0, video.destination))
                                })
                            }

                            break
                        }
                    }
                }

                // Process audio frames
                if !video.configuration.disableAudio, let audioWriterInput = audioWriterInput, let audioReaderOutput = audioReaderOutput {
                    audioWriterInput.requestMediaDataWhenReady(on: processingQueue) {
                        while audioWriterInput.isReadyForMoreMediaData {
                            if let sampleBuffer = audioReaderOutput.copyNextSampleBuffer() {
                                audioWriterInput.append(sampleBuffer)
                            } else {
                                audioWriterInput.markAsFinished()

                                videoWriter.finishWriting(completionHandler: {
                                    completion(compressionResult ?? .onSuccess(0, video.destination))
                                })

                                break
                            }
                        }
                    }
                }

                videoWriter.finishWriting {
                    DispatchQueue.main.async {
                        completion(compressionResult ?? .onSuccess(0, video.destination))
                    }
                }
            }
        }

        completion(.onStart)
    }

    /**
     * Function to compress video without completion and progress handlers
     *
     * @param [videos] the list of videos to be compressed
     */
    public func compressVideo(videos: [Video]) {
        compressVideo(videos: videos, progressHandler: nil, completion: { _ in })
    }

    /**
     * Function to cancel video compression
     *
     * @param [videoCompression] the VideoCompression instance to be cancelled
     */
    public func cancelCompression(videoCompression: VideoCompression) {
        videoCompression.cancel = true
    }
 }*/
import AVFoundation
import UIKit

public enum VideoQuality {
    case veryHigh
    case high
    case medium
    case low
    case veryLow
}

public enum CompressionResult {
    case onStart
    case onSuccess(URL)
    case onFailure(CompressionError)
    case onCancelled
}

public class VideoCompression {
    private var compressionSession: AVAssetExportSession?
    public var cancel = false
    
    public init() {}
    
    public func compressVideo(
        video: URL,
        outputURL: URL,
        quality: VideoQuality = .veryLow,
        completion: @escaping (CompressionResult) -> Void
    ) {
        cancel = false
        
        let sourceAsset = AVURLAsset(url: video)
        
        guard let exportSession = AVAssetExportSession(asset: sourceAsset, presetName: AVAssetExportPresetPassthrough) else {
            completion(.onFailure(CompressionError(title: "Could not create AVAssetExportSession")))
            return
        }
        
        let supportedVideoQualities: [VideoQuality: String] = [
            .veryHigh: AVAssetExportPresetHighestQuality,
            .high: AVAssetExportPresetMediumQuality,
            .medium: AVAssetExportPreset640x480,
            .low: AVAssetExportPresetLowQuality,
            .veryLow: AVAssetExportPresetLowQuality
        ]
        
        guard let presetName = supportedVideoQualities[quality],
              let exportSession = AVAssetExportSession(asset: sourceAsset, presetName: presetName) else {
            completion(.onFailure(CompressionError(title: "Could not create AVAssetExportSession")))
            return
        }

       
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.canPerformMultiplePassesOverSourceMediaData = true
        exportSession.videoComposition = videoComposition(for: sourceAsset)
        exportSession.audioMix = audioMix(for: sourceAsset)
        exportSession.timeRange = CMTimeRange(start: CMTime.zero, duration: sourceAsset.duration)
        compressionSession = exportSession
        
        exportSession.exportAsynchronously {
            if exportSession.status == .completed {
                completion(.onSuccess(outputURL))
            } else if exportSession.status == .cancelled {
                completion(.onCancelled)
            } else {
                let error = exportSession.error ?? CompressionError(title: "Video compression failed")
                completion(.onFailure(error as! CompressionError ))
            }
        }
    }
    
    public func cancelCompression() {
        compressionSession?.cancelExport()
        cancel = true
    }
    
    private func videoComposition(for asset: AVAsset) -> AVMutableVideoComposition? {
        let videoComposition = AVMutableVideoComposition()
        let videoTrack = asset.tracks(withMediaType: .video).first
        
        videoComposition.renderSize = videoTrack?.naturalSize ?? CGSize.zero
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: CMTime.zero, duration: asset.duration)
        instruction.layerInstructions = [videoLayerInstruction(for: videoTrack)]
        
        videoComposition.instructions = [instruction]
        
        return videoComposition
    }
    
    private func videoLayerInstruction(for track: AVAssetTrack?) -> AVMutableVideoCompositionLayerInstruction {
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track!)
        let transform = videoTransformOrientation(track)
        
        layerInstruction.setTransform(transform, at: CMTime.zero)
        
        return layerInstruction
    }
    
    private func videoTransformOrientation(_ track: AVAssetTrack?) -> CGAffineTransform {
        guard let assetTrack = track else {
            return CGAffineTransform.identity
        }
        
        let transform = assetTrack.preferredTransform
        
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            return CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            return CGAffineTransform(rotationAngle: -CGFloat.pi / 2.0)
        } else {
            return transform
        }
    }
    
    private func audioMix(for asset: AVAsset) -> AVMutableAudioMix? {
        guard let audioTrack = asset.tracks(withMediaType: .audio).first else {
            return nil
        }
        
        let audioMix = AVMutableAudioMix()
        let audioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
        audioMixInputParameters.setVolume(1.0, at: CMTime.zero)
        audioMix.inputParameters = [audioMixInputParameters]
        
        return audioMix
    }
}

public struct CompressionError: LocalizedError {
    public let title: String
    
    public init(title: String = "Compression Error") {
        self.title = title
    }
}
