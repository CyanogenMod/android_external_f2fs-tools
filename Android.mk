LOCAL_PATH:= $(call my-dir)

LOCAL_CFLAGS := -DANDROID

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mkfs/f2fs_format.c mkfs/f2fs_format_main.c mkfs/f2fs_format_utils.c lib/libf2fs.c lib/libf2fs_io.c
LOCAL_MODULE := libmake_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mkfs/main.c
LOCAL_MODULE := mkfs.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libmake_f2fs libcutils liblog libc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/main.c fsck/fsck.c fsck/dump.c fsck/mount.c lib/libf2fs.c lib/libf2fs_io.c
LOCAL_MODULE := libfsck_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/fsck_f2fs_main.c
LOCAL_MODULE := fsck.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libfsck_f2fs libcutils liblog libc
include $(BUILD_EXECUTABLE)

SYMLINKS := $(addprefix $(TARGET_OUT)/bin/,dump.f2fs)
$(SYMLINKS):
	@echo "Symlink: $@ -> /system/bin/fsck.f2fs"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf ../bin/fsck.f2fs $@

ALL_DEFAULT_INSTALLED_MODULES += $(SYMLINKS)

ALL_MODULES.$(LOCAL_MODULE).INSTALLED := \
    $(ALL_MODULES.$(LOCAL_MODULE).INSTALLED) $(SYMLINKS)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := tools/fibmap.c
LOCAL_MODULE := libfibmap_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := tools/fibmap_main.c
LOCAL_MODULE := fibmap.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libfibmap_f2fs libcutils liblog libc
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := tools/f2fstat.c
LOCAL_MODULE := libf2fstat_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := tools/f2fstat_main.c
LOCAL_MODULE := f2fstat
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libf2fstat_f2fs libcutils liblog libc
include $(BUILD_EXECUTABLE)
