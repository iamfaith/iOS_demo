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


struct VideoInfo {
    var description: Description
    var videoURL: URL
}


class VideoUtil: ObservableObject {
    
    
    public static func getVideoInfo(_ videoURL: URL) -> Description?{
        let ret = MobileFFprobe.execute("-v quiet -print_format json -show_format -show_streams \(videoURL)")
        if (ret == RETURN_CODE_SUCCESS) {
            let resp = MobileFFmpegConfig.getLastCommandOutput()!
            
            debugPrint("--resp", resp)
            do {
                let videoInfo = try JSONDecoder().decode(Description.self, from: (resp ).data(using: .utf8)!)
                
                debugPrint("----json", videoInfo)
                return videoInfo
            } catch(let e) {
                print(e)
            }
        }
        return nil
    }
}





//struct VideoInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoInfo()
//    }
//}


