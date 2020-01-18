%ifndef GDT_DEFINES_

%define GDT_DEFINES_

;Access byte
%define GDT_ACCESS_PRESENT        (1 << 7)
%define GDT_ACCESS_DESC_TYPE_DATA (1 << 4)
%define GDT_ACCESS_EXECUTABLE     (1 << 3)
%define GDT_ACCESS_DIRECTION      (1 << 2)
%define GDT_ACCESS_RW             (1 << 1)

;Flags
%define GDT_FLAG_GRANULARITY      (1 << 7)
%define GDT_FLAG_SIZE             (1 << 6)
%define GDT_FLAG_LONG_MODE        (1 << 5)

%endif