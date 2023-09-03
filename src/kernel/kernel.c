// gcc -m32 -c kernel.c -o kc.o

// void kernel_main(void)
// {
//     const char *str = "Salam Bro!!!";
//     char *vidptr = (char*)0xb8000; // В защищенном режиме это начало видеопамяти
//     unsigned int i = 0;
//     unsigned int j = 0;

//     while(j < 80 * 25 * 2) {
//         vidptr[j] = ' ';
//         vidptr[j+1] = 0x07;         
//         j = j + 2;
//     }

//     j = 0;

//     while(str[j] != '\0') {
//         vidptr[i] = str[j];
//         vidptr[i+1] = 0x02;
//         ++j;
//         i = i + 2;
//     }
//     return;
// }



typedef struct {
	unsigned long long base;
	unsigned long long size;
} BootModuleInfo;

void kernel_main(char boot_disk_id, void *memory_map, BootModuleInfo *boot_module_list) {
	char *screen_buffer = (void*)0xB8000;
	char *msg = "Hello world!";
	unsigned int i = 24 * 80;
	while (*msg) {
		screen_buffer[i * 2] = *msg;
		msg++;
		i++;
	}
} 