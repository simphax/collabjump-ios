//
//  MosaicClient.h
//  Copyright (c) 2013 Mosaic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum MosaicSwipeDirection {
    MosaicSwipeDirectionIn = 1,
    MosaicSwipeDirectionOut = 2
} MosaicSwipeDirection;

typedef struct MosaicSwipe {
    MosaicSwipeDirection direction;
    CGPoint point;
} MosaicSwipe;

@protocol MosaicDelegate <NSObject>
@optional

-(void)mosaicDidConnect;
-(void)mosaicDidDisconnect;

-(void)mosaicSwipeOccurred:(MosaicSwipe)swipe;
-(void)mosaicFrameUpdated:(CGRect)frame;
-(void)mosaicStateUpdated:(NSData *)state;

@end

@class BLYClient, BLYChannel;
@interface MosaicClient : NSObject <CLLocationManagerDelegate, UIGestureRecognizerDelegate> {
    BLYClient *client;
    BLYChannel *channel;
    NSString *sessionName;
    CLLocationManager *locationManager;
    double latitude;
    double longitude;
    double radius;
    BOOL connected;
}
@property NSString *APIKey;
@property(readonly) UIView *view;
@property CGRect frame;
@property NSData *state;
@property id<MosaicDelegate> delegate;

+(MosaicClient *)sharedClient;
-(void)connect;
-(void)attachToView:(UIView *)newView;
-(void)updateState:(NSData *)newState;

@end
