
#ifndef __PointCloudWrapper_h
#define __PointCloudWrapper_h

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
    void Load(const std::string& filename);

    // Feature
    // Filter
    void FilterAxis(const std::string& axis, double min, double max);

private:
    // namespace �̎g�p��NG
    // ���H�O�f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud;
    // ���H��f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud_filtered;
    float* pointdata;
};

#endif // __PointCloudWrapper_h


