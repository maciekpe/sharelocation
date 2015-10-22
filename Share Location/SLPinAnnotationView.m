#import "SLPinAnnotationView.h"
#import "Consts.h"

@implementation SLPinAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        CGRect frame = self.frame;
        frame.size = CGSizeMake(35, 35);
        self.frame = frame;
        self.calloutOffset = CGPointMake(0, -15);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:PIC_PERSON_PATH];
    [image drawInRect:CGRectMake(0, 0, 35, 35)];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
