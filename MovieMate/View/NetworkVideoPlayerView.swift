//
//  NetworkVideoPlayerView.swift
//  MovieMate
//
//  Created by Deepak Kumar Maurya on 28/08/25.
//

import SwiftUI
import AVKit
import Combine

struct ContentBottomSheet: View {
    let videoURL: URL
    let imageName: String
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Top close button - horizontally centered
                HStack {
                    Spacer()
                    Button(action: {
                        onDismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.8))
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 20)
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    // Video player taking full width
                    NetworkVideoPlayerView(videoURL: videoURL)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(1, contentMode: .fit) // Keeps 1:1 ratio as requested
                    
                    // Image with 16:9 aspect ratio at the bottom
                    AsyncImage(url: URL(string: imageName)) { image in
                        image
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.clear)
                            .aspectRatio(16/9, contentMode: .fit)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // OK button
                    Button(action: {
                        onDismiss()
                    }) {
                        Text("OK")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
            }
        }
    }
}

struct NetworkVideoPlayerView: UIViewRepresentable {
    let videoURL: URL
    
    func makeUIView(context: Context) -> UIView {
        return NetworkPlayerUIView(videoURL: videoURL)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

class NetworkPlayerUIView: UIView {
    private var playerLayer = AVPlayerLayer()
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()
    
    init(videoURL: URL) {
        super.init(frame: .zero)
        setupPlayer(with: videoURL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayer(with url: URL) {
        // Create player item
        playerItem = AVPlayerItem(url: url)
        
        // Create player
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        // Setup looping
        setupLooping()
        
        // Start playing
        player?.play()
    }
    
    private func setupLooping() {
        // Observe when playback reaches end
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        
        // Alternatively using Combine (iOS 13+)
        if #available(iOS 13.0, *) {
            NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
                .sink { [weak self] _ in
                    self?.player?.seek(to: .zero)
                    self?.player?.play()
                }
                .store(in: &cancellables)
        }
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        player?.seek(to: .zero)
        player?.play()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        timeObserver.map(player!.removeTimeObserver)
        player?.pause()
        player = nil
    }
}
