//
//  RNSimpleSound.m
//  RNSimpleSound
//
//  Copyright © 2015 mikehedman. All rights reserved.
//

#import "RNSimpleSound.h"
#import <AVFoundation/AVFoundation.h>

@implementation RNSimpleSound {
  BOOL _enabled;
  AVAudioPlayer* player;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(enable:(BOOL)enabled) {
  _enabled = enabled;
  AVAudioSession *session = [AVAudioSession sharedInstance];
  [session setCategory: AVAudioSessionCategoryAmbient error: nil];
  [session setActive: enabled error: nil];
}

RCT_EXPORT_METHOD(prepare:(NSString *)fileName) {
  // Construct URL to sound file
  NSString *soundFilePath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] resourcePath], fileName];
  NSURL *soundURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
  player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
  [player prepareToPlay];
}

RCT_EXPORT_METHOD(play) {
  if (!_enabled || !player.url) {
    return;
  }

  [player play];
}

RCT_EXPORT_METHOD(pause) {
  if (!_enabled) {
    return;
  }
  [player pause];
}

RCT_EXPORT_METHOD(stop) {
    if (!_enabled) {
        return;
    }
    [player stop];
    //stop does not reset the player, so force it
    [player prepareToPlay];
}

@end