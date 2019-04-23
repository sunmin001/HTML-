//
//  ViewController.m
//  Cesh
//
//  Created by kgc－mac on 2019/4/11.
//  Copyright © 2019 kgc－mac. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "ZipArchive.h"

#define SCREENWIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT      [UIScreen mainScreen].bounds.size.height


@interface ViewController ()<NSURLSessionDelegate>

@property (nonatomic,strong)WKWebView *webView;
@property (nonatomic,strong)UILabel *labelProgress;
@property (nonatomic,strong)UIProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (int n = 0; n<4; n++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(50, 100+n*150, 100, 60);
        NSString *str = @"删除本地zip";
        if (n == 0) {
            str = @"解压";
        }else if (n == 1){
            str = @"下载";
        }else if (n == 2){
            str = @"读取";
        }
        [button setTitle:str forState:UIControlStateNormal];
        button.backgroundColor = [UIColor redColor];
        button.tag = 1+n;
        [button addTarget:self action:@selector(UnzipCloseFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        self.view.userInteractionEnabled = YES;
    }
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(200, 290, 200, 10)];
    self.progressView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.progressView];
    
    self.labelProgress = [[UILabel alloc] initWithFrame:CGRectMake(200, 260, 80, 20)];
    self.labelProgress.text = @"当前进度";
    [self.view addSubview:self.labelProgress];
}

- (void)reld
{
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *caches = [NSString stringWithFormat:@"%@WebKit/",NSTemporaryDirectory()];
//  NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *file = [caches stringByAppendingPathComponent:@"www.zip"];

//    //获取bundlePath 路径
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    //获取本地html目录 basePath
//    NSString *basePath = [NSString stringWithFormat: @"%@/LOL", bundlePath];
    BOOL is = [SSZipArchive unzipFileAtPath:file toDestination:caches];
    if (is == YES) {
        NSLog(@"解压成功");
    }else{
        NSLog(@"解压失败");
    }
 }

//解压
- (void)UnzipCloseFile:(UIButton *)sender {
    if (sender.tag == 1) {
        [self reld];
     }else if(sender.tag == 2){
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURL *url = [NSURL URLWithString:@"http://admin-flv.kgc.cn/Storyline/www.zip"];
        NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url];
        [task resume];
    }else if (sender.tag == 3){
//        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//        NSString *file = [caches stringByAppendingPathComponent:@"www"];
//        [self readWWW:file];
        [self readWWW];
//        [self movefile];
    }else{
        [self readPath];
    }
}

- (void)movefile
{
//    NSString *libraryPath = [NSString stringWithFormat:@"%@WebKit/",NSTemporaryDirectory()];
//
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
//
//    NSString *file =  [caches stringByAppendingPathComponent:@"www"];
//
//
//     BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:file toPath:libraryPath error:nil];
//     if (isSuccess == YES) {
//         NSLog(@"111111");
//     }else{
//         NSLog(@"222222");
//     }
//
//    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    // 获取在libraryPath文件中加入file1的路径
//    NSFileManager *fileManage = [NSFileManager defaultManager];
//    if (![fileManage fileExistsAtPath:file]) {
//        BOOL isSuccess = [fileManage moveItemAtPath:file toPath:libraryPath error:nil];
//        NSLog(@"%@",isSuccess ? @"移动成功" : @"移动失败");
//        if (isSuccess == YES) {
//             [self readWWW];
//        }
//    }
}

- (void)readPath
{
    NSLog(@"NSHomeDirectory = %@",NSTemporaryDirectory());
    NSString *path = [NSString stringWithFormat:@"%@WebKit/www.zip",NSTemporaryDirectory()];
    NSFileManager *fileManager = [NSFileManager defaultManager];
     BOOL isDelete = [fileManager removeItemAtPath:path error:nil];
     if (isDelete) {
         NSLog(@"删除成功");
      }else{
         NSLog(@"删除失败");
      }
}

- (void)readWWW
{
//  //初始化wkwebview
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
    //添加到view中
    self.webView.backgroundColor = [UIColor redColor];
    [self.view addSubview: self.webView];
//沙盒路径：
    NSLog(@"沙盒路径%@",NSHomeDirectory());
    NSLog(@"NSHomeDirectory = %@",NSTemporaryDirectory());
    NSString *sttr = [NSString stringWithFormat:@"%@WebKit/www/story.html",NSTemporaryDirectory()];
    NSURL *feedbackURL = [NSURL fileURLWithPath:sttr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
    
//  [self.webView. loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
//  //项目中的文件夹路径
//  NSString *directoryPath = [NSFileManager appSourceName:@"FeedbackH5" andType:@""];
//    //tmp缓存文件夹路径
//    NSString *tmpPath = [NSFileManager tmpPath];
//    //新文件夹名字
//    NSString *wwwDir =@"www";
//    //tmp文件夹下创建www文件夹
//    [KFileManger createDirWithPath:tmpPath andDirectoryName: wwwDir];
//
//    //tmp中的www文件夹中的路径
//    NSString *tmpWWW = [tmpPath stringByAppendingString:wwwDir];
//
//    //copy文件夹到 tmp/www 路径下
//    [KFileManger copyMissingFile:directoryPath toPath:tmpWWW];
//
//    // 字符 tmp/www/FeedbackH5/pages/feedback.html 全路径
//    NSString *tmpWWWFeedback = [tmpWWW stringByAppendingString:@"/FeedbackH5/pages/feedback.html"];
//
//    //tmp 操作，字符转换成URL
//    NSURL *feedbackURL = [NSURL fileURLWithPath:tmpWWWFeedback];
//
//    //WKWebView加载
//    [_webview loadRequest:[NSURLRequest requestWithURL:feedbackURL]];
}

- (void)readLoad
{
    //初始化wkwebview
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
    //添加到view中
    [self.view addSubview: self.webView];
    //获取bundlePath 路径
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    //获取本地html目录 basePath
    NSString *basePath = [NSString stringWithFormat:@"%@/www", bundlePath];
    //获取本地html目录 baseUrl
    NSURL *baseUrl = [NSURL fileURLWithPath:basePath isDirectory: YES];
    NSLog(@"%@", baseUrl);
    //html 路径
    NSString *indexPath = [NSString stringWithFormat: @"%@/story.html", basePath];
    //html 文件中内容
    NSString *indexContent = [NSString stringWithContentsOfFile:
                              indexPath encoding: NSUTF8StringEncoding error:nil];
    //显示内容
    [self.webView loadHTMLString: indexContent baseURL: baseUrl];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 创建一个下载任务并设置代理
   
}

#pragma mark -
/**
 下载完毕后调用
 参数：lication 临时文件的路径（下载好的文件）
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    // 创建存储文件路径
    NSString *caches = [NSString stringWithFormat:@"%@WebKit",NSTemporaryDirectory()];
    // response.suggestedFilename：建议使用的文件名，一般跟服务器端的文件名一致
    
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSLog(@"下载完成1111111");
    /**将临时文件剪切或者复制到Caches文件夹
     AtPath :剪切前的文件路径
     toPath :剪切后的文件路径
     */
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    NSLog(@">>>>>>>>>>>>>>>>>%@",location.path);
}

/**
 每当下载完一部分时就会调用（可能会被调用多次）
 参数：
 bytesWritten 这次调用下载了多少
 totalBytesWritten 累计写了多少长度到沙盒中了
 totalBytesExpectedToWrite 文件总大小
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    // 这里可以做些显示进度等操作
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>%lld",bytesWritten);
    self.progressView.progress = 1.0 * totalBytesWritten/totalBytesExpectedToWrite;
    self.labelProgress.text = [NSString stringWithFormat:@"%lf",self.progressView.progress];
}

/**
 恢复下载时使用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // 用于断点续传
}



@end
