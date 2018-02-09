
#ifndef __PointCloudWrapper_hh
#define __PointCloudWrapper_hh

#include <string>
#include <iostream>


// ���̃t�@�C����(cpp�܂�)�ł� namespace �̎g�p��NG
class PointCloudLibraryWrapper
{
public:
    PointCloudLibraryWrapper() 
	{ 
		std::cout << "PointCloudLibraryWrapper Created." << std::endl; 
		// conversion = new PointCloudLibraryConversions();
	}
    ~PointCloudLibraryWrapper()
	{ 
		std::cout << "PointCloudLibraryWrapper Destroyed." << std::endl; 
		// if (conversion != NULL)
		// {
		// 	delete conversion;
		// }
	}

    int PrintFoo();
    std::string foo;

    // io
    void Load(const char* filename);

    // Feature
    // Filter
    void FilterAxis(const char* axis, double min, double max);

    // Segmentation

private:
    // ���H�O�f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud;
    // ���H��f�[�^
    // pcl::PointCloud<pcl::PointXYZ>::ConstPtr cloud_filtered;
	// PointCloudLibraryConversions* conversion;

	// 
    float* pointdata;
};

#endif // __PointCloudWrapper_hh


