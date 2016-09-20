//
//  SoundTonePlayer.m
//
//  Created by ludy520 on 2016-9-13.
//  Copyright © 2016 ludy520. All rights reserved.
//

#import "SoundTonePlayer.h"
#import <AudioToolbox/AudioToolbox.h>

#define kSoundChangedNotification @"kSoundChangedNotification"
@interface SoundTonePlayer ()

@property(nonatomic,strong)NSString *file;
@property(nonatomic,strong)NSString *toneStr;
@property(nonatomic,assign)SystemSoundID currentSoundId;

@property(nonatomic,strong)NSArray *tonesList;//乐谱列表
@property(nonatomic,assign)NSInteger tonePos;//乐谱位置

@property(nonatomic,strong)NSArray *toneArray;//音符列表
@property(nonatomic,assign)NSInteger position;//音符位置

@property(nonatomic,strong)NSMutableDictionary *keytoneInfo;


@end

@implementation SoundTonePlayer

-(instancetype)init
{
    self=[super init];
    if (self) {
        
#if TARGET_IPHONE_SIMULATOR
        NSString *path=[NSString stringWithFormat:@"%@/%@",NSHomeDirectory(),@"Documents"];
#else
        NSString *path =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#endif
        _file=[NSString stringWithFormat:@"%@/%@",path,@"KeytoneInfo.plist"];
        
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_file]) {
            
            [[NSFileManager defaultManager] createFileAtPath:_file contents:nil attributes:nil];
            
            NSDictionary *dic=@{@"0":@"",@"1":@"59.28:56.35:57:59.40:56.44:57:59.23:47:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:59.28:56.35:57:59.40:56.44:57:59.23:51:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:59.28:56.35:57:59.40:56.44:57:59.23:51:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:56.28:52.35:54:56.40:54.44:52:54.23:51:52.30:54:56.35:54:52.39:51:52.25:49.32:51:52.37:40.40:42:44.20:45:44.32:42:44.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:49:51.23:52:54.35:52:51.39:52:49.42:51:52.28",@"current":@"1"};
            
            
            
            [dic writeToFile:_file atomically:YES];
            
        }
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentKeytoneChanged:) name:kSoundChangedNotification object:nil];
        
        _keytoneInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:_file];
        
//        self.tonesList=@[[_keytoneInfo objectForKey:_keytoneInfo[@"current"]]];
        
        
         self.tonesList=@[
         
        @"56:55:56:55:56:51:54:52:49.25:32:37:40:44:49:51.20:32:36:44:48:51:52.25:32:37:44:56:55:56:55:56:51:54:52:49.25:32:37:40:44:49:51.20:32:36:44:52:51:49.25:32:37:56:55:56:55:56:51:54:52:49.25:32:37:40:44:49:51.20:32:36:44:48:51:52.25:32:37:44:56:55:56:55:56:51:54:52:49.25:32:37:40:44:49:51.20:32:36:44:52:51:49.25:32:37:51:52:54:56.28:35:40:47:57:56:54.23:35:39:4556:54:52.25:32:37:44:54:52:51.20:32:44:44:56:44:56:56:68:55:56:55:56:55:56:55:56:55:56:55:56:51:54:52:49.25:32:37:40:44:49:51.20:32:36:44:48:51:52",
         
         
         @"59.28:56.35:57:59.40:56.44:57:59.23:47:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:59.28:56.35:57:59.40:56.44:57:59.23:51:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:59.28:56.35:57:59.40:56.44:57:59.23:51:49.35:51:52.39:54:56.42:57:56.25:52.32:54:56.37:44.40:45:47.20:49:47.32:45:47.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:52:51.23:49:51.35:52:54.39:56:57.42:59:56.28:52.35:54:56.40:54.44:52:54.23:51:52.30:54:56.35:54:52.39:51:52.25:49.32:51:52.37:40.40:42:44.20:45:44.32:42:44.35:52:51.39:52:49.21:52.33:51:49.37:47.40:45:47.28:45:44.32:45:47.35:49:51.40:52:49.21:52.33:51:52.37:51.40:49:51.23:52:54.35:52:51.39:52:49.42:51:52.28",
         
         
         @"61.34:60.41:61.46:60:61.30:56.37:61.44:54.44:54.44:54:49:53:61.34:60.41:61.46:60:61.30:56.37:61.44:54.44:54.44:54:49:53:61.34:60.41:61:61.46:49:60:61:61.30:49:56.37:61:61.44:49:53:49:53.25:54.32:49.56.41:53:51.48.36:39:49:48:44",
         
         
         @"56:59:61.21:28:33:61.28:59.23:54.30:52.35:54.30:56.28:59:54.27:56:52.25:32:56.37:59.32:61.21:28:33:61.28:59.30:54.37:52.42:54.37:56.28:35:40:44:47:56:59:61.21:28:33:61.28:59.23:54.30:52.35:54.30:56.28:59:59.27:54:52.25:32:56.37:59.32:49.21:28:59.33:28:54.23:52.30:35:51.30:49.25:32:37:39:40:56:59:61.21:28:33:61.28:59.23:54.30:52.35:54.30:56.28:59:54.27:56:52.25:32:56.37:59.32:61.21:28:33:64.28:63.30:61.37:59.42:54.37:56.28:35:40:44:56:59:61.21:28:33:61.28:59.23:54.30:52.35:54.30:56.28:59:59.27:54:52.25:32:56.37:59.32:49.21:28:59.33:28:54.23:52.30:35:51.30:49.25:32:37:39:40:56:54:49.21:28:56.33:28:54.23:30:54.35:52.30:51.20:27:50.32:35:37:41:51.39:49.37"
         
         
         
         
         ];
         
        
        self.tonePos=0;
        self.toneStr=[self.tonesList objectAtIndex:self.tonePos];
        self.toneArray=[self.toneStr componentsSeparatedByString:@":"];
        
    }
    return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 播放音符
-(void)playWithTone:(NSString*)tone
{
    NSString *path=[[NSBundle mainBundle] pathForResource:tone ofType:@"mp3"];
    if (path) {
        
        OSStatus error=AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:path]), &_currentSoundId);
        if (error==kAudioServicesNoError) {
            AudioServicesPlaySystemSound(_currentSoundId);
        }
    }

}

#pragma mark 下一首乐谱
-(void)switchTone
{
    self.tonePos++;
    if (self.tonePos>=self.tonesList.count) {
        self.tonePos=0;
    }
    self.toneStr=[self.tonesList objectAtIndex:self.tonePos];
    self.toneArray=[self.toneStr componentsSeparatedByString:@":"];
}

#pragma mark 播放预览
-(void)playPrivew
{
    
    self.isPlayingSound=YES;
    
    
    
    for (int index=0; index<self.toneArray.count; index++)
    {
        if (self.isPlayingSound)
        {
            [NSThread sleepForTimeInterval:0.3f];
            NSString *tone=[self.toneArray objectAtIndex:index];
            if ([tone rangeOfString:@"."].length>0) {
                
                NSArray *array=[tone componentsSeparatedByString:@"."];
                for (NSString *t in array) {
                    [self playWithTone:t];
                }
                
            }else{
                
                [self playWithTone:tone];
            }
            
        }
        
    }
    
    
    
    
}


#pragma mark 播放指定id的音乐
-(void)playPrivewWithKeytoneId:(NSString*)key
{
    
    self.isPlayingSound=YES;
    NSString *keytoneStr=_keytoneInfo[key];
    if (keytoneStr==nil || [keytoneStr isEqualToString:@""]) {
        keytoneStr=_keytoneInfo[@"1"];
    }
    
    NSArray *tones=[keytoneStr componentsSeparatedByString:@":"];
    
    while (self.isPlayingSound) {
        
        
        for (int index=0; index<tones.count; index++)
        {
            if (self.isPlayingSound)
            {
                [NSThread sleepForTimeInterval:0.3f];
                NSString *tone=[tones objectAtIndex:index];
                if ([tone rangeOfString:@"."].length>0) {
                    
                    NSArray *array=[tone componentsSeparatedByString:@"."];
                    for (NSString *t in array) {
                        [self playWithTone:t];
                    }
                    
                }else{
                    
                    [self playWithTone:tone];
                }
                
            }
            
        }
        
    }
    
    
    
}


-(void)stopPlayPreview
{
    self.isPlayingSound=NO;
    [self positionZero];
}





#pragma mark 播放下一个音符
-(void)playNext
{
    if (self.position>=self.toneArray.count) {
        self.position=0;
    }
    
    NSString *tone=[self.toneArray objectAtIndex:self.position];
    //静音
    if (tone == nil || tone.length==0) {
        return;
    }
    
    //键盘音
    if ([tone rangeOfString:@"."].length>0) {
        
        NSArray *array=[tone componentsSeparatedByString:@"."];
        for (NSString *t in array) {
            [self playWithTone:t];
        }
        
    }else{
        
        [self playWithTone:tone];
    }
    
    self.position++;
    
}

#pragma mark 音符位置归零
-(void)positionZero
{
    self.position=0;
}



#pragma mark 当前音乐已改变
-(void)currentKeytoneChanged:(NSNotification*)note

{
    _keytoneInfo=[[NSMutableDictionary alloc] initWithContentsOfFile:_file];
    self.toneStr=[_keytoneInfo objectForKey:_keytoneInfo[@"current"]];
    self.toneArray=[self.toneStr componentsSeparatedByString:@":"];
}

#pragma mark 设置当前启用音乐
-(void)setCurrentKeytoneWithId:(NSString*)id
{
    [_keytoneInfo setValue:id forKey:@"current"];
    [_keytoneInfo writeToFile:_file atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSoundChangedNotification object:nil];
}

#pragma mark 已启用音乐的key
-(NSString*)currentKeytone
{
    return _keytoneInfo[@"current"];
}

#pragma mark 是否已下载音乐
-(BOOL)containsWithKeytone:(NSString*)id
{
    return [_keytoneInfo.allKeys containsObject:id];
}

#pragma mark 写入新的音乐
-(void)addKeytoneStr:(NSString*)str withId:(NSString*)id
{
    [_keytoneInfo setValue:str forKey:id];
    [_keytoneInfo writeToFile:_file atomically:YES];
}

@end
