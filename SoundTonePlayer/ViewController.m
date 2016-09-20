//
//  ViewController.m
//  SoundTonePlayer
//
//  Created by frd on 9/13/16.
//  Copyright © 2016 ludy520. All rights reserved.
//

#import "ViewController.h"
#import "SoundTonePlayer.h"
#import "AFViewShaker.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *letterArray;
@property(nonatomic,strong)SoundTonePlayer *soundTonePlayer;


@end

@implementation ViewController

#pragma - mark lifecirle
- (void)viewDidLoad {
    [super viewDidLoad];

    
    _letterArray=@[@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ"];
    _soundTonePlayer=[[SoundTonePlayer alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma - mark events
//播放预览
- (IBAction)previewAction:(id)sender {
    [_soundTonePlayer stopPlayPreview];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_soundTonePlayer playPrivew];
    });
}


- (IBAction)stopPlay:(id)sender {
    [_soundTonePlayer stopPlayPreview];
}

- (IBAction)playNext:(id)sender {
    [_soundTonePlayer stopPlayPreview];
    [_soundTonePlayer switchTone];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_soundTonePlayer playPrivew];
    });
}

#pragma - mark UICollectionViewDataSource & UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UILabel *numL=(UILabel*)[cell viewWithTag:1000];
    UILabel *letterL=(UILabel*)[cell viewWithTag:1001];
    UIButton *btn=(UIButton*)[cell viewWithTag:1003];
    
    numL.text=@"";
    letterL.text=@"";
    [btn setImage:nil forState:UIControlStateNormal];
    
    if (indexPath.row<9) {
        numL.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        if (indexPath.row>0) {
            letterL.text=self.letterArray[indexPath.row-1];
        }
    }
    
    
    switch (indexPath.row) {
        case 9:
            numL.text=@"*";
            break;
            
        case 10:
            numL.text=@"0";
            letterL.text=@"+";
            break;
        case 11:
            numL.text=@"#";
            break;
    }
    
    
    switch (indexPath.row) {
        case 12:
            [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
            break;
        case 14:
            [btn setImage:[UIImage imageNamed:@"tuige"] forState:UIControlStateNormal];
            break;
        case 13:
            [btn setImage:[UIImage imageNamed:@"bohao"] forState:UIControlStateNormal];
            break;
    }
    
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 15;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_soundTonePlayer playNext];
    UICollectionViewCell *cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    AFViewShaker *shaker=[[AFViewShaker alloc] initWithView:cell];
    [shaker shake];
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width=[[UIScreen mainScreen] bounds].size.width;
    
    return CGSizeMake(width/3., 54);
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
