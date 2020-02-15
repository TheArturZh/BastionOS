#include "cpuid.h"

int* cpuid::call(int leaf_a, int leaf_c, int* where){
	asm volatile("cpuid"
	             :"=a"(where[0]),"=b"(where[1]),
	              "=c"(where[2]),"=d"(where[3])
	             :"a"(leaf_a), "c"(leaf_c) );
	return where;
}

char* cpuid::processor_brand_string(char* string_base){
	call(0x80000002, 0, (int*) (string_base));
	call(0x80000003, 0, (int*) (string_base+16));
	call(0x80000004, 0, (int*) (string_base+32));

	return string_base;
}

char* cpuid::vendor_id_string(char* string_base){
	int cpuid_result[4];
	call(0, 0, cpuid_result);

	int* reg_arr = (int*) string_base;

	reg_arr[0] = cpuid_result[1];
	reg_arr[1] = cpuid_result[3];
	reg_arr[2] = cpuid_result[2];

	string_base[12] = 0;

	return string_base;
}

int cpuid::highest_basic(){
	int cpuid_result[4];
	call(0, 0, cpuid_result);
	return cpuid_result[0];
}

int cpuid::highest_extended(){
	int cpuid_result[4];
	call(0x80000000, 0, cpuid_result);
	return cpuid_result[0];
}

cpuid::cpu_version_info_struct cpuid::processor_version_information(){
	int cpuid_result[4];
	call(0, 0, cpuid_result);

	//Why I can't just reinterpret it? PepeHands
	return cpu_version_info_struct {
		cpuid_result[0],
		cpuid_result[0] >> 4,
		cpuid_result[0] >> 8,
		cpuid_result[0] >> 12,
		0,
		cpuid_result[0] >> 16,
		cpuid_result[0] >> 20,
		0
	};
}

cpuid::enum_processor_types cpuid::processor_type(){
	int cpuid_result[4];
	call(0, 0, cpuid_result);
	return static_cast<enum_processor_types> ( (cpuid_result[0] >> 13 ) & 0b11 );
}

bool cpuid::check(cpuid::feature feature){
	unsigned short feature_us = (unsigned short) feature;

	int cpuid_result[4];

	if (feature_us < 64){
		call(0, 0, cpuid_result);

		if (feature_us < 32){
			return (cpuid_result[3]) & (1 << feature_us);
		}else{
			return (cpuid_result[2]) & (1 << (feature_us - 32));
		}
	}else if(feature_us < 160){
		call(7, 0, cpuid_result);

		if (feature_us < 96){
			return (cpuid_result[1]) & (1 << (feature_us - 64));
		}else if(feature_us < 128){
			return (cpuid_result[2]) & (1 << (feature_us - 96));
		}else{
			return (cpuid_result[3]) & (1 << (feature_us - 128));
		}
	}else if(feature_us < 192){
		call(7, 1, cpuid_result);

		return (cpuid_result[1]) & (1 << (feature_us - 160));
	}else if(feature_us < 256){
		call(0x80000001, 1, cpuid_result);

		if(feature_us < 224){
			return (cpuid_result[3]) & (1 << (feature_us - 192));
		}else{
			return (cpuid_result[2]) & (1 << (feature_us - 224));
		}
	}

	return false;
}