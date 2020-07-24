//
//  VideoInfo.swift
//  anime
//
//  Created by faith on 2020/7/24.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

struct Description: Codable {
    
    struct Streams: Codable {
        var codec_type: String
        var bit_rate: String
        //        var sample_rate: String
        //        var width : Int
        //        var height: Int
        //        var display_aspect_ratio: String
        
    }
    struct Format: Codable {
        var duration: String
        var size: String
        struct Tags: Codable {
            var creation_time: String
        }
        var tags: Tags
    }
    var streams: [Streams]
    var format: Format
}

extension String {
    var byteSize: String {
        return ByteCountFormatter().string(fromByteCount: Int64(self)!)
    }
}


struct VideoInfo {
    var description: Description?
    var videoURL: URL
    
    func getInfo() -> String{
        if let desc = self.description {
            return "size: " + desc.format.size.byteSize + "\n duration:" + desc.format.duration
        } else {
            return String(describing: videoURL)
        }
        
    }
    
    func calculateFileSize(_ bitRate: Double) -> String{
        var duration = Double(self.description!.format.duration) ?? 1.0
        duration = duration * 2.0
        return String(format:"%.2f", (bitRate + 128) * duration / 1024 / 8) + "MB"
    }
}


class VideoUtil: ObservableObject {
    
    
    public static func getVideoInfo(_ videoURL: URL) -> VideoInfo{
        let ret = MobileFFprobe.execute("-v quiet -print_format json -show_format -show_streams \(videoURL)")
        if (ret == RETURN_CODE_SUCCESS) {
            let resp = MobileFFmpegConfig.getLastCommandOutput()!
            //debugPrint("---", resp)
            
            do {
                let description = try JSONDecoder().decode(Description.self, from: (resp ).data(using: .utf8)!)
                debugPrint("----json", description)
                let videoInfo = VideoInfo(description: description, videoURL: videoURL)
                return videoInfo
            } catch(let e) {
                print(e)
            }
        }
        return VideoInfo(description: nil, videoURL: videoURL)
    }
}





//struct VideoInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoInfo()
//    }
//}


