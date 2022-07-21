#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "snake_utils.h"
#include "state.h"

/* Helper function definitions */
static char get_board_at(game_state_t* state, int x, int y);
static void set_board_at(game_state_t* state, int x, int y, char ch);
static bool is_tail(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static int incr_x(char c);
static int incr_y(char c);
static void find_head(game_state_t* state, int snum);
static char next_square(game_state_t* state, int snum);
static void update_tail(game_state_t* state, int snum);
static void update_head(game_state_t* state, int snum);
static game_state_t* create_state(int x_size, int y_size, int snums);
static bool is_snake_dir(char c);

/* Helper function to get a character from the board (already implemented for you). */
static char get_board_at(game_state_t* state, int x, int y) {
  return state->board[y][x];
}

/* Helper function to set a character on the board (already implemented for you). */
static void set_board_at(game_state_t* state, int x, int y, char ch) {
  state->board[y][x] = ch;
}

static game_state_t* create_state(int x_size, int y_size, int snums) {
  game_state_t* game = (game_state_t*) malloc(sizeof(game_state_t));
  assert(game != NULL);

  game->x_size = x_size;
  game->y_size = y_size;
  
  // init board
  game->board = (char**) malloc(sizeof(char*) * game->y_size);
  assert(game->board != NULL);

  size_t len = sizeof(char) * (game->x_size);
  for (int i = 0; i < game->y_size; i++) {
    game->board[i] = (char*) malloc(len);
    assert(game->board[i] != NULL);
    memset(game->board[i], ' ', len);
  }

  for (int j = 0; j < game->y_size; j++) {
      set_board_at(game, 0, j, '#');
      set_board_at(game, game->x_size - 1, j, '#');
  }

  for (int j = 0; j < game->x_size; j++) {
      set_board_at(game, j, 0, '#');
      set_board_at(game, j, game->y_size - 1, '#');
  }

  game->num_snakes = snums;
  game->snakes = (snake_t*) malloc(sizeof(snake_t) * game->num_snakes);
  assert(game->snakes != NULL);
  for (int i = 0; i < game->num_snakes; i++) {
    game->snakes[i].live = true;
  }

  return game;
}

#define GAME_DEFAULT_WIDTH 14
#define GAME_DEFAULT_HEIGHT 10

/* Task 1 */
game_state_t* create_default_state() {
  game_state_t* game = create_state(GAME_DEFAULT_WIDTH, GAME_DEFAULT_HEIGHT, 1); 

  set_board_at(game, 9, 2, '*');

  game->snakes[0].head_x = 5;
  game->snakes[0].head_y = 4;
  set_board_at(game, 5, 4, '>');

  game->snakes[0].tail_x = 4;
  game->snakes[0].tail_y = 4;
  set_board_at(game, 4, 4, 'd');

  return game;
}

/* Task 2 */
void free_state(game_state_t* state) {
  if (state == NULL) {
    return;
  }

  free(state->snakes);

  if (state->board != NULL) {
    for (int i = 0; i < state->y_size; i++) {
      free(state->board[i]);
    }
    free(state->board);
  }
  
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t* state, FILE* fp) {
  if (state == NULL || fp == NULL) return;
  assert(state->board != NULL);

  for (int y = 0; y < state->y_size; y++) {
    for (int x = 0; x < state->x_size; x++) {
      assert(state->board[y] != NULL);
      fprintf(fp, "%c", get_board_at(state, x, y));
    }
    fprintf(fp, "\n");
  }
  return;
}

/* Saves the current state into filename (already implemented for you). */
void save_board(game_state_t* state, char* filename) {
  FILE* f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */
static bool is_tail(char c) {
  bool res = false;
  if (c == 'w' 
      || c == 'a' 
      || c == 's' 
      || c == 'd') {
      res = true;
  }
  return res;
}

static bool is_snake(char c) {
  return strchr("wasd^<>vx", c) != NULL;
}

static bool is_snake_dir(char c) {
  return strchr("^<>v", c) != NULL;
}

static char body_to_tail(char c) {
  switch (c)
  {
  case '^':
    return 'w';
  case '<':
    return 'a';
  case '>':
    return 'd';
  case 'v':
    return 's';
  default:
    return '?';
  }
}

static int incr_x(char c) {
  if (c == '>' || c == 'd') {
    return 1;
  } else if (c == '<' || c == 'a') {
    return -1;
  }
  return 0;
}

static int incr_y(char c) {
  if (c == 'v' || c == 's') {
    return 1;
  } else if (c == '^' || c == 'w') {
    return -1;
  }
  return 0;
}

/* Task 4.2 */
static char next_square(game_state_t* state, int snum) {
  assert(state != NULL);
  assert(snum >= 0);
  assert(snum < state->num_snakes);

  snake_t snake = state->snakes[snum];
  char c = get_board_at(state, snake.head_x, snake.head_y);
  snake.head_x += incr_x(c); snake.head_y += incr_y(c);

  return get_board_at(state, snake.head_x, snake.head_y);
}

/* Task 4.3 */
static void update_head(game_state_t* state, int snum) {
  assert(state != NULL);
  assert(snum >= 0);
  assert(snum < state->num_snakes);

  snake_t* snake = &state->snakes[snum];
  
  assert(state->board != NULL);

  char c = get_board_at(state, snake->head_x, snake->head_y);
  snake->head_x += incr_x(c); snake->head_y += incr_y(c);

  set_board_at(state, snake->head_x, snake->head_y, c);
  return;
}

/* Task 4.4 */
static void update_tail(game_state_t* state, int snum) {
  assert(state != NULL);
  assert(snum >= 0);
  assert(snum < state->num_snakes);
  
  snake_t* snake = &state->snakes[snum];
  
  assert(state->board != NULL);

  char c = get_board_at(state, snake->tail_x, snake->tail_y);
  set_board_at(state, snake->tail_x, snake->tail_y, ' ');

  snake->tail_x += incr_x(c); snake->tail_y += incr_y(c);
  c = get_board_at(state, snake->tail_x, snake->tail_y);
  set_board_at(state, snake->tail_x, snake->tail_y, body_to_tail(c));
  return;
}

/* Task 4.5 */
void update_state(game_state_t* state, int (*add_food)(game_state_t* state)) {
  for (int i = 0; i < state->num_snakes; i++) {
    snake_t* snake = &state->snakes[i];
    char c = next_square(state, i);
    if (is_snake(c) || c == '#') { // died
      snake->live = false;
      set_board_at(state, snake->head_x, snake->head_y, 'x');
    } else if (c == '*') { // fruit
      update_head(state, i);
      add_food(state);
    } else { // blank
      update_head(state, i);
      update_tail(state, i);
    }
  }
  return;
}

/* Task 5 */
game_state_t* load_board(char* filename) {
  FILE* fptr = fopen(filename, "r");
  if (fptr == NULL) {
    fprintf(stderr, "file %s does not exist\n", filename);
    exit(1);
  }

  int rows = 0, cols = 0;
  char c;
  int snums = 0;
  

  // 统计 rows, cols, snums
  while ((c = fgetc(fptr)) != EOF) {
    if (c == '\n') {
      rows++;
    } else if (is_tail(c)) {
      snums++;
    }
    cols++;
  }
  // 去掉多到，\n
  cols = (cols / rows) - 1;
  game_state_t* state = create_state(cols, rows, snums);
 

  // fseek(fptr, 0, SEEK_SET);
  rewind(fptr);

  int snum = 0;
  int cur_x = 0, cur_y = 0;

  while ((c = fgetc(fptr)) != EOF) {
    if (c == '\n') {
      cur_y++;
      cur_x = 0;
      continue;
    }

    // 跳过四周wall与blank
    if (cur_x == 0
        || cur_y == 0
        || (cur_x == cols - 1)
        || (cur_y == rows - 1)
        || c == ' ') {
      cur_x++;
      continue;
    }
    
    if (is_tail(c)) {
      state->snakes[snum].tail_x = cur_x;
      state->snakes[snum].tail_y = cur_y;
      snum++;
    }

    set_board_at(state, cur_x, cur_y, c);
    cur_x++;
  }
  fclose(fptr);

// for debug
  // for (int i = 0; i < snums; i++) {
  //   int x = state->snakes[i].tail_x, y = state->snakes[i].tail_y;
  //   printf("%c %d %d\n", get_board_at(state, x, y), x, y);
  // }
  for (size_t i = 0; i < state->num_snakes; i++) {
    find_head(state, i);
  }
  return state;
}

/* Task 6.1 */
static void find_head(game_state_t* state, int snum) {
  snake_t* snake = &state->snakes[snum];

  int x = snake->tail_x, y = snake->tail_y;
  char c = get_board_at(state, x, y);
  
  int head_x = x, head_y = y;

  while (true) {
    x += incr_x(c); y += incr_y(c);
    c = get_board_at(state, x, y);
    if (!is_snake_dir(c)) break;
    head_x = x; head_y = y;
  }
  snake->head_x = head_x; snake->head_y = head_y;
  return;
}

// 没必要实现，需要重新读一遍board
/* Task 6.2 */
game_state_t* initialize_snakes(game_state_t* state) {
  return NULL;
}
