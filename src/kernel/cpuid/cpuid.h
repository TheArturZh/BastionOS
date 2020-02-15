#ifndef CPUID_H_
#define CPUID_H_

namespace cpuid {
	//Had fun, so will you
	enum class feature : unsigned short {
		//EAX = 1, check in EDX (0-31)
		FPU = 0,
		VME,
		Debugging_Extensions,
		Page_Size_Extension,
		Time_Stamp_Counter,
		Model_Specific_Registers,
		Physical_Address_Extension,
		Machine_Check_Exception,
		CX8,
		APIC,
		//reserved - bit 10
		SEP = 11,
		Memory_Type_Range_Registers,
		Paging,
		Machine_Check_Architecture,
		Conditional_Move,
		Page_Attribute_Table,
		Page_Size_Extension_36bit,
		Processor_Serial_Number,
		CLFSH,
		//reserved - bit 20
		Debug_Store = 21,
		ACPI,
		MMX,
		FXSR,
		SSE,
		SSE2,
		Self_Snoop,
		Hyper_Threading,
		Thermal_Monitor,
		IA64,
		Pending_Break_Table,

		//EAX = 1, check in ECX (32-63)
		SSE3 = 32,
		Carry_Less_Multiplication,
		Debug_Store_64bit,
		MONITOR_and_MWAIT,
		Debug_Store_CPL_Qualified,
		VMX,
		Safer_Mode_Extensions,
		Enhanced_SpeedStep,
		Thermal_Monitor2,
		Supplemental_SSE3,
		L1_Context_ID,
		Silicon_Debug_Interface,
		FMA3,
		CX16,
		XTPR,
		Perfmon_And_Debug_Compat,
		//reserved - bit 16
		Process_Context_Indentifiers = 49,
		DCA,
		SSE4_1,
		SSE4_2,
		x2APIC,
		MOVBE,
		POPCNT,
		TSC_Deadline,
		AES,
		XSAVE,
		OSXSAVE,
		AVX,
		F16C,
		RDRAND,
		Hypervisor,

		//EAX = 7, ECX = 0, check in EBX (64-95)
		FSGSBASE = 64,
		IA32_TSC_ADJUST,
		Software_Guard_Extensions,
		Bit_Manipulation_Instruction_Set_1,
		TSX_Hardware_Lock_Elison,
		AVX2,
		//reserved - bit 6
		Supervisor_Mode_Execution_Prevention = 71,
		Bit_Manipulation_Instruction_Set_2,
		ERMS,
		INVPCID,
		TSX_Restricted_Transactional_Memory,
		Platform_Quality_of_Service_Monitoring,
		FPU_CS_FPU_DS_Deprecated,
		Intel_Memory_Protection_Extensions,
		Platform_Quality_of_Service_Enforcement,
		AVX512_Foundation,
		AVX512_DW_QW_Instructions,
		RDSEED,
		Intel_ADX,
		Supervisor_Mode_Access_Prevention,
		AVX512_IFMA,
		PCOMMIT,
		CLFLUSHOPT,
		CLWB,
		Intel_Processor_Trace,
		AVX512_Prefetch,
		AVX512_ER,
		AVX512_CD,
		SHA,
		AVX512_BW,
		AVX512_VL,

		//EAX = 7, ECX = 0, check in ECX (96-127)
		PREFETCHWT1 = 96,
		AVX512_VBMI,
		User_Mode_Instruction_Prevention,
		PKU,
		OS_PKU,
		WAITPKG,
		AVX512_VBMI2,
		SHSTK,
		Galois_Field_Instructions,
		VEX256_AES,
		VEX256_CLMUL,
		AVX512_VNNI,
		AVX512_BITALG,
		//reserved - bit 13
		AVX512_VPOPCNTDQ = 110,
		//reserved - bit 15
		PML5 = 112,
		//bit 17 - 21: MAWAU
		Read_Processor_ID = 118,
		//reserved - bit 23
		//reserved - bit 24
		CLDEMOTE = 121,
		//reserved - bit 26
		MOVDIR = 123,
		MOVDIR64B,
		//reserved - bit 29
		SGX_Launch_Configuration = 126,
		//reserved - bit 31

		//EAX = 7, ECX = 0, check in EDX (128-159)
		//reserved - bit 0
		//reserved - bit 1
		AVX512_4VNNIW = 130,
		AVX512_4FMAPS,
		FSRM,
		//reserved - bits 5-17
		PCONFIG = 146,
		//reserved - bit 19
		IBT = 148,
		//reserved - bits 21-25
		IBRS_IBPB = 154,
		STIBP,
		//reserved - bit 28
		CAPABILITIES = 157,
		//reserved - bit 30
		SSBD = 159,

		//Extended Features
		//EAX = 7, ECX = 1, check in EAX (160-191)
		//reversed - bits 0-4
		AVX512_BF16 = 165,
		//reserved - bits 6-31

		//EAX = 0x80000001, check in EDX (192-223)
		//bits 0-17: repeated from EAX = 1
		Multiprocessor_Capable = 211,
		No_Execute_Bit,
		Extended_MMX = 214,
		FXSR_Optimizations = 217,
		PDPE_1GB,
		RDTSCP,
		Long_Mode = 221,
		_3DNow_Extended,
		_3DNow,

		//EAX = 0x80000001, check in ECX (224-256)
		LAHF_LM,
		cmp_legacy,
		Secure_Virtual_Machine,
		Extended_APIC_Space,
		CR8_Legacy,
		Advanced_Bit_Manipulation,
		SSE4a,
		Misaligned_SSE,
		_3DNow_Prefetch,
		OS_Visible_Workaround,
		Instruction_Based_Sampling,
		XOP,
		SKINIT,
		Watchdog_Timer,
		//reserved - bit 14
		Light_Weight_Profiling = 239,
		FMA4,
		Translation_Cache_Extension,
		//reserved - bit 18
		NodeID_MSR = 243,
		//reserved - bit 20
		Trailing_Bit_Manipulation = 245,
		Topology_Extensions,
		PERFCTR_Core,
		PERFCTR_NB,
		//reserved - bit 25
		Data_Breakpoint_Extensions = 250,
		Performance_TSC,
		PCX_L2I,
		//reserved - bits 29-31
	};

	enum class enum_processor_types : char {
		OEM,
		Intel_Overdrive,
		Dual_Processor,
	};

	struct cpu_version_info_struct {
		int Stepping_ID : 4;
		int Model_ID : 4;
		int Family_ID : 4;
		int Processor_Type : 2;
		int reserved : 2;
		int Extended_Model_ID : 4;
		int Extended_Family_ID : 8;
		int reserved_2 : 4;
	}__attribute__((packed));

	int* call(int leaf_a, int leaf_c, int* where);

	char* vendor_id_string(char* where);
	char* processor_brand_string(char* where);
	cpuid::enum_processor_types processor_type();
	cpuid::cpu_version_info_struct processor_version_information();

	bool check(cpuid::feature feature_enum);

	int highest_basic();
	int highest_extended();
}

#endif