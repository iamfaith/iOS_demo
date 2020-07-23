//
//  PlayerView.swift
//  anime
//
//  Created by faith on 2020/7/23.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI
import AVKit

struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
    func makeUIView(context: Context) -> UIView {
        return PlayerUIView(frame: .zero)
    }
}



class PlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let outputDir = getDocumentsDirectory()
        var url =  URL(string: "\(outputDir)quick2.mp4")! //URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!
        //    debugPrint(p)
        
        guard let path = Bundle.main.path(forResource: "slow", ofType:"MOV") else {
            debugPrint("video.m4v not found")
            return
        }
        //    MobileFFmpeg.execute("-i \(path) -codec copy \(outputDir)/quick2.mp4")
        //MobileFFmpeg.execute("-i \(path) -filter_complex \"[0:v]setpts=2.0*PTS,minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'[v];[0:a]atempo=0.5[a]\" -map \"[v]\" -map \"[a]\" -b:v 3800k -y \(outputDir)quick.MOV")
        
        
        url =  URL(string: "\(outputDir)/quick.MOV")!
        let player = AVPlayer(url: url)
        player.play()
        
        playerLayer.player = player
        layer.addSublayer(playerLayer)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
