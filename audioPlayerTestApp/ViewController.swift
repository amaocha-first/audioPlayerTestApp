//
//  ViewController.swift
//  audioPlayerTestApp
//
//  Created by amaocha on 2019/02/07.
//  Copyright © 2019 coco j. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // 音楽コントローラ AVAudioPlayerを定義
    var player:AVAudioPlayer = AVAudioPlayer()
    
    //再生ボタン
    @IBAction func playButtonPressed(_ sender: UIButton) {
        player.play()
    }
    //一時停止ボタン
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        player.pause()
    }
    //停止ボタン
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        player.stop()
        //停止後、AudioPlayerをクリア、再定義
        audioPlayerDif()
    }
    
    //ボリューム
    @IBOutlet weak var volume: UISlider!
    
    @IBAction func volumeController(_ sender: UISlider) {
        player.volume = volume.value
    }
    
    //再生スライドバー
    @IBOutlet weak var playSlider: UISlider!
    
    @IBAction func playSliderController(_ sender: UISlider) {
        //再生する音楽の長さとスライダーの長さを同期させる
        player.currentTime = TimeInterval(playSlider.value)
        
    }
    
    //音楽ファイルの全体の長さを表示するラベル(スライドバーの右側)
    @IBOutlet weak var audioDurationLabel: UILabel!
    //音楽ファイルの現在時間を表示するラベル(スライドバーの左側)
    @IBOutlet weak var audioDurationProgressLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AvAudioPlayer呼び出し
        audioPlayerDif()
        
        //再生スライドバー用のタイマー。１秒ごとにsliderCount()を実行する
        let sliderTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(slideCount(_:)), userInfo: nil, repeats: true)
        //再生時間更新用のタイマー。0.1秒ごとにtimeCount()を実行する
        let durationTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timeCount(_:)), userInfo: nil, repeats: true)
        audioDurationProgressLabel.text = "00:00"
        
    }
    
    // 音楽コントローラ AVAudioPlayerを定義(変数定義、定義実施、クリア）
    func audioPlayerDif(){
        
        // 音声ファイルのパスを定義 ファイル名, 拡張子を定義
        let audioPath = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        //ファイルが存在しない、拡張子が誤っている、などのエラーを防止するために実行テスト(try)する。
        do{
            //再生時間取得のためのaudioFileを用意する
            let audioFile: AVAudioFile = try AVAudioFile(forReading: URL(fileURLWithPath: audioPath))
            //再生時間計算用サンプルレートを取得
            let sampleRate = audioFile.fileFormat.sampleRate
            
            //tryで、ファイルが問題なければ player変数にaudioPathを定義
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath))
            
            let duration: Double = floor(Double(audioFile.length) / sampleRate)
            
            let min: Double = floor(duration / 60)
            let sec: Double = duration - (min * 60)
            audioDurationLabel.text = "\(Int(min)):\(Int(sec))"
            
            //スライダーの最大値と音楽ファイルの長さを同期させる
            playSlider.maximumValue = Float(player.duration)
            
        }catch{
            print("error")
        }
    }
    
    //スライドバーを音楽ファイルの現在時間の位置にする
    @objc func slideCount(_ timer: Timer!) {
        playSlider.value = Float(player.currentTime)
    }
    
    //現在再生時間を計算して表示する
    @objc func timeCount(_ timer: Timer!) {
        let min = floor(player.currentTime / 60)
        let sec = player.currentTime - (min * 60)
        if sec < 10 {
            audioDurationProgressLabel.text = "0\(Int(min)):0\(Int(sec))"
        } else if sec >= 10 && min < 10 {
            audioDurationProgressLabel.text = "0\(Int(min)):\(Int(sec))"
        } else {
            audioDurationProgressLabel.text = "\(Int(min)):\(Int(sec))"
        }
    }
}
