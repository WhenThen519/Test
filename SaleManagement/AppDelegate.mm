//
//  AppDelegate.m
//  SaleManagement
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 cn.300.cn. All rights reserved.
//
#import "CY_Business.h"

#import "New_Gonghai.h"
#import "AppDelegate.h"
#import "LoginVC.h"
#import "CY_addClientVc.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "ScheduleViewController.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

BMKMapManager* _mapManager;

@interface AppDelegate ()<JPUSHRegisterDelegate>

@end
//
@implementation AppDelegate
-(void)push 
{
        //    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    //    action.identifier = @"action";//按钮的标示
    //    action.title=@"Accept";//按钮的标题
    //    action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //    //    action.authenticationRequired = YES;
    //    //    action.destructive = YES;
    //
    //    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    //    action2.identifier = @"action2";
    //    action2.title=@"Reject";
    //    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    //    action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    //    action.destructive = YES;
    //
    //    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    //    categorys.identifier = @"alert";//这组动作的唯一标示
    //    [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
    //UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
    //
    //    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    //    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //
    //
    //    UILocalNotification *notification = [[UILocalNotification alloc] init];
    //    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];
    //    notification.timeZone=[NSTimeZone defaultTimeZone];
    //    notification.alertBody=@"测试推送的快捷回复";
    //    notification.category = @"alert";
    //    [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
    //
    //    //用这两个方法判断是否注册成功
    //    // NSLog(@"currentUserNotificationSettings = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
    //判断是否注册了远程通知
    bool iss =[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
}
//
- (void)networkDidSetup:(NSNotification *)notification {
    NSLog(@"Jpush已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    NSLog(@"Jpush未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"Jpush已注册%@", [notification userInfo]);
   
}

- (void)networkDidLogin:(NSNotification *)notification {

    NSLog(@"Jpush已登录");
    if ([JPUSHService registrationID]) {
        NSLog(@"get RegistrationID");
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"BIEMING"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"BIEMING"] length])
    {
        if([Host_url isEqualToString:@"http://m.api.ceboss.cn/SmaMobile/"])
        {
        [JPUSHService setTags:[NSSet setWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"TAG"]] alias:[[NSUserDefaults standardUserDefaults]objectForKey:@"BIEMING"] fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
            
            NSLog(@"哈哈哈哈哈哈哈哈rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
        }];
        }
    }
 
   
 

}
- (void)serviceError:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *error = [userInfo valueForKey:@"error"];
    NSLog(@"Jpush服务器错误%@", error);
}
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];

    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"自定义消息" message:content delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];

}

#pragma mark - applicationdelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//3Dtouch
    CGFloat currentDeviceVersionFloat = [[[UIDevice currentDevice] systemVersion] floatValue];
    //判断版本号，3D Touch是从iOS9.0后开始使用
    if (currentDeviceVersionFloat >= 9.0) {
        UIApplicationShortcutIcon *iconFitness = [UIApplicationShortcutIcon iconWithTemplateImageName:@"释放icon"];
        //菜单文字
        UIMutableApplicationShortcutItem *itemFitness = [[UIMutableApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"去下载"];
        //绑定信息到指定菜单
        itemFitness.icon = iconFitness;

        //绑定到App icon
        application.shortcutItems = @[itemFitness];
    }

    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(serviceError:)
                          name:kJPFServiceErrorNotification
                        object:nil];

    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    //测试
   // BOOL ret = [_mapManager start:@"v8HskSOZhzMC9crsw8BxuZDs" generalDelegate:self];
    //cn.300.SaleManagement-t正式
    BOOL ret = [_mapManager start:@"eVCyLb7R4cDPC9RKnKqrF12C" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"baiduMap manager start failed!");
    }
    
#pragma mark----版本更新
    
     [FX_UrlRequestManager postByUrlStr:onCheckVersion_url andPramas:nil andDelegate:self andSuccess:@"onCheckVersionSuccess:" andFaild:nil andIsNeedCookies:NO];
#pragma mark----JPush推送

    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

    //Required
    //如需兼容旧版本的方式，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化和同时使用pushConfig.plist文件声明appKey等配置内容。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
//#ifdef __IPHONE_8_0
//    //这里主要是针对iOS 8.0,相应的8.1,8.2等版本各程序员可自行发挥，如果苹果以后推出更高版本还不会使用这个注册方式就不得而知了……
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }  else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
//#else
//    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//#endif
    
    //根视图
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginVC *root =  [[LoginVC alloc] init];
    self.window.rootViewController = root;
    self.window.backgroundColor = [ToolList getColor:@"f6f6f6"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark---版本更新
-(void)onCheckVersionSuccess:(NSDictionary *)checkDic{
    
   
    if ([[checkDic objectForKey:@"code"]intValue]==200) {
        
        NSString *lastVersion = [[checkDic objectForKey:@"result"]objectForKey:@"iosVersion" ];
        
  [[NSUserDefaults standardUserDefaults] setObject:lastVersion forKey:@"iosVersion"];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        
        NSString *currentVersion = [NSString stringWithFormat:@"v.%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
    
        _windowUrl =[[checkDic objectForKey:@"result"]objectForKey:@"url" ];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"最新版本号为%@,请更新！",lastVersion] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            [alert show];
            
        }
    }
 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex ==1) {
        //web页面·
        UIWebView *mainWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height)];
        mainWeb.backgroundColor = [UIColor whiteColor];
        [self.window addSubview:mainWeb];
        [mainWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_windowUrl]]];
    }
  
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [BMKMapView willBackGround];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [self push];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [application setApplicationIconBadgeNumber:0];

    [BMKMapView didForeGround];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}                                                                
#pragma mark - generalDelegate

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"地图联网成功");
    }
    else{
        NSLog(@"地图联网失败 %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"地图授权成功");
    }
    else {
        NSLog(@"地图授权失败 %d",iError);
    }
}
#pragma mark - 3dtouch响 应

- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler{
    if ([shortcutItem.type isEqualToString:@"1"]) {
//        NSString * str= @"https://www.pgyer.com/DgTP";
//
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        New_Gonghai *ghVC = [[New_Gonghai alloc]init];
        ghVC.isS = YES;
        UINavigationController *mainVC = [[UINavigationController alloc]initWithRootViewController:ghVC];
        mainVC.navigationBarHidden = YES;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        
        
        self.window.rootViewController = mainVC;

        self.window.backgroundColor = [ToolList getColor:@"f6f6f6"];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.window makeKeyAndVisible];

    }
 
    
    
}
#pragma mark - 推送回调
////本地推送通知
//-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
//{
//    //成功注册registerUserNotificationSettings:后，回调的方法
//}



//-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
//{
//    //在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
//    completionHandler();//处理完消息，最后一定要调用这个代码块
//}

//远程推送通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];

    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (pushToken) {
        [[NSUserDefaults standardUserDefaults]setObject:pushToken forKey:@"pushtoken"];
        [[NSUserDefaults standardUserDefaults] synchronize ];
    }
    
    //向APNS注册成功，收到返回的deviceToken
}
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"向APNS注册失败，返回错误信息:%@",error);
    //向APNS注册失败，返回错误信息error
}
//本地通知
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提醒消息" message:notification.alertBody delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //收到远程推送通知消息
    [JPUSHService handleRemoteNotification:userInfo];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提醒消息" message:[userInfo description] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"通知消息" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"通知消息" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"通知消息" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(); // 系统要求执行这个方法
}


-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮
    //NSLog(@"%@",identifier);
}
@end
