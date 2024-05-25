#include "transpose.h"

/* The naive transpose function as a reference. */
void transpose_naive(int n, int blocksize, int *dst, int *src) {
    for (int x = 0; x < n; x++) {
        for (int y = 0; y < n; y++) {
            dst[y + x * n] = src[x + y * n];
        }
    }
}

/* Implement cache blocking below. You should NOT assume that n is a
 * multiple of the block size. */
void transpose_blocking(int n, int blocksize, int *dst, int *src) {
    // YOUR CODE HERE
    int block_n = n / blocksize + 1;
    int cur_x, cur_y;
    for (int r = 0;  r < block_n; r++) {
        for (int c = 0; c < block_n; c++) {
            for (int x = 0; x < blocksize; x++) {
                for (int y = 0; y < blocksize; y++) {
                    cur_x = x + c * blocksize;
                    cur_y = y + r * blocksize;

                    if (cur_x >= n || cur_y >= n) {
                        continue;
                    }

                    dst[cur_y + cur_x * n] = src[cur_x + cur_y * n];
                }
            }
        }
    }
}
