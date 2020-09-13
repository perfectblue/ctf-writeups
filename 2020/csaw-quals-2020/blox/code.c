#include "util.h" // hidden for simplicity
#include "proprietary.h" // hidden for complexity

#define TTR_NONE 0
#define TTR_I 1
#define TTR_J 2
#define TTR_L 3
#define TTR_O 4
#define TTR_S 5
#define TTR_Z 6
#define TTR_T 7
#define NTTR_TYPES 7
#define TTR_GHOST 8

#define RAND_MINO() (1+rand()%NTTR_TYPES)

// [type][orientation][i] = (x,y) of mino
// a list of position of each of 4 minos in tetramino for each possible shape&orientation
unsigned char shapes[NTTR_TYPES+1][4][4][2] = {
    {}, // none
    { // I
        {{0, 0}, {1, 0}, {2, 0}, {3, 0}},
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}},
        {{0, 0}, {1, 0}, {2, 0}, {3, 0}},
        {{0, 0}, {0, 1}, {0, 2}, {0, 3}}
    },
    { // J
        {{0, 0}, {0, 1}, {1, 1}, {2, 1}},
        {{0, 0}, {0, 1}, {0, 2}, {1, 0}},
        {{0, 0}, {1, 0}, {2, 0}, {2, 1}},
        {{1, 0}, {1, 1}, {1, 2}, {0, 2}}
    },
    { // L
        {{0, 1}, {1, 1}, {2, 1}, {2, 0}},
        {{0, 0}, {0, 1}, {0, 2}, {1, 2}},
        {{0, 0}, {1, 0}, {2, 0}, {0, 1}},
        {{0, 0}, {1, 0}, {1, 1}, {1, 2}},
    },
    { // O
        {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
        {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
        {{0, 0}, {0, 1}, {1, 0}, {1, 1}},
        {{0, 0}, {0, 1}, {1, 0}, {1, 1}}
    },
    { // S
        {{1, 0}, {2, 0}, {0, 1}, {1, 1}},
        {{0, 0}, {0, 1}, {1, 1}, {1, 2}},
        {{1, 0}, {2, 0}, {0, 1}, {1, 1}},
        {{0, 0}, {0, 1}, {1, 1}, {1, 2}}
    },
    { // Z
        {{0, 0}, {1, 0}, {1, 1}, {2, 1}},
        {{1, 0}, {1, 1}, {0, 1}, {0, 2}},
        {{0, 0}, {1, 0}, {1, 1}, {2, 1}},
        {{1, 0}, {1, 1}, {0, 1}, {0, 2}}
    },
    { // T
        {{0, 1}, {1, 0}, {1, 1}, {2, 1}},
        {{0, 0}, {0, 1}, {0, 2}, {1, 1}},
        {{0, 0}, {1, 0}, {1, 1}, {2, 0}},
        {{0, 1}, {1, 0}, {1, 1}, {1, 2}}
    }
};

#define FOR_EACH_BLK(typ, x, y, orient, v) do { \
    for (int __i = 0; __i < 4; __i++) { \
        v( (x)+shapes[(typ)][(orient)][__i][0], (y)+shapes[(typ)][(orient)][__i][1] ); \
    } \
} while (0)


#define NHIGH_SCORES 5
unsigned int high_scores[NHIGH_SCORES];
char* high_score_names[NHIGH_SCORES];

bool cheats_enabled;

#define NROWS 20
#define NCOLS 12
unsigned char g_storage, g_cur_mino, g_next_mino;
unsigned char g_x, g_y, g_orient;
unsigned int g_score;
unsigned char board[NROWS][NCOLS];

void* heap_top;
unsigned char heap[0x1000];


void* malloc(unsigned long n) {
    if (!heap_top)
        heap_top = heap;

    if (heap_top+n >= (void*)&heap[sizeof(heap)]) {
        writestr("ENOMEM\n");
        exit(1);
    }
    void* p = heap_top;
    heap_top += n;
    return p;
}


bool check_high_score() {
    unsigned int idx;
    for (idx = 0; idx < NHIGH_SCORES; idx++)
        if (g_score > high_scores[idx])
            break;
    if (idx == NHIGH_SCORES)
        return 0;

    writestr("  NEW HIGH SCORE!!!\n");
    char* name = malloc(4);
    writestr("Enter your name, press enter to confirm\n");
    writestr("___");

    int nameidx = 0;
    char c;
    while ((c = getchar()) != '\n') {
        if (c == '\b' || c == '\x7f') { // backspace characters
            if (nameidx) {
                name[--nameidx] = 0;
                redraw_name(name);
            }
        }
        else {
            if (c >= 'a' && c <= 'z')
                c -= 0x20;
            if (c >= 'A' && c <= 'Z' && nameidx < 3) {
                name[nameidx++] = c;
                redraw_name(name);
            }
        }
    }

    for (unsigned int i = NHIGH_SCORES-1; i > idx; i--) {
        high_scores[i] = high_scores[i-1];
        high_score_names[i] = high_score_names[i-1];
    }

    high_scores[idx] = g_score;
    high_score_names[idx] = name;
    return 1;
}


#define PLACE_CUR(x, y) board[y][x] = g_cur_mino
void place_cur_mino() {
    FOR_EACH_BLK(g_cur_mino, g_x, g_y, g_orient, PLACE_CUR);
}

#define PLACE_GHOST(x, y) board[y][x] = TTR_GHOST
#define PLACE_CUR(x, y) board[y][x] = g_cur_mino
#define REM_CUR(x, y) board[y][x] = TTR_NONE
void print_game_screen() {
    unsigned char og_x = g_x, og_y = g_y;

    while (move_cur_mino(0, 1));
    FOR_EACH_BLK(g_cur_mino, g_x, g_y, g_orient, PLACE_GHOST);
    FOR_EACH_BLK(g_cur_mino, og_x, og_y, g_orient, PLACE_CUR);
    
    print_board();

    FOR_EACH_BLK(g_cur_mino, g_x, g_y, g_orient, REM_CUR);
    FOR_EACH_BLK(g_cur_mino, og_x, og_y, g_orient, REM_CUR);
    g_x = og_x;
    g_y = og_y;
}

#define CHECK_NEW(x, y) do { if (board[y][x] != TTR_NONE) return 0; } while (0)
bool intro_new_mino() {
    g_cur_mino = g_next_mino;
    g_next_mino = RAND_MINO();
    g_x = NCOLS/2-1;
    g_y = 0;
    g_orient = 0;
    FOR_EACH_BLK(g_cur_mino, g_x, g_y, g_orient, CHECK_NEW);
    return 1;
}

#define CHECK_MOV(x, y) \
    do { \
        if (x < 0 || x >= NCOLS || y < 0 || y >= NROWS || board[y][x] != TTR_NONE) \
        return 0; \
    } while (0)
bool move_cur_mino(int dx, int dy) {
    FOR_EACH_BLK(g_cur_mino, g_x+dx, g_y+dy, g_orient, CHECK_MOV);
    g_x += dx;
    g_y += dy;
    return 1;
}

#define CHECK_ROT(x, y) \
    do { \
        if (x < 0 || x >= NCOLS || y < 0 || y >= NROWS || board[y][x] != TTR_NONE) \
            return; \
    } while (0)
void rot_cur_mino(int dir) {
    FOR_EACH_BLK(g_cur_mino, g_x, g_y, (g_orient+dir)&3, CHECK_ROT);
    g_orient = (g_orient+dir)&3;
}


// magic values for the hardware logging mechanism
// hacking is grounds for voiding this machine's warranty
#define LOG_CHEATING 0xbadb01
#define LOG_HACKING 0x41414141
void hw_log(int reason) {
    syscall(1337, reason);
}


void check_full_lines() {
    unsigned int nfull = 0;

    for (unsigned char y = 0; y < NROWS; y++) {
        bool full = 1;
        for (unsigned char x = 0; x < NCOLS && full; x++)
            if (board[y][x] == TTR_NONE)
                full = 0;

        if (full) {
            nfull++;
            for (unsigned char ty = y; ty > 0; ty--)
                memcpy(board[ty], board[ty-1], sizeof(board[0]));
            memset(board[0], 0, sizeof(board[0]));
        }
    }

    if (nfull)
        g_score += 100+200*(nfull-1);
}


void game_loop() {
    fd_set rfds;
    FD_ZERO(&rfds);

    memset(board, 0, sizeof(board));
    g_orient = 0;
    g_score = 0;
    g_storage = TTR_NONE;
    g_next_mino = RAND_MINO();
    bool game_over = !intro_new_mino();
    bool can_store = 1;

#define TICK_DURATION 1000000
    while (!game_over) {
        long tick_start = current_time();
        long tick_end = tick_start + TICK_DURATION;
        struct timeval timeout = {0, TICK_DURATION};
        bool mino_placed = 0, tick_done = 0;

        while (!tick_done) {
            print_game_screen();

            FD_SET(0, &rfds);
            int ret = select(1, &rfds, 0, 0, &timeout);
            if (ret < 0)
                exit(1);

            // timeout expired
            if (!ret)
                tick_done = 1;
            else {
                // note: arrow keys magically translated to wasd
                char op = getchar();
                if (op == 'w' || op == 'x')
                    rot_cur_mino(1);
                else if (op == 'a')
                    move_cur_mino(-1, 0);
                else if (op == 's') {
                    tick_done = 1;
                    g_score++;
                }
                else if (op == 'd')
                    move_cur_mino(1, 0);
                else if (op == 'z')
                    rot_cur_mino(-1);
                else if (op == 'c') {
                    if (can_store) {
                        unsigned char tmp = g_storage;
                        g_storage = g_cur_mino;
                        g_cur_mino = tmp;
                        if (g_cur_mino == TTR_NONE) {
                            game_over = !intro_new_mino();
                            tick_done = game_over;
                        }
                        else {
                            g_x = NCOLS/2-1;
                            g_y = 0;
                            g_orient = 0;
                        }
                        can_store = 0;
                    }
                }
                else if (op == ' ') {
                    while (move_cur_mino(0, 1))
                        g_score += 2;
                    tick_done = 1;
                }
                else if (cheats_enabled) {
                    int idx = str_index_of(" IJLOSZT", op);
                    if (idx > 0)
                        g_cur_mino = idx;
                }
            }

            long cur_time;
            if (tick_done || (cur_time = current_time()) >= tick_end) {
                tick_done = 1;
                mino_placed = !move_cur_mino(0, 1);
            }
            else {
                timeout.tv_sec = 0;
                timeout.tv_usec = tick_end-cur_time;
            }
        }

        if (mino_placed) {
            place_cur_mino();
            check_full_lines();
            if (!cheats_enabled && check_cheat_codes()) {
                cheats_enabled = 1;
                hw_log(LOG_CHEATING);
            }
            game_over = !intro_new_mino();
            can_store = 1;
        }
    }

    print_game_screen();
    print_game_over();
    if (!check_high_score()) {
        writestr("press enter to continue...\n");
        while (getchar() != '\n');
    }
}


unsigned char menu_selection;

int main() {
    srand(1);
    while (1) {
        print_main_menu();
        // note: arrow keys magically translated to wasd
        char op = getchar();
        if (op == '\n') {
            if (!menu_selection)
                game_loop();
            else
                break;
        }
        else if (op == 'w') {
            if (menu_selection)
                menu_selection--;
        }
        else if (op == 's') {
            if (menu_selection < 1)
                menu_selection++;
        }
    }
    return 0;
}
