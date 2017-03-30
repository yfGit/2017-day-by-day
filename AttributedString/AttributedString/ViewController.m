//
//  ViewController.m
//  AttributedString
//
//  Created by Vincent on 2017/3/20.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic, strong) NSMutableAttributedString *attributedString;

@property (nonatomic, assign) NSRange range;

@end


/*
 NSAttributedString.h
 
 NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeName     设置字体颜色，取值为 UIColor对象，默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 NSStrikethroughStyleAttributeName	设置删除线，取值为 NSNumber 对象（整数）
 NSStrikethroughColorAttributeName	设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用
 NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 NSWritingDirectionAttributeName	设置文字书写方向，从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName	设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 */


static int count = 200;
static NSString *text = @"今天周一打算学习AttributedString,之后再学习RAC";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label.numberOfLines = 3;
    self.label.backgroundColor = [UIColor whiteColor];
    self.label.userInteractionEnabled = YES;
    
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    self.range = NSMakeRange(0, self.attributedString.length);
    
//    [self font];
    
//    [self color];
    
//    [self backgroundColor];
    
//    [self kern];
    
//    [self paragraph];
    
//    [self strikethrough];
    
//    [self underline];
    
//    [self stroke];
    
//    [self shadow];
    
//    [self effect];
    
//    [self textAttach];
    
//    [self link];
    
//    [self baseLine];
    
//    [self obliqueness];
    
//    [self expansion];
    
//    [self writingDirection];
    
//    [self verticalGlyph];
    
//    [self document];
    
    
    self.label.attributedText = self.attributedString;
}

#pragma mark - 计算size
/*
 NSString  
 - (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 6_0);
 
 UIView
 - (CGSize)sizeThatFits:(CGSize)size;     // return 'best' size to fit given size. does not actually resize view. Default is return existing view size
 - (void)sizeToFit;                       // calls sizeThatFits: with current view bounds and changes bounds size.
 
*/


#pragma mark - 字体
- (void) font
{
    [self.attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Papyrus" size:30] range:self.range];
}

#pragma mark - 字体颜色
- (void) color
{
    [self.attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(12, 3)];
}

#pragma mark - 背景色
// 字体所在区域背景色, 优先级高于label背景色
- (void) backgroundColor
{
    [self.attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(0, 10)];
}

#pragma mark - 字间距
// 效果向后, 对前一个字符没有影响
- (void) kern
{
    [self.attributedString addAttribute:NSKernAttributeName value:@(4) range:NSMakeRange(1, 3)];
}

#pragma mark - 行间距
/**
    行间距
    只要第一行, 就看效果填对应的开始和长度
 
    lineSpacing             CGFloat类型，行距
    paragraphSpacing        CGFloat类型，段距
    alignment               NSTextAlignment，对齐方式
    firstLineHeadIndent     CGFloat类型，首行缩进
    headIndent              CGFloat类型，缩进
    tailIndent              CGFloat类型，尾部缩进
    lineBreakMode           CGFloat类型，断行方式
    minimumLineHeight       CGFloat类型，最小行高
    maximumLineHeight       CGFloat类型，最大行高
    baseWritingDirection	NSWritingDirection，句子方向
    lineHeightMultiple      CGFloat类型，可变行高,乘因数
    paragraphSpacingBefore	CGFloat类型，段首空间
    hyphenationFactor       CGFloat类型，连字符属性
 */
- (void) paragraph
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    [self.attributedString addAttribute:NSParagraphStyleAttributeName value:style range:self.range];
}


#pragma mark - 删除线
/**
    删除线, 字体颜色会影响线的颜色, 但删除线颜色优先级最高
    0:没有效果
    1:单线 2-7:加粗
    8:没效果
    9:双删除线 10-15:加粗
    3233:虚线, 一长两短  好2
 */
- (void) strikethrough
{
    [self.attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(5) range:NSMakeRange(5, 10)];
    [self.attributedString addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:self.range];
}

#pragma mark - 下划线
/**
    下划线 和 颜色
    NSUnderlineStyleNone        没有
    NSUnderlineStyleSingle      单线
    NSUnderlineStyleThick       单线加粗
    NSUnderlineStyleDouble      双线
    0,1,2可以同删除线
 */
- (void) underline
{
    [self.attributedString addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:self.range];
    [self.attributedString addAttribute:NSUnderlineColorAttributeName value:[UIColor redColor] range:self.range];
}

#pragma mark - 镂空
/**
    镂空
    NSStrokeColorAttributeName 配合
    NSStrokeWidthAttributeName 负值:填充,中间为 字体颜色, 数值越大,中间的颜色越少至没有
                               正值:镂空
 */
- (void) stroke
{
    [self.attributedString addAttribute:NSStrokeColorAttributeName value:[UIColor redColor] range:self.range];
    [self.attributedString addAttribute:NSStrokeWidthAttributeName value:@(-8) range:self.range];
}


#pragma mark - 阴影
/*
    阴影
    shadowColor   配合
    shadowOffset  模竖方向偏移
 */
- (void) shadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blueColor];
    shadow.shadowOffset = CGSizeMake(5, 5);
    [self.attributedString addAttribute:NSShadowAttributeName value:shadow range:self.range];
}


#pragma mark - 图版印刷
// 特殊效果, 目前只有 图版印刷效果 可用
- (void) effect
{
    [self.attributedString addAttribute:NSTextEffectAttributeName value:NSTextEffectLetterpressStyle range:self.range];
}


#pragma mark - 图文混排
/*
    NSTextAttachment  图文混排
 */
- (void) textAttach
{
    NSTextAttachment *textAttach = [[NSTextAttachment alloc] init];
    textAttach.image  = [UIImage imageNamed:@"Computer"]; // 也可以先转为NSData
    textAttach.bounds = CGRectMake(0, 0, 40, 40);
    
    NSAttributedString *textAttr = [NSAttributedString attributedStringWithAttachment:textAttach];
    [self.attributedString insertAttributedString:textAttr atIndex:2];
}

#pragma mark - 链接
/*
    设置链接属性，对象是NSURL点击后调用浏览器打开指定URL地址
    如果是要Label效果, 用 继承UIView(label+label)效果最好,  还有label+button, 富文本
        https://github.com/DWadeIsTheBest/clickLabel/tree/master
 */
- (void) link
{
    UITextView *textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.frame = CGRectMake(20, 20, 100, 100);
    [self.view addSubview:textView];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"我是NSLinkAttributeName 测试 百度"];
    [attrStr addAttribute: NSLinkAttributeName value:[NSURL URLWithString: @"http://www.baidu.com"] range: NSMakeRange(0, attrStr.length)];
    textView.attributedText = attrStr;
}


#pragma mark - 基线偏移
/*
    正值上偏, 负值下偏
 */
- (void) baseLine
{
    [self.attributedString addAttribute:NSBaselineOffsetAttributeName value:@(10) range:NSMakeRange(0, 10)];
}



#pragma mark - 倾斜
/*
 正值右倾, 负值左倾
 */
- (void) obliqueness
{
    [self.attributedString addAttribute:NSObliquenessAttributeName value:@(0.5) range:self.range];
}


#pragma mark - 横向拉伸
/*
 正值横向拉伸, 负值横向压缩
 */
- (void) expansion
{
    [self.attributedString addAttribute:NSExpansionAttributeName value:@(-1) range:self.range];
}


#pragma mark - 文字书写方向
/*
 @[@(NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding)]
 @[@(NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding)]
 @[@(NSWritingDirectionLeftToRight|NSWritingDirectionOverride)]
 @[@(NSWritingDirectionRightToLeft|NSWritingDirectionOverride)]
 */
- (void) writingDirection
{
    [self.attributedString addAttribute:NSWritingDirectionAttributeName value:@[@(NSWritingDirectionRightToLeft|NSWritingDirectionOverride)] range:self.range];
}


#pragma mark - 文本方向
/*
    0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义
 */
- (void) verticalGlyph
{
    [self.attributedString addAttribute:NSVerticalGlyphFormAttributeName value:@(0) range:self.range];
}


#pragma mark - HTML等显示
/*
    NSDocumentTypeDocumentAttribute
 
    UIKIT_EXTERN NSString * const NSPlainTextDocumentType
    UIKIT_EXTERN NSString * const NSRTFTextDocumentType
    UIKIT_EXTERN NSString * const NSRTFDTextDocumentType
    UIKIT_EXTERN NSString * const NSHTMLTextDocumentType
 */
- (void)document
{
    NSString * htmlString = @"<html><body> Some html string \n <font size=\"13\" color=\"red\">This is some text!This is some text!This is some text!This is some text!This is some text!</font> </body></html>";
    NSData *htmlData = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    
    self.attributedString = [[NSMutableAttributedString alloc] initWithData:htmlData
                                                                    options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                         documentAttributes:nil
                                                                      error:nil];
}
#pragma mark - 
#pragma mark - 
#pragma mark - 
#pragma mark - 
#pragma mark - 
#pragma mark - 
#pragma mark -





#pragma mark - Action
- (IBAction)countAdd:(UIButton *)sender {
    count ++;
    self.countLabel.text = [NSString stringWithFormat:@"%d", count];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:self.label.attributedText];
    [attr addAttribute:NSUnderlineStyleAttributeName value:@(count) range:NSMakeRange(0, text.length)];
    
    self.label.attributedText = attr;
    
}

@end
