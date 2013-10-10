//
//  ViewController.m
//  TapAMail
//
//  Created by Takeshi Bingo on 2013/08/31.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

// 画面を構成するコントロール等のパーツを作成する。
- (void)setupParts {
    // ■ ヘルメットの作成
    //縦、横、トップのマージンを設定
    CGFloat edgeX = 10.0f;
    CGFloat edgeY = 10.0f;
    CGFloat edgeTop = 50.0f;
    //ヘルメットを配置する座標計算用（横）
    CGFloat dx = (320.0f-edgeX*2)/(kXCount*2);
    CGFloat dy = (480.0f-edgeY*2-edgeTop)/(kYCount*2);
    //縦の個数分for文を繰り返す
    for (int y = 0; y < kYCount; y++) {
        //横の個数分for文を繰り返す
        for (int x = 0; x < kXCount; x++) {
            //ヘルメットに付けるtagを作成
            NSInteger tag = y*kXCount+x+1;
            //ヘルメット用のImageViewを作成する
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mole_a1.png"]];
            //オブジェクトにタッチを有効にする指定
            [imgView setUserInteractionEnabled:YES];
            //ImageViewにtagを設定
            [imgView setTag:tag];
            //配置する座標を指定
            CGPoint pos = CGPointMake(edgeX+(x*2+1)*dx,edgeTop+edgeY+(y*2+1)*dy);
            //画像の中心点を指定座標へセット
            [imgView setCenter:pos];
            //Viewに配置する
            [[self view] addSubview:imgView];
        }
    }
    // ■ もぐらの作成
    //もぐらを表示させるImageViewを作成する
    moleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mole_c3.png"]];
    //もぐら用にtagを設定する
    [moleImageView setTag:100];
    //もぐらにHitした時のImageViewを作成する
    [moleImageView setHighlightedImage:
     [UIImage imageNamed:@"mole_d2.png"]];
    //初期状態ではもぐらに対するタップを無効にしておく
    [moleImageView setUserInteractionEnabled:NO];
    //もぐら画像も初期状態では非表示にする
    [moleImageView setAlpha:0.0f];
    //Viewに配置する
    [[self view] addSubview:moleImageView];
    // ■ 時計パーツの作成
    //文字盤面の画像を読み込む
    clock_face = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_face.png"]];
    //時計盤面画像の中心点を配置する座標を指定する
    [clock_face setCenter:CGPointMake(30.0f, 30.0f)];
    //画像を設置する
    [[self view] addSubview:clock_face];
    //針の画像を読み込む
    clock_hand = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock_hand.png"]];
    //針画像の中心点を配置する座標を指定する
    [clock_hand setCenter:CGPointMake(30.0f, 30.0f)];
    //画像を設置する
    [[self view] addSubview:clock_hand];
    
    // ■ Scoreラベルの作成
    //ラベルのサイズと表示座標を指定
    scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 20.0f, 320.0f, 40.0f)];
    //テキストを中央揃えで表示
    [scoreLabel setTextAlignment: NSTextAlignmentCenter];
    //テキストの色を指定
    [scoreLabel setTextColor:[UIColor greenColor]];
    //ラベルの背景色を指定
    [scoreLabel setBackgroundColor:[UIColor clearColor]];
    //フォントサイズを指定
    [scoreLabel setFont:[UIFont systemFontOfSize:32.0f]];
    //表示させる
    [[self view] addSubview:scoreLabel];

    
    // ■ スタートボタンを載せたViewの作成
    
    // スタートボタンをのせるためのViewを表示させる位置を指定
    startButtonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 200.0f, 320.0f, 100.0f)];
    
    // スタートボタンをのせるためのViewの色と透明度を指定
    [startButtonView setBackgroundColor:[UIColor colorWithWhite: 1.0f alpha:0.5f]];
    // スタートボタンの種類を指定
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // スタートボタンの配置場所とサイズを指定
    [startButton setFrame:CGRectMake(130.0f, 30.0f, 60.0f,40.0f)];
    
    // スタートボタンに表示させる文字列を指定
    [startButton setTitle:@"Start" forState: UIControlStateNormal];
    
    // スタートボタンが押されたときに呼び出されるメソッドと、イベントを キャッチする挙動を指定
    [startButton addTarget:self action:@selector(doStart:)forControlEvents:UIControlEventTouchUpInside];
    
    // スタートボタンをViewに追加する
    [startButtonView addSubview:startButton];
    
    // スタートボタンをのせたViewを配置する
    [[self view] addSubview:startButtonView];
    
}
//ゲームをストップさせるメソッド
-(void)doStop {
    //スタートボタンビューを表示する
    [startButtonView setHidden:NO];
    //タイマーの停止
    [self stopTimer];
}
//ゲームをスタートさせるメソッド
-(void)doStart:(id)sender {
    // スタートボタンを載せたViewを隠す
    [startButtonView setHidden:YES];
    //　　ゲームスタート時間をマーク
    startTimeInterval = [NSDate timeIntervalSinceReferenceDate];
    //スコア0を表示
    scoreValue = 0;
    [self calcScore:0];
    //　　タイマーのスタート
    [self startTimer];
}
//タイマーメソッド
- (void)tick_Clock:(NSTimer *)theTimer {
    //現在の時間を取得する
    NSTimeInterval curTimeInterval =
    [NSDate timeIntervalSinceReferenceDate];
    //経過時間を取得する
    NSTimeInterval pastTime = (curTimeInterval - startTimeInterval);
    //針を回転させる角度を取得する
    //M_PIは円周率の定数
    CGFloat angle = pastTime * (M_PI*2) / kTimeOneGame;
    //計算した角度に合わせて針を回転させる準備
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(angle);
    //針を回転させる
    [clock_hand setTransform:transform];
    //もし、経過時間が制限時間より大きかったら
    if ( pastTime > kTimeOneGame ){
        //ゲームをストップさせるメソッドを呼ぶ
        [self doStop];
    }
}
//タイマーをストップするメソッド
-(void)stopTimer {
    //もし、タイマーに何か入っているとき
    if ( aTimerClock != nil ) {
        //タイマーを無効にする
        [aTimerClock invalidate];
        //タイマーを空にする
        aTimerClock = nil;
        //もぐら用タイマーの停止処理
        if ( aTimerMole != nil ) {
            [aTimerMole invalidate];
            aTimerMole = nil;
        }
    }
}
//タイマーをスタートさせるメソッド
-(void)startTimer {
    //もしタイマーが存在するとき
    if ( aTimerClock  || aTimerMole ){
        //タイマーを停止するメソッドを呼ぶ
        [self stopTimer];
    }
    //タイマーを作成する
    aTimerClock = [NSTimer
                   scheduledTimerWithTimeInterval:kTimerClockInterval
                   target:self selector:@selector(tick_Clock:)
                   userInfo:nil repeats:YES];
    aTimerMole = [NSTimer scheduledTimerWithTimeInterval:kTimerMoleInterval
                                                  target:self selector:@selector(tick_Mole:)
                                                userInfo:nil repeats:YES];

}
//もぐら用タイマー
- (void)tick_Mole:(NSTimer *)theTimer {
    //もぐらのタイムアップ処理
    //もし、対象となるもぐらのtagが0で無い時
    if (tagTarget != 0 ) {
        //もし、もぐら用の制限時間が0以上の時
        if (countTimeup > 0) {
            //制限時間から1を引く
            countTimeup--;
            //もしもぐら用の制限時間が0の時
            if ( countTimeup == 0 ) {
                //もし、もぐら画像がHitされていなかったら
                if ( ! [moleImageView isHighlighted] ) {
                    //タグに対応しているImageView（ヘルメットの画像）を表示させる
                    UIImageView *imgView = (UIImageView *)[[self view] viewWithTag:tagTarget];
                    //（ヘルメット画像を）表示状態にしておく
                    [imgView setHidden:NO];
                    //（もぐら画像）ユーザーによるのタッチを無効にする
                    [moleImageView setUserInteractionEnabled:NO];
                    //当該もぐら画像を見えなくする
                    [moleImageView setAlpha:0.0f];
                }
                //対象となるタグをリセットする
                tagTarget = 0;
            }
        }
    }
    //表示させるもぐらを乱数で生成する
    NSInteger tag = (abs(arc4random()) % (kXCount*kYCount))+1;
    //もし、tagと表示中のもぐらが一致したら
    if ( tag == tagTarget ) {
        //何もしないで戻る
        return;
    }
    //タグに対応したヘルメットのImageViewを作成する（これを後でもぐら画像にする）
    UIImageView *imgView = (UIImageView *)[[self view] viewWithTag:tag];
    //ImageViewが空でないなら
    if ( imgView != nil ) {
        //もし、非表示になっていたら
        if ([imgView isHidden]) {
            //表示する
            [imgView setHidden:NO];
        }
        //もし、もぐらが登場していなければ
        if (tagTarget == 0) {
            //もし、乱数がkIncidence(マクロを参照)より小さいならば
            if ( (abs(arc4random())%100) < kIncidence ) {
                //タグに乱数をセットする
                tagTarget = tag;
                //ユーザーによるタッチを有効にする
                [moleImageView setUserInteractionEnabled:YES];
                //ImageViewを表示状態にする
                [moleImageView setAlpha:1.0f];
                //もぐら画像を配置する
                [moleImageView setCenter:[imgView center]];
                //ハイライトさせない
                [moleImageView setHighlighted:NO];
                //もぐら用タイマーの制限時間をセットする
                countTimeup = kTimeup;
                //ヘルメット画像を非表示にしもぐら画像を表示させる
                [imgView setHidden:YES];
            }
        }
    }
}

//タッチイベントを取得するメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //タッチされたかどうかを取得する
    UITouch *touch = [touches anyObject];
    //タッチされた座標を取得する
    CGPoint pos = [touch locationInView:[self view]];
    //タッチされた対象を決定
    UIView *aView = [[self view] hitTest:pos withEvent:event];
    //もし、タッチされた対象があるとき
    if ( aView != nil ) {
        //もし、タッチされた対象のtagが0以上のとき
        if ( [aView tag] > 0 ) {
            //タッチされた対象のオブジェクトをImageViewにする
            UIImageView *imgView = (UIImageView *)aView;
            //もし、タッチされた対象のtagが100の時（もぐら画像をタッチしている場合）
            if ( [imgView tag] == 100 ) {
                //点数を加算する
                [self calcScore:100];
                //ユーザーによるタッチを無効にする
                [imgView setUserInteractionEnabled:NO];
                //ハイライト状態にする
                [imgView setHighlighted:YES];
                //演出のためにもぐら用制限時間を延ばす
                countTimeup = kTimeup;
                //アニメーションの準備
                [UIView beginAnimations:nil context:nil];
                //アニメーションの速度を設定
                [UIView setAnimationDuration:1.0f];
                //アニメーションの透明度を設定
                [imgView setAlpha:0.0f];
                //アニメーションを開始する
                [UIView commitAnimations];
            }
        }
    }
}

//スコア計算用メソッド
-(void)calcScore:(NSInteger)score {
    //スコア全体値に獲得スコアを加算する
    scoreValue = scoreValue+score;
    //スコア全体値をラベルに表示する
    [scoreLabel setText:[NSString stringWithFormat: @"%04d",scoreValue]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6以下でステータスバーを削除したい場合
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    // 背景に色を付ける
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.565f green:0.431f blue:0.270f alpha:1.0f]];
    // 表示系パーツの準備
    [self setupParts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// メソッド追加する
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
