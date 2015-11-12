/**
 * f2fs_format_utils.c
 *
 * Copyright (c) 2014 Samsung Electronics Co., Ltd.
 *             http://www.samsung.com/
 *
 * Dual licensed under the GPL or LGPL version 2 licenses.
 */
#define _LARGEFILE_SOURCE
#define _LARGEFILE64_SOURCE
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <fcntl.h>

#include "f2fs_fs.h"

#if defined(__linux__)
#include <linux/fs.h>
#include <linux/falloc.h>
#endif

int __attribute__((weak)) f2fs_trim_device()
{
	unsigned long long range[2];
	struct stat stat_buf;

	if (!config.trim)
		return 0;

	range[0] = 0;
	range[1] = config.total_sectors * config.sector_size;

	if (fstat(config.fd, &stat_buf) < 0 ) {
		MSG(1, "\tError: Failed to get the device stat!!!\n");
		return -1;
	}

#if defined(__linux__) && defined(BLKDISCARD)
	MSG(0, "Info: Discarding device: %lu sectors\n", config.total_sectors);
	if (S_ISREG(stat_buf.st_mode)) {
#if defined(HAVE_FALLOCATE) && defined(FALLOC_FL_PUNCH_HOLE)
		if (fallocate(config.fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
				range[0], range[1]) < 0) {
			MSG(0, "Info: fallocate(PUNCH_HOLE|KEEP_SIZE) is failed\n");
		}
#endif
		return 0;
	} else if (S_ISBLK(stat_buf.st_mode)) {
#if defined(BLKSECDISCARD)
		if (ioctl(config.fd, BLKSECDISCARD, &range) < 0) {
#endif
			if (ioctl(config.fd, BLKDISCARD, &range) < 0) {
				MSG(0, "Info: This device doesn't support TRIM\n");
			} else {
				MSG(0, "Info: Wipe via secure discard failed, used discard instead\n");
			}
#if defined(BLKSECDISCARD)
		}
#endif
	} else
		return -1;
#endif
	return 0;
}

