//
//  VideoPlayerView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 04/08/25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let url: URL
    
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .onAppear {
                AVPlayer(url: url).play()
            }
    }
}
#Preview {
    VideoPlayerView(url: URL(string: "https://test-videos.co.uk/vids/bigbuckbunny/mp4/h264/720/Big_Buck_Bunny_720_10s_1MB.mp4")!)
        .frame(height: 300)
}

