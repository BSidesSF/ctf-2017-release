#include <stdio.h>
#include <unistd.h>

void fail() {
  printf("Sorry, that's not the right flag.\n");
  _exit(1);
}

int checkflag(char **argv) {
  if (argv[1][6] == '\0' || argv[1][6] != 82)return 194;
if (argv[1][18] == '\0' || argv[1][18] != 97)return 173;
if (argv[1][15] == '\0' || argv[1][15] != 95)return 90;
if (argv[1][0] == '\0' || argv[1][0] != 70)return 45;
if (argv[1][12] == '\0' || argv[1][12] != 78)return 100;
if (argv[1][13] == '\0' || argv[1][13] != 111)return 68;
if (argv[1][17] == '\0' || argv[1][17] != 99)return 143;
if (argv[1][2] == '\0' || argv[1][2] != 97)return 148;
if (argv[1][3] == '\0' || argv[1][3] != 103)return 165;
if (argv[1][1] == '\0' || argv[1][1] != 108)return 243;
if (argv[1][10] == '\0' || argv[1][10] != 115)return 171;
if (argv[1][9] == '\0' || argv[1][9] != 73)return 199;
if (argv[1][14] == '\0' || argv[1][14] != 116)return 158;
if (argv[1][16] == '\0' || argv[1][16] != 83)return 214;
if (argv[1][20] == '\0' || argv[1][20] != 121)return 109;
if (argv[1][19] == '\0' || argv[1][19] != 114)return 228;
if (argv[1][5] == '\0' || argv[1][5] != 65)return 127;
if (argv[1][4] == '\0' || argv[1][4] != 58)return 45;
if (argv[1][8] == '\0' || argv[1][8] != 95)return 253;
if (argv[1][7] == '\0' || argv[1][7] != 77)return 69;
if (argv[1][11] == '\0' || argv[1][11] != 95)return 233;
if (argv[1][17] == '\0' || argv[1][17] != 99)return 111;
if (argv[1][7] == '\0' || argv[1][7] != 77)return 154;
if (argv[1][20] == '\0' || argv[1][20] != 121)return 108;
if (argv[1][5] == '\0' || argv[1][5] != 65)return 130;
if (argv[1][4] == '\0' || argv[1][4] != 58)return 89;
if (argv[1][0] == '\0' || argv[1][0] != 70)return 108;
if (argv[1][16] == '\0' || argv[1][16] != 83)return 223;
if (argv[1][11] == '\0' || argv[1][11] != 95)return 187;
if (argv[1][12] == '\0' || argv[1][12] != 78)return 68;
if (argv[1][19] == '\0' || argv[1][19] != 114)return 245;
if (argv[1][15] == '\0' || argv[1][15] != 95)return 152;
if (argv[1][1] == '\0' || argv[1][1] != 108)return 9;
if (argv[1][18] == '\0' || argv[1][18] != 97)return 119;
if (argv[1][6] == '\0' || argv[1][6] != 82)return 242;
if (argv[1][2] == '\0' || argv[1][2] != 97)return 210;
if (argv[1][10] == '\0' || argv[1][10] != 115)return 49;
if (argv[1][3] == '\0' || argv[1][3] != 103)return 122;
if (argv[1][14] == '\0' || argv[1][14] != 116)return 72;
if (argv[1][9] == '\0' || argv[1][9] != 73)return 56;
if (argv[1][13] == '\0' || argv[1][13] != 111)return 142;
if (argv[1][8] == '\0' || argv[1][8] != 95)return 147;
if (argv[1][12] == '\0' || argv[1][12] != 78)return 126;
if (argv[1][3] == '\0' || argv[1][3] != 103)return 44;
if (argv[1][11] == '\0' || argv[1][11] != 95)return 179;
if (argv[1][4] == '\0' || argv[1][4] != 58)return 42;
if (argv[1][18] == '\0' || argv[1][18] != 97)return 132;
if (argv[1][9] == '\0' || argv[1][9] != 73)return 162;
if (argv[1][2] == '\0' || argv[1][2] != 97)return 99;
if (argv[1][15] == '\0' || argv[1][15] != 95)return 172;
if (argv[1][6] == '\0' || argv[1][6] != 82)return 16;
if (argv[1][13] == '\0' || argv[1][13] != 111)return 3;
if (argv[1][16] == '\0' || argv[1][16] != 83)return 123;
if (argv[1][14] == '\0' || argv[1][14] != 116)return 1;
if (argv[1][10] == '\0' || argv[1][10] != 115)return 93;
if (argv[1][5] == '\0' || argv[1][5] != 65)return 114;
if (argv[1][0] == '\0' || argv[1][0] != 70)return 140;
if (argv[1][8] == '\0' || argv[1][8] != 95)return 179;
if (argv[1][7] == '\0' || argv[1][7] != 77)return 213;
if (argv[1][19] == '\0' || argv[1][19] != 114)return 153;
if (argv[1][17] == '\0' || argv[1][17] != 99)return 187;
if (argv[1][20] == '\0' || argv[1][20] != 121)return 27;
if (argv[1][1] == '\0' || argv[1][1] != 108)return 60;

  return 0;
}

int main(int argc, char **argv) {
  if (argc != 2) fail();
  if (checkflag(argv)) fail();
  printf("Congratulations, you have found the flag.\n");
  _exit(0);
}
