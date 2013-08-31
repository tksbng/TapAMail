//
//  ViewController.h
//  TapAMail
//
//  Created by Takeshi Bingo on 2013/08/31.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>
// １ゲームの時間（秒）
#define kTimeOneGame 20.0f
// 時計用タイマーの間隔
#define kTimerClockInterval 0.1f
//画面に並べるヘルメットの横の個数
#define kXCount 4
//画面に並べるヘルメットの縦の個数
#define kYCount 6
//もぐら用タイマーの間隔
#define kTimerMoleInterval 0.5f
//一体のもぐらに対する制限時間
#define kTimeup (0.5f/kTimerMoleInterval)
//もぐらの発生率(%)
#define kIncidence 50

@interface ViewController : UIViewController
{
    // スタートボタンをのせるためのView
    UIView *startButtonView;
    
        //　　時計用タイマー
    
    NSTimer *aTimerClock;
        //　　時計の盤面
        UIImageView *clock_face;
        //　　時計の針
        UIImageView *clock_hand;
        //　　ゲームをスタートする時間
        NSTimeInterval startTimeInterval;
    //もぐら画像
    UIImageView *moleImageView;
    //もぐら用のタイマー
    NSTimer *aTimerMole;
    //出現させる対象のもぐらのtag
    NSInteger tagTarget;
    //もぐら用の制限時間
    NSInteger countTimeup;
    //スコア用
    NSInteger scoreValue;
    //スコア表示用ラベル
    UILabel *scoreLabel;
    
}


@end
