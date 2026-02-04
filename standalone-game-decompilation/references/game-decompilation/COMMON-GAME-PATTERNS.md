# Common Game Patterns

This document catalogs common patterns found in game development that are useful to recognize during decompilation.

## Initialization Patterns

### Pattern 1: Two-Phase Initialization

```c
// Phase 1: Early initialization (before window/graphics)
void early_init(void) {
    init_memory_allocator();
    init_logging();
    init_config();
}

// Phase 2: Late initialization (after window/graphics)
void late_init(void) {
    init_renderer();
    init_audio();
    load_assets();
}
```

### Pattern 2: Subsystem Registration

```c
typedef struct {
    void (*init)(void);
    void (*update)(float dt);
    void (*shutdown)(void);
} Subsystem;

Subsystem subsystems[] = {
    { init_renderer, update_renderer, shutdown_renderer },
    { init_audio, update_audio, shutdown_audio },
    // ...
};
```

## Game Loop Patterns

### Pattern 1: Fixed Timestep

```c
void game_loop(void) {
    const float fixed_dt = 1.0f / 60.0f;
    float accumulator = 0.0f;
    
    while (running) {
        float frame_time = get_frame_time();
        accumulator += frame_time;
        
        // Update with fixed timestep
        while (accumulator >= fixed_dt) {
            update_game(fixed_dt);
            accumulator -= fixed_dt;
        }
        
        render_frame();
    }
}
```

### Pattern 2: Variable Timestep with Cap

```c
void game_loop(void) {
    float last_time = get_time();
    const float max_dt = 0.1f; // Cap at 100ms
    
    while (running) {
        float current_time = get_time();
        float dt = current_time - last_time;
        last_time = current_time;
        
        if (dt > max_dt) dt = max_dt;
        
        update_game(dt);
        render_frame();
    }
}
```

## Entity Management Patterns

### Pattern 1: Array-Based Entity System

```c
#define MAX_ENTITIES 1000

typedef struct {
    bool active;
    int type;
    float x, y, z;
    // ...
} Entity;

Entity entities[MAX_ENTITIES];

Entity* spawn_entity(int type) {
    for (int i = 0; i < MAX_ENTITIES; i++) {
        if (!entities[i].active) {
            entities[i].active = true;
            entities[i].type = type;
            return &entities[i];
        }
    }
    return NULL; // No free slots
}
```

### Pattern 2: Linked List Entity System

```c
typedef struct Entity {
    int type;
    float x, y, z;
    struct Entity *next;
} Entity;

Entity *entity_list = NULL;

Entity* spawn_entity(int type) {
    Entity *entity = malloc(sizeof(Entity));
    entity->type = type;
    entity->next = entity_list;
    entity_list = entity;
    return entity;
}
```

### Pattern 3: Entity Component System (ECS)

```c
typedef struct {
    uint32_t entity_id;
    float x, y, z;
} PositionComponent;

typedef struct {
    uint32_t entity_id;
    float dx, dy, dz;
} VelocityComponent;

PositionComponent positions[MAX_ENTITIES];
VelocityComponent velocities[MAX_ENTITIES];

// Systems operate on components
void physics_system(float dt) {
    for (int i = 0; i < num_entities; i++) {
        positions[i].x += velocities[i].dx * dt;
        positions[i].y += velocities[i].dy * dt;
        positions[i].z += velocities[i].dz * dt;
    }
}
```

## Memory Management Patterns

### Pattern 1: Pool Allocator

```c
typedef struct {
    void *memory;
    size_t block_size;
    size_t num_blocks;
    void *free_list;
} MemoryPool;

void* pool_alloc(MemoryPool *pool) {
    if (pool->free_list == NULL) return NULL;
    
    void *ptr = pool->free_list;
    pool->free_list = *(void**)pool->free_list;
    return ptr;
}

void pool_free(MemoryPool *pool, void *ptr) {
    *(void**)ptr = pool->free_list;
    pool->free_list = ptr;
}
```

### Pattern 2: Frame Allocator

```c
typedef struct {
    void *buffer;
    size_t size;
    size_t offset;
} FrameAllocator;

void* frame_alloc(FrameAllocator *alloc, size_t size) {
    if (alloc->offset + size > alloc->size) return NULL;
    
    void *ptr = (char*)alloc->buffer + alloc->offset;
    alloc->offset += size;
    return ptr;
}

void frame_reset(FrameAllocator *alloc) {
    alloc->offset = 0; // Reset at frame start
}
```

## Resource Management Patterns

### Pattern 1: Reference Counting

```c
typedef struct {
    void *data;
    int ref_count;
    char name[64];
} Resource;

Resource* load_resource(const char *name) {
    // Check if already loaded
    Resource *res = find_resource(name);
    if (res) {
        res->ref_count++;
        return res;
    }
    
    // Load new resource
    res = create_resource(name);
    res->ref_count = 1;
    return res;
}

void release_resource(Resource *res) {
    res->ref_count--;
    if (res->ref_count == 0) {
        free_resource(res);
    }
}
```

### Pattern 2: Handle-Based System

```c
typedef uint32_t ResourceHandle;

typedef struct {
    void *data;
    uint32_t generation;
    bool active;
} ResourceSlot;

ResourceSlot resource_slots[MAX_RESOURCES];

ResourceHandle create_resource(void) {
    int index = find_free_slot();
    resource_slots[index].active = true;
    resource_slots[index].generation++;
    
    return (resource_slots[index].generation << 16) | index;
}

Resource* get_resource(ResourceHandle handle) {
    int index = handle & 0xFFFF;
    int generation = handle >> 16;
    
    if (resource_slots[index].generation != generation) return NULL;
    if (!resource_slots[index].active) return NULL;
    
    return &resource_slots[index];
}
```

## Rendering Patterns

### Pattern 1: Command Buffer

```c
typedef enum {
    CMD_DRAW_SPRITE,
    CMD_DRAW_TEXT,
    CMD_SET_TRANSFORM,
} CommandType;

typedef struct {
    CommandType type;
    union {
        struct { int sprite_id; float x, y; } draw_sprite;
        struct { const char *text; float x, y; } draw_text;
        struct { Matrix4x4 transform; } set_transform;
    } data;
} RenderCommand;

RenderCommand command_buffer[MAX_COMMANDS];
int num_commands = 0;

void submit_draw_sprite(int sprite_id, float x, float y) {
    command_buffer[num_commands++] = (RenderCommand){
        .type = CMD_DRAW_SPRITE,
        .data.draw_sprite = { sprite_id, x, y }
    };
}

void execute_commands(void) {
    for (int i = 0; i < num_commands; i++) {
        switch (command_buffer[i].type) {
            case CMD_DRAW_SPRITE:
                // Execute sprite draw
                break;
            // ...
        }
    }
    num_commands = 0;
}
```

### Pattern 2: Sprite Batching

```c
typedef struct {
    float x, y;
    float u, v;
    uint32_t color;
} Vertex;

typedef struct {
    int texture_id;
    Vertex *vertices;
    int vertex_count;
} SpriteBatch;

SpriteBatch current_batch;

void draw_sprite(int texture_id, float x, float y) {
    // Flush if texture changes
    if (current_batch.texture_id != texture_id) {
        flush_batch();
        current_batch.texture_id = texture_id;
    }
    
    // Add sprite vertices to batch
    add_quad_to_batch(&current_batch, x, y, ...);
}

void flush_batch(void) {
    if (current_batch.vertex_count == 0) return;
    
    bind_texture(current_batch.texture_id);
    draw_vertices(current_batch.vertices, current_batch.vertex_count);
    current_batch.vertex_count = 0;
}
```

## Input Patterns

### Pattern 1: Input State Tracking

```c
typedef struct {
    bool keys[256];
    bool keys_previous[256];
    int mouse_x, mouse_y;
    int mouse_x_previous, mouse_y_previous;
    bool mouse_buttons[5];
    bool mouse_buttons_previous[5];
} InputState;

InputState input;

bool is_key_pressed(int key) {
    return input.keys[key] && !input.keys_previous[key];
}

bool is_key_down(int key) {
    return input.keys[key];
}

void update_input(void) {
    memcpy(input.keys_previous, input.keys, sizeof(input.keys));
    memcpy(input.mouse_buttons_previous, input.mouse_buttons, sizeof(input.mouse_buttons));
    input.mouse_x_previous = input.mouse_x;
    input.mouse_y_previous = input.mouse_y;
    
    // Update current state from OS
    poll_input_events();
}
```

## State Machine Patterns

### Pattern 1: Simple State Machine

```c
typedef enum {
    STATE_MENU,
    STATE_PLAYING,
    STATE_PAUSED,
    STATE_GAME_OVER
} GameState;

GameState current_state = STATE_MENU;

void update_game(float dt) {
    switch (current_state) {
        case STATE_MENU:
            update_menu(dt);
            break;
        case STATE_PLAYING:
            update_gameplay(dt);
            break;
        case STATE_PAUSED:
            update_pause_menu(dt);
            break;
        case STATE_GAME_OVER:
            update_game_over(dt);
            break;
    }
}
```

### Pattern 2: State Machine with Callbacks

```c
typedef struct {
    void (*enter)(void);
    void (*update)(float dt);
    void (*exit)(void);
} State;

State states[] = {
    [STATE_MENU]      = { menu_enter, menu_update, menu_exit },
    [STATE_PLAYING]   = { play_enter, play_update, play_exit },
    [STATE_PAUSED]    = { pause_enter, pause_update, pause_exit },
    [STATE_GAME_OVER] = { gameover_enter, gameover_update, gameover_exit },
};

void change_state(GameState new_state) {
    if (current_state < NUM_STATES) {
        states[current_state].exit();
    }
    current_state = new_state;
    states[current_state].enter();
}
```

## Collision Detection Patterns

### Pattern 1: AABB Collision

```c
typedef struct {
    float x, y;      // Center
    float width, height;
} AABB;

bool aabb_intersects(const AABB *a, const AABB *b) {
    float a_min_x = a->x - a->width / 2;
    float a_max_x = a->x + a->width / 2;
    float a_min_y = a->y - a->height / 2;
    float a_max_y = a->y + a->height / 2;
    
    float b_min_x = b->x - b->width / 2;
    float b_max_x = b->x + b->width / 2;
    float b_min_y = b->y - b->height / 2;
    float b_max_y = b->y + b->height / 2;
    
    return a_min_x < b_max_x && a_max_x > b_min_x &&
           a_min_y < b_max_y && a_max_y > b_min_y;
}
```

### Pattern 2: Spatial Partitioning (Grid)

```c
#define GRID_SIZE 10
#define CELL_SIZE 100

typedef struct {
    Entity *entities[100]; // Per-cell entity list
    int count;
} GridCell;

GridCell grid[GRID_SIZE][GRID_SIZE];

void add_to_grid(Entity *entity) {
    int cell_x = (int)(entity->x / CELL_SIZE);
    int cell_y = (int)(entity->y / CELL_SIZE);
    
    if (cell_x >= 0 && cell_x < GRID_SIZE &&
        cell_y >= 0 && cell_y < GRID_SIZE) {
        grid[cell_y][cell_x].entities[grid[cell_y][cell_x].count++] = entity;
    }
}

void check_collisions_in_cell(int cell_x, int cell_y) {
    GridCell *cell = &grid[cell_y][cell_x];
    for (int i = 0; i < cell->count; i++) {
        for (int j = i + 1; j < cell->count; j++) {
            check_collision(cell->entities[i], cell->entities[j]);
        }
    }
}
```

## Save/Load Patterns

### Pattern 1: Binary Serialization

```c
void save_game(const char *filename) {
    FILE *f = fopen(filename, "wb");
    
    // Write header
    uint32_t version = SAVE_VERSION;
    fwrite(&version, sizeof(version), 1, f);
    
    // Write game state
    fwrite(&player, sizeof(player), 1, f);
    fwrite(&level, sizeof(level), 1, f);
    fwrite(entities, sizeof(Entity), num_entities, f);
    
    fclose(f);
}

bool load_game(const char *filename) {
    FILE *f = fopen(filename, "rb");
    if (!f) return false;
    
    // Read header
    uint32_t version;
    fread(&version, sizeof(version), 1, f);
    if (version != SAVE_VERSION) {
        fclose(f);
        return false;
    }
    
    // Read game state
    fread(&player, sizeof(player), 1, f);
    fread(&level, sizeof(level), 1, f);
    fread(entities, sizeof(Entity), num_entities, f);
    
    fclose(f);
    return true;
}
```

These patterns are commonly found in game code and recognizing them during decompilation helps understand the code structure more quickly.
