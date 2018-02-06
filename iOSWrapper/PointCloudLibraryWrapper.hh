
#ifndef __PointCloudWrapper_hh
#define __PointCloudWrapper_hh

#include <string>
#include <iostream>


// namespace �̎g�p��NG
class PointCloudLibraryWrapper
{
public:
    PointCloudLibraryWrapper() { std::cout << "PointCloudLibraryWrapper Created." << std::endl; }
    ~PointCloudLibraryWrapper() { std::cout << "PointCloudLibraryWrapper Destroyed." << std::endl; }

    int PrintFoo();
    std::string foo;

    // double[] GetPointData();
    // double[] GetPointData2();

    // io
    void Load(const char* filename);

    // Feature
    // Filter
    void FilterAxis(const char* axis, double min, double max);

private:
    // namespace �̎g�p��NG
    // ���H�O�f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud;
    // ���H��f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud_filtered;
    float* pointdata;
};

#endif // __PointCloudWrapper_hh


