#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SPMapView.h"

/** MKAnnotation for SPClusterView. Calculates its own centroid and MKMapRect that encompasses all contained annotations
 *
 * Used internally by SPMapView
 */
@interface SPCluster : NSObject<MKAnnotation> {
@private
    NSUInteger count; 
    MKMapPoint centroid;
    
    /** Used to calculate a encompassing map rect for this cluster */
    MKMapPoint topLeftMapPoint;
    MKMapPoint bottomRightMapPoint; /**< See topLeftMapPoint */
    
    NSMutableSet *annotations;
}

/** Number of annotations contained in this cluster */
@property(nonatomic,readonly) NSUInteger count;
/** Coordinates for the SPClusterView */
@property(nonatomic,readonly) CLLocationCoordinate2D coordinate;
/** MKMapRect that contains all annotations in this cluster */
@property(nonatomic,readonly) MKMapRect encompassingMapRect;

/** Centroid of the cluster. Calculated through add/removeMapPoint */
@property(nonatomic,readonly) MKMapPoint centroid;
#ifndef DOXYGEN_SHOULD_SKIP_THIS
/** Internal NSSet so we can split up clusters that don't get big enough for clustering. Won't ever contain more than clusteringThreshold annotations */
@property(nonatomic,readonly) NSSet* annotations;
#endif /* DOXYGEN_SHOULD_SKIP_THIS */

/** Used by SPMapView to decrease to count of contained annotation and update the cluster's centroid */
- (void)removeMapPoint:(MKMapPoint)point;
/** Used by SPMapView to add a MapPoint (but for performance reasons not the annotation object) to the cluster. Updates the cluster's centroid */
- (void)addMapPoint:(MKMapPoint)point;
/** Used by SPMapView to add an annotation to the cluster. For performance reasons SPMapView tries to use addMapPoint instead of addAnnotation whenever possible. Updates the cluster's centroid */
- (void)addAnnotation:(id<MKAnnotation>)annotation;

@end
