LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mkfs/f2fs_format.c lib/libf2fs.c
LOCAL_MODULE := libmake_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mkfs/main.c
LOCAL_MODULE := mkfs.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libmake_f2fs
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/main.c fsck/fsck.c fsck/dump.c fsck/mount.c lib/libf2fs.c
LOCAL_MODULE := libfsck_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/fsck_f2fs_main.c
LOCAL_MODULE := fsck.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libfsck_f2fs
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/fibmap.c
LOCAL_MODULE := libfibmap_f2fs
LOCAL_MODULE_TAGS := optional
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := fsck/fibmap_main.c
LOCAL_MODULE := fibmap.f2fs
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libfibmap_f2fs
include $(BUILD_EXECUTABLE)
