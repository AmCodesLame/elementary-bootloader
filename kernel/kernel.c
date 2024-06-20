
void print_str(char* str, char* video_memory);

void main() {
    char* video_memory = (char*) 0xb8000;
    char* str = "Hello, World!";
    while (*str != 0) {
        *video_memory = *str;
        str++;
        video_memory++;
        *video_memory = 0x0a;
        video_memory++;
    }
    // print_str(str, video_memory);

    
}

void print_str(char* str, char* video_memory) {
    
    
}
