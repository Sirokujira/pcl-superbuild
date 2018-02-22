// Objective-C++ objective-c class to interface with C++ Library
#import <Foundation/Foundation.h>

// typedef struct {
//     float x;
//     float y;
//     float z;
//     float r;
//     float g;
//     float b;
//     float a;
// } Vertex;
// Swift/Object-C �Ɠ_�Q�f�[�^������肷��ۂ̍\���̂��`����
// struct SwiftPointXYZRGBA{
//     float x;
//     float y;
//     float z;
//     float r;
//     float g;
//     float b;
//     float a;
// };
// 
// typedef struct SwiftPointXYZRGBA SwiftPointXYZRGBA;
struct float3 {
    float x;
    float y;
    float z;
};

struct float3 fc(const float **);
struct float3 fc2(float [][3]);

@interface PointCloudLibraryInterface : NSObject

@property (nonatomic, copy) NSArray *pointArray;

- (void)callLoad:(NSString *)argString;
- (void)callFiltering;
// - (void)setPointCloudData:(NSArray<NSValue *>)pointArray;
- (NSArray<NSValue *>)GetPointCloudData;
@end
