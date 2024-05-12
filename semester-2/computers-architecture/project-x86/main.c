#define BMP_SIGNATURE 0x4d42

#define SUCCESS         0x00000000
#define NO_BARCODE      0x00000001
#define WRONG_SET       0x00000002
#define WRONG_CHECKSUM  0x00000003
#define WRONG_CODE      0x00000004
#define TOO_WIDE        0x00000005

//#pragma pack(push, 1)

//#pragma pack(pop)

#include <string.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>
#include <sys/stat.h>

extern int code(unsigned char* img, char* text, unsigned int img_height);


int main()
{
    char text[] = "0123";
    int text_len = strlen(text);
    int row, column;
    int width = (text_len+5) * 11;
    width += 4 - (width % 4);
    int height = 64;
    int size = width * height * 3;
    if (width > 768) {
        printf("Barcode is too long");
        return 1;
    }


    char header[54] = { 0 };
    strcpy(header, "BM");
    memset(&header[2],  (int)(54 + size), 1);
    memset(&header[10], (int)54, 1);//always 54
    memset(&header[14], (int)40, 1);//always 40
    memset(&header[18], (int)width, 1);
    memset(&header[22], (int)height, 1);
    memset(&header[26], (short)1, 1);
    memset(&header[28], (short)24, 1);//24 bit
    memset(&header[34], (int)size, 1);//pixel size

    unsigned char *pixels = malloc(size);
    int result;
    int img_height = width * 3-2;
    code(pixels, text, img_height);

    FILE *fout = fopen("code128.bmp", "wb");
    fwrite(header, 1, 54, fout);
    fwrite(pixels, 1, size, fout);
    free(pixels);
    fclose(fout);
    return 0;
}
