### NSArray 快速求总和 最大值 最小值 和 平均值

    NSArray *array = [NSArray arrayWithObjects:@"2.0", @"2.3", @"3.0", @"4.0", @"10", nil];
    CGFloat sum = [[array valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
    NSLog(@"%f\n%f\n%f\n%f",sum,avg,max,min);
    
###UIView设置部分圆角

    CGRect rect = view.bounds;
    CGSize radio = CGSizeMake(30, 30);//圆角尺寸
    UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;//这只圆角位置
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = view.bounds;
    masklayer.path = path.CGPath;//设置路径
    view.layer.mask = masklayer;
    
###取图片某一像素点的颜色 在UIImage的分类中

	- (UIColor *)colorAtPixel:(CGPoint)point
	{
  	  if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, 		self.size.height), point))
   		 {
        	return nil;
   		 }
    
    	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    	int bytesPerPixel = 4;
    	int bytesPerRow = bytesPerPixel * 1;
    	NSUInteger bitsPerComponent = 8;
    	unsigned char pixelData[4] = {0, 0, 0, 0};
    
    	CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | 		kCGBitmapByteOrder32Big);
    	CGColorSpaceRelease(colorSpace);
    	CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    	CGContextTranslateCTM(context, -point.x, point.y - self.size.height);
    	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, self.size.width, 		self.size.height), self.CGImage);
    	CGContextRelease(context);
    
   	 	CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    	CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    	CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    	CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
	}

###iOS跳转到App Store下载应用评分
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APPID"]];
	
###字符串按多个符号分割
    NSString * stt = @"abc,vf;123.1";
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@",;."];
    NSLog(@"%@",[stt componentsSeparatedByCharactersInSet:set]);
    
###手动更改iOS状态栏的颜色
	- (void)setStatusBarBackgroundColor:(UIColor *)color
	{
    	UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    	if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    	{
       	 statusBar.backgroundColor = color;
    	}
	}
###判断view是不是指定视图的子视图
	BOOL isView = [textView isDescendantOfView:self.view];
###修改UITextField中Placeholder的文字颜色
	[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
###获取一个类的所有子类
	+ (NSArray *) allSubclasses
	{
    	Class myClass = [self class];
    	NSMutableArray *mySubclasses = [NSMutableArray array];
    	unsigned int numOfClasses;
    	Class *classes = objc_copyClassList(&numOfClasses;);
    	for (unsigned int ci = 0; ci ( numOfClasses; ci++)
    	{
       	 	Class superClass = classes[ci];
       	 	do{
          	  	superClass = class_getSuperclass(superClass);
        	} while (superClass && superClass != myClass);

        	if (superClass)
        	{
            	[mySubclasses addObject: classes[ci]];
        	}
    	}
    	free(classes);
    	return mySubclasses;
	}
###监测IOS设备是否设置了代理，需要CFNetwork.framework

	NSDictionary *proxySettings = (__bridge NSDictionary *)(CFNetworkCopySystemProxySettings());
	NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL 	URLWithString:@"http://www.baidu.com"]), (__bridge CFDictionaryRef _Nonnull)(proxySettings)));
	NSLog(@"\n%@",proxies);

	NSDictionary *settings = proxies[0];
	NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
	NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
	NSLog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);

	if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"])
	{
     	NSLog(@"没代理");
	}
	else
	{
   	  NSLog(@"设置了代理");
	}
	
###取消UICollectionView的隐式动画
UICollectionView在reloadItems的时候，默认会附加一个隐式的fade动画，有时候很讨厌，尤其是当你的cell是复合cell的情况下(比如cell使用到了UIStackView)。

下面几种方法都可以帮你去除这些动画

	//方法一
	[UIView performWithoutAnimation:^{
    	[collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
	}];

	//方法二
	[UIView animateWithDuration:0 animations:^{
    	[collectionView performBatchUpdates:^{
        	[collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    	} completion:nil];
	}];

	//方法三
	[UIView setAnimationsEnabled:NO];
	[self.trackPanel performBatchUpdates:^{
   	 	[collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
	} completion:^(BOOL finished) {
   	    [UIView setAnimationsEnabled:YES];
	}];
	
###UIImage 占用内存大小
	UIImage *image = [UIImage imageNamed:@"aa"];
	NSUInteger size  = CGImageGetHeight(image.CGImage) * CGImageGetBytesPerRow(image.CGImage);
###GCD timer定时器
	-(void)activeGCDTimer{
   	 	NSTimeInterval period = 1.0; //设置时间间隔
   	 	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    	dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    	dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),period*NSEC_PER_SEC, 0); //每秒执行
    	dispatch_source_set_event_handler(timer, ^{
        	//@"倒计时结束，关闭"
			//dispatch_source_cancel(timer);
        	dispatch_async(dispatch_get_main_queue(), ^{
            	NSLog(@"do...");
        	});
        
    	});
   	 	dispatch_resume(timer);
    	_timer = timer;
	}
	
###图片上绘制文字
`- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize
{
    //画布大小
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0

    [self drawAtPoint:CGPointMake(0.0,0.0)];

    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中

    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;

    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle}];

    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}`

###防止scrollView手势覆盖侧滑手势
	[scrollView.panGestureRecognizerrequireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];

###去掉导航栏返回的back标题
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];

	
[--->查看更多内容](http://www.tuicool.com/articles/numYreu)


### Mac OS X中开启或关闭显示隐藏文件命令
	defaults write com.apple.finder AppleShowAllFiles -bool true       此命令显示隐藏文件
	defaults write com.apple.finder AppleShowAllFiles -bool false      此命令关闭显示隐藏文件