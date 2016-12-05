LOCAL_PATH:= $(call my-dir)

# f2fs-tools depends on Linux kernel headers being in the system include path.
ifneq (,$(filter linux darwin,$(HOST_OS)))

# The versions depend on $(LOCAL_PATH)/VERSION
version_CFLAGS := -DF2FS_MAJOR_VERSION=1 -DF2FS_MINOR_VERSION=7 -DF2FS_TOOLS_VERSION=\"1.7.0\" -DF2FS_TOOLS_DATE=\"2016-07-28\"

# external/e2fsprogs/lib is needed for uuid/uuid.h
common_C_INCLUDES := $(LOCAL_PATH)/include external/e2fsprogs/lib/ $(LOCAL_PATH)/mkfs

# fsck.f2fs forces a full file system scan whenever /proc/version changes
ifeq ($(F2FS_DISABLE_FORCED_CHECK), true)
    DISABLE_FORCED_CHECK_FLAG := -DDISABLE_FORCED_CHECK
endif

#----------------------------------------------------------
libf2fs_src_files := lib/libf2fs.c lib/libf2fs_io.c lib/zbc.c

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs
LOCAL_SRC_FILES := $(libf2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_SHARED_LIBRARIES := libext2_uuid libsparse libz
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_static
LOCAL_SRC_FILES := $(libf2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
mkfs_f2fs_src_files := \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \
	mkfs/f2fs_format_main.c

include $(CLEAR_VARS)
LOCAL_MODULE := mkfs.f2fs
LOCAL_SRC_FILES := $(mkfs_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_CLANG := false
LOCAL_SHARED_LIBRARIES := libf2fs libext2_uuid
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_mkfs_static
LOCAL_SRC_FILES := $(mkfs_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS) -Dmain=mkfs_f2fs_main
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
fsck_f2fs_src_files := \
	fsck/defrag.c \
	fsck/dir.c \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/node.c \
	fsck/resize.c \
	fsck/segment.c \
	fsck/sload.c \
	fsck/xattr.c

include $(CLEAR_VARS)
LOCAL_MODULE := fsck.f2fs
LOCAL_SRC_FILES := $(fsck_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS) $(DISABLE_FORCED_CHECK_FLAG)
LOCAL_SHARED_LIBRARIES := libf2fs libselinux
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fsck_static
LOCAL_SRC_FILES := $(fsck_f2fs_src_files)
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS) -Dmain=fsck_f2fs_main $(DISABLE_FORCED_CHECK_FLAG)
LOCAL_STATIC_LIBRARIES := libselinux
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt-host
LOCAL_SRC_FILES := \
    lib/libf2fs.c \
    lib/zbc.c \
    mkfs/f2fs_format.c \
    mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_EXPORT_CFLAGS := $(version_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_HOST_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host_dyn
LOCAL_SRC_FILES := \
    lib/libf2fs.c \
    lib/zbc.c \
    mkfs/f2fs_format.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS) -DANDROID_HOST
LOCAL_EXPORT_CFLAGS := $(version_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
LOCAL_STATIC_LIBRARIES := \
     libf2fs_fmt-host \
     libf2fs_ioutils_host \
     libext2_uuid-host \
     libsparse_host \
     libz
# LOCAL_LDLIBS := -ldl
include $(BUILD_HOST_SHARED_LIBRARY)

endif
