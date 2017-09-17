#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <stdint.h>

int
scan(FILE *fp, char *buf, char dum, int print) {
	if (fread(buf, 1, dum, fp) != dum) {
		printf("Read: %s\n", strerror(errno));
		return 1;
	}
	if (print) {
		printf("\t");
		for (int i = 0; i < dum; ++i) {
//			printf("%2d %02x %c\n", i, (unsigned char)buf[i], buf[i]);
			printf("%02x.", (uint8_t)buf[i]);
		}
		printf("\n");
	}
	return 0;
}

typedef union intbyte {
	int i;
	char b[4];
} intbyte_t;

int
makeInteger(char * buf) {
	intbyte_t x;
	x.i = 0;
	x.b[1] = buf[1];
	x.b[0] = buf[0];
	return x.i;
}

int
get_item(FILE *fp) {
	char num;
	char buf[256];
	int dum = 0;
	unsigned long value = 0;
	uint8_t type;
	uint16_t low, mid, high;
	int align, cursed, special;

	scan(fp, buf, 16, 0);
	buf[buf[0] + 1] = 0;
	printf("Identified Name    : %s\n", &buf[1]);

	scan(fp, buf, 16, 0);
	buf[buf[0] + 1] = 0;
	printf("Un-identified Name : %s\n", &buf[1]);

	scan(fp, buf, 2, 1);
	type = makeInteger(buf);
	printf("Type               : %d\n", type);
	switch (type) {
		case 0: // error?
		case 1: // armor
		case 2: // shield
		case 3: // helm
		case 5: // potion, scroll
		case 6: // amulet
			scan(fp, buf, 2, 0);
			align = makeInteger(buf);
			printf("Align              : %d\n", align);

			scan(fp, buf, 2, 0);
			cursed = makeInteger(buf);
			printf("Cursed             : %d\n", cursed);

			scan(fp, buf, 2, 0);
			special = makeInteger(buf);
			printf("Special            : %d\n", special);

			scan(fp, buf, 4, 1);

			scan(fp, buf, 2, 0);
			low = makeInteger(buf);
			scan(fp, buf, 2, 0);
			mid = makeInteger(buf);
			scan(fp, buf, 2, 0);
			high = makeInteger(buf);
			printf("low                : %d\n", low);
			printf("mid                : %d\n", mid);
			printf("high               : %d\n", high);
			value = low + (mid * 10000) + (high * 10000 * 10000);
			printf("Value              : %ld\n", value);
			
			scan(fp, buf, 6, 1);
			scan(fp, buf, 1, 1);
			scan(fp, buf, 7, 1);
			scan(fp, buf, 1, 0);
			printf("Armor Class        : %d\n", (int8_t)buf[0]);
			scan(fp, buf, 13, 1);
			break;
		case 90: // error?
			scan(fp, buf, 1, 1);
			break;
		default:
			break;

	}

	return 0;
}


int
main(int argc, char *argv[]) {

	FILE *fp;
	unsigned long start;

	if (argc < 3) {
		printf("Please specify an input file & start index (hex).\n");
		return 1;
	}

	fp = fopen(argv[1], "rb");
	if (NULL == fp) {
		printf("Unable to open input file: %s\n", strerror(errno));
		return 1;
	}

	start = strtoul(argv[2], NULL, 16);
	if (errno) {
		printf("Failed to parse start point: %s\n", strerror(errno));
		goto error_exit;
	}

	printf("Starting scan at offset 0x%lx\n", start);
	if (fseek(fp, start, SEEK_SET)) {
		printf("Failed to skip to start: %s\n", strerror(errno));
		goto error_exit;
	}


	for (int i = 0; i < 10; ++i) {
		if (get_item(fp)) {
			goto error_exit;
		}
	}

	fclose(fp);
	return 0;

error_exit:
	fclose(fp);
	return 1;
}