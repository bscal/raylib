#include "raylib.h"

int main(void)
{
    Raylib_InitWindow(800, 450, "raylib [core] example - basic window");

    while (!Raylib_WindowShouldClose())
    {
        BeginDrawing();
            ClearBackground(RAYWHITE);
            Raylib_DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);
        EndDrawing();
    }

    Raylib_CloseWindow();

    return 0;
}