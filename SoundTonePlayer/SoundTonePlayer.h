//
//  SoundTonePlayer.h
//
//  Created by ludy520 on 2016-9-13.
//  Copyright © 2016 ludy520. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SoundTonePlayer : NSObject

@property(nonatomic,assign)BOOL isPlayingSound;

-(void)playPrivew;
-(void)playNext;
-(void)positionZero;
-(void)switchTone;
-(void)stopPlayPreview;

-(NSString*)currentKeytone;
-(void)setCurrentKeytoneWithId:(NSString*)id;
-(BOOL)containsWithKeytone:(NSString*)id;
-(void)addKeytoneStr:(NSString*)str withId:(NSString*)id;
-(void)playPrivewWithKeytoneId:(NSString*)key;

@end
