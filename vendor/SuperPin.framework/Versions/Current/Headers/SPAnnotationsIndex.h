#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "compass.h"


/** Objective C wrapper around the internal Compass data structure.
 * 
 * Used internally by SPMapView.
 */
@interface SPAnnotationsIndex : NSObject {
@private
    Compass *db; /**< C data structure for efficient spatial querying */
    NSMutableSet *annotationsSet; /**< Enables an efficient allAnnotations implementation and controls retain/release for objects */
}

/** Add an annotation to the internal SuperPin data structure. 
 *
 * This retains the annotation
 */
- (void)addAnnotation:(id<MKAnnotation>)annotation;

/** Remove an annotation from the internal SuperPin data structure.
 *
 * This releases the annotation
 */
- (void)removeAnnotation:(id<MKAnnotation>)annotation;

/** Clear the internal SuperPin data strucutre.
 *
 * This method releases all annotations.
 * This method internally frees and then creates a new tree.
 */
- (void)removeAllAnnotations;

/** Find all annotations in the given MKMapRect.
 *
 * This method is 1:1 compatible to annotationsForMapRect that was introduced in iOS 4.2
 */
- (NSSet*)annotationsForMapRect:(MKMapRect)rect;

/** Return an array with all annotations
 *
 * Calling this method is no more expensive than NSSet's allObjects 
 */
- (NSArray*)allAnnotations;

@end
