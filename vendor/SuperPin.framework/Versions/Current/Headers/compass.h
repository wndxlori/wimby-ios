// Compass is our C99 Quadtree implementation, used internally by SPAnnotationsIndex

#ifndef DOXYGEN_SHOULD_SKIP_THIS

typedef struct { double x; double y; } CompassPoint;
typedef struct { double width; double height; } CompassSize;
typedef struct { CompassPoint origin; CompassSize size; } CompassRect;

typedef struct _Compass Compass;

typedef void (*CompassFindCallback)(CompassPoint point, void *payload, void *context);

Compass* compass_create(int maxLevel, CompassRect rect);
void compass_destroy(Compass* config);
void compass_add_point(Compass* compass, CompassPoint point, void *payload);
void compass_remove_payload_at_point(Compass* compass, CompassPoint point, void *payload);
unsigned int compass_find_points_in_rect(Compass* compass, CompassRect rect, CompassFindCallback callback, void *callback_context);
unsigned int compass_visit_all(Compass *config, CompassFindCallback callback, void *callback_context);

static inline CompassRect CompassMakeRect(double x, double y, double w, double h) {
    CompassRect rect={{x,y},{w,h}};
    return rect;
}

static inline CompassPoint CompassMakePoint(double x, double y) {
    CompassPoint p={x,y};
    return p;
}

#endif /* DOXYGEN_SHOULD_SKIP_THIS */

