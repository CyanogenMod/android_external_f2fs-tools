/**
 * f2fs_format_utils.c
 *
 * Copyright (c) 2014 Samsung Electronics Co., Ltd.
 *             http://www.samsung.com/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */
#define _LARGEFILE64_SOURCE

#include <stdio.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <linux/fs.h>

#include "include/f2fs_fs.h"

void f2fs_finalize_device()
{
	/*
	 * We should call fsync() to flush out all the dirty pages
	 * in the block device page cache.
	 */
	if (fsync(config.fd) < 0)
		MSG(0, "\tError: Could not conduct fsync!!!\n");

	if (close(config.fd) < 0)
		MSG(0, "\tError: Failed to close device file!!!\n");

}

int f2fs_trim_device()
{
	unsigned long long range[2];
	struct stat stat_buf;

	if (!config.trim)
		return 0;

	range[0] = 0;
	range[1] = config.total_sectors * DEFAULT_SECTOR_SIZE;

	if (fstat(config.fd, &stat_buf) < 0 ) {
		MSG(1, "\tError: Failed to get the device stat!!!\n");
		return -1;
	}

	MSG(0, "Info: Discarding device\n");
	if (S_ISREG(stat_buf.st_mode))
		return 0;
	else if (S_ISBLK(stat_buf.st_mode)) {
		if (ioctl(config.fd, BLKDISCARD, &range) < 0)
			MSG(0, "Info: This device doesn't support TRIM\n");
	} else
		return -1;
	return 0;
}

