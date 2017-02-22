#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

#define VHASHSTATESIZE 32
#define VHASHBLOCKSIZE 4
#define ROTATEUPWARDSN(x, n) (((x) << (n)) | ((x) >> (32 - (n))))
#define WSWAP(a, b, t) {t = a; a = b; b = t;}
#define ADDBYTE(b, bl, n) {bl[(n) / 4] |= (b) << (24 - (((n) % 4) * 8));}

#ifndef DEBUG
#define DEBUG 0
#endif

/* Viagra Hash -- Built for maximum length extension */


/* Vhash Context */
struct vhash_ctx {
  uint32_t state[32];
};

void vhash_init(struct vhash_ctx *);
void vhash_round(struct vhash_ctx *);
void vhash_update(struct vhash_ctx *, uint32_t (*)[VHASHBLOCKSIZE]);
void vhash_final(struct vhash_ctx *, uint32_t);
void print_block(uint32_t (*)[VHASHBLOCKSIZE]);
void print_state(struct vhash_ctx *);


void vhash_init(struct vhash_ctx *vctx) {

  /* They call them 'words' for a reason, right? */
  memcpy(&(vctx->state[0]), "vhas", sizeof(uint32_t));
  memcpy(&(vctx->state[1]), "h: r", sizeof(uint32_t));
  memcpy(&(vctx->state[2]), "ock ", sizeof(uint32_t));
  memcpy(&(vctx->state[3]), "hard", sizeof(uint32_t));
  memcpy(&(vctx->state[4]), " 102", sizeof(uint32_t));
  memcpy(&(vctx->state[5]), "4 bi", sizeof(uint32_t));
  memcpy(&(vctx->state[6]), "t se", sizeof(uint32_t));
  memcpy(&(vctx->state[7]), "curi", sizeof(uint32_t));
  memcpy(&(vctx->state[8]), "ty. ", sizeof(uint32_t));
  memcpy(&(vctx->state[9]), "For ", sizeof(uint32_t));
  memcpy(&(vctx->state[10]), "thos", sizeof(uint32_t));
  memcpy(&(vctx->state[11]), "e sp", sizeof(uint32_t));
  memcpy(&(vctx->state[12]), "ecia", sizeof(uint32_t));
  memcpy(&(vctx->state[13]), "l mo", sizeof(uint32_t));
  memcpy(&(vctx->state[14]), "mome", sizeof(uint32_t));
  memcpy(&(vctx->state[15]), "nts ", sizeof(uint32_t));
  memcpy(&(vctx->state[16]), "when", sizeof(uint32_t));
  memcpy(&(vctx->state[17]), " you", sizeof(uint32_t));
  memcpy(&(vctx->state[18]), " nee", sizeof(uint32_t));
  memcpy(&(vctx->state[19]), "d th", sizeof(uint32_t));
  memcpy(&(vctx->state[20]), "robb", sizeof(uint32_t));
  memcpy(&(vctx->state[21]), "ing ", sizeof(uint32_t));
  memcpy(&(vctx->state[22]), "perf", sizeof(uint32_t));
  memcpy(&(vctx->state[23]), "orma", sizeof(uint32_t));
  memcpy(&(vctx->state[24]), "nce.", sizeof(uint32_t));
  memcpy(&(vctx->state[25]), " Ask", sizeof(uint32_t));
  memcpy(&(vctx->state[26]), " you", sizeof(uint32_t));
  memcpy(&(vctx->state[27]), "r do", sizeof(uint32_t));
  memcpy(&(vctx->state[28]), "ctor", sizeof(uint32_t));
  memcpy(&(vctx->state[29]), " abo", sizeof(uint32_t));
  memcpy(&(vctx->state[30]), "ut v", sizeof(uint32_t));
  memcpy(&(vctx->state[31]), "hash", sizeof(uint32_t));
}


void vhash_round(struct vhash_ctx *vctx) {

  int i;
  uint32_t t; /* temp var */

  /* Add 1 to every word */
  for (i = 0; i < 32; i++) {
    vctx->state[i] += 1;
  }

  /* Rotate each each word by it's index */
  for (i = 0; i < 32; i++) {
    vctx->state[i] = ROTATEUPWARDSN(vctx->state[i], i);
  }

  /* s[n] = s[n] + s[n + 1] */
  for (i = 0; i < 32; i++) {
    vctx->state[i] += vctx->state[(i + 1) % 32];
  }

  /* s[n] = s[n] ^ s[n + 7] */
  for (i = 0; i < 32; i++) {
    vctx->state[i] ^= vctx->state[(i + 7) % 32];
  }

  /* Rotate whole thing to the left */
  t = vctx->state[0];
  for (i = 0; i < 31; i++) {
    vctx->state[i] = vctx->state[i + 1];
  }
  vctx->state[31] = t;

}


void vhash_update(struct vhash_ctx *vctx, uint32_t (*in)[VHASHBLOCKSIZE]) {

  int i;

  /* Add the input into the state */
  for (i = 0; i < 32; i++) {
    vctx->state[i] += (*in)[i % VHASHBLOCKSIZE];
  }
  /* Now do 512 rounds */
  for (i = 0; i < 512; i++) {
    vhash_round(vctx);
  }

  /* XOR the input into the state */
  for (i = 0; i < 32; i++) {
    vctx->state[i] ^= (*in)[i % VHASHBLOCKSIZE];
  }
  /* Now do 512 rounds */
  for (i = 0; i < 512; i++) {
    vhash_round(vctx);
  }
}


void vhash_final(struct vhash_ctx *vctx, uint32_t len) {

  uint32_t f[VHASHBLOCKSIZE];

  f[0] = 0x80000000;
  f[1] = len;
  f[2] = 0x00000000;
  f[3] = 0xffffffff;

  if (DEBUG) {
    fprintf(stderr, "\n");
    fprintf(stderr, "Adding final block to state:\n");
    print_block(&(f));
    fprintf(stderr, "\n");
  }

  vhash_update(vctx, &f);
}


void print_block(uint32_t (*block)[VHASHBLOCKSIZE]) {

  fprintf(stderr, "Block: %08x %08x %08x %08x\n",
    (*block)[0], (*block)[1], (*block)[2], (*block)[3]);
}


void print_state(struct vhash_ctx *vctx) {

  int i;

  fprintf(stderr, "State:\n");
  for (i = 0; i < (VHASHSTATESIZE / 4); i++) {
    fprintf(stderr, "%08x %08x %08x %08x\n",
      vctx->state[(i * 4) + 0], vctx->state[(i * 4) + 1],
      vctx->state[(i * 4) + 2], vctx->state[(i * 4) + 3]);
  }
}


void print_hash(struct vhash_ctx *vctx) {

  int i;

  for (i = 0; i < (VHASHSTATESIZE / 4); i++) {
    printf("%08x%08x%08x%08x",
     vctx->state[(i * 4) + 0], vctx->state[(i * 4) + 1],
     vctx->state[(i * 4) + 2], vctx->state[(i * 4) + 3]);
  }
}


int main(void) {

  int i;

  struct vhash_ctx vctx;
  uint32_t block[VHASHBLOCKSIZE];
  uint32_t size;
  uint8_t inbyte;
  ssize_t ret;
  int done = 0;

  vhash_init(&(vctx));
  if (DEBUG) {
    fprintf(stderr, "\n");
    fprintf(stderr, "vhash state initialized\n");
    print_state(&(vctx));
    fprintf(stderr, "\n");
  }

  size = 0;
  while (done == 0) {
    memset(&block, 0, sizeof(block));

    for (i = 0; i < (VHASHBLOCKSIZE * sizeof(uint32_t)); i++) {
      ret = read(0, &inbyte, sizeof(uint8_t));

      if (ret == 1) {
  size++;
  /*fprintf(stderr, "Got byte: %02x\n", inbyte);*/
  ADDBYTE(inbyte, block, i);
      }
      else if (ret < 1) {
  if (DEBUG) {
    fprintf(stderr, "\n");
    fprintf(stderr, "Got end of input\n");
    fprintf(stderr, "Final block padded with %ld nulls\n",
      (VHASHBLOCKSIZE * sizeof(uint32_t)) - i);
    fprintf(stderr, "\n");
  }

  done = 1;
  break;
      }
    }
    if (DEBUG) {
      fprintf(stderr, "\n");
      fprintf(stderr, "Adding block to state:\n");
      print_block(&(block));
      fprintf(stderr, "\n");
    }

    vhash_update(&(vctx), &(block));
  }
  vhash_final(&(vctx), size);

  if (DEBUG) {
    fprintf(stderr, "\n");
    fprintf(stderr, "final vhash state (this is the hash value)\n");
    print_state(&(vctx));
    fprintf(stderr, "\n");
  }

  print_hash(&(vctx));
  printf(" -\n");

  return 0;
}
