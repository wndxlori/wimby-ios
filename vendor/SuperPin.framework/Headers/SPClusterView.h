#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/** Default view for cluster annotations on the MapView.
 * 
 * If you want to replace the cluster view with your own set SPMapView's defaultClusterViewClass to [MyOwnView class].
 *
 * Your class has to support all methods as documented here.
 */
@interface SPClusterView : MKAnnotationView {
@private

}

+ (UIImage*)backgroundImage;
+ (void)setBackgroundImage:(UIImage*)image;

+ (UIFont*)font;
+ (void)setFont:(UIFont*)newFont;

+ (UIEdgeInsets)edgeInsets;
+ (void)setEdgeInsets:(UIEdgeInsets)newEdgeInsets;
    
+ (UIColor*)textColor;
+ (void)setTextColor:(UIColor*)newTextColor;

/**
 * Initializes and returns a new SPClusterView.
 * @param annotation: The SPCluster object to associate with the new view.
 * @param reuseIdentifier: To allow reuse of the annotation view SPMapView provides a string to identify it.
 */
- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier;

/**
 * Called by SPMapView when it reuses an SPClusterView.
 * @param annotation: The SPCluster object to associate with the view.
 */
- (void)setAnnotation:(id <MKAnnotation>)annotation;

/**
 * Draws the receiver’s image within the passed-in rectangle.
 *
 * To access the cluster's count use ((SPCluster*)self.annotation).count
 *
 * @param rect: The portion of the view’s bounds that needs to be updated.
 */
 - (void)drawRect:(CGRect)rect;
@end
