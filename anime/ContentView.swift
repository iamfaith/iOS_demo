//
//  ContentView.swift
//  anime
//
//  Created by faith on 2020/6/25.
//  Copyright © 2020 iamfaith. All rights reserved.
//

import SwiftUI

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}


struct ContentView: View {
    
    @State var image: Image? = nil
    @State var videoURL: URL? = nil
    @State var showCaptureImageView: Bool = false
    @State var text: String = "wait for converting"
    @State var showShareVideo: Bool = false
    @State var videos = [Any]()
    static let fileName: String = "quick.mp4"
    let dir = getDocumentsDirectory().appendingPathComponent(fileName)
    
    class FFMPEGLog:NSObject, LogDelegate {
        
        var text: String = ""
        
        func logCallback(_ level: Int32, _ message: String!) {
            DispatchQueue.main.async {
                if (!message.isEmpty) {
                    self.text = message
                    //                    debugPrint("==", self.text)
                }
                
            }
        }
        
    }
    
    let log = FFMPEGLog()
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    init() {
        MobileFFmpegConfig.setLogDelegate(self.log)
    }
    
    
    
    //    let videoProcessingQueue = DispatchQueue(label: "video-processing")
    var body: some View {
        
        ZStack {
            
            VStack(spacing: 30) {
                CPUWheel().frame(height: 150)
                Text(self.text).padding().onReceive(timer) { _ in
                    //                    debugPrint("timer", input)
                    if (!self.log.text.isEmpty) {
                        self.text = self.log.text
                    }
                }
                
                Button(action: {
                    self.showCaptureImageView.toggle()
                }) {
                    Text("Choose videos")
                }
                
                image?.resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                Text("videoURL:\(String(describing: videoURL))").padding()
                
                Button(action: {
                    
                    if (self.videoURL != nil) {
                        //debugPrint("begin")
                        self.text = "Converting!......"
                        DispatchQueue.global(qos: .background).async {
                            //debugPrint("before convert---")
                            let ret = self.convertVideo(source: self.videoURL!)
                            DispatchQueue.main.async {
                                if (ret == RETURN_CODE_SUCCESS) {
                                    self.videos.removeAll()
                                    self.videos.append(self.dir)
                                    self.showShareVideo = true
                                    self.text = "Converted!!Pls Save"
                                } else {
                                    self.text = "Convert failed"
                                }
                                
                                //                                var filesToShare = [Any]()
                                //                                filesToShare.append(dir)
                                //                                let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
                                //                                UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                }) {
                    Text("Slow Motion")
                }
                
                Button(action: {
                    self.videos.removeAll()
                    self.videos.append(self.dir)
                    self.showShareVideo = true
                    
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            if (showCaptureImageView) {
                CaptureImageView(isShown: $showCaptureImageView, image: $image, videoURL: $videoURL)
            }
            
            //            PlayerView()
        }.sheet(isPresented: $showShareVideo) {
            ShareSheet(activityItems: self.videos)
        }
        
    }
    
    func convertVideo(source: URL) -> Int {
        //NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file)
        
        //        let ret = MobileFFmpeg.execute("-i \(source) -codec copy -y \(getDocumentsDirectory())\(ContentView.fileName)")
        
        let ret = MobileFFmpeg.execute("-i \(source) -filter_complex \"[0:v]setpts=2.0*PTS,minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'[v];[0:a]atempo=0.5[a]\" -map \"[v]\" -map \"[a]\" -b:v 3800k -qscale:v 9 -preset veryslow -crf 18 -y -f mp4 \(getDocumentsDirectory())\(ContentView.fileName)")
        
        //        debugPrint("---" +  MobileFFmpegConfig.getLastCommandOutput())
        return Int(ret)
        //        var filesToShare = [Any]()
        //        filesToShare.append(dir!)
        //        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        //        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    
    
}



extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
}


//        let player = AVPlayer(url: URL(fileURLWithPath: path))
//        let playerController = AVPlayerViewController()
//        playerController.player = player
//        present(playerController, animated: true) {
//            player.play()
//        }

//        let appFolder = Bundle.main.resourceURL!
//        let outputDir = getDocumentsDirectory()
//        debugPrint(outputDir)
//        debugPrint(appFolder)
//        //        let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
//        //         debugPrint(galleryPath)
//        do {
//            let fileList = try FileManager.default.contentsOfDirectory(at: outputDir, includingPropertiesForKeys: nil)
//            debugPrint(fileList)
//
//        } catch {
//            print("Error while enumerating files")
//        }

//        guard let path = Bundle.main.path(forResource: "slow", ofType:"MOV") else {
//            debugPrint("video.m4v not found")
//            return Text("fail")
//        }
//        let outputDir = getDocumentsDirectory()
//        MobileFFmpeg.execute("-i \(path) -codec copy \(outputDir)/quick2.mp4")

//        MobileFFmpeg.execute("-i \(path) -filter_complex \"[0:v]setpts=2.0*PTS,minterpolate='mi_mode=mci:mc_mode=aobmc:vsbmc=1:fps=60'[v];[0:a]atempo=0.5[a]\" -map \"[v]\" -map \"[a]\" \(galleryPath)quick.mp4")

//        return ZStack{
//            VideoPlayer(player: AVPlayer(url:  URL(string: "\(outputDir)quick.mp4")!)) {
//                VStack {
//                    Text("Watermark")
//                        .font(.caption)
//                        .foregroundColor(.white)
//                        .background(Color.black.opacity(0.7))
//                        .clipShape(Capsule())
//                    Spacer()
//                }


//        Button(action: wirtieFile) {
//            Image(systemName: "square.and.arrow.up")
//        }


//                    do {
//                        let fileList = try FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)
//                        debugPrint(fileList)
//
//
//                        let text = try String(contentsOf: getDocumentsDirectory().appendingPathComponent("message.txt"), encoding: .utf8)
//                        debugPrint(text)
//                    } catch {
//                        print("Error while enumerating files")
//                    }



//    func wirtieFile() -> Void{
//        guard let path = Bundle.main.path(forResource: "slow", ofType:"MOV") else {
//            debugPrint("video.m4v not found")
//            return
//        }
//        let file = "quick.MOV"
//        let dir = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file)
//
//        //        let contents = "test..."
//        //        do {
//        //            try contents.write(to: dir!, atomically: true, encoding: .utf8)
//        //        } catch {
//        //            print(error.localizedDescription)
//        //        }
//        var filesToShare = [Any]()
//        filesToShare.append(dir!)
//        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
//        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
//    }

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


//                        let group = DispatchGroup()
//                        group.enter()
//                        var dir: URL? = nil
//
//
//                        DispatchQueue.main.async {
//
//                            debugPrint("convertVideo +++")
//                            dir = self.convertVideo(source: self.videoURL!)
//                            group.leave()
//                             debugPrint("convertVideo ---")
//                        }
//
//                        // does not wait. But the code in notify() gets run
//                        // after enter() and leave() calls are balanced
//                        group.notify(queue: .main) {
//                            var filesToShare = [Any]()
//                            filesToShare.append(dir!)
//                            let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
//                            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
//                            self.text = "Converted!!Pls Save"
//
//
//debugPrint("end")
//                        }
//
//                        debugPrint("after")
//                        self.text = "Converting!......"
