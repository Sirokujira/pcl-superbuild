#ifndef __PointCloudWrapper_hh
#define __PointCloudWrapper_hh

#include <string>
#include <iostream>

#include "vertex.h"

struct SwiftPointXYZ fcpp(const float **);
extern "C" struct SwiftPointXYZ fc(const float ** p) {
    return fcpp(p);
};

struct SwiftPointXYZ fcpp2(float t[3][3]);
extern "C" struct SwiftPointXYZ fc2(float t[3][3]) {
    return fcpp2(t);
};

// parameter is pointer to array of array 3 of const float
struct SwiftPointXYZ fcpp3(const float (* const t)[][3]) {
    return fcpp2(*t);
}

// ���̃t�@�C����(cpp�܂�)�ł� namespace �̎g�p��NG
class PointCloudLibraryWrapper
{
public:
    PointCloudLibraryWrapper();
    ~PointCloudLibraryWrapper();

    int PrintFoo();
    std::string foo;

    // io
    void Load(const char* filename);

    // Feature
    // Filter
    void FilterAxis(const char* axis, double min, double max);

    // Segmentation
    // float* GetPointCloudData() 
    // { 
    //     return this->pointdata;
    // }
	struct SwiftPointXYZRGBA* GetPointCloudData();
    // struct SwiftPointXYZRGBA* GetPointCloudData() 
    // {
    //     // float** ����� Convert �őΉ�����H
    //     return this->pointdata;
    // }

    // struct SwiftPointXYZ* GetPointCloudData()
    // {
    //     // float** ����� Convert �őΉ�����H
    //     return this->pointdata;
    // }

    int GetPointCloudCount() { return this->pointcount; }
    int GetPointCloudType() { return this->pointtype; }
private:
    // ���H�O�f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud;
    // ���H��f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud_filtered;
    // PointCloudLibraryConversions* conversion;
    // float** pointdata;
    SwiftPointXYZRGBA* pointdata;
    int pointcount;
    int pointtype;
};

#endif // __PointCloudWrapper_hh

